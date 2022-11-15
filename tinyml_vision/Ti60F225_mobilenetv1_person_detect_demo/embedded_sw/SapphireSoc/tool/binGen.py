import binascii
import argparse
import csv
import json
import os
import cmd
import time
import codecs
import shutil
from io import StringIO
from pathlib import Path

binDatal        = []
binData_binaryl = []

rom0Hex         = ".v_toplevel_system_ramA_logic_ram_symbol0.bin"
rom1Hex         = ".v_toplevel_system_ramA_logic_ram_symbol1.bin"
rom2Hex         = ".v_toplevel_system_ramA_logic_ram_symbol2.bin"
rom3Hex         = ".v_toplevel_system_ramA_logic_ram_symbol3.bin"
rom4Hex         = ".v_toplevel_system_ramA_logic_ram_symbol4.bin"
rom5Hex         = ".v_toplevel_system_ramA_logic_ram_symbol5.bin"
rom6Hex         = ".v_toplevel_system_ramA_logic_ram_symbol6.bin"
rom7Hex         = ".v_toplevel_system_ramA_logic_ram_symbol7.bin"

def binSplit (start, romHex, ramsize):
    rom_l           = []
    for x in range (start, len(binData_binaryl), 4):
        rom_l.append(binData_binaryl[x])
        
    padNumber = (ramsize >> 2)-len(rom_l)
    
    for x in range (0, padNumber):
        rom_l.append("00000000")

    fp=Path(os.getcwd(), 'rom', romHex)
    f = open(fp ,'w',encoding="utf-8")
    for x in range(0, len(rom_l)):
        f.write(rom_l[x]+"\n")
    f.close

def binSplit8 (start, romHex, ramsize):
    rom_l           = []
    for x in range (start, len(binData_binaryl), 8):
        rom_l.append(binData_binaryl[x])
        
    padNumber = (ramsize >> 3)-len(rom_l)
    
    for x in range (0, padNumber):
        rom_l.append("00000000")

    fp=Path(os.getcwd(), 'rom', romHex)
    f = open(fp ,'w',encoding="utf-8")
    for x in range(0, len(rom_l)):
        f.write(rom_l[x]+"\n")
    f.close

def app_binSplit(args):
    
    ramSize = int(args.sizeram)
    fpuEnable = args.fpu
    
    if(fpuEnable == '1'):
        rom0Hex_p = args.core+rom0Hex
        rom1Hex_p = args.core+rom1Hex
        rom2Hex_p = args.core+rom2Hex
        rom3Hex_p = args.core+rom3Hex
        rom4Hex_p = args.core+rom4Hex
        rom5Hex_p = args.core+rom5Hex
        rom6Hex_p = args.core+rom6Hex
        rom7Hex_p = args.core+rom7Hex
    else:
        rom0Hex_p = args.core+rom0Hex
        rom1Hex_p = args.core+rom1Hex
        rom2Hex_p = args.core+rom2Hex
        rom3Hex_p = args.core+rom3Hex
   
    if(args.binfile[-4:] != ".bin"):
        return 1

    bf=Path(args.binfile)
    with open(bf, 'rb') as f:
        while True:
            binData = f.read(1)
            if not binData:
                break
            binDatal.append(binData)

    for binData in binDatal:
        binData_value = ord(binData)
        binData_binary = '{0:08b}'.format(binData_value)
        binData_binaryl.append(binData_binary)
    
    if(fpuEnable == '1'):
        binSplit8(0,rom0Hex_p,ramSize)
        binSplit8(1,rom1Hex_p,ramSize)
        binSplit8(2,rom2Hex_p,ramSize)
        binSplit8(3,rom3Hex_p,ramSize)
        binSplit8(4,rom4Hex_p,ramSize)
        binSplit8(5,rom5Hex_p,ramSize)
        binSplit8(6,rom6Hex_p,ramSize)
        binSplit8(7,rom7Hex_p,ramSize)
    else:
        binSplit(0,rom0Hex_p,ramSize)
        binSplit(1,rom1Hex_p,ramSize)
        binSplit(2,rom2Hex_p,ramSize)
        binSplit(3,rom3Hex_p,ramSize)
    
    return 0


def parse_args():
    parser = argparse.ArgumentParser()
    parser.add_argument('-f',
                        '--fpu',
                        default='0',
                        help='SoC with fpu, 0 or 1')
    parser.add_argument('-b',
                        '--binfile',
                        default=None,
                        help='firmware binary to convert',
                        required=True)
    parser.add_argument('-c',
                        '--core',
                        default="EfxSapphireSoc",
                        help='SoC prefix name')
    parser.add_argument('-s',
                        '--sizeram',
                        default=4096,
                        help='SoC RAM Size')

    #check efinity environment
    try:
        os.environ['EFINITY_HOME']
    except:
        print('neither EFINITY_HOME nor EFXIPM_HOME is set.  Stop.')
        quit()

    df=Path(os.getcwd(),'rom')
    if os.path.exists(df):
        shutil.rmtree(Path(df))
    os.mkdir(df)

    args = parser.parse_args()
    return args


if __name__ == '__main__':
    args = parse_args()
    ret=app_binSplit(args)
    if(ret == 1):
        print("Invalid binary file detected, script aborted!")
        print("Please insert correct firmware binary file, for eg apb3Demo.bin.")
    else:
        print("The RAM memory initialization files have been successfully generated!")
