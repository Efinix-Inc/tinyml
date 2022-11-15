#ifndef PLATFORM_TINYML_PROFILER_H_
#define PLATFORM_TINYML_PROFILER_H_

#include "tensorflow/lite/micro/debug_log.h"
#include "tensorflow/lite/micro/kernels//kernel_util.h"
#include "tensorflow/lite/micro/micro_error_reporter.h"

#include "bsp.h"
class FullProfiler : public tflite::MicroProfiler {
public:
	FullProfiler() :
		tag_filter(nullptr),layer_filter(-1),lid(0),dump(false) {}
	void setDump(bool dump) {
		this->dump = dump;
	}
	void setTagFilter(const char *tag) {
		tag_filter = tag;
	}
	void setLayerFilter(int layer) {
		layer_filter = layer;
	}
	virtual u64 BeginEvent(const char *ltag) {
		op_tag = ltag;
		//MicroPrintf("%s ===> ", ltag);
		return clint_getTime(BSP_CLINT);
	}
	virtual void EndEvent(u64 st) {
		auto ed = clint_getTime(BSP_CLINT);
		u32 cost = (ed - st)/(SYSTEM_CLINT_HZ/1000);
		MicroPrintf("%s,%u,%u\n\r", op_tag, lid, cost);

#if (__x86_64 || __x86)
#define PUTCHAR(c) putchar(c)
#else
#include "bsp.h"
#define PUTCHAR(c) uart_write(SYSTEM_UART_0_IO_CTRL, c);
#endif

#define DUMP(str, tensor) \
		if(tensor) { \
			printf(#str": ("); \
			int size = 1; \
			for(int i = 0; i < tensor->dims->size; i++) { \
				char c = i == tensor->dims->size - 1 ? ')' : 'x'; \
				MicroPrintf("%d%c", tensor->dims->data[i], c); \
				size *= tensor->dims->data[i]; \
			} \
			MicroPrintf(" = %d\n\r", size); \
			auto udata = tensor->data.uint8; \
			const char *hex = "0123456789ABCDEF"; \
			for(int i = 0; i < size; i++) { \
				unsigned char v = udata[i]; \
				PUTCHAR(hex[v >> 4]); \
				PUTCHAR(hex[v & 0xF]); \
				if((i & 0xf) == 0xf) { \
					PUTCHAR('\n'); \
					PUTCHAR('\r'); \
				} \
			} \
			PUTCHAR('\n'); \
			PUTCHAR('\r'); \
		}
		if(dump && ((tag_filter && !strcmp(tag_filter, op_tag)) || ((layer_filter >= 0) && (lid == layer_filter)) || (!tag_filter && (layer_filter < 0)))) {
			auto context = interpreter->context_;
			auto graph = interpreter->GetGraph();
			auto ga = graph->GetAllocations();
			auto nodes = ga[0].node_and_registrations;
			auto node = &nodes[lid].node;
			DUMP(input,  tflite::micro::GetEvalInput(&context, node, 0));
			DUMP(filter,  tflite::micro::GetEvalInput(&context, node, 0));
			DUMP(output,  tflite::micro::GetEvalOutput(&context, node, 0));

		}
		lid++;
	}
	void setInterpreter(tflite::MicroInterpreter* interpreter) {
		this->interpreter = interpreter;
	}
	static void operator delete(void *) {
	}
private:
	int lid;
	const char *op_tag;
	const char *tag_filter;
	bool dump;
	int layer_filter;
	tflite::MicroInterpreter* interpreter;
};


#endif /* PLATFORM_TINYML_PROFILER_H_ */
