# Frequently Asked Questions

**General:**
- [How are design files and related scripts organized?](#how-are-design-files-and-related-scripts-organized)
- [How much resources are consumed by Efinix TinyML designs?](#how-much-resources-are-consumed-by-efinix-tinyml-designs)
- [Why compile provided example designs using Efinity RISC-V Embedded Software IDE failed?](#why-compile-provided-example-designs-using-efinity-risc-v-embedded-software-ide-failed)
- [How to compile AI inference software app for optimized speed performance?](#how-to-compile-ai-inference-software-app-for-optimized-speed-performance)
- [Where are AI training and quantization scripts located?](#where-are-ai-training-and-quantization-scripts-located)
- [How to make use of outputs generated from model zoo training and quantization flow for inference purposes?](#how-to-make-use-of-outputs-generated-from-model-zoo-training-and-quantization-flow-for-inference-purposes)
- [How to run inference with or without Efinix TinyML accelerator?](#how-to-run-inference-with-or-without-efinix-tinyml-accelerator)
- [How to perform profiling of an AI model running on RISC-V?](#how-to-perform-profiling-of-an-ai-model-running-on-risc-v)
- [How to boot a complete TinyML design from flash?](#how-to-boot-a-complete-tinyml-design-from-flash)
- [How to modify Efinix Vision TinyML demo designs to use Google Coral Camera instead of Raspberry PI Camera v2?](#how-to-modify-efinix-vision-tinyml-demo-designs-to-use-google-coral-camera-instead-of-raspberry-pi-camera-v2)

<br />

**Create Your Own TinyML Solution:**
- [How to run static input inference on a different test image with provided example quantized models?](#how-to-run-static-input-inference-on-a-different-test-image-with-provided-example-quantized-models)
- [How to add user-defined accelerator?](#how-to-add-user-defined-accelerator)
- [How to customize Efinix TinyML accelerator for different resource-performance trade-offs?](#how-to-customize-efinix-tinyml-accelerator-for-different-resource-performance-trade-offs)
- [How to train and quantize a different AI model for running on Efinix TinyML platform?](#how-to-train-and-quantize-a-different-ai-model-for-running-on-efinix-tinyml-platform)
- [How to run inference with a different quantized AI model using Efinix TinyML platform?](#how-to-run-inference-with-a-different-quantized-ai-model-using-efinix-tinyml-platform)
- [How to implement a TinyML solution using Efinix TinyML platform?](#how-to-implement-a-tinyml-solution-using-efinix-tinyml-platform)

<br />

## How are design files and related scripts organized?
The directory structure of Efinix TinyML repo is depicted below:

```
├── docs
├── model_zoo
│   ├── deep_autoencoder_anomaly_detection
│   ├── ds_cnn_keyword_spotting
│   ├── mediapipe_face_landmark_detection
│   ├── mobilenetv1_person_detection
│   ├── resnet_image_classification
│   └── yolo_person_detection
├── quick_start
├── tinyml_hello_world
│   ├── Ti60F225_tinyml_hello_world
│   |    ├── embedded_sw
│   |    ├── ip
│   |    ├── replace_files
│   |    └── source
│   └── Ti180M484_tinyml_hello_world
│       ├── embedded_sw
│       ├── ip
│       ├── replace_files
│       └── source
├── tinyml_vision
│   ├── Ti60F225_mediapipe_face_landmark_demo
│   │   ├── embedded_sw
│   │   ├── ip
│   │   ├── replace_files
│   │   └── source
│   ├── Ti60F225_mobilenetv1_person_detect_demo
│   │   ├── embedded_sw
│   │   ├── ip
│   │   ├── replace_files
│   │   └── source
│   ├── Ti60F225_yolo_person_detect_demo
│   │   ├── embedded_sw
│   │   ├── ip
│   │   ├── replace_files
│   │   └── source
│   ├── Ti180M484_mediapipe_face_landmark_demo
│   │   ├── embedded_sw
│   │   ├── ip
│   │   ├── replace_files
│   │   └── source
│   ├── Ti180M484_mobilenetv1_person_detect_demo
│   │   ├── embedded_sw
│   │   ├── ip
│   │   ├── replace_files
│   │   └── source
│   └── Ti180M484_yolo_person_detect_demo
│      ├── embedded_sw
│      ├── ip
│      ├── replace_files
│      └── source
└── tools
    └── tinyml_generator
```

For [TinyML Hello World](../tinyml_hello_world/README.md) design, the project structure is depicted below :
```
├── tinyml_hello_world
│   ├── <device>_tinyml_hello_world
│   |    ├── embedded_sw
│   |    │   └── SapphireSoc
│   |    │       └── software
│   |    │           └── standalone
│   |    │               ├── common
│   |    │               ├── tinyml_fl
│   |    │               ├── tinyml_imgc
│   |    │               ├── tinyml_kws
│   |    │               ├── tinyml_pdti8
│   |    │               ├── tinyml_ypd
│   |    │               └── tinyml_ad
│   |    ├── ip
│   |    ├── replace_files
│   |    │   ├── bootloader_4MB
│   |    │   └── user_def_accelerator
│   |    └── source
│   |        ├── axi
│   |        ├── common
│   |        ├── hw_accel
│   |        └── tinyml
```

For [TinyML Vision](../tinyml_vision/README.md) design, the project structure is depicted below: 

```
├── tinyml_vision
│   ├── <device>_<architecture>_<application>_demo
│   │   ├── embedded_sw
│   │   │   └── SapphireSoc
│   │   │       └── software
│   │   │           └── standalone
│   │   │               ├── common
│   │   │               └── evsoc_tinyml_<application_alias>
│   │   ├── ip
│   │   ├── replace_files
│   │   │   └── bootloader_4MB
│   │   └── source
│   │       ├── axi
│   │       ├── cam
│   │       ├── common
│   │       ├── display
│   │       ├── hw_accel
│   │       └── tinyml
```


***Note:*** Source files for Efinix soft-IP(s) are to be generated using IP Manager in Efinity® IDE, where IP settings files are provided in *ip* directory in respective project folder.

<br />

## How much resources are consumed by Efinix TinyML designs?
Resource utilization tables compiled for Efinix Titanium® Ti60F225 device using Efinity® IDE v2022.2 are as follows.
    
 **Resource utilization for TinyML Hello World design:**  
 | Building Block                | XLR   | FF    | ADD  | LUT   | MEM (M10K) | DSP |
 |-------------------------------|:-----:|:-----:|:----:|:-----:|:----------:|:---:|
 | TinyML Hello World (Total)    | 53888 | 27838 | 8869 | 33359 | 186        | 74  |
 | RISC-V SoC                    |   -   | 6712  | 690  | 5565  | 48         | 4   |
 | DMA Controller                |   -   | 4431  | 772  | 5591  | 45         | 0   |
 | HyperRAM Controller Core      |   -   | 1153  | 305  | 2096  | 22         | 0   |
 | Hardware Accelerator* (Dummy) |   -   | 369   | 273  | 162   | 4          | 2   |
 | Efinix TinyML Accelerator     |   -   | 14485 | 6817 | 18760 | 67         | 68  |

<br />

 **Resource utilization for Edge Vision TinyML MobileNetV1 Person Detection Demo design:**  
 | Building Block                | XLR   | FF    | ADD  | LUT   | MEM (M10K) | DSP |
 |-------------------------------|:-----:|:-----:|:----:|:-----:|:----------:|:---:|
 | Person Detection Demo (Total) | 56387 | 27341 | 8993 | 35971 | 207        | 54  |
 | RISC-V SoC                    |   -   | 6481  | 697  | 5307  | 43         | 4   |
 | DMA Controller                |   -   | 4339  | 520  | 5967  | 36         | 0   |
 | HyperRAM Controller Core      |   -   | 1153  | 305  | 2099  | 22         | 0   |
 | CSI-2 RX Controller Core      |   -   | 844   | 194  | 2053  | 15         | 0   |
 | DSI TX Controller Core        |   -   | 1736  | 409  | 3491  | 19         | 0   |
 | Camera                        |   -   | 778   | 919  | 663   | 11         | 0   |
 | Display                       |   -   | 341   | 174  | 363   | 8          | 0   |
 | Hardware Accelerator*         |   -   | 334   | 273  | 123   | 4          | 2   |
 | Efinix TinyML Accelerator     |   -   | 10483 | 5483 | 14652 | 45         | 48  |
 
 
 Resource utilization tables compiled for Efinix Titanium® Ti180M484 device using Efinity® IDE v2022.2 are as follows.
    
 **Resource utilization for TinyML Hello World design:**  
 | Building Block                | XLR    | FF    | ADD   | LUT   | MEM (M10K) | DSP |
 |-------------------------------|:------:|:-----:|:-----:|:-----:|:----------:|:---:|
 | TinyML Hello World (Total)    | 130214 | 64441 | 21350 | 79716 | 492        | 186 |
 | RISC-V SoC                    |   -    | 11463 | 699   | 7239  | 87         | 4   |
 | DMA Controller                |   -    | 9422  | 832   | 14637 | 223        | 0   |
 | Hardware Accelerator* (Dummy) |   -    | 352   | 294   | 125   | 4          | 2   |
 | Efinix TinyML Accelerator     |   -    | 40895 | 19516 | 54163 | 178        | 180 |

<br />

 **Resource utilization for Edge Vision TinyML MobileNetV1 Person Detection Demo design:**  
 | Building Block                | XLR    | FF     | ADD   | LUT   | MEM (M10K) | DSP |
 |-------------------------------|:------:|:------:|:-----:|:-----:|:----------:|:---:|
 | Person Detection Demo (Total) | 123412 | 60303  | 21529 | 74382 | 545        | 166 |
 | RISC-V SoC                    |   -    | 11788  | 769   | 7464  | 87         | 4   |
 | DMA Controller                |   -    | 10358  | 921   | 15602 | 240        | 0   |
 | CSI-2 RX Controller Core      |   -    | 611    | 204   | 1602  | 17         | 0   |
 | Camera                        |   -    | 744    | 946   | 662   | 11         | 0   |
 | Display                       |   -    | 762    | 226   | 603   | 46         | 0   |
 | Hardware Accelerator*         |   -    | 352    | 294   | 136   | 4          | 2   |
 | Efinix TinyML Accelerator     |   -    | 33333  | 18160 | 45143 | 140        | 160 |

\* Hardware accelerator consists of pre-processing blocks for inference. For the MobileNetv1 Person Detection Demo design, the pre-processing blocks are image downscaling, RGB to grayscale conversion, and grayscale pixel packing. Refer to the defines.v for respective design TinyML accelerator configuration

***Note:*** Resource values may vary from compile-to-compile due to PnR and updates in RTL. The presented tables are served as reference purposes.

<br />

## Why compile provided example designs using Efinity RISC-V Embedded Software IDE failed?
User is required to generate Sapphire RISC-V SoC IP using IP Manager in Efinity® IDE. RISC-V SoC IP related contents for software are generated in *embedded_sw* folder.

<br />

## How to compile AI inference software app for optimized speed performance?
In Efinity RISC-V Embedded Software IDE, set the environment variables for C/C++ compilation with O3 flag, optimize for speed performance. Go to Efinity RISC-V Embedded Software IDE -> Window -> Preferences -> C/C++ -> Build -> Environment
- *BENCH* set to *yes*
- *DEBUG* set to *no*
- *DEBUG_OG* set to *no*

<br />

## Where are AI training and quantization scripts located?
AI model training and quantization scripts are located in *model_zoo* directory. Refer to *model_zoo* directory for more details regarding AI models, training and quantization.

<br />

## How to make use of outputs generated from model zoo training and quantization flow for inference purposes? 
There are two output files generated from the training and post-training quantization flow i.e., *\<architecture\>_\<application\>_model_data.h* and *\<architecture\>_\<application\>_model_data.cc*. The generated output files contain model data of the quantized model. In the provided example/demo designs, they are placed in the *<proj_directory>/embedded_sw/SapphireSoc/software/standalone/<application_name>/src/model* folder.

The model data header is included in the *main.cc* in corresponding *<proj_directory>/embedded_sw/SapphireSoc/software/standalone/<application_name>/src/model* directory. The model data is assigned to TFlite interpreter through the command below:

```
   model = tflite::GetModel(<architecture>_<application>_model_data);
```
<br />

## How to run inference with or without Efinix TinyML accelerator?
By default, the provided example/demo designs are with Efinix TinyML accelerator enabled, where it is set in *define.cc* in corresponding *<proj_directory>/embedded_sw/SapphireSoc/software/standalone/<application_name>/src/model* directory. Note that, define.cc file is generated using [Efinix TinyML Generator](../tools/tinyml_generator/README.md).

To run AI inference using pure software approach, user can make use of [Efinix TinyML Generator](../tools/tinyml_generator/README.md) to disable Efinix TinyML accelerator accordingly. Alternatively, user may set all the *\*_mode* variables in *define.cc* to *0*.

<br />

## How to perform profiling of an AI model running on RISC-V?

To perform profiling i.e., to determine execution time of a quantized AI model running on RISC-V, make the following modification in the *main.cc* of the corresponding *<proj_directory>/embedded_sw/SapphireSoc/software/standalone/<application_name>/src* directory to enable the profiler.

```
   //error_reporter, nullptr); //Without profiler
   error_reporter, &prof);     //With profiler
```

Build and run the particular software app of interest, the profiling result will be printed on the UART terminal.

<br />

## How to boot a complete TinyML design from flash?

A complete TinyML design consists of hardware/RTL (FPGA bitstream) and software/firmware (software binary). FPGA bitstream is generated from Efinity® IDE compilation, whereas software binary is generated from Efinity RISC-V Embedded Software IDE compilation. By default, there is a RISC-V bootloader that copies 124KB user binary from flash to main memory for execution upon boot-up.

As AI-related application binary is typically larger than 124KB, the bootloader is to be updated to copy larger software binary size. Bootloader for moving up to 4MB software binary is provided in *<proj_directory>/replace_files/bootloader_4MB* folder. User is to copy and replace the corresponding files i.e., *EfxSapphireSoc.v_toplevel_system_ramA_logic_ram_symbol\*.bin* in *ip/SapphireSoc* directory. Then, compile the Efinity project using Efinity® IDE for generating the FPGA bitstream.

Refer to [EVSoC User Guide](https://www.efinixinc.com/support/docsdl.php?s=ef&pn=UG-EVSOC) *Copy a User Binary to Flash (Efinity Programmer)* section for steps to combine FPGA bitstream and user application binary using Efinity Programmer, as well as boot the design from flash.

<br />

## How to modify Efinix Vision TinyML demo designs to use Google Coral Camera instead of Raspberry PI Camera v2?

To get started, user may refer to the Google Coral designs (*\<device\>\_coral\_\<display\>*) in [EVSoC GitHub repo](https://github.com/Efinix-Inc/evsoc).

In summary, the required changes to use Google Coral Camera on Efinix Vision TinyML demo designs are as follows:
1. To connect a Google Coral Camera to Efinix development kit, a Google Coral Camera connector daughter card is required.   
   - For Titanium Ti60 F225 Development Board, connect the Google Coral Camera connector daughter card to P2 header.   
   - For Titanium Ti180 M484 Development Board, connect the Google Coral Camera connector daughter card to P1 header.
2. Using Efinity Interface Designer,
   - Update the GPIO setting for *io_cam_scl*, *io_cam_sda*, and *o_cam_rstn* accordingly. For Ti180 design, to create a new GPIO output block for *o_cam_rstn*.
   - Update the MIPI DPHY RX setting accordingly.
3. Replace RTL source file for camera module *cam_picam_v2.v* with *cam_coral.v* from EVSoC Google Coral design. To update Efinity design file list accordingly.
4. Update top-level RTL source file *edge_vision_soc.v* accordingly.
   
   - Replace the line:
     ```
     cam_picam_v2 # (
     ```
      with:
      ```
      cam_coral # (
      ```
   
   - For Ti180 design,
      - Add an output port in I/O declaration:
         ```
         output  o_cam_rstn,
         ```
         
      - Add the signal assignment:
         ```
         assign o_cam_rstn = i_arstn;
         ```

5. Update embedded_sw folder to use the software driver and settings for Google Coral Camera.
   - Copy Google Coral Camera driver *CoralCam.c* and *CoralCam.h* from EVSoC Google Coral design to *<proj_directory>/embedded_sw/SapphireSoc/software/standalone/<application_name>/src/platform/vision*.
   - Refer to *common.h* in EVSoC Google Coral design for adding *CORALCAM_I2C_ADDRESS* and *i2c_reg_config_t variable* to *<proj_directory>/embedded_sw/SapphireSoc/software/standalone/<application_name>/src/platform/vision/common.h*.
   - Update *<proj_directory>/embedded_sw/SapphireSoc/software/standalone/<application_name>/src/main.cc* accordingly.

      - Replace the line:
         ```
         #include "PiCamDriver.h"
         ```
         with:
         ```
         #include "CoralCam.h"
         ```
   
      - Replace the line:
         ```
         PiCam_init();
         ```
         with:
         ```
         CoralCam_init();
         ```

      - Replace the line:
         ```
         Set_RGBGain(1,5,3,4);
         ```
         with:      
         ```
         Set_RGBGain(1,3,3,3);
         ```

<br />

## How to run static input inference on a different test image with provided example quantized models?

In the provided TinyML Hello World example designs, test image input data for static inference is defined in header file placed in corresponding *<proj_directory>/embedded_sw/SapphireSoc/software/standalone/<application_name>/src/model* folder. For example, *quant_airplane.h* and *quant_bird.h* contain the airplane and bird test image, respectively, for the ResNet image classification model.

The test image data header is included in the *main.cc* in corresponding *<proj_directory>/embedded_sw/SapphireSoc/software/standalone/<application_name>/src* directory. The image data is assigned to TFLite interpreter input through the command below:

```
   for (unsigned int i = 0; i < quant_airplane_dat_len; ++i)
      model_input->data.int8[i] = quant_airplane_dat[i];
```  

User may use a different test input data for inference by creating a header file that contains the corresponding input data. For inference with image input, the input data is typically the grayscale or RGB pixel data of the test image. The input colour format, total data size, data type, etc., are determined during the AI model training/quantization stage. It is important to ensure the provided test data fulfil the input requirement of the quantized AI model used for inference.

<br />

## How to add user-defined accelerator?
RISC-V custom instruction interface includes a 10-bit function ID signal, where up to 1024 custom instructions can be implemented. As coded in the *tinyml_top* module (*<proj_directory>/source/tinyml/tinyml_top.v*), function IDs with MSB *0* (with up to 512 custom instructions) are reserved for Efinix TinyML accelerator, whereas the rest of the function IDs can be used to implement user-defined accelerator as per application need.

To demonstrate how to add a user-defined accelerator, a minimum maximum Lite accelerator example is provided in *tinyml_hello_world/<proj_directory>/replace_files/user_def_accelerator*.
1. Copy the files in *hardware* folder to *<proj_directory>/source/tinyml*.
2. Copy the files in *software* folder to *<proj_directory>/embedded_sw/SapphireSoc/software/standalone/<application_name>/src/tensorflow/lite/kernels/internal/reference*.
3. Compile the hardware using Efinity® IDE, build the software using Efinity RISC-V Embedded Software IDE, and run the application.

<br />

## How to customize Efinix TinyML accelerator for different resource-performance trade-offs?

A GUI-based [Efinix TinyML Generator](../tools/tinyml_generator/README.md) is provided to facilitate the customization of Efinix TinyML Accelerator.

Efinix TinyML Accelerator supports two modes, which is customizable by layer type:
1. Lite mode - Lightweight accelerator that consumes less resources.
2. Standard mode - High performance accelerator that consumes more resources.

<br />

## How to train and quantize a different AI model for running on Efinix TinyML platform?
Refer to [Efinix Model Zoo](../model_zoo/README.md) for examples on how to make use of the training and quantization scripts based on different training frameworks and datasets. The training and quantization examples are provided as Jupyter Notebook, which runs on Google Colab. To make use of the produced quantized model data for inference purposes, refer to [this FAQ](#how-to-make-use-of-outputs-generated-from-model-zoo-training-and-quantization-flow-for-inference-purposes).
    
If user has an own pre-trained network (floating point model), the training stage can be skipped. User may proceed with model quantization and perform conversion from *.tflite* quantized model to the corresponding *.h* and *.cc* files for inference purposes. 

<br />

## How to run inference with a different quantized AI model using Efinix TinyML platform?
Refer to [this FAQ](#how-to-train-and-quantize-a-different-ai-model-for-running-on-efinix-tinyml-platform) for training and quantization of a different AI model. To test out the quantized model, it is recommended to try out inference of targeted model using the [TinyML Hello World](../tinyml_hello_world/README.md) design, which takes in static input data. In addition, it is recommended to run inference in pure software mode i.e., disabled TinyML accelerator (refer to [this FAQ](#how-to-run-inference-with-or-without-efinix-tinyml-accelerator)), as this would help to isolate potential setting/design issues to either software (TFlite Micro library and inference setup) or hardware (TinyML accelerator).

With TinyML accelerator disabled - pure software inference, some adjustments may be required for running a different AI model. This is due to there might be variations in the overall model size, layers/operations, input/output format, normalization, etc., for different AI models. Followings are some tips for making the necessary adjustments:
- Refer to [this FAQ](#how-to-make-use-of-outputs-generated-from-model-zoo-training-and-quantization-flow-for-inference-purposes) on how to include quantized model for inference purposes.
- Refer to [this FAQ](#how-to-run-static-input-inference-on-a-different-test-image-with-provided-example-quantized-models) on how to include a different test input data.
- If seeing *Allocate Tensor Failed* error message on UART terminal during inference execution, adjust tensor arena size in *main.cc*.
- If seeing *Insufficient memory region size allocated* error message during Efinity RISC-V Embedded Software IDE build project, adjust *Application Region Size* parameter of Sapphire SoC IP using Efinity® IDE IP Manager accordingly. It is important to ensure the adjusted *Application Region Size* does not exceed the external memory RAM size.

After running inference successfully with the targeted AI model (with expected inference score/output) in pure software mode, user may enable Efinix TinyML accelerator for hardware speed-up. Refer to [Efinix TinyML Generator](../tools/tinyml_generator/README.md) for enabling/customizing Efinix TinyML accelerator for the targeted model.

<br />

## How to implement a TinyML solution using Efinix TinyML platform?
To implement a TinyML solution for vision application, user may make use of the presented Efinix Edge Vision TinyML framework. For more details about the flexible domain-specific Edge Vision SoC framework, visit [Edge Vision SoC webpage](https://www.efinixinc.com/edge-vision-soc.html). Furthermore, user may refer to the provided demo design on [Edge Vision TinyML framework](../tinyml_vision/README.md) for the interfacing and integration of a working vision AI system with camera and display.
- Refer to [this FAQ](#how-to-train-and-quantize-a-different-ai-model-for-running-on-efinix-tinyml-platform) for training and quantization of an AI model.
- Refer to [this FAQ](#how-to-run-inference-with-a-different-quantized-ai-model-using-efinix-tinyml-platform) for running inference with a quantized AI model on Efinix TinyML platform.
