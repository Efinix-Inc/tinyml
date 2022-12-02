# TinyML Hello World

Efinix TinyML Hello World design is targeted for running AI inference on static input data. Inference on static input data is important to verify the overall inference process of a specific trained and quantized model is correct. The obtained inference outputs can be used to cross-check against the golden reference model in equivalent Python or PC-based C++ implementations. In addition, profiling can be performed to identify compute-intensive operation/layer for acceleration. Furthermore, user may make use of [Efinix TinyML Generator](../tools/tinyml_generator/README.md) for customizing Efinix TinyML Accelerator with different accelerator modes and levels of parallelism based on targeted applications.

TinyML Hello World design is composed of Efinix Sapphire RISC-V SoC, DMA controller, Efinix TinyML Accelerator, pre-defined accelerator socket, and reserved interface for optional user-defined accelerator.

<img src="../docs/tinyml_hello_world_top_level.png "/>


<br />

List of static inference examples:
1. MobilenetV1 Person Detection (*pdti8*) - Trained with Tensorflow using MobilenetV1 architecture to perform human presence detection.
2. Yolo Person Detection (*yolo_pd*) - Trained with Tensorflow using Yolo architecture to perform person detection.
3. ResNet Image Classification (*imgc*) - Trained with Tensorflow using ResNet architecture to perform classification (CIFAR10 - 10 classes).
4. DS-CNN Keyword Spotting (*kws*) - Trained with Tensorflow framework using DS-CNN architecture to perform keyword spotting on speech command.
5. MediaPipe Face Landmark Detection (*face_landmark*) - A pre-trained Tensorflow model obtained using MediaPipe architecture to perform face landmark detection.


Refer to the *model_zoo* directory for more details on the related model training and quantization.

<br />

## Get Started
The example designs are implemented on:
- [Titanium® Ti60 F225 Development Kit](https://www.efinixinc.com/products-devkits-titaniumti60f225.html)

Efinity® IDE is required for project compilation and bitstream generation, whereas RISC-V SDK (includes Eclipse, OpenOCD Debugger, etc) is used to manage RISC-V software projects and for debugging purposes.

<br />

Bring up TinyML Hello World design on Efinix development kit by following listed steps below:
1. Set up hardware
   - Refer to *Set Up the Hardware* section in [EVSoC User Guide](https://www.efinixinc.com/support/docsdl.php?s=ef&pn=UG-EVSOC) for targeted development kit.
   - For TinyML Hello World design, the connections to camera and mini-DSI panel are not required.
2. Using Efinity® IDE
   - Pre-compiled bitstream .hex (for Programmer SPI active mode) and .bit (for Programmer JTAG mode) files are provided in Efinity project(s) in *tinyml_hello_world* directory. User may skip Efinity project compilation by using the provided bitstream.
   - To compile TinyML Hello World design,
      - Open Efinity project (*tinyml_hello_world/<proj_directory>/tinyml_soc.xml*).
      - Generate all included IPs in the IP list.
      - Compile
   - Program FPGA bitstream to targeted development kit using Efinity Programmer.
   - Note that, user is required to generate SapphireSoc in IP list (if not done), prior to proceed with using RISC-V SDK for building software applications.
3. Using RISC-V SDK
   - Setup Eclipse workspace at *tinyml_hello_world/<proj_directory>/embedded_sw/SapphireSoc* directory.
   - Window -> Preferences -> C/C++ -> Build -> Environment (for C/C++ compilation with O3 flag, optimize for speed performance)
      - *BENCH* set to *yes*
      - *DEBUG* set to *no*
      - *DEBUG_OG* set to *no*
   - TinyML Hello World software apps are in *tinyml_hello_world/<proj_directory>/embedded_sw/SapphireSoc/software/tinyml* directory.
   - Refer to *Using Eclipse and OpenOCD* section in [EVSoC User Guide](https://www.efinixinc.com/support/docsdl.php?s=ef&pn=UG-EVSOC) for other general setting and steps for running the static inference example software applications.

<br />

Refer to [Frequently Asked Questions](../docs/faq.md) for general questions and guidelines for creating your own TinyML solution using Efinix TinyML platform.

<br />

Software Tools Version:
- [Efinity® IDE](https://www.efinixinc.com/support/efinity.php) v2022.1.226.3.17
- [RISC-V SDK](https://www.efinixinc.com/support/ip/riscv-sdk.php) v1.4