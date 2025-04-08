///////////////////////////////////////////////////////////////////////////////////
// Copyright 2024 Efinix.Inc. All Rights Reserved.
// You may obtain a copy of the license at
//    https://www.efinixinc.com/software-license.html
///////////////////////////////////////////////////////////////////////////////////

// Define the picam version. Picam V2 will be the default if PICAM_VERSION is not defined.
#define PICAM_VERSION 3

#include <stdlib.h>
#include <stdint.h>
#include "riscv.h"
#include "soc.h"
#include "bsp.h"
#include "plic.h"
#include "uart.h"
#include <math.h>
//#include "print.h"
#include "clint.h"
#include "common.h"
#if PICAM_VERSION == 3
#include "PiCamV3Driver.h"
#else
#include "PiCamDriver.h"
#endif
#include "apb3_cam.h"
#include "i2c.h"
#include "i2cDemo.h"
extern "C" {
#include "dmasg.h"
}
#include "axi4_hw_accel.h"

//Tinyml Header File
#include "intc.h"
#include "tinyml.h"
#include "ops/ops_api.h"

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
#include "userDef.h"


//Arena allocation
#include "model/arena.h"

//Model pre-processing, init and output
#include "model/crop_scale_util.h"
#include "model/tinyml_init.h"
#include "model/model_setup.h"
#include "model/tinyml_output.h"

//text
#include "spiFlash.h"
#include "platform/vision/printf.h"
#include"platform/vision/font.h"
#define SPI SYSTEM_SPI_0_IO_CTRL


//Multicore related
// Encryption count for single core processing
#define ENCRYPT_COUNT HART_COUNT
// Stack space used by smpInit.S to provide stack to secondary harts
u8 hartStack[STACK_PER_HART*HART_COUNT] __attribute__((aligned(16)));

// Used as a syncronization barrier between all threads
volatile u32 hartCounter = 0;

//Flag to indicate multicore initialization completion
volatile u32 tinyml_multicore_init = 0;

//Flag to print out multicore tinyml accelerator configs
volatile u32 print_config = 1;

//Flag for face detection to be used for landmark
volatile u32 face_detection_person1 = 0;
volatile u32 face_detection_person2 = 0;



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




extern "C" {
void smpInit();
void smp_unlock(void (*userMain)(u32, u32, u32) );

}



//Results for each core
volatile struct yolo_result results_c0;
volatile struct fd_result results_c1;
volatile struct fl_result results_c2;
volatile struct fl_result results_c3;



//Store information about person coordinates
volatile struct box_image person1,person2;

//Set frame width, height and channels based on display
int frame_width = FRAME_WIDTH;
int frame_height = FRAME_HEIGHT;
int frame_channels = FRAME_CHANNELS;

int square_size = frame_width > frame_height ? frame_width : frame_height ;



#define FONT_WIDTH 		8
#define FONT_HEIGHT 	16
#define FRAMEBUF_WIDTH 	135
#define FRAMEBUF_HEIGHT 68
#define FRAME_WIDTH    	1080
#define FRAME_HEIGHT   	1080
#define DUMMY_SIZE 		20
#define BBOX_MAX 		16

#define FONT_FLASH_ADDR 	0x005F0000
#define FONT_FLASH_SIZE 	(128 * FONT_WIDTH * FONT_HEIGHT / 8)


// sizes
#define FRAMEBUF_SIZE 		(FRAMEBUF_WIDTH*FRAMEBUF_HEIGHT)
#define IMAGE_SIZE 			(FRAME_WIDTH*FRAME_HEIGHT*4)
#define TOTAL_BOX_SIZE		(BBOX_MAX * 8)

// offsets
#define FRAMEBUF_CMD_OFFSET 	0
#define FRAMEBUF_START_OFFSET 	8
#define FRAMEBUF_END_OFFSET 	(FRAMEBUF_START_OFFSET + FRAMEBUF_SIZE)


#define DUMMY_START_OFFSET 		(FRAMEBUF_END_OFFSET)
#define DUMMY_END_OFFSET 		(DUMMY_START_OFFSET + DUMMY_SIZE)

#define IMAGE_CMD_OFFSET 		(DUMMY_END_OFFSET)
#define IMAGE_START_OFFSET 		(IMAGE_CMD_OFFSET + 8)
#define IMAGE_END_OFFSET 		(IMAGE_START_OFFSET + IMAGE_SIZE)

#define TOTAL_BUFFER_SIZE		(IMAGE_END_OFFSET - FRAMEBUF_CMD_OFFSET)

#define TOTAL_DISPLAY_BUF_SIZE	(IMAGE_END_OFFSET - FRAMEBUF_CMD_OFFSET)

#define DISPLAY_BUF_ADDR 		0x02100000
#define MAX_DISPLAY_BUFFERS 	5

#define TINYML_INPUT_START_ADDR  	(DISPLAY_BUF_ADDR + TOTAL_BUFFER_SIZE * MAX_DISPLAY_BUFFERS)
#define tinyml_input_array 			((volatile uint8_t*)TINYML_INPUT_START_ADDR)

#define YOLO_BOX_CMD_OFFSET		(TINYML_INPUT_START_ADDR + 0x100000)
#define YOLO_BOX_START_OFFSET	(YOLO_BOX_CMD_OFFSET + 8)
#define YOLO_BOX_END_OFFSET		(YOLO_BOX_START_OFFSET + TOTAL_BOX_SIZE)

#define FD_BOX_CMD_OFFSET		(YOLO_BOX_END_OFFSET + 8)
#define FD_BOX_START_OFFSET		(FD_BOX_CMD_OFFSET + 8)
#define FD_BOX_END_OFFSET		(FD_BOX_START_OFFSET + TOTAL_BOX_SIZE)

