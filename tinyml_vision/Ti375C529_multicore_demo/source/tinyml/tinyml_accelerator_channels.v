///////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2022 github-efx
// 
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
// 
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
///////////////////////////////////////////////////////////////////////////////////
`include "tinyml_core0_define.v"
`include "tinyml_core1_define.v"
`include "tinyml_core2_define.v"
`include "tinyml_core3_define.v"
  
module tinyml_accelerator_channels#(
   parameter int                   NUMBER_OF_CHANNELS                                        = 4, 
   parameter int                   AXI_DW_M                                                  = 128, 
   parameter int                   STRING_LENGTH                                             = 11,
   parameter int                   AXI_DW[NUMBER_OF_CHANNELS-1:0]                            = {`TML_C3_AXI_DW         ,`TML_C2_AXI_DW         ,`TML_C1_AXI_DW         ,`TML_C0_AXI_DW         },
   parameter [8*STRING_LENGTH-1:0] ADD_MODE[NUMBER_OF_CHANNELS-1:0]                          = {`TML_C3_ADD_MODE       ,`TML_C2_ADD_MODE       ,`TML_C1_ADD_MODE       ,`TML_C0_ADD_MODE       },
   parameter [8*STRING_LENGTH-1:0] MIN_MAX_MODE[NUMBER_OF_CHANNELS-1:0]                      = {`TML_C3_MIN_MAX_MODE   ,`TML_C2_MIN_MAX_MODE   ,`TML_C1_MIN_MAX_MODE   ,`TML_C0_MIN_MAX_MODE   },
   parameter [8*STRING_LENGTH-1:0] MUL_MODE[NUMBER_OF_CHANNELS-1:0]                          = {`TML_C3_MUL_MODE       ,`TML_C2_MUL_MODE       ,`TML_C1_MUL_MODE       ,`TML_C0_MUL_MODE       },
   parameter [8*STRING_LENGTH-1:0] FC_MODE[NUMBER_OF_CHANNELS-1:0]                           = {`TML_C3_FC_MODE        ,`TML_C2_FC_MODE        ,`TML_C1_FC_MODE        ,`TML_C0_FC_MODE        },
   parameter [8*STRING_LENGTH-1:0] LR_MODE[NUMBER_OF_CHANNELS-1:0]                           = {`TML_C3_LR_MODE        ,`TML_C2_LR_MODE        ,`TML_C1_LR_MODE        ,`TML_C0_LR_MODE        },
   parameter [8*STRING_LENGTH-1:0] TINYML_CACHE[NUMBER_OF_CHANNELS-1:0]                      = {`TML_C3_TINYML_CACHE   ,`TML_C2_TINYML_CACHE   ,`TML_C1_TINYML_CACHE   ,`TML_C0_TINYML_CACHE   },
   parameter int 				        CACHE_DEPTH[NUMBER_OF_CHANNELS-1:0]                       = {`TML_C3_CACHE_DEPTH    ,`TML_C2_CACHE_DEPTH    ,`TML_C1_CACHE_DEPTH    ,`TML_C0_CACHE_DEPTH    },
   //Convolution & Depthwise Convolution OP Parameter          
   parameter [8*STRING_LENGTH-1:0] CONV_DEPTHW_MODE[NUMBER_OF_CHANNELS-1:0]                  = {`TML_C3_CONV_DEPTHW_MODE              ,`TML_C2_CONV_DEPTHW_MODE              ,`TML_C1_CONV_DEPTHW_MODE              ,`TML_C0_CONV_DEPTHW_MODE              },   
   parameter int                   CONV_DEPTHW_LITE_PARALLEL[NUMBER_OF_CHANNELS-1:0]         = {`TML_C3_CONV_DEPTHW_LITE_PARALLEL     ,`TML_C2_CONV_DEPTHW_LITE_PARALLEL     ,`TML_C1_CONV_DEPTHW_LITE_PARALLEL     ,`TML_C0_CONV_DEPTHW_LITE_PARALLEL     }, 
   parameter int                   CONV_DEPTHW_LITE_AW[NUMBER_OF_CHANNELS-1:0]               = {`TML_C3_CONV_DEPTHW_LITE_AW           ,`TML_C2_CONV_DEPTHW_LITE_AW           ,`TML_C1_CONV_DEPTHW_LITE_AW           ,`TML_C0_CONV_DEPTHW_LITE_AW           }, 
   parameter int                   CONV_DEPTHW_STD_IN_PARALLEL[NUMBER_OF_CHANNELS-1:0]       = {`TML_C3_CONV_DEPTHW_STD_IN_PARALLEL   ,`TML_C2_CONV_DEPTHW_STD_IN_PARALLEL   ,`TML_C1_CONV_DEPTHW_STD_IN_PARALLEL   ,`TML_C0_CONV_DEPTHW_STD_IN_PARALLEL   }, 
   parameter int                   CONV_DEPTHW_STD_OUT_PARALLEL[NUMBER_OF_CHANNELS-1:0]      = {`TML_C3_CONV_DEPTHW_STD_OUT_PARALLEL  ,`TML_C2_CONV_DEPTHW_STD_OUT_PARALLEL  ,`TML_C1_CONV_DEPTHW_STD_OUT_PARALLEL  ,`TML_C0_CONV_DEPTHW_STD_OUT_PARALLEL  }, 
   parameter int                   CONV_DEPTHW_STD_OUT_CH_FIFO_A[NUMBER_OF_CHANNELS-1:0]     = {`TML_C3_CONV_DEPTHW_STD_OUT_CH_FIFO_A ,`TML_C2_CONV_DEPTHW_STD_OUT_CH_FIFO_A ,`TML_C1_CONV_DEPTHW_STD_OUT_CH_FIFO_A ,`TML_C0_CONV_DEPTHW_STD_OUT_CH_FIFO_A }, 
   parameter int                   CONV_DEPTHW_STD_FILTER_FIFO_A [NUMBER_OF_CHANNELS-1:0]    = {`TML_C3_CONV_DEPTHW_STD_FILTER_FIFO_A ,`TML_C2_CONV_DEPTHW_STD_FILTER_FIFO_A ,`TML_C1_CONV_DEPTHW_STD_FILTER_FIFO_A ,`TML_C0_CONV_DEPTHW_STD_FILTER_FIFO_A }, 
   parameter int                   CONV_DEPTHW_STD_CNT_DTH[NUMBER_OF_CHANNELS-1:0]           = {`TML_C3_CONV_DEPTHW_STD_CNT_DTH       ,`TML_C2_CONV_DEPTHW_STD_CNT_DTH       ,`TML_C1_CONV_DEPTHW_STD_CNT_DTH       ,`TML_C0_CONV_DEPTHW_STD_CNT_DTH       }, 
   //FC OP Parameter         
   parameter int                   FC_MAX_IN_NODE[NUMBER_OF_CHANNELS-1:0]                    = {`TML_C3_FC_MAX_IN_NODE  ,`TML_C2_FC_MAX_IN_NODE  ,`TML_C1_FC_MAX_IN_NODE  ,`TML_C0_FC_MAX_IN_NODE },   
   parameter int                   FC_MAX_OUT_NODE[NUMBER_OF_CHANNELS-1:0]                   = {`TML_C3_FC_MAX_OUT_NODE ,`TML_C2_FC_MAX_OUT_NODE ,`TML_C1_FC_MAX_OUT_NODE ,`TML_C0_FC_MAX_OUT_NODE}
) (
   input                           clk,
   input                           reset,
   //Command Interface
   input  [NUMBER_OF_CHANNELS-1:0]       cmd_valid,
   input  [NUMBER_OF_CHANNELS*10-1:0]    cmd_function_id,
   input  [NUMBER_OF_CHANNELS*32-1:0]    cmd_inputs_0,
   input  [NUMBER_OF_CHANNELS*32-1:0]    cmd_inputs_1,
   output [NUMBER_OF_CHANNELS-1:0]       cmd_ready,
   output [NUMBER_OF_CHANNELS-1:0]       cmd_int,
   //Response Interface
   output [NUMBER_OF_CHANNELS-1:0]       rsp_valid,
   output [NUMBER_OF_CHANNELS*32-1:0]    rsp_outputs_0,
   input  [NUMBER_OF_CHANNELS-1:0]       rsp_ready,
   //AXI Master Interface
   
   
   //Master AXI4 Bus Interface
	//--Global Signals
	input                           m_axi_clk,
	input                           m_axi_rstn,
	//--Master AXI4 Write
	output  wire                    m_axi_awvalid,
	input                           m_axi_awready,
	output  wire    [31:0]          m_axi_awaddr,
	output  wire    [7:0]           m_axi_awlen,
	output  wire    [7:0]           m_axi_awid,
	output  wire    [2:0]           m_axi_awsize,
	output  wire    [1:0]           m_axi_awburst,
	output  wire    [0:0]           m_axi_awlock,
	output  wire    [3:0]           m_axi_awcache,
	output  wire    [2:0]           m_axi_awprot,
	
	output  wire                     m_axi_wvalid,
	input                            m_axi_wready,
	output  wire    [AXI_DW_M-1:0]   m_axi_wdata,
	output  wire    [AXI_DW_M/8-1:0] m_axi_wstrb,
	output  wire                     m_axi_wlast,
	input                            m_axi_bvalid,
	output  wire                     m_axi_bready,
	input           [1:0]            m_axi_bresp,
	//--Master AXI4 Read
	output  wire                     m_axi_arvalid,
	input                            m_axi_arready,
	output  wire    [31:0]           m_axi_araddr,
	output  wire    [7:0]            m_axi_arlen,
	output  wire    [7:0]            m_axi_arid,
	output  wire    [2:0]            m_axi_arsize,
	output  wire    [1:0]            m_axi_arburst,
	output  wire    [0:0]            m_axi_arlock,
	output  wire    [3:0]            m_axi_arcache,
	output  wire    [2:0]            m_axi_arprot,
	input                            m_axi_rvalid,
	output  wire                     m_axi_rready,
	input           [AXI_DW_M-1:0]   m_axi_rdata,
	input                            m_axi_rlast,
	input           [1:0]            m_axi_rresp
   
   
);

