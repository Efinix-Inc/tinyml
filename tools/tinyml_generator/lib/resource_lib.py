"""
Copyright 2022 Efinix.Inc. All Rights Reserved.
You may obtain a copy of the license at
https://www.efinixinc.com/software-license.html
"""

import math



roundup=math.ceil
log=math.log

lookup_table = {
    'COMMON_MODULE_1' : {
        "DISABLE": "[0,0,0,0,0]",
        "STANDARD":"self.common_module_1_res_calc(OP_CNT)",
    },
    'COMMON_MODULE_2' : {
        "DISABLE": "[0,0,0,0,0]",
        "STANDARD": {
            32:"[531,705,86,self.common_module_2_res_calc(),0]",
            64:"[1024,813,86,self.common_module_2_res_calc(),0]",
            128:"[2177,1029,86,self.common_module_2_res_calc(),0]",
            256:"[4972,1461,86,self.common_module_2_res_calc(),0]",
            512:"[11292,2325,86,self.common_module_2_res_calc(),0]",
        }
    },

    'TINYML_CACHE' : {
        "LITE": "[0,0,0,0,0]",
        "STANDARD":"self.tinyml_cache_res_calc()",
    },
    'CONV_DEPTHW_MODE' : {
        "LITE": "self.conv_depthwise_res_lite()",
        "STANDARD":"self.conv_depthwise_res_standard()",
    },

    'ADD_MODE' : {
        "LITE": "[1159,1250,630,0,8]",
        "STANDARD": {
            32:"[1609,1887,752,0,8]",
            64:"[1681,2156,749,0,8]",
            128:"[1904,2674,747,0,8]",
            256:"[2829,3716,741,0,8]",
            512:"[3617,5796,738,0,8]",
        }
    },
    'MIN_MAX_MODE' : {
        "LITE": "[86,34,0,0,0]",
        "STANDARD": {
            32:"[543,544,149,0,0]",
            64:"[611,672,144,0,0]",
            128:"[926,936,139,0,0]",
            256:"[1448,1464,134,0,0]",
            512:"[2033,2524,129,0,0]",
        }
    },
    'MUL_MODE' : {
        "LITE": "[459,491,263,0,4]",
        "STANDARD": {
            32:"[1546,1507,734,0,7]",
            64:"[1766,1716,700,0,7]",
            128:"[2416,2168,695,0,7]",
            256:"[3107,3124,690,0,7]",
            512:"[6014,5024,685,0,7]",
        }
    },
    'FC_MODE' : {
        "LITE": "self.fc_res_lite()",
        "STANDARD": {
            32:"[1104,1357,654,0,4]",
            64:"[1439,1630,761,0,8]",
            128:"[1842,2351,976,0,16]",
            256:"[2800,3844,1407,0,32]",
            512:"[4693,6789,2270,0,64]",
        }
    }
}