#define bbox_array_yolo			((volatile uint64_t*)(YOLO_BOX_START_OFFSET))
#define bbox_array_fd			((volatile uint64_t*)(FD_BOX_START_OFFSET))

#define FONT_START_OFFSET 		FD_BOX_END_OFFSET
#define FONT_END_OFFSET			FONT_START_OFFSET + FONT_FLASH_SIZE
#define YOLO_INPUT_START_ADDR   FONT_END_OFFSET + 0x100000
#define YOLO_INPUT_BYTES 96*96*3

#define FD_INPUT_START_ADDR  YOLO_INPUT_START_ADDR + YOLO_INPUT_BYTES + 0x100000
#define FD_INPUT_BYTES 128*128*3



uint8_t camera_buffer = 0;
uint8_t display_buffer = 0;
uint8_t next_display_buffer = 0;
uint8_t draw_buffer = 0;
uint8_t bbox_overlay_updated = 0;
uint8_t bbox_overlay_fd_updated = 0;
uint8_t bbox_overlay_yolo_updated = 0;




u32 buf(u32 i) {
	return DISPLAY_BUF_ADDR +  TOTAL_BUFFER_SIZE*i;
}

u32 buf_yolo(u32 i) {
	return YOLO_INPUT_START_ADDR +  YOLO_INPUT_BYTES*i;
}

u32 buf_fd(u32 i) {
	return FD_INPUT_START_ADDR +  FD_INPUT_BYTES*i;
}


static void flush_data_cache(){
	asm(".word(0x500F)");
}

u32 buf_offset(u32 i, u32 offset)
{
	return buf(i) + offset;
}

char* buf_offset_char(u32 i, u32 offset)
{
	return (char*)buf_offset(i, offset);
}

u32* buf_offset_u32(u32 i, u32 offset)
{
	return (u32*)buf_offset(i, offset);
}

u64* buf_offset_u64(u32 i, u32 offset)
{
	return (u64*)buf_offset(i, offset);
}

void send_dma(u32 channel, u32 port, u32 addr, u32 size, int interrupt, int wait, int self_restart) {
	dmasg_input_memory(DMASG_BASE, channel, addr, 16);
	dmasg_output_stream(DMASG_BASE, channel, port, 0, 0, 1);

	if(interrupt) {
		dmasg_interrupt_config(DMASG_BASE, channel, DMASG_CHANNEL_INTERRUPT_CHANNEL_COMPLETION_MASK);
	}

	if(self_restart) {
		dmasg_direct_start(DMASG_BASE, channel, size, 1);
	} else {
		dmasg_direct_start(DMASG_BASE, channel, size, 0);
	}

	if(wait) {
		while(dmasg_busy(DMASG_BASE, channel));
		flush_data_cache();
	}
}

void recv_dma(u32 channel, u32 port, u32 addr, u32 size, int interrupt, int wait, int self_restart) {
	dmasg_input_stream(DMASG_BASE, channel, port, 1, 0);
	dmasg_output_memory(DMASG_BASE, channel, addr, 16);

	if(interrupt){
		dmasg_interrupt_config(DMASG_BASE, channel, DMASG_CHANNEL_INTERRUPT_CHANNEL_COMPLETION_MASK);
	}

	if(self_restart) {
		dmasg_direct_start(DMASG_BASE, channel, size, 1);
	} else {
		dmasg_direct_start(DMASG_BASE, channel, size, 0);
	}

	if(wait){
		while(dmasg_busy(DMASG_BASE, channel));
		flush_data_cache();
	}
}

u32 array_offset;
int32_t next_display_buffer_2 = 0;

// Helper function to plot landmarks
void plot_landmark(volatile uint32_t *landmark_x, volatile uint32_t *landmark_y, int left, int top, volatile u32* buf) {
	for (int i = 0; i < NUM_LANDMARK; i++) {
		// Calculate the original coordinates based on the crop offset
		int original_x = landmark_x[i] + left;
		int original_y = landmark_y[i] + top;

		// Ensure the original coordinates are within the bounds of the original image
		if (original_x >= 0 && original_x < FRAME_WIDTH && original_y >= 0 && original_y < FRAME_HEIGHT) {
			// Plot the landmark (red color)
			for (int j = 0; j < 3; j++) {
				for (int k = 0; k < 3; k++) {
					int plot_x = original_x + k;
					int plot_y = original_y + j;
					if (plot_x >= 0 && plot_x < FRAME_WIDTH && plot_y >= 0 && plot_y < FRAME_HEIGHT) {
						buf[plot_y * FRAME_WIDTH + plot_x] = 0x000000FF; // Red color
					}
				}
			}
		}
	}
}




void trigger_next_display_dma() {
	send_dma(DMASG_DISPLAY_MM2S_CHANNEL, DMASG_DISPLAY_MM2S_PORT, buf(display_buffer), TOTAL_BUFFER_SIZE, 1, 0, 0);

	if (results_c2.landmark_valid  && results_c3.landmark_valid) {
		asm("fence r,r");
		plot_landmark(results_c2.landmark_x, results_c2.landmark_y, (int)results_c2.left, (int)results_c2.top, buf_offset_u32(display_buffer,IMAGE_START_OFFSET));
		plot_landmark(results_c3.landmark_x, results_c3.landmark_y, (int)results_c3.left, (int)results_c3.top, buf_offset_u32(display_buffer,IMAGE_START_OFFSET));

	}
	else if (results_c2.landmark_valid) {
		asm("fence r,r");
		plot_landmark(results_c2.landmark_x, results_c2.landmark_y, (int)results_c2.left, (int)results_c2.top, buf_offset_u32(display_buffer,IMAGE_START_OFFSET));
	}
	else if (results_c3.landmark_valid ) {
		asm("fence r,r");
		plot_landmark(results_c3.landmark_x, results_c3.landmark_y, (int)results_c3.left, (int)results_c3.top, buf_offset_u32(display_buffer,IMAGE_START_OFFSET));
	}
	display_buffer = next_display_buffer_2;
}