wire [NUMBER_OF_CHANNELS*8-1:0]             s_axi_tinyml_awid;
wire [NUMBER_OF_CHANNELS*32-1:0]            s_axi_tinyml_awaddr;
wire [NUMBER_OF_CHANNELS*8-1:0]             s_axi_tinyml_awlen;
wire [NUMBER_OF_CHANNELS*3-1:0]             s_axi_tinyml_awsize;
wire [NUMBER_OF_CHANNELS*2-1:0]             s_axi_tinyml_awburst;
wire [NUMBER_OF_CHANNELS*2-1:0]             s_axi_tinyml_awlock;
wire [NUMBER_OF_CHANNELS*4-1:0]             s_axi_tinyml_awcache;
wire [NUMBER_OF_CHANNELS*3-1:0]             s_axi_tinyml_awprot;
wire [NUMBER_OF_CHANNELS*4-1:0]             s_axi_tinyml_awqos;
wire [NUMBER_OF_CHANNELS-1:0]               s_axi_tinyml_awvalid;
wire [NUMBER_OF_CHANNELS-1:0]               s_axi_tinyml_awready;
wire [NUMBER_OF_CHANNELS*AXI_DW_M-1:0]      s_axi_tinyml_wdata;
wire [NUMBER_OF_CHANNELS*(AXI_DW_M/8)-1:0]  s_axi_tinyml_wstrb;
wire [NUMBER_OF_CHANNELS-1:0]               s_axi_tinyml_wlast;
wire [NUMBER_OF_CHANNELS-1:0]               s_axi_tinyml_wvalid;
wire [NUMBER_OF_CHANNELS-1:0]               s_axi_tinyml_wready;
wire [NUMBER_OF_CHANNELS*8-1:0]             s_axi_tinyml_bid;
wire [NUMBER_OF_CHANNELS*2-1:0]             s_axi_tinyml_bresp;
wire [NUMBER_OF_CHANNELS-1:0]               s_axi_tinyml_bvalid;
wire [NUMBER_OF_CHANNELS-1:0]               s_axi_tinyml_bready;
wire [NUMBER_OF_CHANNELS*8-1:0]             s_axi_tinyml_arid;
wire [NUMBER_OF_CHANNELS*32-1:0]            s_axi_tinyml_araddr;
wire [NUMBER_OF_CHANNELS*8-1:0]             s_axi_tinyml_arlen;
wire [NUMBER_OF_CHANNELS*3-1:0]             s_axi_tinyml_arsize;
wire [NUMBER_OF_CHANNELS*2-1:0]             s_axi_tinyml_arburst;
wire [NUMBER_OF_CHANNELS*2-1:0]             s_axi_tinyml_arlock;
wire [NUMBER_OF_CHANNELS*4-1:0]             s_axi_tinyml_arcache;
wire [NUMBER_OF_CHANNELS*3-1:0]             s_axi_tinyml_arprot;
wire [NUMBER_OF_CHANNELS*4-1:0]             s_axi_tinyml_arqos;
wire [NUMBER_OF_CHANNELS-1:0]               s_axi_tinyml_arvalid;
wire [NUMBER_OF_CHANNELS-1:0]               s_axi_tinyml_arready;
wire [NUMBER_OF_CHANNELS*8-1:0]             s_axi_tinyml_rid;
wire [NUMBER_OF_CHANNELS*AXI_DW_M-1:0]      s_axi_tinyml_rdata;
wire [NUMBER_OF_CHANNELS*2-1:0]             s_axi_tinyml_rresp;
wire [NUMBER_OF_CHANNELS-1:0]               s_axi_tinyml_rlast;
wire [NUMBER_OF_CHANNELS-1:0]               s_axi_tinyml_rvalid;
wire [NUMBER_OF_CHANNELS-1:0]               s_axi_tinyml_rready;



