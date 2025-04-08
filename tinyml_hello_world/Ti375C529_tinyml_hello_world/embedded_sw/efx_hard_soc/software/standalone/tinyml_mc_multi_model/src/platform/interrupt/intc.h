/*
 * intc.h
 *
 *  Created on: 2022年4月2日
 *      Author: jefferyl
 */

#ifndef SRC_INTC_H_
#define SRC_INTC_H_

#ifdef __cplusplus
extern "C" {
#endif

/************************** Variable Definitions *****************************/

/************************** Function Definitions *****************************/
void IntcInitialize(uint32_t core, uint32_t channel);
void trap_entry();
void trap();


#define BSP_PLIC_CPU_1 SYSTEM_PLIC_SYSTEM_CORES_1_EXTERNAL_INTERRUPT
#define BSP_PLIC_CPU_2 SYSTEM_PLIC_SYSTEM_CORES_2_EXTERNAL_INTERRUPT
#define BSP_PLIC_CPU_3 SYSTEM_PLIC_SYSTEM_CORES_3_EXTERNAL_INTERRUPT

#define BSP_INIT_CHANNEL_0 SYSTEM_PLIC_USER_INTERRUPT_D_INTERRUPT
#define BSP_INIT_CHANNEL_1 SYSTEM_PLIC_USER_INTERRUPT_F_INTERRUPT
#define BSP_INIT_CHANNEL_2 SYSTEM_PLIC_USER_INTERRUPT_G_INTERRUPT
#define BSP_INIT_CHANNEL_3 SYSTEM_PLIC_USER_INTERRUPT_H_INTERRUPT



#ifdef __cplusplus
}
#endif
#endif /* SRC_INTC_H_ */
