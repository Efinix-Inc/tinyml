#ifndef FC_H
#define FC_H

#include "ops_api.h"
#include "intc.h"
#include "model/define.h"

OP_STATUS_T fully_connected_drv(

    const int32_t input_offset,
    const int32_t filter_offset,
    const int32_t output_offset,
    const int32_t output_multiplier,
    const int output_shift,
    const int32_t output_activation_min,
    const int32_t output_activation_max,

    const int batches,
    const int output_depth,
    const int accum_depth,

    const int8_t *input_data,
    const int8_t *filter_data,
    const int32_t *bias_data,
    int32_t *acc_store
);


#endif // FC_H

