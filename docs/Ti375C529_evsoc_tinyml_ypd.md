# Single-Model (Yolo) TinyML Firmware — Build Walkthrough

This README walks through evsoc_tinyml_ypd `main.cc` phase by phase, in the
same order the file is written and the same order things actually happen at
boot. Each phase says what the software does and, where there's a direct
counterpart, which hardware block in the EVSOC (`edge_vision_soc.v`) it's
talking to. This is the *minimal* build — one model (yolo person detection)
and one hart.

## Hardware Setup

<br />

<img src="./ti375c529_setup.png "/>

<br />


## Phase 0 — What hardware this firmware assumes

Before touching the code, it's worth knowing what's actually on the other
side of these register writes and DMA calls:

- **One physical TinyML accelerator.** All 4 RISC-V harts' custom-instruction
  buses feed a single `tinyml_accelerator_channels` instance
  (`u_tinyml_top_channels`), with its own dedicated AXI master
  (`io_ddrMasters_0_*`, 128-bit). This firmware only ever runs on hart 0, and
  the accelerator only has one "slot" to configure — that's why `init_accel(0)`
  (0 here is referring to accelerator that is connected to custom-instruction
  interface 0) is called exactly once in Phase 7.
- **One DMA engine, many channels.** The scatter-gather DMA engine
  (`dma` / `u_dma`) is APB3-controlled and multiplexes several logical
  channels: camera capture, hardware-resize outputs, and display output all
  share this one physical engine. `DMASG_BASE` in the code points at it.
- **A camera capture chain**: `csi2_rx_cam` → `cam_picam` (`u_cam`), a MIPI
  CSI-2 receiver feeding a RAW10 → 8-bit pixel path. `EXAMPLE_APB3_SLV` in
  the code maps to `common_apb3` (`u_apb3_cam_display`, 7 registers) — the
  small register block used to reset the camera, trigger captures, and pick
  RGB/grayscale output.
- **A hardware pre-resize block per model input.** `hw_accel_stream`
  instances (`u_hw_accel_ch0` for yolo's 96×96, `u_hw_accel_ch1` for a
  128×128 output not used in this build) downscale the live camera stream
  in real time, in parallel with the full-resolution capture. This is why
  the firmware never resizes images in software for yolo — the hardware
  already handed it a 96×96 crop by the time `buf_yolo()` is read.
- **A hardware overlay compositor** (`Annotator` / `u_annotator`) that draws
  the bounding boxes & text overlays on top of the live video feed, fed by a 
  small DMA'd box buffer rather than the firmware drawing pixels itself.

## Phase 1 — Memory map (`#define`s near the top of the file)

Nothing here talks to hardware directly — this phase is pure address-space
bookkeeping in DRAM. It defines, back to back:

1. **Display buffers** (`DISPLAY_BUF_ADDR`, `MAX_DISPLAY_BUFFERS = 5`) — five
   identical slots, each laid out as `[cmd tag][text overlay][padding][full image]`.
   This 5-slot ring buffer is what lets capture, model inference, and display
   output all be a frame or two out of phase with each other without
   corrupting one another's data (see Phase 5).
2. **The yolo box buffer** (`YOLO_BOX_CMD_OFFSET`/`bbox_array_yolo`) — a
   small, separate region the firmware writes decoded box coordinates into.
   This buffer and text overlay buffer are what the `Annotator` hardware block 
   actually reads to know where to draw.
3. **The font buffer and yolo model input buffer** — the hardware-resized
   96×96 pixels land in `YOLO_INPUT_START_ADDR` via the `hw_accel_stream`
   channel from Phase 0.

None of these addresses are hardware-fixed — they're software's own choice
of where in DRAM to park each thing. What *is* fixed by hardware is the
*width* of certain fields (e.g. the 8-byte cmd/tag word at the start of each
display buffer slot, sized to match a single bus-width-aligned DMA transfer).

## Phase 2 — Global state & low-level helpers

Plain software bookkeeping: which buffer index is currently being captured
into / displayed / fed to the model (`camera_buffer`, `display_buffer`,
`draw_buffer`, ...), plus the address-math helpers (`buf()`, `buf_yolo()`,
`buf_offset()`) that turn a buffer index into a real DRAM address using the
Phase 1 layout.

