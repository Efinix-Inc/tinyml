# Frequently Asked Questions

**General:**
- [How are design files and related scripts organized?](#how-are-design-files-and-related-scripts-organized)
- [How much resources are consumed by Efinix TinyML designs?](#how-much-resources-are-consumed-by-efinix-tinyml-designs)
- [Why compile provided example designs using Eclipse failed?](#why-compile-provided-example-designs-using-eclipse-failed)
- [How to compile AI inference software app for optimized speed performance?](#how-to-compile-ai-inference-software-app-for-optimized-speed-performance)
- [Where are AI training and quantization scripts located?](#where-are-ai-training-and-quantization-scripts-located)
- [How to make use of outputs generated from model zoo training and quantization flow for inference purposes?](#how-to-make-use-of-outputs-generated-from-model-zoo-training-and-quantization-flow-for-inference-purposes)
- [How to run inference with or without Efinix TinyML accelerator?](#how-to-run-inference-with-or-without-efinix-tinyml-accelerator)
- [How to perform layer-by-layer profiling of an AI model running on RISC-V?](#how-to-perform-layer-by-layer-profiling-of-an-ai-model-running-on-risc-v)
- [How to boot a complete TinyML design from flash?](#how-to-boot-a-complete-tinyml-design-from-flash)

<br />

**Create Your Own TinyML Solution:**
- [How to run static input inference on a different test image with provided example quantized models?](#how-to-run-static-input-inference-on-a-different-test-image-with-provided-example-quantized-models)
- [How to add user custom instruction?](#how-to-add-user-custom-instruction)
- [How to adjust RTL parameter of Efinix TinyML accelerator for different resource-performance trade-offs?](#how-to-adjust-rtl-parameter-of-efinix-tinyml-accelerator-for-different-resource-performance-trade-offs)
- [How to train and quantize a different AI model for running on Efinix TinyML platform?](#how-to-train-and-quantize-a-different-ai-model-for-running-on-efinix-tinyml-platform)
- [How to run inference with a different quantized AI model using Efinix TinyML platform?](#how-to-run-inference-with-a-different-quantized-ai-model-using-efinix-tinyml-platform)
- [How can user improve inference speed performance of a targeted model on Efinix TinyML platform?](#how-can-user-improve-inference-speed-performance-of-a-targeted-model-on-efinix-tinyml-platform)
- [How to implement a TinyML solution using Efinix TinyML platform?](#how-to-implement-a-tinyml-solution-using-efinix-tinyml-platform)

<br />

## How are design files and related scripts organized??
The directory structure of Efinix TinyML repo is depicted below:

```
├── docs
├── model_zoo
│   ├── image_classification
│   ├── person_detection
│   └── yolo_pico_person
├── quick_start
├── tinyml_hello_world
│   └── Ti60F225_tinyml_hello_world_lite
│       ├── embedded_sw
│       │   └── SapphireSoc
│       │       └── software
│       │           └── tinyml
│       │               ├── common
│       │               ├── imgc
│       │               │   └── src
│       │               │       ├── model
│       │               │       └── tensorflow
│       │               ├── pdti8
│       │               │   └── src
│       │               │       ├── model
│       │               │       └── tensorflow
│       │               └── yolo_pico
│       │                   └── src
│       │                       ├── model
│       │                       └── tensorflow
│       ├── ip
│       │   ├── dma
│       │   ├── hbram
│       │   ├── hw_accel_dma_in_fifo
│       │   ├── hw_accel_dma_out_fifo
│       │   └── SapphireSoc
│       ├── replace_files
│       │   └── bootloader_4MB
│       └── source
│           ├── axi
│           ├── hw_accel
│           └── tinyml
└── tinyml_vision
    └── Ti60F225_person_detect_demo_lite
        ├── embedded_sw
        │   └── SapphireSoc
        │       └── software
        │           └── tinyml
        │               ├── common
        │               └── evsoc_pdti8
        │                   └── src
        │                       ├── model
        │                       └── tensorflow
        ├── ip
        │   ├── cam_dma_fifo
        │   ├── cam_pixel_remap_fifo
        │   ├── csi2_rx_cam
        │   ├── display_dma_fifo
        │   ├── dma
        │   ├── dsi_tx_display
        │   ├── hbram
        │   ├── hw_accel_dma_in_fifo
        │   ├── hw_accel_dma_out_fifo
        │   └── SapphireSoc
        ├── replace_files
        │   └── bootloader_4MB
        └── source
            ├── axi
            ├── cam
            ├── display
            ├── hw_accel
            └── tinyml
```

***Note:*** Source files for Efinix soft-IP(s) are to be generated using IP Manager in Efinity® IDE, where IP settings files are provided in *ip* directory in respective project folder.

<br />

## How much resources are consumed by Efinix TinyML designs?
Resource utilization tables compiled for Efinix Titanium® Ti60F225 device using Efinity® IDE v2021.2 are as follows.
    
 **Resource utilization for TinyML Hello World (lite) design:**  
 | Building Block                | XLR   | FF    | ADD  | LUT   | MEM (M10K) | DSP |
 |-------------------------------|:-----:|:-----:|:----:|:-----:|:----------:|:---:|
 | TinyML Hello World (Total)    | 28450 | 15794 | 4637 | 17376 | 135        | 41  |
 | RISC-V SoC                    |   -   | 6686  | 508  | 5611  | 57         | 4   |
 | DMA Controller                |   -   | 4432  | 631  | 5966  | 45         | 0   |
 | HyperRAM Controller Core      |   -   | 1153  | 193  | 2194  | 13         | 0   |
 | Hardware Accelerator* (Dummy) |   -   | 369   | 138  | 331   | 4          | 2   |
 | TinyML Accelerator            |   -   | 2477  | 3155 | 2419  | 16         | 35  |

<br />

 **Resource utilization for Edge Vision TinyML person detection demo (lite) design:**  
 | Building Block                | XLR   | FF    | ADD  | LUT   | MEM (M10K) | DSP |
 |-------------------------------|:-----:|:-----:|:----:|:-----:|:----------:|:---:|
 | Person Detection Demo (Total) | 39813 | 19932 | 5481 | 26195 | 218        | 41  |
 | RISC-V SoC                    |   -   | 6738  | 508  | 5731  | 48         | 4   |
 | DMA Controller                |   -   | 4859  | 683  | 6568  | 54         | 0   |
 | HyperRAM Controller Core      |   -   | 1153  | 193  | 2193  | 13         | 0   |
 | CSI-2 RX Controller Core      |   -   | 837   | 41   | 2112  | 15         | 0   |
 | DSI TX Controller Core        |   -   | 1486  | 93   | 4143  | 17         | 0   |
 | Camera                        |   -   | 778   | 643  | 1022  | 11         | 0   |
 | Display                       |   -   | 345   | 15   | 570   | 27         | 0   |
 | Hardware Accelerator*         |   -   | 369   | 138  | 331   | 4          | 2   |
 | TinyML Accelerator            |   -   | 2477  | 3155 | 2426  | 16         | 35  |

\* Hardware accelerator consists of pre-processing blocks for inference. For the person detection demo design, the pre-processing blocks are image downscaling, RGB to grayscale conversion, and grayscale pixel packing.

***Note:*** Resource values may vary from compile-to-compile due to PnR and updates in RTL. The presented tables are served as reference purposes.

<br />

## Why compile provided example designs using Eclipse failed?
User is required to generate Sapphire RISC-V SoC IP using Efinity software. RISC-V SoC IP related contents for software are generated in *embedded_sw* folder. Note that, when user generates/re-generates Sapphire SoC IP, contents in *embedded_sw* folder will be generated/overwritten. User is required to replace the provided file(s) in *replace_files* folder into respective directories:
- bsp.h in *\*/\*/embedded_sw/SapphireSoc/bsp/efinix/EfxSapphireSoc/include* folder
- default.ld in *\*/\*/embedded_sw/SapphireSoc/bsp/efinix/EfxSapphireSoc/linker* folder

<br />

## How to compile AI inference software app for optimized speed performance?
In Eclipse, set the environment variables for C/C++ compilation with O3 flag, optimize for speed performance. Go to Eclipse -> Window -> Preferences -> C/C++ -> Build -> Environment
- *BENCH* set to *yes*
- *DEBUG* set to *no*
- *DEBUG_OG* set to *no*

<br />

## Where are AI training and quantization scripts located?
AI model training and quantization scripts are located in *model_zoo* directory. Refer to *model_zoo* directory for more details regarding AI models, training and quantization.

<br />

## How to make use of outputs generated from model zoo training and quantization flow for inference purposes? 
There are two output files generated from the training and post-training quantization flow i.e., *\<architecture\>_\<application\>_model_data.h* and *\<architecture\>_\<application\>_model_data.cc*. The generated output files contain model data of the quantized model. In the provided example/demo designs, they are placed in the *\*/\*/embedded_sw/SapphireSoc/software/tinyml/\*/src/model* folder.

The model data header is included in the *main.cc* in corresponding *\*/\*/embedded_sw/SapphireSoc/software/tinyml/\*/src* directory. The model data is assigned to TFlite interpreter through the command below:

```
   model = tflite::GetModel(<architecture>_<application>_model_data);
```
<br />

## How to run inference with or without Efinix TinyML accelerator?
By default, the provided example/demo designs are with Efinix TinyML accelerator enabled, where it is set in *main.cc* in corresponding *\*/\*/embedded_sw/SapphireSoc/software/tinyml/\*/src* directory.

```
   int enable_hwaccel=1;
```

To run AI inference using pure software approach with the original TFLite Micro library, set the *enable_hwaccel* variable in *main.cc* to *0*.
```
   int enable_hwaccel=0;
```

<br />

## How to perform layer-by-layer profiling of an AI model running on RISC-V?

To perform layer-by-layer profiling i.e., to determine execution time of each layer/operation in a quantized AI model running on RISC-V (with or without Efinix TinyML accelerator), make the following modification in the *main.cc* of the corresponding *\*/\*/embedded_sw/SapphireSoc/software/tinyml/\*/src* directory to enable the profiler.

```
   //error_reporter, nullptr); //Without profiler
   error_reporter, &prof);     //With profiler
```

Build and run the particular software app of interest, the layer-by-layer profiling results will be printed on the UART terminal.

<br />

## How to boot a complete TinyML design from flash?

A complete TinyML design consists of hardware/RTL (FPGA bitstream) and software/firmware (software binary). FPGA bitstream is generated from Efinity software compilation, whereas software binary is generated from Eclipse compilation. By default, there is a RISC-V bootloader that copies 124KB user binary from flash to main memory for execution upon boot-up.

As AI-related application binary is typically larger than 124KB, the bootloader is to be updated to copy larger software binary size. Bootloader for moving up to 4MB software binary is provided in *tinyml_vision/\*/replace_files/bootloader_4MB* and *tinyml_hello_world/\*/replace_files/bootloader_4MB* folders. User is to copy and replace the corresponding files i.e., *EfxSapphireSoc.v_toplevel_system_ramA_logic_ram_symbol\*.bin* in *ip/SapphireSoc* directory. Then, compile the Efinity project using Efinity software for generating the FPGA bitstream.

Refer to [EVSoC User Guide](https://www.efinixinc.com/support/docsdl.php?s=ef&pn=UG-EVSOC) *Copy a User Binary to Flash (Efinity Programmer)* section for steps to combine FPGA bitstream and user application binary using Efinity Programmer, as well as boot the design from flash.

<br />

## How to run static input inference on a different test image with provided example quantized models?

In the provided TinyML Hello World example designs, test image input data for static inference is defined in header file placed in corresponding *\*/\*/embedded_sw/SapphireSoc/software/tinyml/\*/src/model* folder. For example, *quant_airplane.h* and *quant_bird.h* contain the airplane and bird test image, respectively, for the image classification model.

The test image data header is included in the *main.cc* in corresponding *\*/\*/embedded_sw/SapphireSoc/software/tinyml/\*/src* directory. The image data is assigned to TFlite interpreter input through the command below:

```
   for (unsigned int i = 0; i < quant_airplane_dat_len; ++i)
      model_input->data.int8[i] = quant_airplane_dat[i];
```  

User may use a different test input data for inference by creating a header file that contains the corresponding input data. For inference with image input, the input data is typically the grayscale or RGB pixel data of the test image. The input color format, total data size, data type, etc., are determined during the AI model training/quantization stage. It is important to ensure the provided test data fulfill the input requirement of the quantized AI model used for inference.

<br />

## How to add user custom instruction?
RISC-V custom instruction interface includes a 10-bit function ID signal, where up to 1024 custom instructions can be implemented. As coded in the *custom_instruction_top* module (*source/tinyml/custom_instruction_top.v*), function IDs with MSB 3 bits *000* (with up to 128 custom instructions) are reserved for Efinix TinyML accelerator, whereas the rest of the function IDs can be used to implement user custom instruction as per application need.
    
Efinix Sapphire RISC-V SoC IP provides demo/example for RISC-V custom instruction implementation. Refer to [Sapphire RISC-V SoC IP User Guide](https://www.efinixinc.com/support/docsdl.php?s=ef&pn=SAPPHIREUG) for more details.

<br />

## How to adjust RTL parameter of Efinix TinyML accelerator for different resource-performance trade-offs?

By default, the *MAC_BUF_CNT* RTL parameter that determines the parallelism of MAC operations in Efinix TinyML accelerator is set to 4. To explore different resource/performance trade-offs for the TinyML accelerator, user may modify the *MAC_BUF_CNT* RTL parameter in *\*/\*/source/custom_instruction_top.v* tinyml_acceleration module instantiation. In addition, the same value set for *MAC_BUF_CNT* should be assigned to the *parallel_core* variable defined in *main.cc* in *\*/\*/embedded_sw/SapphireSoc/software/tinyml/\*/src* for correct inference operation.

Note that, the max parallelism could be achieved is limited by the number of output channels of a convolution/depthwise-convolution layer.

<br />

## How to train and quantize a different AI model for running on Efinix TinyML platform?
Refer to [Efinix Model Zoo](../model_zoo/README.md) for examples on how to make use of the training and quantization scripts based on different training frameworks and datasets. The training and quantization examples are provided as Jupyter Notebook, which runs on Google Colab. To make use of the produced quantized model data for inference purposes, refer to [this FAQ](#how-to-make-use-of-outputs-generated-from-model-zoo-training-and-quantization-flow-for-inference-purposes).
    
If user has an own pre-trained network (floating point model), the training stage can be skipped. User may proceed with model quantization and perform conversion from *.tflite* quantized model to the corresponding *.h* and *.cc* files for inference purposes. 

<br />

## How to run inference with a different quantized AI model using Efinix TinyML platform?
Refer to [this FAQ](#how-to-train-and-quantize-a-different-ai-model-for-running-on-efinix-tinyml-platform) for training and quantization of a different AI model. To test out the quantized model, it is recommended to try out inference of targeted model using the [TinyML Hello World](tinyml_hello_world.md) design, which takes in static input data. In addition, it is recommended to run inference in pure software mode i.e., disabled TinyML accelerator (refer to [this FAQ](#how-to-run-inference-with-or-without-efinix-tinyml-accelerator)), as this would help to isolate potential setting/design issues to either software (TFlite Micro library and inference setup) or hardware (TinyML accelerator).

With TinyML accelerator disabled - pure software inference, some adjustments may be required for running a different AI model. This is due to there might be variations in the overall model size, layers/operations, input/output format, normalization, etc., for different AI models. Followings are some tips for making the necessary adjustments:
- Refer to [this FAQ](#how-to-make-use-of-outputs-generated-from-model-zoo-training-and-quantization-flow-for-inference-purposes) on how to include quantized model for inference purposes.
- Refer to [this FAQ](#how-to-run-static-input-inference-on-a-different-test-image-with-provided-example-quantized-models) on how to include a different test input data.
- If seeing *Allocate Tensor Failed* error message on UART terminal during inference execution, adjust tensor arena size in *main.cc*.
- If seeing *Insufficient memory region size allocated* error message during Eclipse build project, adjust *MEMORY LENGTH* in *default.ld* accordingly. It is important to ensure the adjusted *LENGTH* does not exceed the external memory RAM size.

After running inference successfully with the targeted AI model (with expected inference score/output) in pure software mode, user may turn on the TinyML accelerator for hardware speed-up. Refer to [this FAQ](#how-to-run-inference-with-or-without-efinix-tinyml-accelerator) for enabling TinyML accelerator for inference. Efinix TinyML accelerator is designed to be parameterizable at RTL level for more effective logic resource utilization. User may adjust the RTL parameters accordingly as required and re-compile the design using Efinity software.
- Refer to [this FAQ](#how-to-adjust-rtl-parameter-of-efinix-tinyml-accelerator-for-different-resource-performance-trade-offs) on how to adjust the TinyML accelerator for different resource/performance trade-offs.
- Note that, *MAC_BUF_AW* RTL parameter in *\*/\*/source/custom_instruction_top.v* tinyml_accelerator module instantiation has to be sufficient to store filter data of the largest layer in the targeted model (based on targeted parallelism). Two to the power of *MAC_BUF_AW* value should be greater than *input_depth\*filter_width\*filter_height\*parallel_out_channel* of the largest layer of targeted model, where *parallel_out_channel* is equivalent to the *MAC_BUF_CNT* RTL parameter value.

<br />

## How can user improve inference speed performance of a targeted model on Efinix TinyML platform?
User may perform layer-by-layer profiling analysis (refer to [this FAQ](#how-to-perform-layer-by-layer-profiling-of-an-ai-model-running-on-risc-v)) to identify the compute-intensive layers/operations for acceleration. After identifying the bottleneck of the targeted model, user may implement RISC-V custom instruction (refer to [this FAQ](#how-to-add-user-custom-instruction)) or make use of provided pre-defined hardware accelerator socket for implementing custom hardware accelerator for overall inference speed-up.

<br />

## How to implement a TinyML solution using Efinix TinyML platform?
To implement a TinyML solution for vision application, user may make use of the presented Efinix Edge Vision TinyML framework. For more details about the flexible domain-specific Edge Vision SoC framework, visit [Edge Vision SoC webpage](https://www.efinixinc.com/edge-vision-soc.html). Furthermore, user may refer to the provided demo design on [Edge Vision TinyML framework](evsoc_tinyml.md) for the interfacing and integration of a working vision AI system with camera and display.
- Refer to [this FAQ](#how-to-train-and-quantize-a-different-ai-model-for-running-on-efinix-tinyml-platform) for training and quantization of an AI model.
- Refer to [this FAQ](#how-to-run-inference-with-a-different-quantized-ai-model-using-efinix-tinyml-platform) for running inference with a quantized AI model on Efinix TinyML platform.
