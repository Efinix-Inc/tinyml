////////////////////////////////////////////////////////////////////////////////
// Copyright (C) 2013-2026 Efinix Inc. All rights reserved.
// See https://github.com/Efinix-Inc/tinyml/blob/main/LICENSE.txt for details.
////////////////////////////////////////////////////////////////////////////////
//
// SINGLE-MODEL REFERENCE (Yolo only, single core)
// ---------------------------------------------------------
// This is the multicore SMP demo with everything unrelated to running ONE
// model (yolo person detection) on ONE hart physically deleted. The goal 
// is to show, as plainly as possible, the smallest set of pieces the EVSOC 
// needs to run a single TinyML model.
//
// The file is ordered to make sense of the main running loop:
//   1. Includes
//   2. Memory map (where everything lives in DRAM)
//   3. Global state (results, buffer indices)
//   4. Low-level helpers (buffer addresses, DMA send/receive, flash read)
//   5. Drawing primitives (text overlay)
//   6. Startup / init (camera, display, buffers)
//   7. Per-frame DMA triggers (capture next frame, send to display)
//   8. Detection helpers (boxes, labels)
//   9. main() -- load one model, turn on the accelerator once, loop
//
////////////////////////////////////////////////////////////////////////////////

// =============================================================================
// INCLUDES
// =============================================================================

#include <stdlib.h>
#include <stdint.h>
#include "riscv.h"
#include "soc.h"
#include "bsp.h"
#include "plic.h"
#include "uart.h"
#include <math.h>
#include "clint.h"
#include "common.h"
#include "platform/vision/camera.h"
#include "PiCamV3Driver.h"
#include "PiCamDriver.h"
#include "apb3_cam.h"
#include "i2c.h"
#include "userDef.h"
extern "C" {
#include "dmasg.h"
}
#include "intc.h"
#include "axi4_hw_accel.h"
//Tinyml Header File
#include "tinyml.h"
#include "ops/ops_api.h"
//Import TensorFlow lite libraries
#include "tensorflow/lite/micro/micro_error_reporter.h"
#include "tensorflow/lite/micro/micro_interpreter.h"
#include "tensorflow/lite/micro/all_ops_resolver.h"
#include "tensorflow/lite/micro/testing/micro_test.h"
#include "tensorflow/lite/schema/schema_generated.h"
#include "tensorflow/lite/c/common.h"
#include "tensorflow/lite/micro/debug_log.h"
#include "tensorflow/lite/micro/micro_time.h"
#include "platform/tinyml/profiler.h"
#include "coreDef.h"
//Arena allocation
#include "model/arena.h"
//Model pre-processing, setup, init, and output
#include "model/crop_scale_util.h"
#include "model/tinyml_init.h"
#include "model/model_setup.h"
#include "model/tinyml_output.h"
//text
#include "spiFlash.h"
#include "platform/vision/printf.h"
#include "platform/vision/font.h"
#define SPI SYSTEM_SPI_0_IO_CTRL

// =============================================================================
// MEMORY MAP (display buffers and model input location in DRAM)
// =============================================================================

#define FONT_WIDTH   	8
#define FONT_HEIGHT  	16
#define FRAMEBUF_WIDTH  135
#define FRAMEBUF_HEIGHT 68
#define FRAME_WIDTH    	1080
#define FRAME_HEIGHT   	1080
#define DUMMY_SIZE  	20
#define BBOX_MAX    	16
#define FONT_FLASH_ADDR		0x005F0000
#define FONT_FLASH_SIZE		(128 * FONT_WIDTH * FONT_HEIGHT / 8)
#define FRAMEBUF_SIZE 		(FRAMEBUF_WIDTH*FRAMEBUF_HEIGHT)
#define IMAGE_SIZE    		(FRAME_WIDTH*FRAME_HEIGHT*4)
#define TOTAL_BOX_SIZE 		(BBOX_MAX * 8)