`send_dma()`/`recv_dma()` are thin wrappers around the `dma` module's
scatter-gather API (`dmasg_*` calls) — `send_dma` pushes memory out to a
stream (used for display output), `recv_dma` pulls a stream into memory
(used for camera capture). Every DMA operation in this firmware, camera or
display, funnels through these two functions and the one physical `dma`
block from Phase 0.

`flash_copy()` is unrelated to the vision pipeline — it's a SPI Flash read
used once, at boot, to pull font glyph bitmaps out of flash to memory.

## Phase 3 — Drawing primitives (text overlay)

`framebuf()`/`framebuf_printf()` write into the "text overlay" portion of a
display buffer slot (offset 8 onward, right after the cmd tag from Phase 1).

- The top `Annotator` module contains exactly one controller,
  `AnnotatorController`, it takes the raw pixel stream (`io_in_pixel_data`), 
  the framebuf text data (`io_framebuf_data`), the font glyph data 
  (`io_fontbuf_data`), *and* the box coordinate data 
  (`io_in_box_data`/`io_in_box_counter`) all as inputs, and produces a 
  single composited stream (`io_out_pixel_data`) as output.


## Phase 4 — Startup / init (`init_vision()`)

This is where software first actually talks to the hardware blocks from
Phase 0, in order:

1. **Camera soft-reset**, via `EXAMPLE_APB3_REGW(EXAMPLE_APB3_SLV, ...)` —
   these register writes go to `common_apb3`'s reset register, which resets 
   the `csi2_rx_cam`/`cam_picam` MIPI chain.
2. **Camera I2C bring-up** (`cam0_init()`) — configures the camera sensor
   itself over I2C, separate from the APB3 control-register path above.
   This function automatically detects either PiCamV2/V3.
3. **DMA channel priorities** (`dmasg_priority()`) — tells the one physical
   `dma` engine how to arbitrate between the camera-capture channel, the
   hardware-resize channel, and the display-output channel when more than
   one wants the bus at once.
4. **Display memory content init** — `init_fontbuf()`, `init_framebuf()`,
   `init_image()` fill every one of the 5 display buffer slots, text-overlay
   frame buffer, and font buffer with a known starting state (font data, 
   cleared text overlay, a test color-bar pattern, clear existing frame buffer)
   before any real camera data exists.
5. **Box overlay init** (`init_bbox_yolo()`) — marks the box buffer as "no
   detections yet," so the `Annotator` hardware doesn't draw garbage boxes
   before the first inference completes.
6. **First display DMA trigger** — sends the color-bar test pattern out to
   the screen, proving the display path (buffer → `dma` → `display_hdmi_yuv`)
   works before the camera is even live.
7. **First camera DMA trigger** — starts the actual capture: one `recv_dma()`
   for the hardware-resized yolo input (via `hw_accel_stream`/`u_hw_accel_ch0`),
   one for the full-resolution image (via `cam_picam`). This is the same
   pair of calls that `trigger_next_cam_dma()` repeats every subsequent frame
   (Phase 5) — `init_vision()` just does it once, directly, to get the first
   frame in flight.

## Phase 5 — Per-frame DMA triggers

These three functions are **not called from the main loop** — it is triggered
via `intc.c`, i.e. from interrupt handlers that fire on DMA completion. They
are the steady-state of the pipeline once `init_vision()` has run once:

- `trigger_next_cam_dma()` — picks a free buffer slot (the one *not*
  currently being displayed, about-to-be-displayed, or read by the model)
  and starts the next camera capture into it, again pulling from both the
  `hw_accel_stream` resize output and the raw `cam_picam` capture
  simultaneously. The round-robin index hand-off (`camera_buffer →
  next_display_buffer → next_display_buffer_2 → display_buffer`) is
  documented inline in the function and is what keeps capture, inference,
  and display from ever colliding on the same buffer.
- `trigger_next_display_dma()` — sends whichever buffer is now "current" out
  to the screen.
