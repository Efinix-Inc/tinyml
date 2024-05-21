#ifndef MAXMIN_H
#define MAXMIN_H
#include "ops_api.h"
#include "intc.h"
#include "model/define.h"
template<typename T, bool Max>
OP_STATUS_T maxmin_drv(
		const T *data1,
		const T *data2,
		T *output_data,
		const int32_t flat_size
		);
#endif // MAXMIN_H
