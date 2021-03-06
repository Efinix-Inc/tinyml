# Efinix TinyML Platform

Welcome to the Efinix TinyML GitHub repo. Efinix offers a TinyML platform based on an open-source TensorFlow Lite for Microcontrollers (TFLite Micro) C++ library running on RISC-V with custom TinyML accelerator. This site provides an end-to-end design flow that facilitates deployment of TinyML applications on Efinix FPGAs. The design flow from Artificial Intelligence (AI) model training, post-training quantization, all the way to running inference on RISC-V with custom TinyML accelerator is presented. In addition, TinyML deployment on Efinix highly flexible domain-specific framework is demonstrated.

- [Overview](#overview)
- [Quick Start](#quick-start)
- [Model Zoo - Training and Quantization](model_zoo/README.md)
- [TinyML Hello World](docs/tinyml_hello_world.md)
- [Edge Vision TinyML Framework](docs/tinyml_vision.md)
- [Frequently Asked Questions](docs/faq.md)
- [Useful Links](#useful-links)

<br />

## Overview

Artificial Intelligence (AI) is gaining popularity in a wide range of applications across various domains. AI model training is typically performed using GPUs or CPUs, whereas AI inference for edge applications are typically deployed on mobile GPUs, MCUs, ASIC AI chips or FPGAs. General design flow for deployment of TinyML solution on FPGAs is as follows:

<br />

![](docs/general_ai_flow.png "General AI Design Flow for FPGAs")

<br />

For solely AI inference implementation, other platforms may have better speed/power performance than FPGAs. However, FPGAs have clear advantages for system-level implementations, where other operations/algorithms are required with hardware acceleration and configurability. FPGA-based AI solutions are typically based on AI accelerator implementations as custom IPs or parameterizable processing elements (PEs). Nevertheless, with the custom IP and PE approaches, the supported network topologies and models are somehow restricted, where the change of a model/topology may require major re-work on the design. As AI research advances rapidly and new models/layers/operations are proposed at fast pace, it is crucial to support the state-of-the-art AI model implementations at quick turnaround time.

<br />

Efinix presents a flexible RISC-V based TinyML platform with various acceleration strategies:
- Using **open-source TFLite Micro C++ library** running on Efinix **user configurable Sapphire RISC-V SoC**.
- **TinyML accelerator** for accelerating commonly used AI inference layers/operations through **RISC-V custom instruction interface**.
- **Optional user-defined custom instructions** to accelerate other compute-intensive operations, which are to be determined **as per application need**.
- **Pre-defined hardware accelerator socket** that is **connected to Direct Memory Access (DMA) controller and SoC slave interface** for data transfer and CPU control, which may be used for pre-processing/post-processing before/after the AI inference.

<br />

![](docs/efinix_tinyml_design_flow.png "Efinix TinyML Design Flow")

<br />

Advantages of Efinix TinyML platform:
- **Flexible AI solutions** with configurable RISC-V SoC, TinyML accelerator speed-up, optional user custom instructions, hardware accelerator socket to cater for **various applications needs**.
- Support all AI inferences that are supported by the **TFLite Micro library**, which is **maintained by open-source community**.
- **Multiple acceleration options** with different performance-and-design-effort ratio to speed-up overall AI inference deployment.

<br />

![](docs/accel_strategy.png "Efinix TinyML Acceleration Strategy")

<br />

### TensorFlow Lite Micro
Tensorflow is an end-to-end open-source machine learning platform. It offers comprehensive, flexible ecosystem of tools, libraries and community resources that facilitate development and deployment of machine learning applications. TensorFlow Lite is part of Tensorflow that provides a mobile library for edge devices. On the other hand, TensorFlow Lite Micro is a C++ library that is designed to be readable, ease of modification and integration, as well as compatible with the regular TensorFlow Lite.

Related links:
- [Understand the C++ library](https://www.tensorflow.org/lite/microcontrollers/library)
- [GitHub: tflite-micro](https://github.com/tensorflow/tflite-micro)
- [Tensorflow Lite Converter - Post Training Quantization](https://www.tensorflow.org/lite/performance/post_training_quantization)

<br />

### Efinix TinyML Accelerator
Efinix offers a TinyML Accelerator, that is compatible with TFLite Micro library, for acceleration of compute-intensive layers/operations in AI inference. The TinyML Accelerator is connected to RISC-V through custom instruction interface.

List of accelerated layers/operations in TinyML accelerator:
- Convolution layer
- Depthwise Convolution layer

<br />

## Quick Start
For a quick start on Efinix TinyML platform, combined hex file (FPGA bitstream + RISC-V application binary) for demo design is provided in *quick_start* directory.

List of quick start demo design:
- Person detection demo on [Titanium?? Ti60 F225 Development Kit](https://www.efinixinc.com/products-devkits-titaniumti60f225.html)

Bring up quick start demo design on Efinix development kit by following listed steps below:
1. Set up hardware
   - Refer to *Set Up the Hardware* section in [EVSoC User Guide](https://www.efinixinc.com/support/docsdl.php?s=ef&pn=UG-EVSOC) for targeted development kit.
2. Program hex file using Efinity Programmer
   - Program quick start demo hex file to targeted development kit using Efinity Programmer in SPI active mode
3. Press CRESET button & Demo design is up and running
   - Note that, the demo design may take about a minute for initial loading of the application binary.

As the quick start demo design is programmed through SPI active mode, the design is stored in flash memory. Since flash is non-volatile memory, the design is retained even after power off. Hence, before loading other design, which is with separate FPGA bitstream and RISC-V application binary (run with Eclipse OpenOCD Debugger), user should erase the flash memory (recommend to erase 8192000 bytes) using Efinity Programmer.

<br />

To further explore Efinix TinyML platform:
- Training & Quantization
   - For users who are interested in exploring the model training and post-training quantization flow, refer to [Efinix Model Zoo](model_zoo/README.md) in *model_zoo* directory to get started.
   - For users who would like to skip the training and quantization flow, proceed to try out [TinyML Hello World](docs/tinyml_hello_world.md) design for static input AI inference on FPGAs. Pre-trained and quantized models are included in the TinyML Hello World example designs.
- AI Inference on FPGAs
   - TinyML Hello World design is provided for user to run AI inference on FPGAs based on TFLite Micro library with Efinix TinyML accelerator.
   - AI inference with static input is crucial to facilitate model verification against golden reference model. In addition, layer-by-layer profiling can be performed to identify compute-intensive operation/layer for acceleration. Furthermore, user may tune the TinyML accelerator RTL parameter for different levels of parallelism based on available logic resources and targeted speed performance.
   - Refer to [TinyML Hello World](docs/tinyml_hello_world.md) to get started.
- TinyML Solution on FPGAs
   - Flexible domain-specific framework is vital to facilitate quick deployment of TinyML solution on FPGAs.
   - To leverage on Efinix domain-specific framework for TinyML vision solution deployment, refer to [Edge Vision TinyML Framework](docs/tinyml_vision.md) to get started.

<br />

Refer to [Frequently Asked Questions](docs/faq.md) for general questions and guidelines for creating your own TinyML solution using Efinix TinyML platform.

<br />

## Useful Links

- [Edge Vision SoC (EVSoC) Webpage](https://www.efinixinc.com/edge-vision-soc.html)
- [GitHub: EVSoC](https://github.com/Efinix-Inc/evsoc)
- [EVSoC User Guide](https://www.efinixinc.com/support/docsdl.php?s=ef&pn=UG-EVSOC)
- [Sapphire RISC-V SoC Hardware and Software User Guide](https://www.efinixinc.com/support/docsdl.php?s=ef&pn=SAPPHIREUG)
- [Titanium Ti60 F225 Development Kit User Guide](https://www.efinixinc.com/support/docsdl.php?s=ef&pn=Ti60F225-DK-UG)