- `trigger_next_box_dma()` — sends the yolo box buffer to the `Annotator`
  hardware whenever `draw_boxes_yolo()` (Phase 6) has produced fresh
  coordinates, so the overlay hardware always draws the latest available
  detection on top of whatever frame is currently live.

## Phase 6 — Detection helpers (box decode → overlay)

Pure software, no direct hardware counterpart:

- `draw_boxes_yolo()` converts the model's raw 0..1-range box coordinates
  into screen-space pixel coordinates and packs them into `bbox_array_yolo`
  — the buffer that `trigger_next_box_dma()` (Phase 5) sends to the
  `Annotator` hardware.
- `display_text_on_box()` writes "Person(score)" labels into the text
  overlay (Phase 3) above each valid detection.

## Phase 7 — `main()`: load the model, turn on the accelerator, loop


1. **One arena** (`arena[0] = arena_create(5000000)`) — scratch memory the
   TFLM interpreter uses during inference. A multi-model build needs one of
   these per model (or per hart, in the original SMP version); a
   single-model build needs exactly one.
2. **`init_vision()`** — Phase 4, camera/display/DMA bring-up.
3. **Load the yolo model** (`setup_tflite_micro_model()`) — allocates the
   model's own tensor arena (`yolo_core0_tensor_arena`, separate from the
   scratch arena above) and builds the TFLM interpreter. This is a purely
   software step; it doesn't touch the hardware accelerator yet, it just
   prepares the interpreter that will *dispatch* to it.