class ResourceUtil():
    def __init__(self):
        self.p_tinyml_gen={}
        self.AXI_DW=None
        self.AXI_DW_BYTES=None

    def conv_depthwise_res_lite(self):
        ram = (self.calc_bram_size(self.p_tinyml_gen["CONV_DEPTHW_LITE_AW"]['val'],64))*self.p_tinyml_gen["CONV_DEPTHW_LITE_PARALLEL"]['val']

        res=([600*self.p_tinyml_gen["CONV_DEPTHW_LITE_PARALLEL"]['val'], \
            600*self.p_tinyml_gen["CONV_DEPTHW_LITE_PARALLEL"]['val'], \
            800*self.p_tinyml_gen["CONV_DEPTHW_LITE_PARALLEL"]['val'], \
            ram, \
            3+8*self.p_tinyml_gen["CONV_DEPTHW_LITE_PARALLEL"]['val']])
        
        return res

    def fc_res_lite(self):
        num_data_load = roundup(int(self.p_tinyml_gen['FC_MAX_IN_NODE']['val'])/(64/8))
        input_addr_bit = log(num_data_load,2) if (log(num_data_load,2) != 0) else 1
        res =([417,506,305,self.calc_bram_size(roundup(input_addr_bit),64),8])
        return res



    def conv_depthwise_res_standard(self):
        INPUT_CNT = int(self.p_tinyml_gen['CONV_DEPTHW_STD_IN_PARALLEL']['val'])
        OUTPUT_CNT = int(self.p_tinyml_gen['CONV_DEPTHW_STD_OUT_PARALLEL']['val'])
        FILTER_FIFO_A = int(self.p_tinyml_gen['CONV_DEPTHW_STD_FILTER_FIFO_A']['val'])
        OUTPUT_CH_FIFO_A = int(self.p_tinyml_gen['CONV_DEPTHW_STD_OUT_CH_FIFO_A']['val'])
        OUTPUT_CH_AW = roundup(log(OUTPUT_CH_FIFO_A,2)) if (roundup(log(OUTPUT_CH_FIFO_A,2)) > 9) else 9
        FILTER_AW = roundup(log(FILTER_FIFO_A,2)) if (roundup(log(FILTER_FIFO_A,2)) > 9) else 9
        om_ram = self.calc_bram_size(OUTPUT_CH_AW,32)
        os_ram = self.calc_bram_size(OUTPUT_CH_AW,32)
        b_ram = self.calc_bram_size(OUTPUT_CH_AW,32)

        filter_ram = self.calc_bram_size(FILTER_AW,INPUT_CNT*8)
        input_ram = OUTPUT_CNT * (self.calc_bram_size(FILTER_AW,INPUT_CNT*8+1) )

        rams = om_ram + os_ram + b_ram + filter_ram + input_ram
        res = [(INPUT_CNT*110+697)*OUTPUT_CNT+3600+(int(self.AXI_DW_BYTES*163)), (300+130*INPUT_CNT)*OUTPUT_CNT + 1350 + (int(self.AXI_DW_BYTES*135)), (120*INPUT_CNT+240)*OUTPUT_CNT+459 + (int(self.AXI_DW_BYTES*4)), rams, (4+INPUT_CNT)*OUTPUT_CNT]
        return res


    def tinyml_cache_res_calc(self):
        CACHE_DEPTH=int(self.p_tinyml_gen['CACHE_DEPTH']['val'])
        CACHE_AW=roundup(log(CACHE_DEPTH,2))
        cache_ram = self.calc_bram_size(CACHE_AW,int(self.p_tinyml_gen['AXI_DW']['val']))+3 
        res = [int(self.AXI_DW_BYTES*10 + (CACHE_AW*80)),int(CACHE_AW*15+337+self.AXI_DW_BYTES),int(4*CACHE_AW-(self.AXI_DW_BYTES/4)+140),cache_ram,0]
        return res



    def common_module_1_res_calc(self,OP_CNT):
        ram = self.calc_bram_size(9,int(self.p_tinyml_gen['AXI_DW']['val']))
        res = [int(12*int(self.AXI_DW_BYTES*OP_CNT)+120),44,30,ram,0]
        return res



    def common_module_2_res_calc(self):
        FIFO3_A=8
        u2_ram = self.calc_bram_size(log(8,2),(int(self.AXI_DW+self.AXI_DW_BYTES)))
        u3_ram = self.calc_bram_size(log(FIFO3_A,2),(self.AXI_DW_BYTES+32))
        u4_ram = self.calc_bram_size(log(FIFO3_A*4,2),(self.AXI_DW_BYTES+roundup(log(self.AXI_DW_BYTES,2))))
        u5_ram = self.calc_bram_size(log(FIFO3_A*4,2),(2+int(self.AXI_DW)))
        total_ram =  u2_ram +u3_ram + u4_ram + u5_ram 
        return total_ram



    def calc_bram_size(self,ADDR_WIDTH=None,DATA_WIDTH=None):
        addr_width_per_bram=9
        data_width_per_bbram=20
        bram_size= pow(2,addr_width_per_bram)*data_width_per_bbram
        if(ADDR_WIDTH<=addr_width_per_bram and DATA_WIDTH>=data_width_per_bbram):
            bram_count = roundup(DATA_WIDTH/data_width_per_bbram)
        else:
            total_size =(pow(2,ADDR_WIDTH))*DATA_WIDTH
            bram_count=roundup(total_size/bram_size)
        return bram_count

    def evaluate_res(self,module,mode):
        if(module not in lookup_table.keys()):
            print("NOT SUPPORTED")
        if("STANDARD" in mode or "ENABLE" in mode):
            if(str(self.AXI_DW) in str(lookup_table[module]["STANDARD"])):
                res=eval(str(lookup_table[module]['STANDARD'][self.AXI_DW]))
            else:
                res=eval(str(lookup_table[module]['STANDARD']))
        elif ("LITE" in mode):
            res=eval(str(lookup_table[module]['LITE']))
        else:
            res=([0,0,0,0,0])

        return res

    def evaluate_common_module(self,layer_mode):
        res_com_total=[0,0,0,0,0]
        OP_CNT=0
        for layer in layer_mode:
            if("STANDARD" in layer):
                OP_CNT+=1
        if(OP_CNT>=1):
            res_com_1=eval(str(lookup_table['COMMON_MODULE_1']['STANDARD']))
            res_com_2=eval(str(lookup_table['COMMON_MODULE_2']['STANDARD'][self.AXI_DW]))
            for i in range(5):
                res_com_total[i]=res_com_1[i]+res_com_2[i]
            return res_com_total
        else:
            return False

    
    def initialize_param(self,p2):
        self.p_tinyml_gen={}
        self.p_tinyml_gen=p2.copy()
        self.AXI_DW = int(self.p_tinyml_gen['AXI_DW']['val'])
        self.AXI_DW_BYTES = int(self.AXI_DW/8)


