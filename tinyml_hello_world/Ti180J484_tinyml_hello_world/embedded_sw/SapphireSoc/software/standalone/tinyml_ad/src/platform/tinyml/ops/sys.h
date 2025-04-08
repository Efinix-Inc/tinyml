#ifndef SYS_H
#define SYS_H

#include "riscv.h"
#include "bsp.h"


//Structure to hold HW settings
struct hw_setting {
    int32_t uuid;
    int32_t core_id;
    int32_t axi_dw;
    int32_t conv_depthw_lite_parallel;
    int32_t cache_depth;
    int32_t axi_db_w;
    int32_t cache_en;
    int32_t conv_depthw_mode;
    int32_t add_mode;
    int32_t fc_mode;
    int32_t mul_mode;
    int32_t lr_mode;
    int32_t min_max_mode;
    int32_t conv_depthw_mode_input_cnt;
    int32_t conv_depthw_mode_output_cnt;
    int override_flag;
    int accel_active;
};

//Structure to hold hardware settings to turn off and on from SW
struct override_setting {
    int32_t cache_en;
    int32_t conv_depthw_en;
    int32_t add_en;
    int32_t fc_en;
    int32_t mul_en;
    int32_t lr_en;
    int32_t min_max_en;
    int override_flag;
};


int32_t tinyml_accel_get_uuid();
int32_t tinyml_accel_get_axi_dw();
int32_t tinyml_accel_get_cache_en();
int32_t tinyml_accel_get_cache_depth();
int32_t tinyml_accel_get_conv_depthw_mode();
int32_t tinyml_accel_get_conv_depthw_lite_parallel_setting();
int32_t tinyml_accel_get_add_mode();
int32_t tinyml_accel_get_fc_mode();
int32_t tinyml_accel_get_mul_mode();
int32_t tinyml_accel_get_lr_mode();
int32_t tinyml_accel_get_min_max_mode();
int32_t tinyml_accel_get_accel_count();
void 	turn_accel_off(hw_setting *hw_setting);
void 	apply_accel_config(hw_setting *hw_setting, override_setting * override_setting);
void    read_accel_config(hw_setting *hw_setting);
void    print_accel_config(hw_setting * hw_setting);
void    override_accel_config(hw_setting *hw_setting, override_setting * override_setting);

#endif // SYS_H
