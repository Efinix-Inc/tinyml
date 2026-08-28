////////////////////////////////////////////////////////////////////////////////
// Copyright (C) 2013-2026 Efinix Inc. All rights reserved.
// See https://github.com/Efinix-Inc/tinyml/blob/main/LICENSE.txt for details.
////////////////////////////////////////////////////////////////////////////////

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
