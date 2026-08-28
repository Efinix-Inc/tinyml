# Ti375C529 Single-Core Firmware evsoc_tinyml_ypd

## Hardware Changes

> [!NOTE]
> This hardware change is not mandatory. This section is purely for
> understanding the differences in single-core and multi-core
> hardware. Users can still use the current multi-core hardware
> [Ti375C529 multi-core hardware](https://github.com/Efinix-Inc/tinyml/tree/main/tinyml_vision/Ti375C529_multicore_demo)
> to run the
> [evsoc_tinyml_ypd single-core firmware](https://github.com/Efinix-Inc/tinyml/tree/main/tinyml_vision/Ti375C529_multicore_demo/embedded_sw/efx_hard_soc/software/standalone/evsoc_tinyml_ypd).

Everything here is a firmware change only — the chip itself still
physically has 4 RV32 harts on it; the firmware just never wakes 3 of them.
If you want the *hardware* itself to only have one hart, that's a separate 
step done in the hardware project.

### Step 1 — Reduce the hart count where it's actually configured

`edge_vision_soc.v` does **not** instantiate the RV32 cores itself — it only
exposes top-level ports for them (`cpu0_customInstruction_*` through
`cpu3_customInstruction_*`) and the `EfxSapphireHpSoc_slb` instance inside it
only carries peripheral bus signals (UART, SPI, I2C, APB, JTAG, debug AXI) —
not custom-instruction ports. So the actual hart count is decided one level
up, in whatever generates the Sapphire HP SoC (the Efinity SoC/IP
configurator) — that's the first place to change 4 down to 1 and regenerate.

<img src="../../docs/socconfig.png "/>

### Step 2 — Edit `edge_vision_soc.v` itself to match

This is the part that's easy to miss: the four hart interfaces in this file
are **hand-declared**, not a parameterized bus that shrinks automatically
when the CPU cluster's hart count changes. Concretely:

- **Remove the unused port groups.** `cpu1_customInstruction_*`,
  `cpu2_customInstruction_*`, and `cpu3_customInstruction_*` (each a full
  cmd/rsp group: `cmd_valid`, `cmd_ready`, `function_id`, `inputs_0/1`,
  `rsp_valid`, `rsp_ready`, `outputs_0`) drop out of the port list entirely
  once nothing drives them.
  ```verilog
    input		                    cpu0_customInstruction_cmd_valid,
    output		                    cpu0_customInstruction_cmd_ready,
    input [9:0]                     cpu0_customInstruction_function_id,
    input [31:0]                    cpu0_customInstruction_inputs_0,
    input [31:0]                    cpu0_customInstruction_inputs_1,
    output		                    cpu0_customInstruction_rsp_valid,
    input		                    cpu0_customInstruction_rsp_ready,
    output [31:0]                   cpu0_customInstruction_outputs_0,

    // Remove unused in/out port groups cpu1_*,cpu2_*, and cpu3_*
    ...
  ```
- **Narrow the accelerator instantiation.** Every input into
  `tinyml_accelerator_channels` (`u_tinyml_top_channels`) is currently a
  4-way concatenation, hart 3 down to hart 0:
  ```verilog
  .cmd_valid ({cpu3_customInstruction_cmd_valid, cpu2_customInstruction_cmd_valid,
               cpu1_customInstruction_cmd_valid, cpu0_customInstruction_cmd_valid}),
                                            ↓ 
  .cmd_valid (cpu0_customInstruction_cmd_valid),                  
  ```
  and the same pattern repeats for `cmd_ready`, `cmd_function_id`,
  `cmd_inputs_0`, `cmd_inputs_1`, `cmd_int`, `rsp_valid`, `rsp_ready`, and
  `rsp_outputs_0`.


The channel count inside tinyml_accelerator_channels is controlled separately, 
in `tinyml_defines.v` (included into the module). `NUM_TINYML_CHANNEL`
determines the number of accelerators instantiated in order:

- **Uncomment `define NUM_TINYML_CHANNEL_1 1`.** This will only instantiate 1
TinyML accelerator that is connected to cpu0_customInstruction. 
`NUM_TINYML_CHANNEL_2` will instantiate 2 TinyML accelerators that are
connected to cpu0_customInstruction and cpu1_customInstruction instead. Same 
rule applies for all `NUM_TINYML_CHANNEL_*`.

```verilog
 `define NUM_TINYML_CHANNEL_1 1
// `define NUM_TINYML_CHANNEL_2 1
// `define NUM_TINYML_CHANNEL_3 1
// `define NUM_TINYML_CHANNEL_4 1
```

- **Update if necessary tinyml_coreN_define.v.** `tinyml_accelerator_channels.v` 
conditionally includes one of these per active channel, gated by the same 
NUM_TINYML_CHANNEL_N macro:

```verilog
  `ifdef NUM_TINYML_CHANNEL_1
      `include "tinyml_core0_define.v"
      `define NUMBER_OF_CHANNELS 1
      `define ENABLED_ACCELERATOR_CHANNEL 4'b0001
  `endif
  `ifdef NUM_TINYML_CHANNEL_2
      `include "tinyml_core0_define.v"
      `include "tinyml_core1_define.v"
      `define NUMBER_OF_CHANNELS 2
      `define ENABLED_ACCELERATOR_CHANNEL 4'b0011
  `endif
```

and so on up through _3/_4, each adding one more tinyml_coreN_define.v include. 
Each file is a per-channel resource configuration — AXI data width, which 
implementation variant each op (conv/depthwise, add, multiply, min/max, rescale, 
fully-connected) uses, how much parallelism each stage gets, and whether/how big 
that channel's cache is (`TML_C0_AXI_DW`, `TML_C0_CONV_DEPTHW_MODE`, 
`TML_C0_FC_MAX_IN_NODE`, `TML_C0_CACHE_DEPTH`, etc.).

- **Clean up the unused interrupt wiring:**
  ```verilog
  assign userInterruptD = cpu0_customInstruction_cmd_int;
  assign userInterruptF = cpu1_customInstruction_cmd_int;
  assign userInterruptG = cpu2_customInstruction_cmd_int;
  assign userInterruptH = cpu3_customInstruction_cmd_int;
  ```
  `userInterruptF/G/H` (and the wires feeding them) have nothing left to
  report once harts 1–3 don't exist — remove them, or tie to `1'b0`, and
  make sure nothing downstream still expects them to fire.


## Software Changes

Compared to the original multicore firmware, the single-core version has
these pieces removed or disabled. Nothing here changes how TinyML on EVSoC
itself runs.

- **The code that wakes up harts 1, 2, and 3.** At boot, the multicore
  firmware explicitly releases the other three harts from their startup
  parking loop and hands them an entry point. The single-core firmware never
  does this, so harts 1–3 stay parked forever — they never run any code at
  all.

  Multicore:
  ```c
  void smpInitWrapper(u32 a, u32 b, u32 c) {
      smpInit(); // Call the original function
      // ...
  }

  int main(void) {
      smp_unlock(smpInitWrapper);   // releases harts 1-3
      mainSmp();                    // hart 0 continues on into shared entry point
  }
  ```
  Single-core: `smpInit()`/`smp_unlock()` are never declared or called —
  hart 0 goes straight into `main()`.

- **The atomic counter and barrier used to coordinate harts.** The multicore
  version has harts check in with each other so hart 0 knows the others are 
  ready before continuing. With only one hart running, there's nothing to 
  coordinate, so this is gone too.

  Multicore:
  ```c
  volatile u32 hartCounter = 0;   // sync barrier between all threads

  __inline__ __attribute__((always_inline)) s32 atomicAdd(s32 *a, u32 increment) {
      s32 old;
      __asm__ volatile(
          "amoadd.w %[old], %[increment], (%[atomic])"
          : [old] "=r"(old)
          : [increment] "r"(increment), [atomic] "r"(a)
          : "memory"
      );
      return old;
  }

  extern "C" void mainSmp(){
      u32 hartId = csr_read(mhartid);
      atomicAdd((s32*)&hartCounter, 1);
      while(hartCounter != HART_COUNT);   // hart 0 blocks here until all 4 check in
      ...
  ```
  Single-core: no `hartCounter`, no `atomicAdd()`, no wait loop — execution
  falls straight through into setup.

- **The per-hart work dispatch.** The multicore version reads which hart is
  currently running and sends it to different work: hart 0 → YOLO, hart 1 →
  face detection, hart 2/3 → face landmark (one person each). Single-core
  just runs YOLO directly — there's no dispatch step left, since only one
  hart, and one job, exists.

  Multicore:
  ```c
  extern "C" void mainSmp(){
      u32 hartId = csr_read(mhartid);
      ...
      if (hartId == 0) {
          // Yolo person detection
          ...
      }
      else if (hartId == 1) {
          // Face detection
          ...
      }
      else if (hartId == 2) {
          // Face landmark, person 1
          ...
      }
      else if (hartId == 3) {
          // Face landmark, person 2
          ...
      }
  }
  ```
  Single-core:
  ```c
  int main() {
      bsp_init();
      bsp_printf("***Starting Single-Model (Yolo) Demo*** \r\n");
      ...
      while (1) {
          // just the old hartId == 0 body — no hartId, no branches
          uint8_t *yolo_resized_rgb_image = (uint8_t *)buf_yolo(draw_buffer);
          assign_model_input(&yolo_core0, yolo_resized_rgb_image);
          invoke_model(&yolo_core0, &results_c0);
          run_yolo_layer(&yolo_core0, &results_c0, yolo_anchors);
          draw_boxes_yolo(results_c0.boxes, results_c0.total_boxes, YOLO_OBJECTNESS_THRESHOLD);
          display_text_on_box(results_c0.boxes, results_c0.total_boxes, YOLO_OBJECTNESS_THRESHOLD);
          draw_buffer = next_display_buffer;
          arena_clear(arena[0]);
      }
  }
  ```

- **The multi-hart accelerator setup loop.** The multicore firmware
  initializes the shared hardware accelerator once per hart (4 times, once
  each). Single-core initializes it once, for hart 0 only, since that's the
  only hart that will ever ask the accelerator to do anything.

  Multicore:
  ```c
  for (int i = 0; i < HART_COUNT; i++) {
      arena[i] = arena_create(5000000);
  }
  ...
  init_accel(hartId);
  ```
  Single-core:
  ```c
  arena[0] = arena_create(5000000);
  ...
  init_accel(0);   // must run exactly once — every op driver reads mhartid, which is always 0 here
  ```

- **coreDef.h's HART_COUNT and STACK_PER_HART become obsolete.** The 
  multicore firmware relies on both for its multicore setup — 
  HART_COUNT sizes per-hart loops and arrays, STACK_PER_HART sizes 
  the stack space reserved for each secondary hart.

   Multicore:
   ```c
   // coreDef.h
   #define HART_COUNT 1   // was 4
   #define STACK_PER_HART 	4096
   #define HART_COUNT 		4
   ```
   Single-core:
   ```c
   // HART_COUNT and STACK_PER_HART are no longer needed —
   // there's only ever one hart, and no secondary-hart stack to reserve.
   ```

- **Which launch file to execute.** Generating high-performance Sapphire
  SoC will automatically generates `<software_name>_ti.launch` and 
  `<software_name>_ti_mc.launch` execute files. You only need to execute
  `<software_name>_ti.launch` file if your firmware is only utilizing
  single-core. Otherwise if you use harts 0-3, execute
  `<software_name>_ti_mc.launch` file instead.

  <img src="../../docs/mc_execute_files.png "/>



What remains the same: camera capture, the display buffer/DMA logic, and 
the box/text overlay hardware path. None of that is hart-count-specific 
and it stays exactly as it was.
