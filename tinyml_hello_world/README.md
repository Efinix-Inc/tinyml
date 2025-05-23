# TinyML Hello World

Efinix TinyML Hello World design is targeted for running AI inference on static input data. Inference on static input data is important to verify the overall inference process of a specific trained and quantized model is correct. The obtained inference outputs can be used to cross-check against the golden reference model in equivalent Python or PC-based C++ implementations. In addition, profiling can be performed to identify compute-intensive operation/layer for acceleration. Furthermore, user may make use of [Efinix TinyML Generator](../tools/tinyml_generator/README.md) for customizing Efinix TinyML Accelerator with different accelerator modes and levels of parallelism based on targeted applications.

TinyML Hello World design is composed of Efinix Sapphire RISC-V SoC, DMA controller, Efinix TinyML Accelerator, pre-defined accelerator socket, and reserved interface for optional user-defined accelerator.




<br />


## Single Core Design

- The single-core design executes a single model on one core, requiring fewer hardware resources because only one TinyML Accelerator module is instantiated on the FPGA fabric.
- Single-core design examples are available and supported on the Ti60F225 (Sapphire SoC), and Ti180J484 (Sapphire SoC).

<br />

<img src="../docs/tinyml_hello_world_top_level.png "/>

<br />

List of static inference examples:
1. MobilenetV1 Person Detection (*tinyml_pdti8*) - Trained with Tensorflow using MobilenetV1 architecture to perform human presence detection.
2. Yolo Person Detection (*tinyml_ypd*) - Trained with Tensorflow using Yolo architecture to perform person detection.
3. ResNet Image Classification (*tinyml_imgc*) - Trained with Tensorflow using ResNet architecture to perform classification (CIFAR10 - 10 classes).
4. DS-CNN Keyword Spotting (*tinyml_kws*) - Trained with Tensorflow framework using DS-CNN architecture to perform keyword spotting on speech command.
5. MediaPipe Face Landmark Detection (*tinyml_fl*) - A pre-trained Tensorflow model obtained using MediaPipe architecture to perform face landmark detection.
6. Deep AutoEncoder Anomaly Detection (*tinyml_ad*) - Trained with Tensorflow framework using Deep AutoEncoder architecture in detecting anomalies in machine operating sounds

Refer to the *model_zoo* directory for more details on the related model training and quantization.

<br />

## Multi Cores Design

- The multi-core design enables the concurrent execution of multiple models across several cores. This approach requires more hardware resources than a single-core design, as it instantiates multiple TinyML Accelerator modules.
- Currently, the multi-core design is officially supported only on our Ti375C529 Development Board, which is optimized to harness the full power of our Sapphire High-Performance SoC. Although the design is compatible with our multi-core Sapphire SoC, users will need to manually port it to support multi-core configurations.

<img src="../docs/tinyml_hello_world_top_level_multicore.jpg " width="1200" alt="TinyML Hello World Top Level Multicore"/>

<br />

List of static inference examples:
1. Multi-model inference (*tinyml_mc_multi_model
*)
   - Enables simultaneous execution of multiple models within a single application.
   - Leverages all four cores of the High-Performance Sapphire SoC to accelerate detection processing.
   - Core 0: Yolo Person Detection 
      - Trained with Tensorflow using Yolo architecture to perform person detection
   - Core 1: MediaPipe Face Landmark Detection
      - A pre-trained Tensorflow model using Mediapipe architecture to perform face landmark detection
   - Core 2: MobilenetV1 Person Detection
      - Trained with Tensorflow using MobilenetV1 architecture to perform human presence detection.
   - Core 3: Image Classification
      - Trained with Tensorflow using ResNet architecture to perform classification (CIFAR10 - 10 classes).

<br />

## Get Started
The example designs are implemented on:
- [Titanium® Ti60 F225 Development Kit](https://www.efinixinc.com/products-devkits-titaniumti60f225.html)
- [Titanium® Ti180 J484 Development Kit](https://www.efinixinc.com/products-devkits-titaniumti180j484.html)
- [Titanium® Ti375 C529 Development Kit](https://www.efinixinc.com/products-devkits-titaniumti375c529.html)

> **Note:** Efinity projects of the hello world designs are in [tinyml_hello_world](./) directory.

SoC Utilization in Example Designs;
| Example Design  | SoC Type                      |
|-----------------|-------------------------------|
| Ti375C529       | Sapphire High-Performance SoC |
| Ti60F225        | Soft Sapphire SoC             |
| Ti180J484       | Soft Sapphire SoC             |

<br />
Efinity® IDE is required for project compilation and bitstream generation, whereas Efinity RISC-V Embedded Software IDE is used to manage RISC-V software projects and for debugging purposes.

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
   - Note that, user is required to generate SapphireSoc in IP list (if not done), prior to proceed with using Efinity RISC-V Embedded Software IDE for building software applications.
3. Using Efinity RISC-V Embedded Software IDE
   - Setup Eclipse workspace at *tinyml_hello_world/<proj_directory>/embedded_sw/SapphireSoc* directory.
   - TinyML Hello World software apps are in *tinyml_hello_world/<proj_directory>/embedded_sw/SapphireSoc/software/standalone* directory.
   - Refer to *Using Eclipse and OpenOCD* section in [EVSoC User Guide](https://www.efinixinc.com/support/docsdl.php?s=ef&pn=UG-EVSOC) for other general setting and steps for running the static inference example software applications.

<br />

Refer to [Frequently Asked Questions](../docs/faq.md) for general questions and guidelines for creating your own TinyML solution using Efinix TinyML platform.

<br />

Software Tools Version:
- [Efinity® IDE](https://www.efinixinc.com/support/efinity.php) v2024.2.294.4.15
- [Efinity® RISC-V Embedded Software IDE](https://www.efinixinc.com/support/efinity.php) v2024.2.0.1