// Each display buffer slot is laid out as: [cmd tag][text overlay][padding][full image]
#define FRAMEBUF_CMD_OFFSET 	0                                    // 8-byte tag for the text overlay
#define FRAMEBUF_START_OFFSET 	8                                    // text overlay pixel data starts here
#define FRAMEBUF_END_OFFSET 	(FRAMEBUF_START_OFFSET + FRAMEBUF_SIZE)
#define DUMMY_START_OFFSET 		(FRAMEBUF_END_OFFSET)               // small padding region
#define DUMMY_END_OFFSET 		(DUMMY_START_OFFSET + DUMMY_SIZE)
#define IMAGE_CMD_OFFSET 		(DUMMY_END_OFFSET)                  // 8-byte tag for the full image
#define IMAGE_START_OFFSET 		(IMAGE_CMD_OFFSET + 8)          // full image pixel data starts here
#define IMAGE_END_OFFSET 		(IMAGE_START_OFFSET + IMAGE_SIZE)
#define TOTAL_BUFFER_SIZE 		(IMAGE_END_OFFSET - FRAMEBUF_CMD_OFFSET) // size of one whole display buffer slot
#define TOTAL_DISPLAY_BUF_SIZE 	(IMAGE_END_OFFSET - FRAMEBUF_CMD_OFFSET)
#define DISPLAY_BUF_ADDR 		0x02100000                          // DRAM start address of buffer 0
#define MAX_DISPLAY_BUFFERS 	5                                    // number of display buffer slots (ring buffer)

// Buffer DRAM Allocations (unaffected by removing FD/landmark -- this is
// exactly the same 5-slot display buffer layout as the multi-model build)
//   | ------------------------------------------ | 0xE000_0000
//   |                                            |
//   | ------------------------------------------ | 0x0374_A900 (55.29 MiB)
//   | (Repeat 4 more identical buffers)          |
//   | ------------------------------------------ | 0x0257_5500 (37.46 MiB)
//   | IMAGE							          |  1080 x 1080 x 4 = 4.45 MiB
//   | ------------------------------------------ | 0x0210_2400
//   | IMAGE_CMD				                  |  8 Bytes
//   | ------------------------------------------ | 0x0210_23F8
//   | DUMMY     		                          |  20 Bytes
//   | ------------------------------------------ | 0x0210_23E4
//   | FRAMEBUF                                   |  135 x 68 = 8.96 KiB
//   | ------------------------------------------ | 0x0210_0008
//   | FRAMEBUF_CMD			                      |  8 Bytes
//   | ------------------------------------------ | 0x0210_0000 (33.00 MiB)

// TinyML model input buffers (separate region, right after the display buffers)
#define TINYML_INPUT_START_ADDR  	(DISPLAY_BUF_ADDR + TOTAL_BUFFER_SIZE * MAX_DISPLAY_BUFFERS)
#define tinyml_input_array 			((volatile uint8_t*)TINYML_INPUT_START_ADDR)
#define YOLO_BOX_CMD_OFFSET 		(TINYML_INPUT_START_ADDR + 0x100000)
#define YOLO_BOX_START_OFFSET 		(YOLO_BOX_CMD_OFFSET + 8)
#define YOLO_BOX_END_OFFSET 		(YOLO_BOX_START_OFFSET + TOTAL_BOX_SIZE)
#define bbox_array_yolo 			((volatile uint64_t*)(YOLO_BOX_START_OFFSET)) // yolo boxes, sent to overlay HW
#define FONT_START_OFFSET 			(YOLO_BOX_END_OFFSET + 8)
#define FONT_END_OFFSET 			(FONT_START_OFFSET + FONT_FLASH_SIZE)
#define YOLO_INPUT_START_ADDR 		(FONT_END_OFFSET + 0x100000)
#define YOLO_INPUT_BYTES 			(96*96*3)                        // yolo model input size (96x96 RGB)