void trigger_next_box_dma() {
	//   //If only one of them ready then send either one
	if (bbox_overlay_yolo_updated) {
		asm("fence r,r");
		send_dma(DMASG_DISPLAY_MM2S_CHANNEL, DMASG_DISPLAY_MM2S_PORT, YOLO_BOX_CMD_OFFSET, TOTAL_BOX_SIZE + 8, 0, 1, 0); //Wait till complete

		asm("fence w,w");
		bbox_overlay_yolo_updated = 0;

	}
	if (bbox_overlay_fd_updated) {
		asm("fence r,r");
		send_dma(DMASG_DISPLAY_MM2S_CHANNEL, DMASG_DISPLAY_MM2S_PORT, FD_BOX_CMD_OFFSET, TOTAL_BOX_SIZE + 8, 0, 1, 0); //Wait till complete

		asm("fence w,w");
		bbox_overlay_fd_updated = 0;

	}
}


void trigger_next_cam_dma() {
	next_display_buffer_2 = next_display_buffer;
	next_display_buffer = camera_buffer;

	for(int i=0; i<=MAX_DISPLAY_BUFFERS; i++)
	{
		if(i!=display_buffer && i!=next_display_buffer && i!=draw_buffer && i!=next_display_buffer_2)
		{
			camera_buffer = i;
			break;
		}
	}
	recv_dma(DMASG_HW_RESCALE_CH0_S2MM_CHANNEL, DMASG_HW_RESCALE_CH0_S2MM_PORT, buf_yolo(camera_buffer), YOLO_INPUT_BYTES, 0, 0, 0);
	recv_dma(DMASG_HW_RESCALE_CH1_S2MM_CHANNEL, DMASG_HW_RESCALE_CH1_S2MM_PORT, buf_fd(camera_buffer), FD_INPUT_BYTES, 0, 0, 0);
	recv_dma(DMASG_CAM_S2MM_CHANNEL, DMASG_CAM_S2MM_PORT, buf_offset(camera_buffer, IMAGE_START_OFFSET), IMAGE_SIZE, 1, 0, 0);

	//Indicate start of S2MM DMA to camera building block via APB3 slave
	EXAMPLE_APB3_REGW(EXAMPLE_APB3_SLV, EXAMPLE_APB3_SLV_REG4_OFFSET, 0x00000007);
	EXAMPLE_APB3_REGW(EXAMPLE_APB3_SLV, EXAMPLE_APB3_SLV_REG4_OFFSET, 0x00000000);

	//Trigger storage of one captured frame via APB3 slave
	EXAMPLE_APB3_REGW(EXAMPLE_APB3_SLV, EXAMPLE_APB3_SLV_REG2_OFFSET, 0x00000001);
	EXAMPLE_APB3_REGW(EXAMPLE_APB3_SLV, EXAMPLE_APB3_SLV_REG2_OFFSET, 0x00000000);
}

char* framebuf(int i) {
	return (char*) buf_offset(i, FRAMEBUF_START_OFFSET);
}

void framebuf_clear(void) {
	memset(framebuf(draw_buffer), 0, FRAMEBUF_SIZE);
}

void framebuf_clearall(void) {
	for(int i = 0; i < MAX_DISPLAY_BUFFERS; i++){
		memset((char*)buf_offset(i, FRAMEBUF_START_OFFSET), 0, FRAMEBUF_SIZE);
	}
}

int framebuf_printf(int x, int y, const char *format, ...) {
	int pos = FRAMEBUF_WIDTH * y + x;
	int max_length = FRAMEBUF_HEIGHT * FRAMEBUF_WIDTH - pos;

	va_list va;
	va_start(va, format);
	int ret;
	for (int i =0;i < MAX_DISPLAY_BUFFERS; i++ ){
		ret = vsnprintf_(framebuf(i) + pos, max_length, format, va);
	}

	va_end(va);

	return ret;
}

void flash_copy(volatile char *dest, u32 flash_addr, u32 size, int loading) {
	spiFlash_wake(SPI,0);
	spi_select(SPI, 0);
	spi_write(SPI, 0x03);
	spi_write(SPI, (flash_addr >> 16) & 0xFF);
	spi_write(SPI, (flash_addr >> 8) & 0xFF);
	spi_write(SPI, flash_addr & 0xFF);

	for (u32 i = 1; i <= size; i++) {
		*dest++ = spi_read(SPI);
	}

	spi_diselect(SPI, 0);
}

void color_pattern(volatile u32* buf){
	for (int y=0; y<FRAME_HEIGHT; y++) {
		for (int x=0; x<FRAME_WIDTH; x++) {
			if ((x<3 && y<3) || (x>=FRAME_WIDTH-3 && y<3) || (x<3 && y>=FRAME_HEIGHT-3) || (x>=FRAME_WIDTH-3 && y>=FRAME_HEIGHT-3)) {
				buf [y*FRAME_WIDTH + x] = 0x000000FF; //RED
			} else if (x<(FRAME_WIDTH/4)) {
				buf [y*FRAME_WIDTH + x] = 0x0000FF00; //GREEN
			} else if (x<(FRAME_WIDTH/4 *2)) {
				buf [y*FRAME_WIDTH + x] = 0x00FF0000; //BLUE
			} else if (x<(FRAME_WIDTH/4 *3)) {
				buf [y*FRAME_WIDTH + x] = 0x000000FF; //RED
			} else {
				buf [y*FRAME_WIDTH + x] = 0x00FF0000; //BLUE
			}
		}
	}
}


void init_fontbuf(void) {
	// assign the address to store the font data
	volatile 	u64 *cmd 	= (u64*) 0x00720000;
	volatile 	u64 *buf 	= cmd + 1;

	flash_copy((volatile char*) buf, FONT_FLASH_ADDR, FONT_FLASH_SIZE, 0);
	*cmd = 1;
}

