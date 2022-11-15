# Efinix TinyML Generator

Efinix TinyML Generator is a graphical user interface (GUI) for customizing Efinix TinyML Accelerator. It has a built-in tflite analyzer, which analyzes the selected .tflite model (full integer quantization) and provides the option for acceleration based on layer type that is present.

Efinix TinyML Accelerator supports two modes, which is customizable by layer type:
1. Lite mode - Lightweight accelerator that consumes less resources.
2. Standard mode - High performance accelerator that consumes more resources.

Generated define files from Efinix TinyML Generator are used to facilitate customization of Efinix TinyML Accelerator for RTL compilation using Efinity® IDE and software compilation using Eclipse. In addition, the model data files, that are used to run the inference application, are generated based on the selected tflite model.

<img src="../../docs/efinix_tinyml_generator.png " width="960"/>


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

<br />

## Parameters

`AXI_DW` - AXI data width which is based on memory interface connected. Default is 128-bit (targeted for Ti60 design).

`CONV_DEPTH_MODE` - Option to accelerate convolution and depthwise convolution layer on hardware. Supports Standard and Lite mode.

`CONV_DEPTH_STD_IN_PARALLEL` - Parameterizable input parallelism for Standard mode convolution and depthwise convolution accelerator.

`CONV_DEPTH_STD_OUT_PARALLEL` - Parameterizable output parallelism for Standard mode convolution and depthwise convolution accelerator.

*Note: For CONV_DEPTH_STD_IN_PARALLEL and CONV_DEPTH_STD_OUT_PARALLEL, validated combinations are 8x1, 8x2, 8x3 and 8x4. User may adjust the parameter values for different performance/resource exploration.

`CONV_DEPTH_LITE_PARALLEL` - Parameterizable parallelism for Lite mode convolution and depthwise convolution accelerator.

`ADD_MODE` - Option to accelerate add layer on hardware. Supports Standard and Lite mode.

`FC_MODE` - Option to accelerate fully connected layer on hardware. Supports Lite mode.

`MULT_MODE` - Option to accelerate multiply layer on hardware. Supports Lite mode.

`MIN_MAX_MODE` - Option to accelerate minimum and maximum layer on hardware. Supports Lite mode.

<br />

## Supported layers for hardware acceleration

- Convolution and Depthwise Convolution Layer

- Fully Connected Layer

- Add Layer

- Multiply Layer

- Minimum and Maximum Layer

<br />

## Output Generation

- Example of .tflite models are included under `model` folder.

- Upon selecting the option and generating the model, a list of output files will be produced in `output/<model_name>` :
  
  - `defines.v` - Hardware setting files which need to be included under `<path_to_project>/source/tinyml`
  
  - `define.cc` and `define.h` - Software setting files which need to be included under `<path_to_project>/embedded_sw/SapphireSoC/<application_name>/model`
  
  - `<model_name>.cc` and `<model_name>.h` - Model files which need to be included under `<path_to_project>/embedded_sw/SapphireSoC/<application_name>/model`