genvar i;
generate 	

for(i=0; i<NUMBER_OF_CHANNELS; i=i+1)
begin 
tinyml_top  #(
    .AXI_DW                         (AXI_DW_M),    // AXI_DW of each accelerator
    .ADD_MODE                       (ADD_MODE[i]),
    .MIN_MAX_MODE                   (MIN_MAX_MODE[i]),
    .MUL_MODE                       (MUL_MODE[i]),
    .FC_MODE                        (FC_MODE[i]),
    .LR_MODE                        (LR_MODE[i]),
    .TINYML_CACHE                   (TINYML_CACHE[i]),
    .CACHE_DEPTH                    (CACHE_DEPTH[i]),
    //Convolution & Depthwise Convolution OP Parameter          
    .CONV_DEPTHW_MODE               (CONV_DEPTHW_MODE[i]),    
    .CONV_DEPTHW_LITE_PARALLEL      (CONV_DEPTHW_LITE_PARALLEL[i]),        
    .CONV_DEPTHW_LITE_AW            (CONV_DEPTHW_LITE_AW[i]),        
    .CONV_DEPTHW_STD_IN_PARALLEL    (CONV_DEPTHW_STD_IN_PARALLEL[i]),        
    .CONV_DEPTHW_STD_OUT_PARALLEL   (CONV_DEPTHW_STD_OUT_PARALLEL[i]),
    .CONV_DEPTHW_STD_OUT_CH_FIFO_A  (CONV_DEPTHW_STD_OUT_CH_FIFO_A[i]),
    .CONV_DEPTHW_STD_FILTER_FIFO_A  (CONV_DEPTHW_STD_FILTER_FIFO_A[i]),
    .CONV_DEPTHW_STD_CNT_DTH        (CONV_DEPTHW_STD_CNT_DTH[i]),
    //FC OP Parameter         
    .FC_MAX_IN_NODE                 (FC_MAX_IN_NODE[i]),  
    .FC_MAX_OUT_NODE                (FC_MAX_OUT_NODE[i])  
	
	
	
) u_tinyml_top_ch (

   .clk              (clk              ),
   .reset            (reset            ),
   .cmd_valid        (cmd_valid       [i]),
   .cmd_function_id  (cmd_function_id [i*10 +: 10]),
   .cmd_inputs_0     (cmd_inputs_0    [i*32 +: 32]),
   .cmd_inputs_1     (cmd_inputs_1    [i*32 +: 32]),
   .cmd_ready        (cmd_ready       [i]),
   .cmd_int          (cmd_int         [i]), //Interrupt
   .rsp_valid        (rsp_valid       [i]),
   .rsp_outputs_0    (rsp_outputs_0   [i*32 +: 32]),
   .rsp_ready        (rsp_ready       [i]),

   .m_axi_clk        (m_axi_clk),
   .m_axi_rstn       (m_axi_rstn),
   .m_axi_awvalid    (s_axi_tinyml_awvalid[ i*1 +: 1]),
   .m_axi_awaddr     (s_axi_tinyml_awaddr [ i*32+: 32]),
   .m_axi_awlen      (s_axi_tinyml_awlen  [ i*8 +: 8] ),
   .m_axi_awsize     (s_axi_tinyml_awsize [ i*3 +: 3]),
   .m_axi_awburst    (s_axi_tinyml_awburst[ i*2 +: 2]),
   .m_axi_awprot     (s_axi_tinyml_awprot [ i*3 +: 3]),
   .m_axi_awlock     (s_axi_tinyml_awlock [ i*2 +: 2]),
   .m_axi_awcache    (s_axi_tinyml_awcache[ i*4 +: 4]),
   .m_axi_awready    (s_axi_tinyml_awready[ i*1 +: 1]),
   .m_axi_wdata      (s_axi_tinyml_wdata  [ i*AXI_DW_M +: AXI_DW_M]),
   .m_axi_wstrb      (s_axi_tinyml_wstrb  [ i*(AXI_DW_M/8) +: (AXI_DW_M/8)]),
   .m_axi_wlast      (s_axi_tinyml_wlast  [ i*1 +: 1]),
   .m_axi_wvalid     (s_axi_tinyml_wvalid [ i*1 +: 1]),
   .m_axi_wready     (s_axi_tinyml_wready [ i*1 +: 1]), 
   .m_axi_bresp      (s_axi_tinyml_bresp  [ i*2 +: 2]), 
   .m_axi_bvalid     (s_axi_tinyml_bvalid [ i*1 +: 1]), 
   .m_axi_bready     (s_axi_tinyml_bready [ i*1 +: 1]),
   .m_axi_arvalid    (s_axi_tinyml_arvalid[ i*1 +: 1]),
   .m_axi_araddr     (s_axi_tinyml_araddr [ i*32+: 32]),
   .m_axi_arlen      (s_axi_tinyml_arlen  [ i*8 +:  8]),
   .m_axi_arsize     (s_axi_tinyml_arsize [ i*3 +:  3]),
   .m_axi_arburst    (s_axi_tinyml_arburst[ i*2 +:  2]),
   .m_axi_arprot     (s_axi_tinyml_arprot [ i*3 +:  3]),
   .m_axi_arlock     (s_axi_tinyml_arlock [ i*2 +:  2]),
   .m_axi_arcache    (s_axi_tinyml_arcache[ i*4 +:  4]),
   .m_axi_arready    (s_axi_tinyml_arready[ i*1 +:  1]), 
   .m_axi_rvalid     (s_axi_tinyml_rvalid [ i*1 +:  1]), 
   .m_axi_rdata      (s_axi_tinyml_rdata  [ i*AXI_DW_M +: AXI_DW_M]), 
   .m_axi_rlast      (s_axi_tinyml_rlast  [ i*1 +:  1]),
   .m_axi_rresp      (s_axi_tinyml_rresp  [ i*2 +:  2]), 
   .m_axi_rready     (s_axi_tinyml_rready [ i*1 +:  1])
   
);
end 

