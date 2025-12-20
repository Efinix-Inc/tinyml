///////////////////////////////////////////////////////////////////////////////////
// Copyright 2024 Efinix.Inc. All Rights Reserved.
// You may obtain a copy of the license at
//    https://www.efinixinc.com/software-license.html
///////////////////////////////////////////////////////////////////////////////////
#include <stdlib.h>
#include <stdint.h>
#include "riscv.h"
#include "soc.h"
#include "bsp.h"
#include "plic.h"
#include "uart.h"
#include <math.h>
#include "print.h"
#include "clint.h"

//Tinyml Header File
#include "intc.h"
#include "tinyml.h"
#include "ops/ops_api.h"
#include "platform/tinyml/accel_settings.h"

//Import TensorFlow lite libraries
#include "tensorflow/lite/micro/micro_error_reporter.h"
#include "tensorflow/lite/micro/micro_interpreter.h"
//#include "tensorflow/lite/micro/micro_mutable_op_resolver.h"
#include "tensorflow/lite/micro/all_ops_resolver.h"
#include "tensorflow/lite/micro/testing/micro_test.h"
#include "tensorflow/lite/schema/schema_generated.h"
#include "tensorflow/lite/c/common.h"
#include "tensorflow/lite/micro/debug_log.h"
#include "tensorflow/lite/micro/micro_time.h"
#include "platform/tinyml/profiler.h"

//Multicore user def
#include "coreDef.h"


//Arena allocation
#include "arena.h"

//Model pre-processing, init and output
#include "model/tinyml_init.h"
#include "model/tinyml_input.h"
#include "model/tinyml_output.h"



//Multicore related
// Encryption count for single core processing
#define ENCRYPT_COUNT HART_COUNT
// Stack space used by smpInit.S to provide stack to secondary harts
u8 hartStack[STACK_PER_HART*HART_COUNT] __attribute__((aligned(16)));

// Used as a syncronization barrier between all threads
volatile u32 hartCounter = 0;

//Flag to indicate multicore initialization completion
volatile u32 tinyml_multicore_init = 0;

//Flag to print out multicore tinyml accelerator configs & output
volatile u32 print_config = 0;
volatile u32 print_enable = 0;



//Atomic
__inline__ __attribute__((always_inline)) s32 atomicAdd(s32 *a, u32 increment) {
	s32 old;
	__asm__ volatile(
			"amoadd.w %[old], %[increment], (%[atomic])"
			: [old] "=r"(old)
			  : [increment] "r"(increment), [atomic] "r"(a)
				: "memory"
	);
	return old;
}






//Results for each core
volatile struct yolo_result results_c0[10];
volatile struct fd_result results_c1[10];
volatile struct fl_result results_c2[10];
volatile struct fl_result results_c3[10];

volatile u32 h0_ready = 0;
volatile u32 h1_ready = 0;
volatile u32 h2_ready = 0;
volatile u32 h3_ready = 0;

volatile u32 invoked1_done = 0;
volatile u32 invoked2_done = 0;
volatile u32 invoked3_done = 0;
volatile u32 start_tinyml_multicore = 0;

extern "C" {
void smpInit();
void smp_unlock(void (*userMain)(u32, u32, u32) );

}


/***************************************************	Main start **********************************************************************/
volatile u32 core0_done = 0;
volatile u32 core1_done = 0;
volatile u32 core2_done = 0;
volatile u32 core3_done = 0;

