////////////////////////////////////////////////////////////////////////////////
// Copyright (C) 2013-2024 Efinix Inc. All rights reserved.              
// Full license header bsp/efinix/EfxSapphireSoc/include/LICENSE.MD
////////////////////////////////////////////////////////////////////////////////
//#include "bsp.h"
//#include "userDef.h"
//#include "riscv.h"
//#include "start.h"



//Tiny ML

#include <stdlib.h>
#include "userDef.h"
#include <stdint.h>
#include "riscv.h"
#include "soc.h"
#include "bsp.h"
#include <math.h>
#include "clint.h"
#include "print.h"
//Tinyml Header File
#include "intc.h"
#include "ops/ops_api.h"
#include "arena.h"
#include "platform/tinyml/accel_settings.h"

#include "tinyml.h"
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

#include "model/tinyml_init.h"
#include "model/tinyml_input.h"
#include "model/tinyml_output.h"

volatile struct yolo_result results0[10];
volatile struct fl_result results1[10];
volatile struct pdt8_result results2[10];
volatile struct imgc_result results3[10];

int enable_printing = 1;


// Encryption count for single core processing
#define ENCRYPT_COUNT HART_COUNT
// Stack space used by smpInit.S to provide stack to secondary harts
u8 hartStack[STACK_PER_HART*HART_COUNT] __attribute__((aligned(16)));

// Used as a syncronization barrier between all threads
volatile u32 hartCounter = 0;
// Flag used by hart 0 to notify the other harts that the "value" variable is loaded
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

//extern "C" void mainSmp();

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

extern "C" void mainSmp(){
	u32 hartId = csr_read(mhartid);
	atomicAdd((s32*)&hartCounter, 1);

	while(hartCounter != HART_COUNT);
	// Hart 0 will provide a value to the other harts, other harts wait on it by pulling the "ready" variable

	////////////////
	//Core 0: Yolo//
	////////////////
	if(hartId == 0) {
		bsp_printf("Core is Synced! \r\n");
		//Hart ID: 0/ Core 0 is coordinator, initialization and printing is all done in Core 0

		//Create 4 arena space within heap for each core.
		//We create 5MBs of arena for each core
		for(int i=0 ; i < HART_COUNT ; i++){
			arena[i] = arena_create(5000000);
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


        for(int i=0;i<10;i++){
        	set_yolo_input(&yolo_core0);
        	invoke_model(&yolo_core0, &results0[i]);
        	run_yolo_layer(&yolo_core0, &results0[i], yolo_anchors);
        }


        while(!invoked1_done && !invoked2_done && !invoked3_done);
        asm("fence r,r");

        overall_tend = clint_getTime(BSP_CLINT);
        print_inference_time("[Multicore Core]", overall_tstart, overall_tend);

        // print out accelerator configs
        for(int i=0;i<HART_COUNT;i++)
        	print_accel(i);

        for(int i=0;i<HART_COUNT;i++)
        	arena_clear(arena[i]);

        if(enable_printing){
        	for(int i=0;i<10;i++) {
        		MicroPrintf("__________________ Inference %d ________________________\n\r",i+1);
        		if(i < 1){
					MicroPrintf("==============Results from Core 0==================\n\r");
					show_output_yolo( &(results0[i]) , i) ;

					MicroPrintf("==============End Core 0==================\n\r");

        			MicroPrintf("==============Results from Core 1==================\n\r");
        			show_output_fl(&face_landmark_core1, i, &(results1[i])) ;

        			MicroPrintf("==============End Core 1==================\n\r");
        		}

				if(i < 6){
					MicroPrintf("==============Results from Core 2==================\n\r");

					show_output_pdt8(&person_detection_core2, i, &(results2[i])) ;

					MicroPrintf("==============End Core 2==================\n\r");
				}
        		MicroPrintf("==============Results from Core 3==================\n\r");

        		show_output_imgc(&image_classification_core3, i, &(results3[i]));

        		MicroPrintf("==============End Core 3==================\n\r");
        		MicroPrintf("__________________ End Inference %d ________________________\n\r",i+1);
        	}
        }
    }

	//////////////////////////
	//Core 1: Face landmark //
	//////////////////////////
	else if(hartId == 1) {
        IntcInitialize(BSP_PLIC_CPU_1, BSP_INIT_CHANNEL_1);
        while(!start_tinyml_multicore);
        init_accel(hartId);
        asm("fence r,r");


        for(int i=0;i<3;i++) {
        	set_fl_input(&face_landmark_core1);
        	invoke_model(&face_landmark_core1, &(results1[i]) );
        	run_landmark_output(&face_landmark_core1,&(results1[i]));
        }

        asm("fence w,w");
        invoked1_done = 1;
    }

	/////////////////////////////
	//Core 2: Person Detection //
	/////////////////////////////
    else if(hartId == 2){
        IntcInitialize(BSP_PLIC_CPU_2, BSP_INIT_CHANNEL_2);
        while(!start_tinyml_multicore);
        init_accel(hartId);
        asm("fence r,r");

        for(int i=0;i<10;i++) {
        	set_pdt8_input(&person_detection_core2, i, &(results2[i]));
        	invoke_model(&person_detection_core2, &(results2[i]) );
    		//Retrieve inference output
        	results2[i].no_person_score = person_detection_core2.interpreter->output(0)->data.int8[kNotAPersonIndex];
        	results2[i].person_score    = person_detection_core2.interpreter->output(0)->data.int8[kPersonIndex];
        	results2[i].person_score_percent = ((results2[i].person_score + 128) * 100) >> 8;
        }

        asm("fence w,w");
        invoked2_done = 1;
    }

	/////////////////////////////////
	//Core 3: Image Classification //
	/////////////////////////////////
    else if(hartId == 3){
    	IntcInitialize(BSP_PLIC_CPU_3, BSP_INIT_CHANNEL_3);
    	while(!start_tinyml_multicore);
    	init_accel(hartId);
    	asm("fence r,r");


    	for(int i=0;i<10;i++) {
    		set_imgc_input(&image_classification_core3, i, &(results3[i]));
    		invoke_model(&image_classification_core3, &(results3[i]) );
			memcpy(const_cast<int8_t*>(results3[i].output), image_classification_core3.interpreter->output(0)->data.int8, kCategoryCountImgc);
    	}

    	asm("fence w,w");
    	invoked3_done = 1;
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
    bsp_printf("Hello world complete\n\r");

    ops_unload();
}