void init_framebuf(void) {
	for (int i = 0; i < MAX_DISPLAY_BUFFERS; i++) {
		*buf_offset_u64(i, FRAMEBUF_CMD_OFFSET) = 2;
	}
	framebuf_clearall();
//	flash_copy(buf_offset_char(display_buffer, FRAMEBUF_START_OFFSET), BANNER_FLASH_ADDR, BANNER_FLASH_SIZE, 0);
}

void send_dma_font_buf(void){
	dmasg_input_memory(DMASG_BASE, DMASG_DISPLAY_MM2S_CHANNEL, 0x00720000, 16);
	dmasg_output_stream(DMASG_BASE, DMASG_DISPLAY_MM2S_CHANNEL, DMASG_DISPLAY_MM2S_PORT, 0, 0, 1);
	dmasg_direct_start(DMASG_BASE, DMASG_DISPLAY_MM2S_CHANNEL, FONT_FLASH_SIZE + 8, 0);  //Without self restart
	while (dmasg_busy(DMASG_BASE, DMASG_DISPLAY_MM2S_CHANNEL));
	flush_data_cache();
}

void init_image(void)
{
	for(int i=0; i<MAX_DISPLAY_BUFFERS; i++)
	{
		*buf_offset_u64(i, IMAGE_CMD_OFFSET) = 3;
	}
	color_pattern(buf_offset_u32(display_buffer, IMAGE_START_OFFSET));
}

void init_bbox_yolo(void)
{
	//Initialize all box coordinate to invalid, as well as dummy data to be sent with command and data.
	*(volatile uint64_t*)YOLO_BOX_CMD_OFFSET = 0x0000000000000004;
	for(int j=0;j<=(BBOX_MAX+1);j++)
	{
		bbox_array_yolo[j] = 0xffffffffffffffff; //Invalid bounding box
	}

	bbox_overlay_yolo_updated=1;
}

void init_bbox_fd(void)
{
	//Initialize all box coordinate to invalid, as well as dummy data to be sent with command and data.
	*(volatile uint64_t*)FD_BOX_CMD_OFFSET = 0x0000000000000005;
	for(int j=0;j<=(BBOX_MAX+1);j++)
	{
		bbox_array_fd[j] = 0xffffffffffffffff; //Invalid bounding box
	}
	bbox_overlay_fd_updated=1;
}

void init_dummy(void) {
	if(DUMMY_SIZE == 0)
		return;

	//set all dummy data to 0xffffffff if any
	for (int i = 0; i < MAX_DISPLAY_BUFFERS; i++) {
		memset((char*)buf_offset(i, DUMMY_START_OFFSET), 0xFFFFFFFF, DUMMY_SIZE);
	}
}

void init_vision() {
	/************************************************************SETUP PICAM************************************************************/

	MicroPrintf("Camera Setting...");

	// Reset mipi
//	EXAMPLE_APB3_REGW(EXAMPLE_APB3_SLV, EXAMPLE_APB3_SLV_REG1_OFFSET, 0);//de-assert reset
//	bsp_uDelay(10);
	EXAMPLE_APB3_REGW(EXAMPLE_APB3_SLV, EXAMPLE_APB3_SLV_REG1_OFFSET, 1);// assert reset
	bsp_uDelay(100);
	EXAMPLE_APB3_REGW(EXAMPLE_APB3_SLV, EXAMPLE_APB3_SLV_REG1_OFFSET, 0);//de-assert reset
	bsp_uDelay(1000*10); //10ms delay
	// reset frame buffer
	spiFlash_init(SPI,0);
	framebuf_clearall();

	//Camera I2C configuration
	mipi_i2c_init();
#if PICAM_VERSION == 3
	PiCamV3_Init();

	//SET camera pre-processing RGB gain value
	Set_RGBGain(1,5,3,7);
#else
	PiCam_init();

	//SET camera pre-processing RGB gain value
	Set_RGBGain(1,5,3,4);
#endif

	MicroPrintf("Done\n\r");

	/*************************************************************SETUP DMA*************************************************************/

	MicroPrintf("DMA Setting...");
	dma_init();

	dmasg_priority(DMASG_BASE, DMASG_HW_RESCALE_CH0_S2MM_CHANNEL, 0, 0);
	dmasg_priority(DMASG_BASE, DMASG_HW_RESCALE_CH1_S2MM_CHANNEL, 0, 0);
	dmasg_priority(DMASG_BASE, DMASG_DISPLAY_MM2S_CHANNEL,  3, 0);
	dmasg_priority(DMASG_BASE, DMASG_CAM_S2MM_CHANNEL,      0, 0);

	MicroPrintf("Done\n\r");

	/***********************************************************TRIGGER DISPLAY*******************************************************/

	MicroPrintf("Initialize display memory content...");


	//Initialize test image in buffer_array (default buffer 0) 
	init_fontbuf();
	init_framebuf();
	init_image();
	MicroPrintf("Done\n\r");
	//Initialize bbox_overlay_buffer - Trigger DMA for initialized bbox_overlay_buffer content to display annotator module!!!
	MicroPrintf("Initialize Bbox to invalid ...");

	init_bbox_yolo();
	init_bbox_fd();

	MicroPrintf("Done\n\r");

	init_dummy();
	send_dma_font_buf();

	//Trigger display DMA once then the rest handled by interrupt sub-rountine
	MicroPrintf("Trigger display DMA...");
	send_dma(DMASG_DISPLAY_MM2S_CHANNEL, DMASG_DISPLAY_MM2S_PORT, buf(display_buffer), TOTAL_BUFFER_SIZE, 1, 0, 0);
	display_mm2s_active = 1;
	MicroPrintf("Done\n\r");

	msDelay(3000); //Display colour bar for 3 seconds
	framebuf_clearall();
	/*********************************************************TRIGGER CAMERA CAPTURE*****************************************************/

	//SELECT RGB or grayscale output from camera pre-processing block.
	EXAMPLE_APB3_REGW(EXAMPLE_APB3_SLV, EXAMPLE_APB3_SLV_REG3_OFFSET, 0x00000000);   //RGB

	//Trigger camera DMA once then the rest handled by interrupt sub-rountine
	MicroPrintf("Trigger camera DMA...");
	recv_dma(DMASG_HW_RESCALE_CH0_S2MM_CHANNEL, DMASG_HW_RESCALE_CH0_S2MM_PORT, buf_yolo(camera_buffer), YOLO_INPUT_BYTES, 0, 0, 0);
	recv_dma(DMASG_HW_RESCALE_CH1_S2MM_CHANNEL, DMASG_HW_RESCALE_CH1_S2MM_PORT, buf_fd(camera_buffer), FD_INPUT_BYTES, 0, 0, 0);
	recv_dma(DMASG_CAM_S2MM_CHANNEL, DMASG_CAM_S2MM_PORT, buf_offset(camera_buffer, IMAGE_START_OFFSET), IMAGE_SIZE, 1, 0, 0);
	cam_s2mm_active = 1;

	//Indicate start of S2MM DMA to camera building block via APB3 slave
	EXAMPLE_APB3_REGW(EXAMPLE_APB3_SLV, EXAMPLE_APB3_SLV_REG4_OFFSET, 0x00000007);
	EXAMPLE_APB3_REGW(EXAMPLE_APB3_SLV, EXAMPLE_APB3_SLV_REG4_OFFSET, 0x00000000);

	//Trigger storage of one captured frame via APB3 slave
	EXAMPLE_APB3_REGW(EXAMPLE_APB3_SLV, EXAMPLE_APB3_SLV_REG2_OFFSET, 0x00000001);
	EXAMPLE_APB3_REGW(EXAMPLE_APB3_SLV, EXAMPLE_APB3_SLV_REG2_OFFSET, 0x00000000);

	MicroPrintf("Done\n\r");
}

