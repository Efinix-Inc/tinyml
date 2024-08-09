#include "define.h"

int conv_depthw_mode=2;
int conv_depthw_lite_parallel=4;
int add_mode=2;
int fc_mode=0;
int mul_mode=2;
int lr_mode=0;
int min_max_mode=2;
int tinyml_cache=1;
int cache_depth = 4096;
int axi_dw = 512;
int axi_db_w = axi_dw/8;
int cache_mode = 1;
const char* layer_mode="";
