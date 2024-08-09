#ifndef OPS_API_H
#define OPS_API_H

#include <stdint.h>
#include "intc.h"
#ifdef __cplusplus
extern "C" {
#endif

typedef enum {
	OP_OK,
	OP_BYPASS,
	OP_ERR,
} OP_STATUS_T;

#define INTR_CUSTROM_INSTRUCTION opcode_R(CUSTOM0, 7, 7, 0x0, 0x0)

/*
 * ops_drv_intr
*/
void ops_drv_intr();
typedef struct ops_drv_t ops_drv_t;
struct ops_drv_t{
	void (*load)(ops_drv_t *drv);
	void (*intr)(ops_drv_t *drv);
	void (*unload)(ops_drv_t *drv);
	int intr_id;
	const char *name;
	struct ops_drv_t *next;
	struct ops_drv_t *priv;
};
void ops_unload();
extern ops_drv_t *ops_list;
#define OP_LOAD(a) \
static void __attribute__((constructor(101))) __##a##_load() { \
	ops_drv_t *op = &a; \
	if(!ops_list) { \
		op->next = 0; \
		ops_list = op; \
		op->priv = 0; \
		return; \
	} \
	ops_drv_t *t; \
	for(t = ops_list; t->next != 0; t = t->next); \
	t->next = op; \
	op->priv = t; \
	op->next = 0; \
}
extern int global_intr_id;

#ifdef __cplusplus
}
#endif
#endif // OPS_API_H
