#ifndef RESHAPE_H
#define RESHAPE_H
#include "ops_api.h"
#include "intc.h"
#include "platform/tinyml/accel_settings.h"

OP_STATUS_T reshape_drv(
	const void* input_address,
	void* output_address,
	int32_t input_bytes
);

#endif // RESHAPE_H