endgenerate 

axi_interconnect_beta #(
    .S_COUNT                            (NUMBER_OF_CHANNELS         ),
    .SLAVE_ASYN_ARRAY                   ({NUMBER_OF_CHANNELS{1'b0}} ),
    .S_AXI_DW_ARRAY                     ({NUMBER_OF_CHANNELS{128}}  ),
    .CB_DW                              (AXI_DW_M                   ),
    .M_AXI_DW                           (AXI_DW_M                   ),
    .ARB_MODE                           (1                          ),
    .FAMILY                             ("TITANIUM"                 ),
    .RD_QUEUE_FIFO_RAM_STYLE            ("block_ram"                ),
    .RD_QUEUE_FIFO_DEPTH                (512                        )
 ) inst_axi_1to1(
    //AXI slave interfaces - S0: Connected to RISC-V SoC; S1: Connected to DMA controller; S2: Connected to TinyML accelerator
   .s_axi_clk        ({NUMBER_OF_CHANNELS{m_axi_clk}}),
   .s_axi_rstn       ({NUMBER_OF_CHANNELS{m_axi_rstn}}),
   .s_axi_awvalid    (s_axi_tinyml_awvalid),
   
   .s_axi_awaddr     (s_axi_tinyml_awaddr),
   .s_axi_awlen      (s_axi_tinyml_awlen),
   
   .s_axi_awready    (s_axi_tinyml_awready),
   .s_axi_wdata      (s_axi_tinyml_wdata),
   .s_axi_wstrb      (s_axi_tinyml_wstrb),
   .s_axi_wlast      (s_axi_tinyml_wlast),
   .s_axi_wvalid     (s_axi_tinyml_wvalid),
   .s_axi_wready     (s_axi_tinyml_wready), 
   .s_axi_bresp      (s_axi_tinyml_bresp), 
   .s_axi_bvalid     (s_axi_tinyml_bvalid), 
   .s_axi_bready     (s_axi_tinyml_bready),
   .s_axi_araddr     (s_axi_tinyml_araddr),
   .s_axi_arlen      (s_axi_tinyml_arlen),
   .s_axi_arvalid    (s_axi_tinyml_arvalid),
   .s_axi_arready    (s_axi_tinyml_arready), 
   .s_axi_rdata      (s_axi_tinyml_rdata), 
   .s_axi_rresp      (s_axi_tinyml_rresp), 
   .s_axi_rlast      (s_axi_tinyml_rlast),
   .s_axi_rvalid     (s_axi_tinyml_rvalid), 
   .s_axi_rready     (s_axi_tinyml_rready),
   //AXI master interface - Connect to HyperRAM controller
	
   .m_axi_clk        (m_axi_clk),
   .m_axi_rstn       (m_axi_rstn),
	
   .m_axi_awid		   (m_axi_awid),
   .m_axi_awaddr     (m_axi_awaddr),     
   .m_axi_awlen      (m_axi_awlen),   
   .m_axi_awsize     (m_axi_awsize),
   .m_axi_awburst    (m_axi_awburst),  
   .m_axi_awlock     (m_axi_awlock),  
   .m_axi_awcache    (m_axi_awcache),
   .m_axi_awprot     (m_axi_awprot),
   .m_axi_awvalid    (m_axi_awvalid), 
   .m_axi_awready    (m_axi_awready),
   .m_axi_wdata      (m_axi_wdata),
   .m_axi_wstrb      (m_axi_wstrb),
   .m_axi_wlast      (m_axi_wlast),
   .m_axi_wvalid     (m_axi_wvalid),  
   .m_axi_wready     (m_axi_wready), 
   .m_axi_bresp      (m_axi_bresp), 
   .m_axi_bvalid     (m_axi_bvalid), 
   .m_axi_bready     (m_axi_bready),  
   .m_axi_arid		   (m_axi_arid),   
   .m_axi_araddr     (m_axi_araddr),  
   .m_axi_arlen      (m_axi_arlen),
   .m_axi_arsize     (m_axi_arsize),
   .m_axi_arburst    (m_axi_arburst),
   .m_axi_arlock     (m_axi_arlock),
   .m_axi_arcache    (m_axi_arcache),  
   .m_axi_arprot     (m_axi_arprot), 
   .m_axi_arvalid    (m_axi_arvalid), 
   .m_axi_arready    (m_axi_arready),   
   .m_axi_rdata      (m_axi_rdata),   
   .m_axi_rresp      (m_axi_rresp),   
   .m_axi_rlast      (m_axi_rlast),   
   .m_axi_rvalid     (m_axi_rvalid),    
   .m_axi_rready     (m_axi_rready)
);

endmodule