void draw_boxes_yolo(box* boxes,int total_boxes, float objectness_thresh){
	//To store coordinates information
	float min_val = 0.00;
	float max_val = 1.00;
	uint16_t x_min;
	uint16_t x_max;
	uint16_t y_min;
	uint16_t y_max;
	uint64_t box_coordinates;
	int count_boxes=0;

	for (int i = 0; i<(BBOX_MAX); i++) {
		if(i < total_boxes) {
			//Clamp within frames
			if (boxes[i].x_min < min_val || boxes[i].y_min < min_val ||
					boxes[i].x_max < min_val || boxes[i].y_max < min_val ||
					boxes[i].x_min > max_val || boxes[i].y_min > max_val ||
					boxes[i].x_max > max_val || boxes[i].y_max  > max_val ||
					boxes[i].objectness < objectness_thresh) {
				bbox_array_yolo[i] = 0xffffffffffffffff;
			}
			else {
				x_min = (boxes[i].x_min)*FRAME_WIDTH;
				y_min = (boxes[i].y_min)*FRAME_HEIGHT;
				x_max = (boxes[i].x_max)*FRAME_WIDTH;
				y_max = (boxes[i].y_max)*FRAME_HEIGHT;

				if(x_max > FRAME_WIDTH){
					x_max = (FRAME_WIDTH-1);
				}
				if(y_max > FRAME_HEIGHT){
					y_max = (FRAME_HEIGHT-1);
				}
				box_coordinates = (uint64_t) x_min << 48 | (uint64_t) y_min << 32 | (uint64_t) x_max << 16 |(uint64_t) y_max << 0;
				bbox_array_yolo[i] = box_coordinates;
				count_boxes++;
			}
		}
		else{
			bbox_array_yolo[i] = 0xffffffffffffffff;
		}
	}
	asm("fence w,w");
	bbox_overlay_yolo_updated=1;
}

//Return total number of boxes that are valid for detect face checking
int draw_boxes_fd(bf_box* boxes,int total_boxes, float objectness_thresh){ 
	//To store coordinates information
	float min_val = 0.00;
	float max_val = 1.00;
	uint16_t x_min;
	uint16_t x_max;
	uint16_t y_min;
	uint16_t y_max;
	uint64_t box_coordinates;
	int count_boxes=0;

	for (int i = 0; i<(BBOX_MAX); i++) {
		if(i < total_boxes) {
			if (boxes[i].x_min < min_val || boxes[i].y_min < min_val ||
					boxes[i].x_max < min_val || boxes[i].y_max < min_val ||
					boxes[i].x_min > max_val || boxes[i].y_min > max_val ||
					boxes[i].x_max > max_val || boxes[i].y_max  > max_val ||
					boxes[i].objectness < objectness_thresh) {

				// Invalid box, set it to some sentinel value or just skip it
				bbox_array_fd[i] = 0xffffffffffffffff;

				//For invalid boxes, we will set everything to 0 to ensure that sorting will be done properly later
				boxes[i].x_min = 0;
				boxes[i].y_min = 0;
				boxes[i].x_max = 0;
				boxes[i].y_max = 0;
				boxes[i].objectness = 0;
			}

			else {
				x_min = (boxes[i].x_min)*FRAME_WIDTH;
				y_min = (boxes[i].y_min)*FRAME_HEIGHT;
				x_max = (boxes[i].x_max)*FRAME_WIDTH;
				y_max = (boxes[i].y_max)*FRAME_HEIGHT;

				if(x_max > FRAME_WIDTH){
					x_max = (FRAME_WIDTH-1);
				}
				if(y_max > FRAME_HEIGHT){
					y_max = (FRAME_HEIGHT-1);
				}
				box_coordinates = (uint64_t) x_min << 48 | (uint64_t) y_min << 32 | (uint64_t) x_max << 16 |(uint64_t) y_max << 0;
				bbox_array_fd[i] = box_coordinates;
				count_boxes++;
			}
		}
		else{
			bbox_array_fd[i] = 0xffffffffffffffff;
		}
	}
	asm("fence w,w");
	bbox_overlay_fd_updated=1;
	return count_boxes;
}