// TinyML Input DRAM Allocations -- same idea as the multi-model build's
// diagram, just without the FD_INPUT / FD_BOX rows (and everything below
// FONT shifts down accordingly -- the exact addresses aren't reprinted
// here since they depend on your build's FONT_FLASH_SIZE; walk the
// #defines above if you need the literal hex).
//   | ------------------------------------------ |
//   | GAP FOR MULTIPLE YOLO_INPUT BUFFERS        |  1 MiB
//   | ------------------------------------------ |
//   | YOLO_INPUT                                 |  96 x 96 x 3 = 27 KiB
//   | ------------------------------------------ |
//   |                                            |  1 MiB
//   | ------------------------------------------ |
//   | FONT                                       |  (128 x 8 x 16) / 8 = 2 KiB
//   | ------------------------------------------ |
//   | YOLO_BOX     		                      |  16 x 8 = 128 Bytes
//   | ------------------------------------------ |
//   | YOLO_BOX_CMD                               |  8 Bytes
//   | ------------------------------------------ |
//   | TINYML_INPUT_ARRAY			              |  1 MiB
//   | ------------------------------------------ |

// =============================================================================
// GLOBAL STATE (results, buffer indices, flags)
// =============================================================================

volatile u32 print_config = 1;               // print accelerator config once at boot

//Result of the one model this build runs (boxes, timing, status)
struct yolo_result results_c0;

// Which display buffer slot is being captured / shown / drawn into right now
// Plain software bookkeeping
uint8_t camera_buffer = 0;
uint8_t display_buffer = 0;
uint8_t next_display_buffer = 0;
uint8_t draw_buffer = 0;
uint8_t bbox_overlay_yolo_updated = 0;
int32_t next_display_buffer_2 = 0;

// =============================================================================
// LOW-LEVEL HELPERS (buffer addresses, cache flush, DMA wrappers)
// =============================================================================

static void flush_data_cache(){ asm(".word(0x500F)"); }

// Display & yolo input buffer addresses
u32 buf(u32 i)      { return DISPLAY_BUF_ADDR + TOTAL_BUFFER_SIZE*i; }     // address of display buffer i
u32 buf_yolo(u32 i) { return YOLO_INPUT_START_ADDR + YOLO_INPUT_BYTES*i; } // address of yolo input buffer i

// Get an address/pointer at some byte offset inside display buffer i
u32        buf_offset(u32 i, u32 offset) { return buf(i) + offset; }
char* buf_offset_char(u32 i, u32 offset) { return (char*)buf_offset(i, offset); }
u32*   buf_offset_u32(u32 i, u32 offset) { return  (u32*)buf_offset(i, offset); }
u64*   buf_offset_u64(u32 i, u32 offset) { return  (u64*)buf_offset(i, offset); }

// DMA wrappers
// send_dma = memory -> stream (MM2S), used to push a buffer out to the display
// recv_dma = stream -> memory (S2MM), used to capture camera pixels into a buffer
void send_dma(u32 channel, u32 port, u32 addr, u32 size, int interrupt, int wait, int self_restart) {
	dmasg_input_memory(DMASG_BASE, channel, addr, 16);
	dmasg_output_stream(DMASG_BASE, channel, port, 0, 0, 1);
	if(interrupt) dmasg_interrupt_config(DMASG_BASE, channel, DMASG_CHANNEL_INTERRUPT_CHANNEL_COMPLETION_MASK);
	dmasg_direct_start(DMASG_BASE, channel, size, self_restart ? 1 : 0);
	if(wait){ while(dmasg_busy(DMASG_BASE, channel)); flush_data_cache(); }
}
void recv_dma(u32 channel, u32 port, u32 addr, u32 size, int interrupt, int wait, int self_restart) {
	dmasg_input_stream(DMASG_BASE, channel, port, 1, 0);
	dmasg_output_memory(DMASG_BASE, channel, addr, 16);
	if(interrupt) dmasg_interrupt_config(DMASG_BASE, channel, DMASG_CHANNEL_INTERRUPT_CHANNEL_COMPLETION_MASK);
	dmasg_direct_start(DMASG_BASE, channel, size, self_restart ? 1 : 0);
	if(wait){ while(dmasg_busy(DMASG_BASE, channel)); flush_data_cache(); }
}

