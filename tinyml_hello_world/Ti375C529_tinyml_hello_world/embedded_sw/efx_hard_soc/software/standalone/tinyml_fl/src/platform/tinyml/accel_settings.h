/*
 * override_accel.h
 *
 *  Created on: 10 Mar 2025
 *      Author: mfaiz
 */

 #ifndef SRC_MODEL_ACCEL_SETTINGS_H_
 #define SRC_MODEL_ACCEL_SETTINGS_H_
 
 #include "platform/tinyml/ops/sys.h"
 #include "platform/tinyml/ops/ops_api.h"
 
 
 //Hold setting for each core
 extern struct hw_setting hw_accel_setting[1];
 
 //Override accelerator settings for particular core
 extern struct override_setting override_hw_accel_setting[1];
 
 //Profile layer
 extern const char* layer_mode;
 
 //Check number of accelerator instantiation
 extern int accel_count;
 
 //API to initialize accelerator
 void init_accel(int32_t hartId);
 
 //API to print accelerator config
 void print_accel(int32_t hartId);
 
 #endif /* SRC_MODEL_ACCEL_SETTINGS_H_ */
 