//Display text on top of the box plotted
void display_text_on_box(box* yolo_boxes, int total_yolo_boxes, float yolo_objectness_thresh, bf_box* fd_boxes, int total_fd_boxes, float fd_objectness_thresh){
	//To store coordinates information
	float min_val = 0.00;
	float max_val = 1.00;
	uint16_t x_min;
	uint16_t x_max;
	uint16_t y_min;
	uint16_t y_max;
	int total_box = total_yolo_boxes > total_fd_boxes ? total_yolo_boxes : total_fd_boxes;
	for (int i = 0; i< total_box; i++) {
		//Text on yolo
		if(i < total_yolo_boxes) {
			if (!(yolo_boxes[i].x_min < min_val || yolo_boxes[i].y_min < min_val ||
					yolo_boxes[i].x_max < min_val || yolo_boxes[i].y_max < min_val ||
					yolo_boxes[i].x_min > max_val || yolo_boxes[i].y_min > max_val ||
					yolo_boxes[i].x_max > max_val || yolo_boxes[i].y_max > max_val ||
					yolo_boxes[i].objectness < yolo_objectness_thresh)) {
				x_min = (yolo_boxes[i].x_min)*FRAME_WIDTH;
				y_min = (yolo_boxes[i].y_min)*FRAME_HEIGHT;
				uint16_t x_font = x_min / FONT_WIDTH + 1;
				uint16_t y_font = y_min / FONT_HEIGHT - 1;
				if(y_font <= 0)	y_font = 0;
				framebuf_printf(x_font, y_font, "Person(%.2f)", yolo_boxes[i].objectness);

			}
		}
		//Text on fd
		if(i < total_fd_boxes) {
			if (!(fd_boxes[i].x_min < min_val || fd_boxes[i].y_min < min_val ||
					fd_boxes[i].x_max < min_val || fd_boxes[i].y_max < min_val ||
					fd_boxes[i].x_min > max_val || fd_boxes[i].y_min > max_val ||
					fd_boxes[i].x_max > max_val || fd_boxes[i].y_max > max_val ||
					fd_boxes[i].objectness < fd_objectness_thresh)) {
				x_min = (fd_boxes[i].x_min)*FRAME_WIDTH;
				y_min = (fd_boxes[i].y_min)*FRAME_HEIGHT;
				uint16_t x_font = x_min / FONT_WIDTH + 1;
				uint16_t y_font = y_min / FONT_HEIGHT - 1;
				if(y_font <= 0)	y_font = 0;
				framebuf_printf(x_font, y_font, "Face(%.2f)", fd_boxes[i].objectness);

			}
		}
	}
}

/**
 * Compare two bounding boxes based on the x_min value
 *
 * @param box_1_pointer Pointer to bounding box 1
 * @param box_2_pointer Pointer to bounding box 2
 * @return Integer flag indicating the comparison result (1 denotes box 1 > box 2, -1 denotes box 1 < box 2, otherwise 0)
 */
int compare_box_size(const void *box_1_pointer, const void *box_2_pointer) {
	bf_box box_1 = *(bf_box *)box_1_pointer;
	bf_box box_2 = *(bf_box *)box_2_pointer;
	float area_box1 = (box_1.x_max - box_1.x_min)*(box_1.y_max - box_1.y_min);
	float area_box2 = (box_2.x_max - box_2.x_min)*(box_2.y_max - box_2.y_min);
	return (area_box1 > area_box2) ? -1 : (area_box1 < area_box2) ? 1 : 0;
}




// Function to calculate Euclidean distance between two points
float calculate_distance(int x1, int y1, int x2, int y2) {
	return  std::pow(x2 - x1, 2) + std::pow(y2 - y1, 2);
}

// Threshold to determine if the face belongs to the same person
const float DISTANCE_THRESHOLD = 100.0f;  // Adjust this threshold as needed
const float DISTANCE_THRESHOLD_SQUARED = DISTANCE_THRESHOLD * DISTANCE_THRESHOLD;


