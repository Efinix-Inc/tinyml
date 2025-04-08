#ifndef CACHE_H
#define CACHE_H

#include "ops_api.h"
#include "intc.h"
#include "platform/tinyml/accel_settings.h"



void cache_init_trigger(
		int32_t set_0_num_of_cache_lines,
		int32_t set_0_num_of_cache_words,
		int32_t set_0_roll_update_gap_bytes,
		int32_t set_0_ext_addr,
		int32_t set_1_num_of_cache_lines,
		int32_t set_1_num_of_cache_words,
		int32_t set_1_roll_update_gap_bytes,
		int32_t set_1_ext_addr,
		int roll_update_enable
		);

void cache_reset();

int32_t get_cache_hit_cntr();
int32_t get_cache_miss_cntr();

#endif //CACHE_H