extern "C" void mainSmp(){
	u32 hartId = csr_read(mhartid);
	atomicAdd((s32*)&hartCounter, 1);

	while(hartCounter != HART_COUNT);
	//MASTER CORE//
	// Hart 0 will provide a value to the other harts, other harts wait on it by pulling the "ready" variable
	////////////////
	//Core 0: Yolo//
	////////////////
	if(hartId == 0) {
		bsp_printf("Core is Synced! \r\n");
		//Hart ID: 0/ Core 0 is coordinator, initialization and printing is all done in Core 0

		//Create arena space within heap for each core. See model/arena.h for detailed usage.
		//5MB arena allocation for each core.
		for(int i=0 ; i < HART_COUNT ; i++){
			arena[i] = arena_create(50000000);
		}

		MicroPrintf("[TinyML] Initializing multicore model ...\n\r");


		//Initialize interrupt and model
		initialize_multicore_model();
		IntcInitialize(BSP_PLIC_CPU_0, BSP_INIT_CHANNEL_0);
		init_accel(hartId);
		MicroPrintf("[TinyML] Done ...\n\r");
		uint64_t overall_tstart;
		uint64_t overall_tend;

		asm("fence w,w");
		start_tinyml_multicore = 1;

		overall_tstart = clint_getTime(BSP_CLINT);

		for (int i=0; i<1; i++){
			set_yolo_input(&yolo_core0);
			invoke_model(&yolo_core0, &results_c0[i]);
			run_yolo_layer(&yolo_core0, &results_c0[i], yolo_anchors);
		}

		core0_done = 1;

		while(!core1_done || !core2_done || !core3_done);
		asm("fence r,r");

        overall_tend = clint_getTime(BSP_CLINT);
        print_inference_time("[Multicore Core]", overall_tstart, overall_tend);

        if (print_config) {
			// print out accelerator configs
			for(int i=0;i<HART_COUNT;i++)
				print_accel(i);
        }

        for(int i=0;i<HART_COUNT;i++)
        	arena_clear(arena[i]);

        if (print_enable) {
			MicroPrintf("==============Results from Core 0==================\n\r");
			show_output_yolo(&(results_c0[0]) , 0) ;
			MicroPrintf("==============End Core 0==================\n\r");
			MicroPrintf("==============Results from Core 1==================\n\r");
			show_output_fd(&(results_c1[0]));
			MicroPrintf("==============End Core 1==================\n\r");
			MicroPrintf("==============Results from Core 2==================\n\r");
			show_output_fl(&face_landmark_core2, 1, &(results_c2[0]));
			MicroPrintf("==============End Core 2==================\n\r");
			MicroPrintf("==============Results from Core 3==================\n\r");
			show_output_fl(&face_landmark_core3, 1, &(results_c3[0]));
			MicroPrintf("==============End Core 3==================\n\r");
        }

	}


	//////////////////////////
	//Core 1: Face detection//
	//////////////////////////
	else if(hartId == 1) {
		IntcInitialize(BSP_PLIC_CPU_1, BSP_INIT_CHANNEL_1);
		while(!start_tinyml_multicore);
		init_accel(hartId);
		while(!core0_done);
		asm("fence r,r");

        for(int i=0;i<1;i++) {
        	set_fd_input(&face_detection_core1);
        	invoke_model(&face_detection_core1, &(results_c1[i]) );
        	run_fd_layer(&face_detection_core1,&(results_c1[i]));
        }

        asm("fence w,w");
        core1_done = 1;
	}


	//////////////////////////
	//Core 2: Face landmark //
	//////////////////////////
	else if (hartId == 2) {
        IntcInitialize(BSP_PLIC_CPU_2, BSP_INIT_CHANNEL_2);
        while(!start_tinyml_multicore);
        init_accel(hartId);
        while(!core1_done);
        asm("fence r,r");

        for(int i=0;i<1;i++) {
        	set_fl_input(&face_landmark_core2);
        	invoke_model(&face_landmark_core2, &(results_c2[i]) );
        	run_landmark_output(&face_landmark_core2,&(results_c2[i]));
        }

        asm("fence w,w");
        core2_done = 1;

	}




	//////////////////////////
	//Core 3: Face landmark //
	//////////////////////////

	else if (hartId == 3) {
        IntcInitialize(BSP_PLIC_CPU_3, BSP_INIT_CHANNEL_3);
        while(!start_tinyml_multicore);
        init_accel(hartId);

        while(!core2_done);
        asm("fence r,r");

        for(int i=0;i<1;i++) {
        	set_fl_input(&face_landmark_core3);
        	invoke_model(&face_landmark_core3, &(results_c3[i]) );
        	run_landmark_output(&face_landmark_core3,&(results_c3[i]));
        }

        asm("fence w,w");
        core3_done = 1;
	}
}



void smpInitWrapper(u32 a, u32 b, u32 c) {
	smpInit(); // Call the original function
}





void main() {
	bsp_init();
	bsp_printf("***Starting Multicore Hello World*** \r\n");
	smp_unlock(smpInitWrapper);
	mainSmp();
	bsp_printf("***Hello world complete*** \r\n");

	ops_unload();
}

