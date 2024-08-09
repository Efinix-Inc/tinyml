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
void IntcInitialize();
void trap_entry();
void trap();

#ifdef __cplusplus
}
#endif
#endif /* SRC_INTC_H_ */