// Reads size bytes out of SPI flash starting at flash_addr, into dest (used for font data)
void flash_copy(volatile char *dest, u32 flash_addr, u32 size, int loading) {
	spiFlash_wake(SPI,0);
	spi_select(SPI, 0);
	spi_write(SPI, 0x03);
	spi_write(SPI, (flash_addr >> 16) & 0xFF);
	spi_write(SPI, (flash_addr >> 8) & 0xFF);
	spi_write(SPI, flash_addr & 0xFF);
	for (u32 i = 1; i <= size; i++) *dest++ = spi_read(SPI);
	spi_diselect(SPI, 0);
}

// =============================================================================
// DRAWING PRIMITIVES (text overlay)
// (init & DMA both require them)
// =============================================================================

char* framebuf(int i) { return (char*) buf_offset(i, FRAMEBUF_START_OFFSET); }  // pointer to buffer i's text layer
void  framebuf_clear(void) { memset(framebuf(draw_buffer), 0, FRAMEBUF_SIZE); } // clear current draw buffer's text
void  framebuf_clearall(void) {                                                 // clear text in every display buffer
	for(int i = 0; i < MAX_DISPLAY_BUFFERS; i++) memset((char*)buf_offset(i, FRAMEBUF_START_OFFSET), 0, FRAMEBUF_SIZE);
}
// Print text onto the text-overlay layer at coordinates (x,y)
int framebuf_printf(int x, int y, const char *format, ...) {
	int pos = FRAMEBUF_WIDTH * y + x;
	int max_length = FRAMEBUF_HEIGHT * FRAMEBUF_WIDTH - pos;
	va_list va;
	va_start(va, format);
	int ret;
	for (int i =0;i < MAX_DISPLAY_BUFFERS; i++ ) ret = vsnprintf_(framebuf(i) + pos, max_length, format, va);
	va_end(va);
	return ret;
}

// =============================================================================
// STARTUP / INIT -- fill buffers with sane defaults, bring up camera
// =============================================================================

