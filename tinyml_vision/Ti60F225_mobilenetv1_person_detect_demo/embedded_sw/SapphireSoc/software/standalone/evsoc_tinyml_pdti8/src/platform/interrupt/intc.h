/*
 * intc.h
 *
 *  Created on: 2022年4月2日
 *      Author: jefferyl
 */

#ifndef SRC_INTC_H_
#define SRC_INTC_H_

#define DMASG_BASE            IO_APB_SLAVE_0_INPUT

#include <stdint.h>
#include "riscv.h"
#include "plic.h"
#include "bsp.h"
#include "dmasg.h"

//For DMA interrupt
extern uint8_t cam_s2mm_active;
extern uint8_t display_mm2s_active;

//Each channel connects to only 1 port, hence all ports are referred as port 0.
#define DMASG_CAM_S2MM_CHANNEL         0
#define DMASG_CAM_S2MM_PORT            0

#define DMASG_DISPLAY_MM2S_CHANNEL     1
#define DMASG_DISPLAY_MM2S_PORT        0

#define DMASG_HW_ACCEL_S2MM_CHANNEL    2
#define DMASG_HW_ACCEL_S2MM_PORT       0

#define DMASG_HW_ACCEL_MM2S_CHANNEL    3
#define DMASG_HW_ACCEL_MM2S_PORT       0


#ifdef __cplusplus
extern "C" {
#endif

/************************** Variable Definitions *****************************/

/************************** Function Definitions *****************************/
void IntcInitialize();
void userInterrupt();
void dma_init();
void trap_entry();
void trap();
void trigger_next_display_dma();
void trigger_next_cam_dma();
void trigger_next_box_dma();

#ifdef __cplusplus
}
#endif
#endif /* SRC_INTC_H_ */
