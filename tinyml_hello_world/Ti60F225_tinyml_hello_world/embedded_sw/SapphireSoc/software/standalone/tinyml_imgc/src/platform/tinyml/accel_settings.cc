#include "accel_settings.h"

// TinyML Hardware Accelerator settings for each Core (they will be zero-initialized by default)
struct hw_setting hw_accel_setting[1];  // Array of hw_setting structures for 4 cores

//TinyML Accelerator override settings for each core
//Set the override flag to 1 and set option to be turned off (Set _en to 0 to turn off).
struct override_setting override_hw_accel_setting[1] = {
    [0] = {.cache_en = 1,
        .conv_depthw_en = 1,
        .add_en = 1,
        .fc_en = 1,
        .mul_en = 1,
        .lr_en = 1,
        .min_max_en = 1,
        .override_flag = 0}  // Core 0
};

int accel_count;

void init_accel(int32_t hartId) {
	//Get accelerator count instantiation
	//Only Core 0 check the total instantiated core
	//Ensure that other core instantiate accelerator after core 0
	if(hartId == 0)
		accel_count = tinyml_accel_get_accel_count();

	//Check the accelerator instantiated at hardware. If accelerator not enabled, turn off the accelerator settings
	if(accel_count > hartId)
		apply_accel_config(&hw_accel_setting[hartId],&override_hw_accel_setting[hartId]);
	else
		turn_accel_off(&hw_accel_setting[hartId]);

}

void print_accel(int32_t hartId) {
	print_accel_config(&hw_accel_setting[hartId]);
}

//Printing layer mode
const char* layer_mode="";