4. **`IntcInitialize()`** — wires up the interrupt controller so DMA
   completion interrupts (which drive Phase 5's trigger functions) actually
   fire.
5. **`init_accel(0)`** — turns on the one physical `tinyml_accelerator_channels`
   instance from Phase 0. This must happen exactly once, unconditionally,
   regardless of which models exist in a build — every TFLM op driver reads
   the live hart ID (always 0 here) to pick which accelerator "slot" to use,
   and slot 0 is the only one that's ever required.
6. **The loop** — read the hardware-resized input (`buf_yolo(draw_buffer)`,
   already prepared by Phase 5's DMA triggers), assign it to the model,
   invoke, decode (`run_yolo_layer`), draw boxes (Phase 6), update the text
   overlay (Phase 3), and clear the scratch arena before the next pass.
   `draw_buffer = next_display_buffer` at the end of each pass is what
   advances to the next captured frame as yolo's next input — the actual 
   capturing itself happens asynchronously, driven by the interrupts from 
   Phase 5, not by this loop.

## Data paths — how each display data type is produced and displayed

The firmware juggles three distinct kinds of data that all end up visible on
screen, but each is produced differently, stored in a different place, and
reaches the display over a different transfer. This section traces each one
start to finish.

### 1. Raw camera image (the full-resolution video feed)

- **Produced by:** hardware, not software. The `csi2_rx_cam` → `cam_picam`
  MIPI capture chain (Phase 0) streams pixels directly off the camera
  sensor.
- **Written to:** `IMAGE_START_OFFSET` inside whichever display buffer slot
  `camera_buffer` currently points at, via `recv_dma(DMASG_CAM_S2MM_CHANNEL, ...)`
  in `trigger_next_cam_dma()` (Phase 5). The CPU never touches these pixel
  bytes — it only tells the DMA engine where to put them.
- **Tag:** `IMAGE_CMD_OFFSET` is set to `3` by `init_image()` (Phase 4), once,
  at boot. It isn't re-tagged every frame — only the pixel data at
  `IMAGE_START_OFFSET` changes frame to frame; the tag marking "this region
  is image data" stays fixed.
- **Reaches the display via:** `trigger_next_display_dma()` (Phase 5), as
  part of the single combined `TOTAL_BUFFER_SIZE` transfer covering the
  whole slot — cmd tag, text overlay, padding, *and* image, all in one
  `send_dma()` call. There is no separate "send just the image" transfer;
  it always travels bundled with the text overlay.

### 2. Box coordinates (yolo detections)

- **Produced by:** software, from the model's output. `run_yolo_layer()`
  (Phase 7) decodes the model's raw quantized output into 0..1-range boxes;
  `draw_boxes_yolo()` (Phase 6) converts those into screen-space pixel
  coordinates.
- **Written to:** `bbox_array_yolo`, a completely separate memory region
  from the display buffers (`YOLO_BOX_START_OFFSET`, part of the TinyML
  input region from Phase 1, not the display-buffer ring). Each box is
  packed as one 64-bit word (`x_min<<48 | y_min<<32 | x_max<<16 | y_max`).
- **Tag:** `YOLO_BOX_CMD_OFFSET` is set to `4`, once, by `init_bbox_yolo()`
  (Phase 4).
- **Reaches the display via:** `trigger_next_box_dma()` (Phase 5), a
  separate `send_dma()` call carrying only `TOTAL_BOX_SIZE + 8` bytes (tag +
  up to 16 packed boxes) to the `Annotator` hardware (Phase 0), which
  composites the box outlines on top of whatever image is currently live —
  independent of which display buffer slot that happens to be.

### 3. Framebuf (text overlay — "Person(0.87)" labels)

- **Produced by:** software, formatting text. `display_text_on_box()`
  (Phase 6) calls `framebuf_printf()` (Phase 3), which uses `vsnprintf_()`
  to format each label and write the resulting character bytes directly
  into memory.
- **Written to:** `FRAMEBUF_START_OFFSET` inside *every* display buffer slot
  at once (`framebuf_printf()`'s loop writes the same text into all 5 slots,
  not just the current one) — `FRAMEBUF_SIZE = 135 * 68 = 9,180` bytes.
  The actual glyph shapes come from a separate font bitmap
  (`init_fontbuf()`/`send_dma_font_buf()`, Phase 4), copied from flash once
  at boot — this firmware only decides *which characters* go in *which
  grid cell*, not what a character looks like in pixels.
- **Tag:** `FRAMEBUF_CMD_OFFSET` is set to `2` by `init_framebuf()`
  (Phase 4), once, at boot.
- **Reaches the display via:** the same combined `TOTAL_BUFFER_SIZE`
  transfer as the raw image (`trigger_next_display_dma()`, Phase 5) — text
  overlay and image are always sent together, never separately.

### Why this split exists

Image and text share a transfer because they're both consumed by
the same downstream display logic as one composited frame. Box coordinates
travel separately because they're consumed by differently by (`Annotator`) 
on its own schedule — new boxes can arrive and get drawn independently of 
when the next full frame happens to be sent.

## Appendix — Software concept → RTL module cross-reference

| Firmware concept | RTL module / instance | Notes |
|---|---|---|
| `init_accel(0)` / TFLM op dispatch | `tinyml_accelerator_channels` (`u_tinyml_top_channels`) | Single physical instance shared by all 4 harts' custom-instruction buses; own AXI master (`io_ddrMasters_0_*`) |
| `EXAMPLE_APB3_SLV` register writes | `common_apb3` (`u_apb3_cam_display`) | 7-register APB3 block: reset, trigger capture, RGB/grayscale select, DMA-init-done flags |
| `DMASG_BASE` / `dmasg_*` calls | `dma` (`u_dma`) | One scatter-gather DMA engine, multiple logical channels (camera, resize outputs, display) |
| `cam0_init()` / raw camera capture | `csi2_rx_cam` → `cam_picam` (`u_cam`) | MIPI CSI-2 receiver; RAW10 sensor data → 8-bit memory representation |
| Hardware-resized yolo input (`buf_yolo()`) | `hw_accel_stream` (`u_hw_accel_ch0`) | Real-time downscale to 96×96, running in parallel with the full-res capture |
| Box overlay (`trigger_next_box_dma()`) | `Annotator` (`u_annotator`) → `AnnotatorController` | Draws box using the coordinates on top of current live image |
| Text overlay (`framebuf_printf()`) | `Annotator` (`u_annotator`) → `AnnotatorController` | Framebuf char codes + font bitmap are looked up and turned into a glyph mask by the `Annotator`. `Annotator` gets the font gylph during `send_dma_font_buf` used to decode the characters.|
| Box + text compositing | `AnnotatorController` (inside `Annotator`) | Combines base pixels, text and box masks into output pixel |
| Final display output | `display_hdmi_yuv` | Consumes the single composited stream out of `Annotator` |
