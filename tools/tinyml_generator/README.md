# Efinix TinyML Generator

Efinix TinyML Generator is a graphical user interface (GUI) for customizing Efinix TinyML Accelerator. It has a built-in [tflite](https://github.com/tensorflow/tflite-micro) analyzer, which analyzes the selected .tflite model (full integer quantization) and provides the option for acceleration based on layer type that is present. In addition, resource estimator is included to guide user on the selection of Efinix TinyML Accelerator configuration based on available resources on targeted Efinix FPGAs.

Efinix TinyML Accelerator supports two modes, which is customizable by layer type:
1. Lite mode - Lightweight accelerator that consumes less resources.
2. Standard mode - High performance accelerator that consumes more resources.

Generated define files from Efinix TinyML Generator are used to facilitate customization of Efinix TinyML Accelerator for RTL compilation using Efinity® IDE and software compilation using Efinity® RISC-V Embedded Software IDE. In addition, the model data files, that are used to run the inference application, are generated based on the selected tflite model.

To ensure efficient resource usage, only either Lite mode or Standard mode of a layer accelerator can be enabled and synthesized to FPGA hardware due to the mutual exclusiveness of the two acceleration modes.

The generator also supports deployment of accelerators on multiple cores based designs. Users are required to select the configuration for the accelerators on each of the four available cores respectively when running a multi-core based TinyML projects.

<img src="../../docs/single_core_generator.png " width="960"/>


## Getting Started

1. Source the Efinity.
   
   For Windows
   
   ```
   > \path\to\efinity\<version>\bin\setup.bat
   ```
   
   For Linux
   
   ```
   > source /path/to/efinity/<version>/bin/setup.sh
   ```

2. Execute the GUI.
   
   ```
   python3 tinyml_generator.py
   ```

3. Open a tflite model to get started. Example tflite models are provided in [model](./model) directory.



## To Configure Accelerators for Multiple Cores

1. Select MULTICORE option for `CPU CONFIG`.

2. Select which core (0-3) to deploy the accelerators' configuration on. The `CPU ID` corresponds to each CPU cores available.


<img src="../../docs/multi_core_generator.png " width="960"/>



<br />

## Parameters

`CPU CONFIG` - Option to choose single-core or multi-core based accelerators of a project.

`CPU ID` - Option to select which CPU core to deploy the configured accelerators when CPU CONFIG is set to MULTI CORE.

`AXI_DW` - AXI data width is based on the memory interface Efinix TinyML accelerator connected to. Default is set to 128-bit for Ti60 design, and 512-bit is for Ti180 design.

`CONV_DEPTHW_MODE` - Option to accelerate convolution and depthwise convolution layer on hardware. Supports Standard and Lite mode.

`CONV_DEPTHW_STD_IN_PARALLEL` - Parameterizable input parallelism for Standard mode convolution and depthwise convolution accelerator.

`CONV_DEPTHW_STD_OUT_PARALLEL` - Parameterizable output parallelism for Standard mode convolution and depthwise convolution accelerator.

`CONV_DEPTHW_LITE_PARALLEL` - Parameterizable parallelism for Lite mode convolution and depthwise convolution accelerator.

`ADD_MODE` - Option to accelerate add layer on hardware. Supports Standard and Lite mode.

`LR_MODE` - Option to accelerate leaky relu layer on hardware. Supports Standard mode.

`FC_MODE` - Option to accelerate fully connected layer on hardware. Supports Standard and Lite mode.

`MUL_MODE` - Option to accelerate multiply layer on hardware. Supports Standard and Lite mode.

`MIN_MAX_MODE` - Option to accelerate minimum and maximum layer on hardware. Supports Standard and Lite mode.

`TINYML_CACHE` - Option to enable cache for faster data access by STANDARD mode accelerator.

`CACHE_DEPTH` - Parameterizable TinyML cache size, which may be determined based on available resources and size of targeted AI model.

<br />

## Supported layers for hardware acceleration

- Convolution and Depthwise Convolution Layer

- Fully Connected Layer

- Add Layer

- Multiply Layer

- Minimum and Maximum Layer

- Leaky Relu Layer

<br />

## Resource Estimator

Resource Estimator is integrated to the TinyML Generator GUI to facilitate performance/resource exploration. Estimated resource usage of individual layer accelerator on Efinix Titanium FPGAs are provided based on user selected configuration. User may customize the Efinix TinyML Accelerator based on available resources on targeted Efinix FPGA.

Ti60 FPGA Resources:
<br />

<img src="../../docs/ti60_resources.png " width="720"/>

<br />
Ti180 FPGA Resources:
<br />

<img src="../../docs/ti180_resources.png " width="720"/>

<br />
Ti375 FPGA Resources:

<br />

<img src="../../docs/ti375_resource.png " width="720"/>

<br />


## Output Generation

Upon selecting the accelerator configuration based on targeted AI model and clicking generate, a list of output files will be produced in `output/<model_name>` :
  
- `tinyml_core0_define.v` - Hardware setting file which needs to be included for single core designs under `<path_to_project>/source/tinyml`

- `tinyml_core0_define.v, tinyml_core1_define.v, tinyml_core2_define.v, tinyml_core3_define.v` - Hardware setting files which needs to be included for each core for multi-core designs under `<path_to_project>/source/tinyml` 
  
- `<model_name>.cc` and `<model_name>.h` - Model files which need to be included under `<path_to_project>/embedded_sw/SapphireSoC/software/standalone/<application_name>/src/model`