// Draws a test color bar pattern into a buffer (used before the camera is live)
void color_pattern(volatile u32* buf){
	for (int y=0; y<FRAME_HEIGHT; y++) {
		for (int x=0; x<FRAME_WIDTH; x++) {
			if ((x<3 && y<3) || (x>=FRAME_WIDTH-3 && y<3) || (x<3 && y>=FRAME_HEIGHT-3) || (x>=FRAME_WIDTH-3 && y>=FRAME_HEIGHT-3)) buf[y*FRAME_WIDTH + x] = 0x000000FF;
			else if (x<(FRAME_WIDTH/4)) buf[y*FRAME_WIDTH + x] = 0x0000FF00;
			else if (x<(FRAME_WIDTH/4 *2)) buf[y*FRAME_WIDTH + x] = 0x00FF0000;
			else if (x<(FRAME_WIDTH/4 *3)) buf[y*FRAME_WIDTH + x] = 0x000000FF;
			else buf[y*FRAME_WIDTH + x] = 0x00FF0000;
		}
	}
}
// Set every image slot as valid, then draws the color bar into the current display buffer
void init_image(void) {
	for(int i=0; i<MAX_DISPLAY_BUFFERS; i++) *buf_offset_u64(i, IMAGE_CMD_OFFSET) = 3;
	color_pattern(buf_offset_u32(display_buffer, IMAGE_START_OFFSET));
}
// Copies font glyph data from flash into the font buffer
void init_fontbuf(void) {
	volatile u64 *cmd = (u64*) 0x00720000;
	volatile u64 *buf = cmd + 1;
	flash_copy((volatile char*) buf, FONT_FLASH_ADDR, FONT_FLASH_SIZE, 0);
	*cmd = 1;
}
// Tags every text-overlay slot as valid, then clears the text
void init_framebuf(void) {
	for (int i = 0; i < MAX_DISPLAY_BUFFERS; i++) *buf_offset_u64(i, FRAMEBUF_CMD_OFFSET) = 2;
	framebuf_clearall();
}
// Sends the font buffer to the display once at boot
void send_dma_font_buf(void){
	dmasg_input_memory(DMASG_BASE, DMASG_DISPLAY_MM2S_CHANNEL, 0x00720000, 16);
	dmasg_output_stream(DMASG_BASE, DMASG_DISPLAY_MM2S_CHANNEL, DMASG_DISPLAY_MM2S_PORT, 0, 0, 1);
	dmasg_direct_start(DMASG_BASE, DMASG_DISPLAY_MM2S_CHANNEL, FONT_FLASH_SIZE + 8, 0);
	while (dmasg_busy(DMASG_BASE, DMASG_DISPLAY_MM2S_CHANNEL));
	flush_data_cache();
}
// Marks all yolo bounding boxes as invalid at boot
void init_bbox_yolo(void) {
	*(volatile uint64_t*)YOLO_BOX_CMD_OFFSET = 0x0000000000000004;
	for(int j=0;j<=(BBOX_MAX+1);j++) bbox_array_yolo[j] = 0xffffffffffffffff;
	bbox_overlay_yolo_updated=1;
}
// Fills the small padding (dummy) region in every buffer with 0xFF
void init_dummy(void) {
	if(DUMMY_SIZE == 0) return;
	for (int i = 0; i < MAX_DISPLAY_BUFFERS; i++) memset((char*)buf_offset(i, DUMMY_START_OFFSET), 0xFFFFFFFF, DUMMY_SIZE);
}
// Brings up the camera, DMA engine, and display buffers, then starts the first
// camera capture. Called once at boot, before the main loop.
void init_vision() {
	/************************************************************SETUP PICAM************************************************************/
	MicroPrintf("Camera Setting...\r\n");
	// Reset mipi, Soft reset
	EXAMPLE_APB3_REGW(EXAMPLE_APB3_SLV, EXAMPLE_APB3_SLV_REG1_OFFSET, 1);// assert reset
	bsp_uDelay(100);
	EXAMPLE_APB3_REGW(EXAMPLE_APB3_SLV, EXAMPLE_APB3_SLV_REG1_OFFSET, 0);//de-assert reset
	bsp_uDelay(1000*10); //10ms delay
	spiFlash_init(SPI,0);
	// reset frame buffer
	framebuf_clearall();
	//Camera I2C configuration
	cam0_init(I2C_CTRL_CAM0);

	bsp_printf("Camera Init...Done\r\n");

	/*************************************************************SETUP DMA*************************************************************/
	MicroPrintf("DMA Setting...");
	dma_init();
	dmasg_priority(DMASG_BASE, DMASG_HW_RESCALE_CH0_S2MM_CHANNEL, 0, 0);
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

// =============================================================================
// PER-FRAME DMA TRIGGERS (capture next frame, push to display)
// All trigger_* functions are triggered in intc.c
// =============================================================================

// Sends the current display buffer to the screen
void trigger_next_display_dma() {
	send_dma(DMASG_DISPLAY_MM2S_CHANNEL, DMASG_DISPLAY_MM2S_PORT, buf(display_buffer), TOTAL_BUFFER_SIZE, 1, 0, 0);
	display_buffer = next_display_buffer_2;
}
// Sends updated yolo bounding boxes to the display overlay hardware
void trigger_next_box_dma() {
	if (bbox_overlay_yolo_updated) {
		asm("fence r,r");
		send_dma(DMASG_DISPLAY_MM2S_CHANNEL, DMASG_DISPLAY_MM2S_PORT, YOLO_BOX_CMD_OFFSET, TOTAL_BOX_SIZE + 8, 0, 1, 0); //Wait till complete
		asm("fence w,w");
		bbox_overlay_yolo_updated = 0;
	}
}
// Picks a free buffer slot (out of 5) and starts capturing the next camera frame into it.
// Captures the resized yolo input (as model input) and the raw camera input (for display output).
//
// Below is the round-robin sequence of passing camera_buffer indices:
// 		  display_buffer = next_display_buffer_2;
// next_display_buffer_2 = next_display_buffer;
//   next_display_buffer = camera_buffer;
// 		   camera_buffer = i;
void trigger_next_cam_dma() {
	next_display_buffer_2 = next_display_buffer;
	next_display_buffer = camera_buffer;
	for(int i=0; i<=MAX_DISPLAY_BUFFERS; i++) {
		if(i!=display_buffer && i!=next_display_buffer && i!=draw_buffer && i!=next_display_buffer_2) {
			camera_buffer = i;
			break;
		}
	}
	recv_dma(DMASG_HW_RESCALE_CH0_S2MM_CHANNEL, DMASG_HW_RESCALE_CH0_S2MM_PORT, buf_yolo(camera_buffer), YOLO_INPUT_BYTES, 0, 0, 0);
	recv_dma(DMASG_CAM_S2MM_CHANNEL, DMASG_CAM_S2MM_PORT, buf_offset(camera_buffer, IMAGE_START_OFFSET), IMAGE_SIZE, 1, 0, 0);
	//Indicate start of S2MM DMA to camera building block via APB3 slave
	EXAMPLE_APB3_REGW(EXAMPLE_APB3_SLV, EXAMPLE_APB3_SLV_REG4_OFFSET, 0x00000007);
	EXAMPLE_APB3_REGW(EXAMPLE_APB3_SLV, EXAMPLE_APB3_SLV_REG4_OFFSET, 0x00000000);
	//Trigger storage of one captured frame via APB3 slave
	EXAMPLE_APB3_REGW(EXAMPLE_APB3_SLV, EXAMPLE_APB3_SLV_REG2_OFFSET, 0x00000001);
	EXAMPLE_APB3_REGW(EXAMPLE_APB3_SLV, EXAMPLE_APB3_SLV_REG2_OFFSET, 0x00000000);
}

// =============================================================================
// DETECTION HELPERS (boxes, labels)
// =============================================================================

// Converts yolo detection boxes (0..1 range) into screen coordinates for the overlay
void draw_boxes_yolo(box* boxes,int total_boxes, float objectness_thresh){
	float min_val = 0.00, max_val = 1.00;
	uint16_t x_min,x_max,y_min,y_max;
	uint64_t box_coordinates;
	for (int i = 0; i<(BBOX_MAX); i++) {
		if(i < total_boxes) {
			if (boxes[i].x_min < min_val || boxes[i].y_min < min_val || boxes[i].x_max < min_val || boxes[i].y_max < min_val ||
				boxes[i].x_min > max_val || boxes[i].y_min > max_val || boxes[i].x_max > max_val || boxes[i].y_max > max_val ||
				boxes[i].objectness < objectness_thresh) {
				bbox_array_yolo[i] = 0xffffffffffffffff;
			} else {
				x_min = (boxes[i].x_min)*FRAME_WIDTH; y_min = (boxes[i].y_min)*FRAME_HEIGHT;
				x_max = (boxes[i].x_max)*FRAME_WIDTH; y_max = (boxes[i].y_max)*FRAME_HEIGHT;
				if(x_max > FRAME_WIDTH) x_max = (FRAME_WIDTH-1);
				if(y_max > FRAME_HEIGHT) y_max = (FRAME_HEIGHT-1);
				box_coordinates = (uint64_t)x_min<<48 | (uint64_t)y_min<<32 | (uint64_t)x_max<<16 | (uint64_t)y_max<<0;
				bbox_array_yolo[i] = box_coordinates;
			}
		} else bbox_array_yolo[i] = 0xffffffffffffffff;
	}
	bbox_overlay_yolo_updated=1;
}
// Prints "Person(score)" labels above each valid detection box
void display_text_on_box(box* yolo_boxes, int total_yolo_boxes, float yolo_objectness_thresh){
	float min_val = 0.00, max_val = 1.00;
	uint16_t x_min,y_min;
	for (int i = 0; i< total_yolo_boxes; i++) {
		if (!(yolo_boxes[i].x_min < min_val || yolo_boxes[i].y_min < min_val || yolo_boxes[i].x_max < min_val || yolo_boxes[i].y_max < min_val ||
			  yolo_boxes[i].x_min > max_val || yolo_boxes[i].y_min > max_val || yolo_boxes[i].x_max > max_val || yolo_boxes[i].y_max > max_val ||
			  yolo_boxes[i].objectness < yolo_objectness_thresh)) {
			x_min = (yolo_boxes[i].x_min)*FRAME_WIDTH; y_min = (yolo_boxes[i].y_min)*FRAME_HEIGHT;
			uint16_t x_font = x_min / FONT_WIDTH + 1;
			uint16_t y_font = y_min / FONT_HEIGHT - 1;
			if(y_font <= 0) y_font = 0;
			framebuf_printf(x_font, y_font, "Person(%.2f)", yolo_boxes[i].objectness);
		}
	}
}

// =============================================================================
// MAIN -- load one model, turn on the accelerator once, loop
// =============================================================================

/***************************************************	Main start **********************************************************************/
int main() {
	bsp_init();
	bsp_printf("***Starting Single-Model (Yolo) Demo*** \r\n");

	//One arena for the one model this build runs. See model/arena.h.
	arena[0] = arena_create(5000000);

	MicroPrintf("\t--Hello Efinix Edge Vision TinyML--\n\r");
	MicroPrintf("Initializing camera, display and DMA ... \n\r");
	init_vision();
	soc_write_buffer_flush();
	MicroPrintf("Done Initialization ... \n\r");

	MicroPrintf("[TinyML] Initializing yolo model ...\n\r");
//	//Load the yolo model and its own tensor arena
//	struct TfliteMicroModel yolo_core0;
//	uint8_t yolo_core0_tensor_arena[150000];
//	setup_tflite_micro_model(&yolo_core0,
//	                          yolo_person_detect_model_data,
//	                          yolo_core0_tensor_arena,
//	                          sizeof(yolo_core0_tensor_arena),
//	                          true,
//	                          "Yolo");
	setup_yolo_core0();
	IntcInitialize(BSP_PLIC_CPU_0, BSP_INIT_CHANNEL_0);
	//Turn on the hardware accelerator (must run once), reads hartId = 0
	init_accel(0);
	MicroPrintf("[TinyML] Done ...\n\r");
	MicroPrintf("[TinyML] Starting model run ...\n\r");
	bsp_uDelay(10);

	while(1){
		//Resize 1080x1080 to 96x96 for Yolo -- done in hardware by the
		//HW_RESCALE_CH0 DMA channel triggered in trigger_next_cam_dma()/
		//init_vision(); this just reads out the result -- grab resized
		//camera frame, feed it to the yolo model
		uint8_t * yolo_resized_rgb_image = (uint8_t *)buf_yolo(draw_buffer);
		//Assign to model input
		assign_model_input(&yolo_core0,yolo_resized_rgb_image);
		//Invoke model -- run the yolo model
		invoke_model(&yolo_core0, &results_c0);
		//Run output layer -- decode boxes, draw them, print to UART
		run_yolo_layer(&yolo_core0, &results_c0, yolo_anchors);
		framebuf_clearall();
		//Draw box
		draw_boxes_yolo(results_c0.boxes,results_c0.total_boxes,YOLO_OBJECTNESS_THRESHOLD);
		//Draw "Person(score)" text above each valid box
		display_text_on_box(results_c0.boxes,results_c0.total_boxes,YOLO_OBJECTNESS_THRESHOLD);
		//To print out yolo output detected boxes over UART
//		show_output_yolo(&results_c0);
		//Display print at screen
		framebuf_printf(1, 1, "Yolo Person Detection");
		//Switch draw buffer to latest complete frame
		draw_buffer = next_display_buffer;
		//print out accelerator config, once -- only accelerator instance 0 is ever used
		if(print_config){
			print_accel(0);
			print_config = 0;
		}
		//Clear memory allocation before new run
		arena_clear(arena[0]);
	}

	bsp_printf("***Succesfully Ran Demo*** \r\n");
	return 0;
}