void find_face(volatile fd_result * result){
	// Sort the boxes by area in descending order (largest box first)
	qsort(results_c1.boxes, results_c1.total_boxes, sizeof(bf_box), compare_box_size);

	//Only loop biggest two boxes after sort for landmark
	int total_boxes = result->total_boxes < 2 ? result->total_boxes : 2;

	//Check total box to control the landmark valid
	int valid_box = 0;

	for (int box_index = 0; box_index < total_boxes; box_index++) {
		// Clamp the crop bounds to be within the image's dimensions
		float xmin = result->boxes[box_index].x_min ;
		float xmax = result->boxes[box_index].x_max ;
		float ymin = result->boxes[box_index].y_min ;
		float ymax = result->boxes[box_index].y_max ;

		//Current demo only handles within the frame. Half face frame is not handled for face landmark
		if(xmin  < 0 || ymin < 0 || xmax > 1 || ymax > 1)
		{
			continue;
		}
		float box_width = xmax - xmin;
		float box_height = ymax - ymin;
		int center_x = int(round((result->boxes[box_index].x_min + box_width / 2) * square_size));
		int center_y = int(round((ymin = result->boxes[box_index].y_min + box_height / 2) * square_size));
		int offset = int(round(std::min({
			box_width * square_size / 4,
			xmin * square_size,
			(1 - xmax) * square_size,
			box_height * square_size / 4,
			ymin * square_size,
			(1 - ymax) * square_size
		}))) + int(round(std::max({box_width * square_size, box_height * square_size}) / 2));
		int width = offset*2;
		int height = offset*2;



		//We only support downscale, thus the size need to be larger than face landmark size
		if((int(round(box_width*square_size))) > face_landmark_core2.input_width && (int(round(box_height*square_size))) > face_landmark_core2.input_height ){

			//Calculate distance between current box and previous plotted box. Plot on the core closest to previous box.
			float distance_to_person1 = calculate_distance(center_x, center_y, person1.center_x, person1.center_y);
			float distance_to_person2 = calculate_distance(center_x, center_y, person2.center_x, person2.center_y);

			//Check to plot face for core 2 and core 3 (Face Landmark)
			if (!face_detection_person1 && !face_detection_person2) {
				//Check if first plot or compare the distance between previous frame, if close to previous frame then plot on particular core
				if (distance_to_person1 < distance_to_person2 || !person1.center_x) {
					//Check if the box is far, then we disable the landmark valid
					if(distance_to_person1 > DISTANCE_THRESHOLD_SQUARED){
						results_c2.landmark_valid = 0;
						asm("fence w,w");
					}
					// Person1 is closer, assign this face to person1
					valid_box++;
					person1.center_x = center_x;
					person1.center_y = center_y;
					person1.box_width = box_width;
					person1.box_height = box_height;
					person1.offset = offset;

					// Update the top and left coordinates ahead
					results_c2.left = center_x - offset;
					results_c2.top = center_y - offset;

					asm("fence w,w");
					face_detection_person1 = 1;

				} else {
					// Person2 is closer, assign this face to person2
					if(distance_to_person2 > DISTANCE_THRESHOLD_SQUARED){
						results_c3.landmark_valid = 0;
						asm("fence w,w");
					}
					valid_box++;
					person2.center_x = center_x;
					person2.center_y = center_y;
					person2.box_width = box_width;
					person2.box_height = box_height;
					person2.offset = offset;

					// Update the top and left coordinates ahead
					results_c3.left = center_x - offset;
					results_c3.top = center_y - offset;

					asm("fence w,w");
					face_detection_person2 = 1;
				}
			}

			else if(!face_detection_person1){
				if(distance_to_person1 > DISTANCE_THRESHOLD_SQUARED){
					results_c2.landmark_valid = 0;
					asm("fence w,w");
				}
				valid_box++;
				person1.center_x = center_x;
				person1.center_y = center_y;
				person1.box_width = box_width;
				person1.box_height = box_height;
				person1.offset = offset;


				//Update the top and left coordinates ahead
				results_c2.left = center_x - offset;
				results_c2.top = center_y - offset;

				asm("fence w,w");
				face_detection_person1 = 1;
			}
			else if (!face_detection_person2){
				if(distance_to_person2 > DISTANCE_THRESHOLD_SQUARED){
					results_c3.landmark_valid = 0;
					asm("fence w,w");
				}
				valid_box++;
				person2.center_x = center_x;
				person2.center_y = center_y;
				person2.box_width = box_width;
				person2.box_height = box_height;
				person2.offset = offset;

				//Update the top and left coordinates ahead
				results_c3.left = center_x - offset;
				results_c3.top = center_y - offset;

				asm("fence w,w");
				face_detection_person2 = 1;
			}

		}
	}
	if(valid_box == 0){
		results_c2.landmark_valid = 0;
		asm("fence w,w");
		results_c3.landmark_valid = 0;
		asm("fence w,w");

	}
	else if(valid_box  == 1) {
		//Check which core is disabled
		if(!face_detection_person1){
			results_c2.landmark_valid = 0;
			asm("fence w,w");
		}
		else if(!face_detection_person2){
			results_c3.landmark_valid = 0;
			asm("fence w,w");

		}

	}

}



/***************************************************	Main start **********************************************************************/

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
			arena[i] = arena_create(5000000);
		}


		MicroPrintf("\t--Hello Efinix Edge Vision TinyML--\n\r");
		MicroPrintf("Initializing camera, display and DMA on core 0 ... \n\r");

		init_vision();
		soc_write_buffer_flush();

#if PICAM_VERSION == 3
		PiCamV3_StartStreaming();
