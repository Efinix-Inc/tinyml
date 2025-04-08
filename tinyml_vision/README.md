# Edge Vision TinyML Framework

Edge Vision TinyML framework is a domain-specific TinyML framework for vision and AI applications. It is using Efinix [Edge Vision SoC (EVSoC) framework](https://github.com/Efinix-Inc/evsoc) as backbone for AI solutions. The key features of EVSoC framework are as follows:
- **Modular building blocks** to facilitate different combinations of system design architecture.
- **Established data transfer flow** between main memory and different building blocks through DMA.
- **Ready-to-deploy** domain-specific **I/O peripherals and interfaces** (SW drivers, HW controllers, pre- and post-processing blocks are provided).
- Highly **flexible HW/SW co-design** is feasible (RISC-V performs control & compute, HW accelerator for time-critical computations).
- Enable **quick porting** of users' design for **edge AI and vision solutions**.

## Single Core Design

- The single-core design executes a single model on one core, requiring fewer hardware resources because only one TinyML Accelerator module is instantiated on the FPGA fabric.
- Single-core design examples are available and supported on the Ti60F225 (Sapphire SoC), and Ti180J484 (Sapphire SoC).

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

## Multi Cores Design

- The multi-core design enables the concurrent execution of multiple models across several cores. This approach requires more hardware resources than a single-core design, as it instantiates multiple TinyML Accelerator modules.
- Currently, the multi-core design is officially supported only on our Ti375C529 Development Board, which is optimized to harness the full power of our Sapphire High-Performance SoC. Although the design is compatible with our multi-core Sapphire SoC, users will need to manually port it to support multi-core configurations.

<img src="../docs/tinyml_vision_top_level_multicore.jpg " width="1200" alt="TinyML Vision Top Level Multicore"/>

<br />

List of video streaming inference demo:
1. Multi-model detection (*evsoc_tinyml_mc*)
   - Enables simultaneous execution of multiple models within a single application.
   - Leverages all four cores of the High-Performance Sapphire SoC to accelerate detection processing.
   - Core 0: Yolo Person Detection 
      - Trained with Tensorflow using Yolo architecture to perform person detection
      - Input to model 96x96 RGB video frame
      - Hardware accelerator - Nearest neighbour downscaling, Pack output pixels to DMA channel data width
      - Output on display - Bounding box(es) in green color is drawn on detected person.
   - Core 1: Mediapipe Face Detection
      - A pre-trained Tensorflow model using Mediapipe architecture to perform face detection
      - Input to model 128x128 RGB video frame
      - Hardware accelerator - Nearest neighbour downscaling, Pack output pixels to DMA channel data width
      - Output on display - Bounding box(es) in cyan color is drawn on detected face(s).
   - Core 2: MediaPipe Face Landmark Detection
      - A pre-trained Tensorflow model using Mediapipe architecture to perform face landmark detection
      - Face Landmark Detection on the first face detected from Core 1
      - Input to model 192x192 RGB video frame
      - Nearest neighbour downscaling via software, Pack output pixels to DMA channel data width
      - Output on display - 468 detected face landmark points are plotted.
   - Core 3: MediaPipe Face Landmark Detection
      - A pre-trained Tensorflow model using Mediapipe architecture to perform face landmark detection
      - Face Landmark Detection on the second face detected from Core 1
      - Input to model 192x192 RGB video frame
      - Nearest neighbour downscaling via software, Pack output pixels to DMA channel data width
      - Output on display - 468 detected face landmark points are plotted.

## Get Started
The TinyML demo design is implemented on:
- [Titanium® Ti60 F225 Development Kit](https://www.efinixinc.com/products-devkits-titaniumti60f225.html)
- [Titanium® Ti180 J484 Development Kit](https://www.efinixinc.com/products-devkits-titaniumti180j484.html)
- [Titanium® Ti375 C529 Development Kit](https://www.efinixinc.com/products-devkits-titaniumti375c529.html)

**Note:** Efinity projects of the demo designs are in [tinyml_vision](./) directory.

Efinity® IDE is required for project compilation and bitstream generation, whereas Efinity RISC-V Embedded Software IDE is used to manage RISC-V software projects and for debugging purposes.

<br />

Bring up Edge Vision TinyML demo design on Efinix development kit by following listed steps below:
1. Set up hardware
   - Refer to *Set Up the Hardware* section in [EVSoC User Guide](https://www.efinixinc.com/support/docsdl.php?s=ef&pn=UG-EVSOC) for Ti60F225 and Ti180J484 development kits.
   - For Ti375C529, refer to the following hardware setup:
      - Attach the HDMI Connector Daughter Card to the P1 connector of the Ti375C529 Development Board.
      - Attach the Dual Raspberry Pi Camera Connector Daughter Card to the P2 connector of the Ti375C529 Development Board.
      - Refer to the table below for headers' connection.

   <table>
      <tr>
         <th style="margin: 0 auto; text-align: center;">Connection</th>
         <th style="margin: 0 auto; text-align: center;">Headers</th>
         <th style="margin: 0 auto; text-align: center;">Pins to Connect</th>
      </tr>
     <tr>
         <td style="text-align:center;">Power Rails</td>
         <td style="text-align:center;">PJ5, PJ6, PJ7, PJ8, PJ9, PJ10, PJ11, PJ12</td>
         <td style="text-align:center;">1,2</td>
      </tr>
      <tr>
         <td style="text-align:center;">QSE1</td>
         <td style="text-align:center;">PJ13</td>
         <td style="text-align:center;">3,4</td>
      </tr>
      <tr>
         <td style="text-align:center;">QSE2</td>
         <td style="text-align:center;">PJ14</td>
         <td style="text-align:center;">3,4</td>
      </tr>
   </table>

   <br>

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
   - Edge Vision TinyML software app(s) is in *tinyml_vision/<proj_directory>/embedded_sw/SapphireSoc/software/standalone* directory.
   - Refer to *Using Eclipse and OpenOCD* section in [EVSoC User Guide](https://www.efinixinc.com/support/docsdl.php?s=ef&pn=UG-EVSOC) for other general setting and steps for running the demo software applications.

<br />

List of supported cameras for TinyML demo design:
1. Raspberry PI Camera Module v2
   - Sony IMX219 image sensor
2. Raspberry PI Camera Module v3
   - Sony IMX708 image sensor

</br>

Refer to [Frequently Asked Questions](../docs/faq.md) for general questions, guidelines for creating your own TinyML solution using Efinix TinyML platform and different camera support.

<br />

Software Tools Version:
- [Efinity® IDE](https://www.efinixinc.com/support/efinity.php) v2024.2.294.4.15
- [Efinity® RISC-V Embedded Software IDE](https://www.efinixinc.com/support/efinity.php) v2024.2.0.1
