********************************************************************************************
This script generates memory initialization bin files for RISC-V SoC Efinity compilation.

By default, memory initialization bin files of SoC on-chip RAM contains spi flash bootloader only.

If you need to bootup other application when powerup the SoC,

Use this script to regenerate memory initialization bin files using following python command:

********************************************************************************************

Command:

********************************************************************************************
Linux:
source ${EFINITY_HOME}/bin/setup.sh
python3 binGen.py -b <application.bin> -f <fpu> -s <ram size> 

********************************************************************************************
Windows:
${EFINITY_HOME}/bin/setup.bat
python3 binGen.py -b <application.bin> -f <fpu> -s <ram size> 

********************************************************************************************
-b
<application.bin>
Path that target user firmware binary. Accept ".bin" format only. For eg, apb3Demo.bin

-f
<fpu>
If floating-point unit is enabled in IP-Manager, please insert "1", else insert "0"

-s
<ram size>
Specify the RAM size. Provide number only.
eg.
1KB - 1024
2KB - 2048
4KB - 4096
8KB - 8192

********************************************************************************************
eg:
python3 binGen.py -b ~/prj/embedded_sw/prj0/software/standalone/apb3Demo/build/apb3Demo.bin -f 0 -s 8192

********************************************************************************************