#endif

		MicroPrintf("Done Initialization ... \n\r");


		MicroPrintf("[TinyML] Initializing multicore model ...\n\r");
		//Initialize interrupt and model
		initialize_multicore_model();
		IntcInitialize(BSP_PLIC_CPU_0, BSP_INIT_CHANNEL_0);
		init_accel(hartId);

		MicroPrintf("[TinyML] Done ...\n\r");
		MicroPrintf("[TinyML] Starting model run ...\n\r");


		//Flag to indicate multicore is ready
		asm("fence w,w");
		tinyml_multicore_init = 1;

		bsp_uDelay(10);

		while(1){
			//Resize 1080x1080 to 96x96 for Yolo
			uint8_t * yolo_resized_rgb_image = (uint8_t *)buf_yolo(draw_buffer);

			//Assign to model input
			assign_model_input(&yolo_core0,yolo_resized_rgb_image);

			//Invoke model
			invoke_model(&yolo_core0, &results_c0);


			//Run output layer
			run_yolo_layer(&yolo_core0, &results_c0, yolo_anchors);

			framebuf_clearall(); 

			//Draw box
			draw_boxes_yolo(results_c0.boxes,results_c0.total_boxes,YOLO_OBJECTNESS_THRESHOLD);

			//display_text_on_box for yolo an face detection
			display_text_on_box(results_c0.boxes,results_c0.total_boxes,YOLO_OBJECTNESS_THRESHOLD,results_c1.boxes,results_c1.total_boxes,FD_OBJECTNESS_THRESHOLD);

//			show_output_yolo(&results_c0);

			//Display print at screen
			framebuf_printf(1, 1, "Core 0 : Yolo Person Detection");

			framebuf_printf(1, 2, "Core 1 : Face Detection");
			if(face_detection_person1 && face_detection_person2){
				framebuf_printf(1, 3, "Core 2 : Face Landmark");
				framebuf_printf(1, 4, "Core 3 : Face Landmark");
			}
			else if(face_detection_person1) {
				framebuf_printf(1, 3, "Core 2 : Face Landmark");
			}
			else if(face_detection_person2) {
				framebuf_printf(1, 3, "Core 3 : Face Landmark");
			}


			//Switch draw buffer to latest complete frame
			draw_buffer = next_display_buffer;

			//print out accelerator config for all cores
			if(print_config){
				for(int i=0 ; i < HART_COUNT ; i++){
					print_accel(i);
				}
				print_config = 0;
			}

			//Clear memory allocation before new run
			arena_clear(arena[hartId]);
		}
	}


	//////////////////////////
	//Core 1: Face detection//
	//////////////////////////
	else if(hartId == 1) {
		while(!tinyml_multicore_init);
		asm("fence r,r");
		IntcInitialize(BSP_PLIC_CPU_1, BSP_INIT_CHANNEL_1);
		init_accel(hartId);

		while (1) {
			//Resize 1080x1080 to 128x128 for face detection
			uint8_t * fd_resized_rgb_image = (uint8_t * )buf_fd(draw_buffer);


			//Assign to model input
			assign_model_input(&face_detection_core1,fd_resized_rgb_image);

			//Invoke model
			invoke_model(&face_detection_core1, &results_c1);


			//Run output layer
			run_fd_layer(&face_detection_core1, &results_c1);

			//Draw box and check against valid image
			int valid_boxes = draw_boxes_fd(results_c1.boxes,results_c1.total_boxes,FD_OBJECTNESS_THRESHOLD); //change here KW

			//Show output
//			show_output_fd(&results_c1);


			//Reset face person 1 and 2 flag to 0 before processing to find faces
			asm("fence w,w");
			face_detection_person1 = 0;

			asm("fence w,w");
			face_detection_person2 = 0;


			//Check if there is any valid boxes plotted
			if (valid_boxes > 0) {
				find_face(&results_c1);
			}
			else {
				asm("fence w,w");
				results_c2.landmark_valid = 0;

				asm("fence w,w");
				results_c3.landmark_valid = 0;

			}

			//Clear memory allocation before new run
			arena_clear(arena[hartId]);
		}

	}


	//////////////////////////
	//Core 2: Face landmark //
	//////////////////////////
	else if (hartId == 2) {
		while(!tinyml_multicore_init);
		asm("fence r,r");
		IntcInitialize(BSP_PLIC_CPU_2, BSP_INIT_CHANNEL_2);
		init_accel(hartId);

		while(1) {

			while(!face_detection_person1);
			asm("fence r,r");


			//Cropping
			uint8_t* cropped_person1_rgb_image = crop_image_rgba((uint8_t*)buf_offset(draw_buffer,IMAGE_START_OFFSET), person1.center_x, person1.center_y, person1.offset, square_size, frame_channels, (int*)&person1.width , (int*)&person1.height, face_landmark_core2.input_channels);


			//Scaling to 192x192
			uint8_t* fl_person1_resized_rgb_image = nearest_neighbor_resize(cropped_person1_rgb_image, person1.width, person1.height, face_landmark_core2.input_channels, face_landmark_core2.input_width, face_landmark_core2.input_height , face_landmark_core2.input_channels);

			//Assign to model input
			assign_model_input(&face_landmark_core2,fl_person1_resized_rgb_image);


			//Invoke model
			invoke_model(&face_landmark_core2, &results_c2);


			//Run output layer
			run_landmark_output(&face_landmark_core2, &results_c2, &person1);


			//Show output
//			show_output_fl(&face_landmark_core2, &results_c2);

			//Clear memory allocation before new run
			arena_clear(arena[hartId]);

		}

	}




	//////////////////////////
	//Core 3: Face landmark //
	//////////////////////////

	else if (hartId == 3) {
		while(!tinyml_multicore_init);
		asm("fence r,r");
		IntcInitialize(BSP_PLIC_CPU_3, BSP_INIT_CHANNEL_3);
		init_accel(hartId);
		while(1){

			while(!face_detection_person2);
			asm("fence r,r");

			//Cropping
			uint8_t* cropped_person2_rgb_image = crop_image_rgba((uint8_t*)buf_offset(draw_buffer,IMAGE_START_OFFSET), person2.center_x, person2.center_y, person2.offset, square_size, frame_channels, (int*)&person2.width , (int*)&person2.height, face_landmark_core3.input_channels);


			//Scaling to 192x192
			uint8_t* fl_person2_resized_rgb_image = nearest_neighbor_resize(cropped_person2_rgb_image, person2.width, person2.height, face_landmark_core3.input_channels, face_landmark_core3.input_width, face_landmark_core3.input_height , face_landmark_core3.input_channels);

			//Assign to model input
			assign_model_input(&face_landmark_core3, fl_person2_resized_rgb_image);

			//Invoke model
			invoke_model(&face_landmark_core3, &results_c3);


			//Run output layer
			run_landmark_output(&face_landmark_core3, &results_c3, &person2);

			//Show output
//			show_output_fl(&face_landmark_core3, &results_c3);

			//Clear memory allocation before new run
			arena_clear(arena[hartId]);
		}
	}
}



void smpInitWrapper(u32 a, u32 b, u32 c) {
	smpInit(); // Call the original function
}


void main() {
	bsp_init();
	bsp_printf("***Starting SMP Demo*** \r\n");
	smp_unlock(smpInitWrapper);
	mainSmp();
	bsp_printf("***Succesfully Ran Demo*** \r\n");
}

