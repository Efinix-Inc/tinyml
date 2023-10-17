# Edge Vision TinyML Framework

Edge Vision TinyML framework is a domain-specific TinyML framework for vision and AI applications. It is using Efinix [Edge Vision SoC (EVSoC) framework](https://github.com/Efinix-Inc/evsoc) as backbone for AI solutions. The key features of EVSoC framework are as follows:
- **Modular building blocks** to facilitate different combinations of system design architecture.
- **Established data transfer flow** between main memory and different building blocks through DMA.
- **Ready-to-deploy** domain-specific **I/O peripherals and interfaces** (SW drivers, HW controllers, pre- and post-processing blocks are provided).
- Highly **flexible HW/SW co-design** is feasible (RISC-V performs control & compute, HW accelerator for time-critical computations).
- Enable **quick porting** of users' design for **edge AI and vision solutions**.

<br />

<img src="../docs/tinyml_vision_top_level.png "/>

<br />

List of video streaming inference demo:
1. MobilenetV1 Person Detection (*evsoc_tinyml_pdti8*)
   - Trained with Tensorflow using MobilenetV1 architecture to perform human presence detection
   - Input to model 96x96 grayscale video frame
   - Hardware accelerator - Nearest neighbour downscaling, RGB to grayscale, Pack output pixels to DMA channel data width
   - Output on display - Green indicates one or more person is detected; Red indicates no person is detected. 
2. Yolo Person Detection (*evsoc_tinyml_ypd*)
   - Trained with Tensorflow using Yolo architecture to perform person detection
   - Input to model 96x96 RGB video frame
   - Hardware accelerator - Nearest neighbour downscaling, Pack output pixels to DMA channel data width
   - Output on display - Bounding box(es) is drawn on detected person.
3. MediaPipe Face Landmark Detection (*evsoc_tinyml_fl*)
   - A pre-trained Tensorflow model using Mediapipe architecture to perform face landmark detection
   - Input to model 192x192 RGB video frame
   - Hardware accelerator - Nearest neighbour downscaling, Pack output pixels to DMA channel data width
   - Output on display - 468 detected face landmark points are plotted.

Refer to the *model_zoo* directory for more details on the related model training and quantization.

<br />

## Get Started
The TinyML demo design is implemented on:
- [Titanium® Ti60 F225 Development Kit](https://www.efinixinc.com/products-devkits-titaniumti60f225.html)
- [Titanium® Ti180 J484 Development Kit](https://www.efinixinc.com/products-devkits-titaniumti180j484.html)

**Note:** Efinity projects of the demo designs are in [tinyml_vision](./) directory.

Efinity® IDE is required for project compilation and bitstream generation, whereas Efinity RISC-V Embedded Software IDE is used to manage RISC-V software projects and for debugging purposes.

<br />

Bring up Edge Vision TinyML demo design on Efinix development kit by following listed steps below:
1. Set up hardware
   - Refer to *Set Up the Hardware* section in [EVSoC User Guide](https://www.efinixinc.com/support/docsdl.php?s=ef&pn=UG-EVSOC) for targeted development kit.
2. Using Efinity® IDE
   - Pre-compiled bitstream .hex (for Programmer SPI active mode) and .bit (for Programmer JTAG mode) files are provided in Efinity project(s) in *tinyml_vision* directory. User may skip Efinity project compilation by using the provided bitstream.
   - To compile Edge Vision TinyML demo design,
      - Open Efinity project (*tinyml_vision/<proj_directory>/edge_vision_soc.xml*).
      - Generate all included IPs in the IP list.
      - Compile
   - Program FPGA bitstream to targeted development kit using Efinity Programmer.
   - Note that, user is required to generate SapphireSoc in IP list (if not done), prior to proceed with using Efinity RISC-V Embedded Software IDE for building software applications.
3. Using Efinity RISC-V Embedded Software IDE
   - Setup Eclipse workspace at *tinyml_vision/<proj_directory>/embedded_sw/SapphireSoc* directory.
   - Window -> Preferences -> C/C++ -> Build -> Environment (for C/C++ compilation with O3 flag, optimize for speed performance)
      - *BENCH* set to *yes*
      - *DEBUG* set to *no*
      - *DEBUG_OG* set to *no*
   - Edge Vision TinyML software app(s) is in *tinyml_vision/<proj_directory>/embedded_sw/SapphireSoc/software/standalone* directory.
   - Refer to *Using Eclipse and OpenOCD* section in [EVSoC User Guide](https://www.efinixinc.com/support/docsdl.php?s=ef&pn=UG-EVSOC) for other general setting and steps for running the demo software applications.

<br />

Refer to [Frequently Asked Questions](../docs/faq.md) for general questions and guidelines for creating your own TinyML solution using Efinix TinyML platform.

<br />

Software Tools Version:
- [Efinity® IDE](https://www.efinixinc.com/support/efinity.php) v2023.1.150.5.11
- [Efinity® RISC-V Embedded Software IDE](https://www.efinixinc.com/support/efinity.php) v2023.1.3
