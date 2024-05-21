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

`include "defines.v"
`timescale 1 ns / 1 ns
module tinyml_accelerator_beta#(
    parameter                       AXI_DW                          = `AXI_DW,
    parameter                       OP_CNT                          = 6,
    parameter                       ADD_MODE                        = `ADD_MODE,          //Only supported "STANDARD" / "LITE".
    parameter                       MIN_MAX_MODE                    = `MIN_MAX_MODE,      //Only supported "STANDARD" / "LITE".
    parameter                       MUL_MODE                        = `MUL_MODE,         //Only supported "STANDARD" / "LITE".
    parameter                       FC_MODE                         = `FC_MODE,           //Only supported "STANDARD" / "LITE".
    parameter                       LR_MODE                         = `LR_MODE,           //Only supported "STANDARD" / "LITE".    
    parameter                       TINYML_CACHE                    = `TINYML_CACHE,
    parameter                       CACHE_DEPTH                     = `CACHE_DEPTH,
    //Convolution & Depthwise Convolution OP Parameter          
    parameter                       CONV_DEPTHW_MODE                = `CONV_DEPTHW_MODE,    //Only supported "STANDARD" / "LITE".    
    parameter                       CONV_DEPTHW_LITE_PARALLEL       = `CONV_DEPTHW_LITE_PARALLEL,        
    parameter                       CONV_DEPTHW_LITE_AW             = `CONV_DEPTHW_LITE_AW,        
    parameter                       CONV_DEPTHW_STD_IN_PARALLEL     = `CONV_DEPTHW_STD_IN_PARALLEL,        
    parameter                       CONV_DEPTHW_STD_OUT_PARALLEL    = `CONV_DEPTHW_STD_OUT_PARALLEL,
    parameter                       CONV_DEPTHW_STD_OUT_CH_FIFO_A   = `CONV_DEPTHW_STD_OUT_CH_FIFO_A,
    parameter                       CONV_DEPTHW_STD_FILTER_FIFO_A   = `CONV_DEPTHW_STD_FILTER_FIFO_A,
    parameter                       CONV_DEPTHW_STD_CNT_DTH         = `CONV_DEPTHW_STD_CNT_DTH,
    //FC OP Parameter         
    parameter                       FC_MAX_IN_NODE                  = `FC_MAX_IN_NODE,  
    parameter                       FC_MAX_OUT_NODE                 = `FC_MAX_OUT_NODE      
)
(
//Globle Signals
input                           clk,
input                           rstn,
//Custom Instruction
//--Command Interface
input                           cmd_valid,
input           [9:0]           cmd_function_id,
input           [31:0]          cmd_inputs_0,
input           [31:0]          cmd_inputs_1,
output  wire                    cmd_ready,
output  wire                    cmd_int,
//--Response Interface
output  wire                    rsp_valid,
output  wire    [31:0]          rsp_outputs_0,
input                           rsp_ready,
//DMA Master AXI4 Bus Interface
input                           m_axi_clk,
input                           m_axi_rstn,
//DMA Master AXI4 Write Bus Interface
output  wire                    m_axi_awvalid,
output  wire    [31:0]          m_axi_awaddr,
output  wire    [7:0]           m_axi_awlen,
output  wire    [2:0]           m_axi_awsize,
output  wire    [1:0]           m_axi_awburst,
output  wire    [2:0]           m_axi_awprot,
output  wire    [1:0]           m_axi_awlock,
output  wire    [3:0]           m_axi_awcache,
input                           m_axi_awready,
output  wire    [AXI_DW-1:0]    m_axi_wdata,
output  wire    [AXI_DW/8-1:0]  m_axi_wstrb,
output  wire                    m_axi_wlast,
output  wire                    m_axi_wvalid,
input                           m_axi_wready,
input           [1:0]           m_axi_bresp,
input                           m_axi_bvalid,
output  wire                    m_axi_bready,
//DMA Master AXI4 Read Bus Interface
output  wire                    m_axi_arvalid,
output  wire    [31:0]          m_axi_araddr,
output  wire    [7:0]           m_axi_arlen,
output  wire    [2:0]           m_axi_arsize,
output  wire    [1:0]           m_axi_arburst,
output  wire    [2:0]           m_axi_arprot,
output  wire    [1:0]           m_axi_arlock,
output  wire    [3:0]           m_axi_arcache,
input                           m_axi_arready,
input                           m_axi_rvalid,
input           [AXI_DW-1:0]    m_axi_rdata,
input                           m_axi_rlast,
input           [1:0]           m_axi_rresp,
output  wire                    m_axi_rready
);

// Parameter Define
localparam AXI_SW = AXI_DW/8;

// Register Define

// Wire Define
//--AXI4 Bus
wire    [(OP_CNT+2)*1-1:0]      axi_awvalid;
wire    [(OP_CNT+2)*32-1:0]     axi_awaddr;
wire    [(OP_CNT+2)*8-1:0]      axi_awlen;
wire    [(OP_CNT+2)*3-1:0]      axi_awsize;
wire    [(OP_CNT+2)*2-1:0]      axi_awburst;
wire    [(OP_CNT+2)*3-1:0]      axi_awprot;
wire    [(OP_CNT+2)*2-1:0]      axi_awlock;
wire    [(OP_CNT+2)*4-1:0]      axi_awcache;
wire    [(OP_CNT+2)*1-1:0]      axi_awready;
wire    [(OP_CNT+2)*AXI_DW-1:0] axi_wdata;
wire    [(OP_CNT+2)*AXI_SW-1:0] axi_wstrb;
wire    [(OP_CNT+2)*1-1:0]      axi_wlast;
wire    [(OP_CNT+2)*1-1:0]      axi_wvalid;
wire    [(OP_CNT+2)*1-1:0]      axi_wready;
wire    [(OP_CNT+2)*2-1:0]      axi_bresp;
wire    [(OP_CNT+2)*1-1:0]      axi_bvalid;
wire    [(OP_CNT+2)*1-1:0]      axi_bready;
wire    [(OP_CNT+2)*1-1:0]      axi_arvalid;
wire    [(OP_CNT+2)*32-1:0]     axi_araddr;
wire    [(OP_CNT+2)*8-1:0]      axi_arlen;
wire    [(OP_CNT+2)*3-1:0]      axi_arsize;
wire    [(OP_CNT+2)*2-1:0]      axi_arburst;
wire    [(OP_CNT+2)*3-1:0]      axi_arprot;
wire    [(OP_CNT+2)*2-1:0]      axi_arlock;
wire    [(OP_CNT+2)*4-1:0]      axi_arcache;
wire    [(OP_CNT+2)*AXI_SW-1:0] axi_arstrb;
wire    [(OP_CNT+2)*1-1:0]      axi_arready;
wire    [(OP_CNT+2)*1-1:0]      axi_rvalid;
wire    [(OP_CNT+2)*AXI_DW-1:0] axi_rdata;
wire    [(OP_CNT+2)*1-1:0]      axi_rlast;
wire    [(OP_CNT+2)*2-1:0]      axi_rresp;
wire    [(OP_CNT+2)*1-1:0]      axi_rready;
//--DMA FIFO Signals
wire    [OP_CNT*1-1:0]          out_wren;
wire    [OP_CNT*AXI_DW-1:0]     out_wdata;
wire    [OP_CNT*1-1:0]          out_rden;
wire    [OP_CNT*AXI_DW-1:0]     out_rdata;
wire    [OP_CNT*1-1:0]          out_progfull;
//--custom instrction Signals
wire                            tinyml_conv_cmd_valid;     
wire                            tinyml_add_cmd_valid;     
wire                            tinyml_mul_cmd_valid;     
wire                            tinyml_max_cmd_valid;     
wire                            tinyml_fc_cmd_valid; 
wire                            tinyml_lr_cmd_valid;   
wire                            tinyml_cache_valid;    
wire    [(OP_CNT+2)*1-1:0]      tinyml_cmd_ready;
wire    [(OP_CNT+2)*1-1:0]      tinyml_cmd_int;
wire    [(OP_CNT+2)*1-1:0]      tinyml_rsp_valid;
wire    [(OP_CNT+2)*32-1:0]     tinyml_rsp_outputs_0;

reg                             user_pulse_0;
reg                             user_pulse_1;

wire                            cache_row_update_conv;

//--
wire    [OP_CNT-1:0]            op_en;

/*----------------------------------------------------------------------------------*\
                                 The main code
\*----------------------------------------------------------------------------------*/

/*----------------------- Cache Module ----------------------------*/
generate 
if(TINYML_CACHE == "DISABLE")
begin
    assign tinyml_cmd_ready    [7*1      +: 1*1 ] = 1'b1;
    assign tinyml_cmd_int      [7*1      +: 1*1 ] = 1'b0;
    assign tinyml_rsp_valid    [7*1      +: 1*1 ] = 1'b0;
    assign tinyml_rsp_outputs_0[7*32     +: 1*32] = 32'b0;
    
/*----------------------- Addr8 To Addrx Module ----------------------------*/
tinyml_common_s_axi4addr8_to_m_axi4addrx#(
    .AXI_DW                             (AXI_DW                             )
)
u_tinyml_common_s_axi4addr8_to_m_axi4addrx
(
//Slave AXI4 Bus Interface
    .s_axi_clk                          (clk                                ),
    .s_axi_rstn                         (rstn                               ),
//--Slave AXI4 Write
    .s_axi_awvalid                      (axi_awvalid[6*1      +: 1*1     ]  ),
    .s_axi_awaddr                       (axi_awaddr [6*32     +: 1*32    ]  ),
    .s_axi_awlen                        (axi_awlen  [6*8      +: 1*8     ]  ),
    .s_axi_awsize                       (axi_awsize [6*3      +: 1*3     ]  ),
    .s_axi_awburst                      (axi_awburst[6*2      +: 1*2     ]  ),
    .s_axi_awprot                       (axi_awprot [6*3      +: 1*3     ]  ),
    .s_axi_awlock                       (axi_awlock [6*2      +: 1*2     ]  ),
    .s_axi_awcache                      (axi_awcache[6*4      +: 1*4     ]  ),
    .s_axi_awready                      (axi_awready[6*1      +: 1*1     ]  ),
    .s_axi_wdata                        (axi_wdata  [6*AXI_DW +: 1*AXI_DW]  ),
    .s_axi_wstrb                        (axi_wstrb  [6*AXI_SW +: 1*AXI_SW]  ),
    .s_axi_wlast                        (axi_wlast  [6*1      +: 1*1     ]  ),
    .s_axi_wvalid                       (axi_wvalid [6*1      +: 1*1     ]  ),
    .s_axi_wready                       (axi_wready [6*1      +: 1*1     ]  ),
    .s_axi_bresp                        (axi_bresp  [6*2      +: 1*2     ]  ),
    .s_axi_bvalid                       (axi_bvalid [6*1      +: 1*1     ]  ),
    .s_axi_bready                       (axi_bready [6*1      +: 1*1     ]  ),
//--Slave AXI4 Read
    .s_axi_arvalid                      (axi_arvalid[6*1      +: 1*1     ]  ),
    .s_axi_araddr                       (axi_araddr [6*32     +: 1*32    ]  ),
    .s_axi_arlen                        (axi_arlen  [6*8      +: 1*8     ]  ),
    .s_axi_arsize                       (axi_arsize [6*3      +: 1*3     ]  ),
    .s_axi_arburst                      (axi_arburst[6*2      +: 1*2     ]  ),
    .s_axi_arprot                       (axi_arprot [6*3      +: 1*3     ]  ),
    .s_axi_arlock                       (axi_arlock [6*2      +: 1*2     ]  ),
    .s_axi_arcache                      (axi_arcache[6*4      +: 1*4     ]  ),
    .s_axi_arstrb                       (axi_arstrb [6*AXI_SW +: 1*AXI_SW]  ),
    .s_axi_arready                      (axi_arready[6*1      +: 1*1     ]  ),
    .s_axi_rvalid                       (axi_rvalid [6*1      +: 1*1     ]  ),
    .s_axi_rdata                        (axi_rdata  [6*AXI_DW +: 1*AXI_DW]  ),
    .s_axi_rlast                        (axi_rlast  [6*1      +: 1*1     ]  ),
    .s_axi_rresp                        (axi_rresp  [6*2      +: 1*2     ]  ),
    .s_axi_rready                       (axi_rready [6*1      +: 1*1     ]  ),
//Master AXI4 Bus Interface
    .m_axi_clk                          (m_axi_clk                          ),
    .m_axi_rstn                         (m_axi_rstn                         ),
//--Master AXI4 Write
    .m_axi_awvalid                      (m_axi_awvalid                      ),
    .m_axi_awaddr                       (m_axi_awaddr                       ),
    .m_axi_awlen                        (m_axi_awlen                        ),
    .m_axi_awsize                       (m_axi_awsize                       ),
    .m_axi_awburst                      (m_axi_awburst                      ),
    .m_axi_awprot                       (m_axi_awprot                       ),
    .m_axi_awlock                       (m_axi_awlock                       ),
    .m_axi_awcache                      (m_axi_awcache                      ),
    .m_axi_awready                      (m_axi_awready                      ),
    .m_axi_wdata                        (m_axi_wdata                        ),
    .m_axi_wstrb                        (m_axi_wstrb                        ),
    .m_axi_wlast                        (m_axi_wlast                        ),
    .m_axi_wvalid                       (m_axi_wvalid                       ),
    .m_axi_wready                       (m_axi_wready                       ),
    .m_axi_bresp                        (m_axi_bresp                        ),
    .m_axi_bvalid                       (m_axi_bvalid                       ),
    .m_axi_bready                       (m_axi_bready                       ),
//--Master AXI4 Read
    .m_axi_arvalid                      (m_axi_arvalid                      ),
    .m_axi_araddr                       (m_axi_araddr                       ),
    .m_axi_arlen                        (m_axi_arlen                        ),
    .m_axi_arsize                       (m_axi_arsize                       ),
    .m_axi_arburst                      (m_axi_arburst                      ),
    .m_axi_arprot                       (m_axi_arprot                       ),
    .m_axi_arlock                       (m_axi_arlock                       ),
    .m_axi_arcache                      (m_axi_arcache                      ),
    .m_axi_arready                      (m_axi_arready                      ),
    .m_axi_rvalid                       (m_axi_rvalid                       ),
    .m_axi_rdata                        (m_axi_rdata                        ),
    .m_axi_rlast                        (m_axi_rlast                        ),
    .m_axi_rresp                        (m_axi_rresp                        ),
    .m_axi_rready                       (m_axi_rready                       )
);

end

else begin : Cache

tinyml_cache#(
    .AXI_DW                             (AXI_DW                             ),
    .CACHE_AW                           ($clog2(CACHE_DEPTH)                )
)
u_tinyml_cache
(
//Globle Signals
    .clk                                (clk                                ),
    .rstn                               (rstn                               ),
//User Clock - User module - TinyML layer accelerator(s)
    .user_clk                           (clk                                ),
    .user_rstn                          (rstn                               ),
    .user_pulse_0                       (user_pulse_0                       ),
    .user_pulse_1                       (user_pulse_1                       ),
//Custom Instruction
//--Command Interface
    .cmd_valid                          (tinyml_cache_valid                 ),
    .cmd_function_id                    (cmd_function_id                    ),
    .cmd_inputs_0                       (cmd_inputs_0                       ),
    .cmd_inputs_1                       (cmd_inputs_1                       ),
    .cmd_ready                          (tinyml_cmd_ready[7*1      +: 1*1 ] ),
    .cmd_int                            (tinyml_cmd_int  [7*1      +: 1*1 ] ),
//--Response Interface
    .rsp_valid                          (tinyml_rsp_valid[7*1      +: 1*1 ] ),
    .rsp_outputs_0                      (tinyml_rsp_outputs_0[7*32 +: 1*32] ),
    .rsp_ready                          (rsp_ready                          ),
//AXI4 Bus Interface
    .axi_clk                            (m_axi_clk                          ),
    .axi_rstn                           (m_axi_rstn                         ),
//Slave AXI4 Bus Interface
    .s_axi_awvalid                      (axi_awvalid[7*1      +: 1*1     ]  ),
    .s_axi_awaddr                       (axi_awaddr [7*32     +: 1*32    ]  ),
    .s_axi_awlen                        (axi_awlen  [7*8      +: 1*8     ]  ),
    .s_axi_awsize                       (axi_awsize [7*3      +: 1*3     ]  ),
    .s_axi_awburst                      (axi_awburst[7*2      +: 1*2     ]  ),
    .s_axi_awprot                       (axi_awprot [7*3      +: 1*3     ]  ),
    .s_axi_awlock                       (axi_awlock [7*2      +: 1*2     ]  ),
    .s_axi_awcache                      (axi_awcache[7*4      +: 1*4     ]  ),
    .s_axi_awready                      (axi_awready[7*1      +: 1*1     ]  ),
    .s_axi_wdata                        (axi_wdata  [7*AXI_DW +: 1*AXI_DW]  ),
    .s_axi_wstrb                        (axi_wstrb  [7*AXI_SW +: 1*AXI_SW]  ),
    .s_axi_wlast                        (axi_wlast  [7*1      +: 1*1     ]  ),
    .s_axi_wvalid                       (axi_wvalid [7*1      +: 1*1     ]  ),
    .s_axi_wready                       (axi_wready [7*1      +: 1*1     ]  ),
    .s_axi_bresp                        (axi_bresp  [7*2      +: 1*2     ]  ),
    .s_axi_bvalid                       (axi_bvalid [7*1      +: 1*1     ]  ),
    .s_axi_bready                       (axi_bready [7*1      +: 1*1     ]  ),
    .s_axi_arvalid                      (axi_arvalid[7*1      +: 1*1     ]  ),
    .s_axi_araddr                       (axi_araddr [7*32     +: 1*32    ]  ),
    .s_axi_arlen                        (axi_arlen  [7*8      +: 1*8     ]  ),
    .s_axi_arsize                       (axi_arsize [7*3      +: 1*3     ]  ),
    .s_axi_arburst                      (axi_arburst[7*2      +: 1*2     ]  ),
    .s_axi_arprot                       (axi_arprot [7*3      +: 1*3     ]  ),
    .s_axi_arlock                       (axi_arlock [7*2      +: 1*2     ]  ),
    .s_axi_arcache                      (axi_arcache[7*4      +: 1*4     ]  ),
    .s_axi_arready                      (axi_arready[7*1      +: 1*1     ]  ),
    .s_axi_rvalid                       (axi_rvalid [7*1      +: 1*1     ]  ),
    .s_axi_rdata                        (axi_rdata  [7*AXI_DW +: 1*AXI_DW]  ),
    .s_axi_rlast                        (axi_rlast  [7*1      +: 1*1     ]  ),
    .s_axi_rresp                        (axi_rresp  [7*2      +: 1*2     ]  ),
    .s_axi_rready                       (axi_rready [7*1      +: 1*1     ]  ),
//Master AXI4 Bus Interface
    .m_axi_awvalid                      (m_axi_awvalid                      ),
    .m_axi_awaddr                       (m_axi_awaddr                       ),
    .m_axi_awlen                        (m_axi_awlen                        ),
    .m_axi_awsize                       (m_axi_awsize                       ),
    .m_axi_awburst                      (m_axi_awburst                      ),
    .m_axi_awprot                       (m_axi_awprot                       ),
    .m_axi_awlock                       (m_axi_awlock                       ),
    .m_axi_awcache                      (m_axi_awcache                      ),
    .m_axi_awready                      (m_axi_awready                      ),
    .m_axi_wdata                        (m_axi_wdata                        ),
    .m_axi_wstrb                        (m_axi_wstrb                        ),
    .m_axi_wlast                        (m_axi_wlast                        ),
    .m_axi_wvalid                       (m_axi_wvalid                       ),
    .m_axi_wready                       (m_axi_wready                       ),
    .m_axi_bresp                        (m_axi_bresp                        ),
    .m_axi_bvalid                       (m_axi_bvalid                       ),
    .m_axi_bready                       (m_axi_bready                       ),
    .m_axi_arvalid                      (m_axi_arvalid                      ),
    .m_axi_araddr                       (m_axi_araddr                       ),
    .m_axi_arlen                        (m_axi_arlen                        ),
    .m_axi_arsize                       (m_axi_arsize                       ),
    .m_axi_arburst                      (m_axi_arburst                      ),
    .m_axi_arprot                       (m_axi_arprot                       ),
    .m_axi_arlock                       (m_axi_arlock                       ),
    .m_axi_arcache                      (m_axi_arcache                      ),
    .m_axi_arready                      (m_axi_arready                      ),
    .m_axi_rvalid                       (m_axi_rvalid                       ),
    .m_axi_rdata                        (m_axi_rdata                        ),
    .m_axi_rlast                        (m_axi_rlast                        ),
    .m_axi_rresp                        (m_axi_rresp                        ),
    .m_axi_rready                       (m_axi_rready                       )
);

/*----------------------- Addr8 To Addrx Module ----------------------------*/
tinyml_common_s_axi4addr8_to_m_axi4addrx#(
    .AXI_DW                             (AXI_DW                             )
)
u_tinyml_common_s_axi4addr8_to_m_axi4addrx
(
//Slave AXI4 Bus Interface
    .s_axi_clk                          (clk                                ),
    .s_axi_rstn                         (rstn                               ),
//--Slave AXI4 Write
    .s_axi_awvalid                      (axi_awvalid[6*1      +: 1*1     ]  ),
    .s_axi_awaddr                       (axi_awaddr [6*32     +: 1*32    ]  ),
    .s_axi_awlen                        (axi_awlen  [6*8      +: 1*8     ]  ),
    .s_axi_awsize                       (axi_awsize [6*3      +: 1*3     ]  ),
    .s_axi_awburst                      (axi_awburst[6*2      +: 1*2     ]  ),
    .s_axi_awprot                       (axi_awprot [6*3      +: 1*3     ]  ),
    .s_axi_awlock                       (axi_awlock [6*2      +: 1*2     ]  ),
    .s_axi_awcache                      (axi_awcache[6*4      +: 1*4     ]  ),
    .s_axi_awready                      (axi_awready[6*1      +: 1*1     ]  ),
    .s_axi_wdata                        (axi_wdata  [6*AXI_DW +: 1*AXI_DW]  ),
    .s_axi_wstrb                        (axi_wstrb  [6*AXI_SW +: 1*AXI_SW]  ),
    .s_axi_wlast                        (axi_wlast  [6*1      +: 1*1     ]  ),
    .s_axi_wvalid                       (axi_wvalid [6*1      +: 1*1     ]  ),
    .s_axi_wready                       (axi_wready [6*1      +: 1*1     ]  ),
    .s_axi_bresp                        (axi_bresp  [6*2      +: 1*2     ]  ),
    .s_axi_bvalid                       (axi_bvalid [6*1      +: 1*1     ]  ),
    .s_axi_bready                       (axi_bready [6*1      +: 1*1     ]  ),
//--Slave AXI4 Read
    .s_axi_arvalid                      (axi_arvalid[6*1      +: 1*1     ]  ),
    .s_axi_araddr                       (axi_araddr [6*32     +: 1*32    ]  ),
    .s_axi_arlen                        (axi_arlen  [6*8      +: 1*8     ]  ),
    .s_axi_arsize                       (axi_arsize [6*3      +: 1*3     ]  ),
    .s_axi_arburst                      (axi_arburst[6*2      +: 1*2     ]  ),
    .s_axi_arprot                       (axi_arprot [6*3      +: 1*3     ]  ),
    .s_axi_arlock                       (axi_arlock [6*2      +: 1*2     ]  ),
    .s_axi_arcache                      (axi_arcache[6*4      +: 1*4     ]  ),
    .s_axi_arstrb                       (axi_arstrb [6*AXI_SW +: 1*AXI_SW]  ),
    .s_axi_arready                      (axi_arready[6*1      +: 1*1     ]  ),
    .s_axi_rvalid                       (axi_rvalid [6*1      +: 1*1     ]  ),
    .s_axi_rdata                        (axi_rdata  [6*AXI_DW +: 1*AXI_DW]  ),
    .s_axi_rlast                        (axi_rlast  [6*1      +: 1*1     ]  ),
    .s_axi_rresp                        (axi_rresp  [6*2      +: 1*2     ]  ),
    .s_axi_rready                       (axi_rready [6*1      +: 1*1     ]  ),
//Master AXI4 Bus Interface
    .m_axi_clk                          (m_axi_clk                          ),
    .m_axi_rstn                         (m_axi_rstn                         ),
//--Master AXI4 Write
    .m_axi_awvalid                      (axi_awvalid[7*1      +: 1*1     ]  ),
    .m_axi_awaddr                       (axi_awaddr [7*32     +: 1*32    ]  ),
    .m_axi_awlen                        (axi_awlen  [7*8      +: 1*8     ]  ),
    .m_axi_awsize                       (axi_awsize [7*3      +: 1*3     ]  ),
    .m_axi_awburst                      (axi_awburst[7*2      +: 1*2     ]  ),
    .m_axi_awprot                       (axi_awprot [7*3      +: 1*3     ]  ),
    .m_axi_awlock                       (axi_awlock [7*2      +: 1*2     ]  ),
    .m_axi_awcache                      (axi_awcache[7*4      +: 1*4     ]  ),
    .m_axi_awready                      (axi_awready[7*1      +: 1*1     ]  ),
    .m_axi_wdata                        (axi_wdata  [7*AXI_DW +: 1*AXI_DW]  ),
    .m_axi_wstrb                        (axi_wstrb  [7*AXI_SW +: 1*AXI_SW]  ),
    .m_axi_wlast                        (axi_wlast  [7*1      +: 1*1     ]  ),
    .m_axi_wvalid                       (axi_wvalid [7*1      +: 1*1     ]  ),
    .m_axi_wready                       (axi_wready [7*1      +: 1*1     ]  ),
    .m_axi_bresp                        (axi_bresp  [7*2      +: 1*2     ]  ),
    .m_axi_bvalid                       (axi_bvalid [7*1      +: 1*1     ]  ),
    .m_axi_bready                       (axi_bready [7*1      +: 1*1     ]  ),
//--Master AXI4 Read
    .m_axi_arvalid                      (axi_arvalid[7*1      +: 1*1     ]  ),
    .m_axi_araddr                       (axi_araddr [7*32     +: 1*32    ]  ),
    .m_axi_arlen                        (axi_arlen  [7*8      +: 1*8     ]  ),
    .m_axi_arsize                       (axi_arsize [7*3      +: 1*3     ]  ),
    .m_axi_arburst                      (axi_arburst[7*2      +: 1*2     ]  ),
    .m_axi_arprot                       (axi_arprot [7*3      +: 1*3     ]  ),
    .m_axi_arlock                       (axi_arlock [7*2      +: 1*2     ]  ),
    .m_axi_arcache                      (axi_arcache[7*4      +: 1*4     ]  ),
    .m_axi_arready                      (axi_arready[7*1      +: 1*1     ]  ),
    .m_axi_rvalid                       (axi_rvalid [7*1      +: 1*1     ]  ),
    .m_axi_rdata                        (axi_rdata  [7*AXI_DW +: 1*AXI_DW]  ),
    .m_axi_rlast                        (axi_rlast  [7*1      +: 1*1     ]  ),
    .m_axi_rresp                        (axi_rresp  [7*2      +: 1*2     ]  ),
    .m_axi_rready                       (axi_rready [7*1      +: 1*1     ]  )
);


end 

endgenerate

/*----------------------- DMA Interface Module ----------------------------*/
tinyml_common_dma_if#(
    .AXI_DW                             (AXI_DW                             ),
    .OP_CNT                             (OP_CNT                             )
)
u_tinyml_common_dma_if
(
//Globle Signals
    .clk                                (clk                                ),
    .rstn                               (rstn                               ),
    .op_en                              (op_en                              ),
//DMA Master AXI4 Bus Interface
//--DMA Master AXI4 Write Bus Interface
    .m_axi_awvalid                      (axi_awvalid[6*1      +: 1*1     ]  ),
    .m_axi_awaddr                       (axi_awaddr [6*32     +: 1*32    ]  ),
    .m_axi_awlen                        (axi_awlen  [6*8      +: 1*8     ]  ),
    .m_axi_awsize                       (axi_awsize [6*3      +: 1*3     ]  ),
    .m_axi_awburst                      (axi_awburst[6*2      +: 1*2     ]  ),
    .m_axi_awprot                       (axi_awprot [6*3      +: 1*3     ]  ),
    .m_axi_awlock                       (axi_awlock [6*2      +: 1*2     ]  ),
    .m_axi_awcache                      (axi_awcache[6*4      +: 1*4     ]  ),
    .m_axi_awready                      (axi_awready[6*1      +: 1*1     ]  ),
    .m_axi_wdata                        (axi_wdata  [6*AXI_DW +: 1*AXI_DW]  ),
    .m_axi_wstrb                        (axi_wstrb  [6*AXI_SW +: 1*AXI_SW]  ),
    .m_axi_wlast                        (axi_wlast  [6*1      +: 1*1     ]  ),
    .m_axi_wvalid                       (axi_wvalid [6*1      +: 1*1     ]  ),
    .m_axi_wready                       (axi_wready [6*1      +: 1*1     ]  ),
    .m_axi_bresp                        (axi_bresp  [6*2      +: 1*2     ]  ),
    .m_axi_bvalid                       (axi_bvalid [6*1      +: 1*1     ]  ),
    .m_axi_bready                       (axi_bready [6*1      +: 1*1     ]  ),
//--DMA Master AXI4 Read Bus Interface
    .m_axi_arvalid                      (axi_arvalid[6*1      +: 1*1     ]  ),
    .m_axi_araddr                       (axi_araddr [6*32     +: 1*32    ]  ),
    .m_axi_arlen                        (axi_arlen  [6*8      +: 1*8     ]  ),
    .m_axi_arsize                       (axi_arsize [6*3      +: 1*3     ]  ),
    .m_axi_arburst                      (axi_arburst[6*2      +: 1*2     ]  ),
    .m_axi_arprot                       (axi_arprot [6*3      +: 1*3     ]  ),
    .m_axi_arlock                       (axi_arlock [6*2      +: 1*2     ]  ),
    .m_axi_arcache                      (axi_arcache[6*4      +: 1*4     ]  ),
    .m_axi_arstrb                       (axi_arstrb [6*AXI_SW +: 1*AXI_SW]  ),
    .m_axi_arready                      (axi_arready[6*1      +: 1*1     ]  ),
    .m_axi_rvalid                       (axi_rvalid [6*1      +: 1*1     ]  ),
    .m_axi_rdata                        (axi_rdata  [6*AXI_DW +: 1*AXI_DW]  ),
    .m_axi_rlast                        (axi_rlast  [6*1      +: 1*1     ]  ),
    .m_axi_rresp                        (axi_rresp  [6*2      +: 1*2     ]  ),
    .m_axi_rready                       (axi_rready [6*1      +: 1*1     ]  ),
//DMA Slave AXI4 Bus Interface
//--DMA Slave AXI4 Write Bus Interface
    .s_axi_awvalid                      (axi_awvalid[0*1      +: OP_CNT*1     ]  ),
    .s_axi_awaddr                       (axi_awaddr [0*32     +: OP_CNT*32    ]  ),
    .s_axi_awlen                        (axi_awlen  [0*8      +: OP_CNT*8     ]  ),
    .s_axi_awsize                       (axi_awsize [0*3      +: OP_CNT*3     ]  ),
    .s_axi_awburst                      (axi_awburst[0*2      +: OP_CNT*2     ]  ),
    .s_axi_awprot                       (axi_awprot [0*3      +: OP_CNT*3     ]  ),
    .s_axi_awlock                       (axi_awlock [0*2      +: OP_CNT*2     ]  ),
    .s_axi_awcache                      (axi_awcache[0*4      +: OP_CNT*4     ]  ),
    .s_axi_awready                      (axi_awready[0*1      +: OP_CNT*1     ]  ),
    .s_axi_wdata                        (axi_wdata  [0*AXI_DW +: OP_CNT*AXI_DW]  ),
    .s_axi_wstrb                        (axi_wstrb  [0*AXI_SW +: OP_CNT*AXI_SW]  ),
    .s_axi_wlast                        (axi_wlast  [0*1      +: OP_CNT*1     ]  ),
    .s_axi_wvalid                       (axi_wvalid [0*1      +: OP_CNT*1     ]  ),
    .s_axi_wready                       (axi_wready [0*1      +: OP_CNT*1     ]  ),
    .s_axi_bresp                        (axi_bresp  [0*2      +: OP_CNT*2     ]  ),
    .s_axi_bvalid                       (axi_bvalid [0*1      +: OP_CNT*1     ]  ),
    .s_axi_bready                       (axi_bready [0*1      +: OP_CNT*1     ]  ),
//--DMA Slave AXI4 Read Bus Interface
    .s_axi_arvalid                      (axi_arvalid[0*1      +: OP_CNT*1     ]  ),
    .s_axi_araddr                       (axi_araddr [0*32     +: OP_CNT*32    ]  ),
    .s_axi_arlen                        (axi_arlen  [0*8      +: OP_CNT*8     ]  ),
    .s_axi_arsize                       (axi_arsize [0*3      +: OP_CNT*3     ]  ),
    .s_axi_arburst                      (axi_arburst[0*2      +: OP_CNT*2     ]  ),
    .s_axi_arprot                       (axi_arprot [0*3      +: OP_CNT*3     ]  ),
    .s_axi_arlock                       (axi_arlock [0*2      +: OP_CNT*2     ]  ),
    .s_axi_arcache                      (axi_arcache[0*4      +: OP_CNT*4     ]  ),
    .s_axi_arstrb                       (axi_arstrb [0*AXI_SW +: OP_CNT*AXI_SW]  ),
    .s_axi_arready                      (axi_arready[0*1      +: OP_CNT*1     ]  ),
    .s_axi_rvalid                       (axi_rvalid [0*1      +: OP_CNT*1     ]  ),
    .s_axi_rdata                        (axi_rdata  [0*AXI_DW +: OP_CNT*AXI_DW]  ),
    .s_axi_rlast                        (axi_rlast  [0*1      +: OP_CNT*1     ]  ),
    .s_axi_rresp                        (axi_rresp  [0*2      +: OP_CNT*2     ]  ),
    .s_axi_rready                       (axi_rready [0*1      +: OP_CNT*1     ]  ),
//DMA FIFO Signals
    .out_wren                           (out_wren    [0*1      +: OP_CNT*1     ] ),
    .out_wdata                          (out_wdata   [0*AXI_DW +: OP_CNT*AXI_DW] ),
    .out_rden                           (out_rden    [0*1      +: OP_CNT*1     ] ),
    .out_rdata                          (out_rdata   [0*AXI_DW +: OP_CNT*AXI_DW] ),
    .out_progfull                       (out_progfull[0*1      +: OP_CNT*1     ] )
);



/*----------------------- Convolution & Depthwise OP Region ----------------------------*/
assign tinyml_system_valid    = cmd_valid & (cmd_function_id[9:4] == 6'd0); //Assume conv  use function ID block 0
assign tinyml_conv_cmd_valid  = cmd_valid & (cmd_function_id[9:4] == 6'd1); //Assume conv  use function ID block 1
assign tinyml_add_cmd_valid   = cmd_valid & (cmd_function_id[9:4] == 6'd2); //Assume add   use function ID block 2
assign tinyml_mul_cmd_valid  = cmd_valid & (cmd_function_id[9:4] == 6'd3); //Assume mul  use function ID block 3
assign tinyml_max_cmd_valid   = cmd_valid & (cmd_function_id[9:4] == 6'd4); //Assume max   use function ID block 4
assign tinyml_fc_cmd_valid    = cmd_valid & (cmd_function_id[9:4] == 6'd5); //Assume fc    use function ID block 5
assign tinyml_cache_valid     = cmd_valid & (cmd_function_id[9:4] == 6'd6); //Assume cache use function ID block 6
assign tinyml_lr_cmd_valid     = cmd_valid & (cmd_function_id[9:4] == 6'd7); //Assume cache use function ID block 7

generate 
if(CONV_DEPTHW_MODE == "DISABLE")
begin
    assign op_en[0] = 1'b0;
    assign tinyml_cmd_ready    [0*1      +: 1*1 ] = 1'b1;
    assign tinyml_cmd_int      [0*1      +: 1*1 ] = 1'b0;
    assign tinyml_rsp_valid    [0*1      +: 1*1 ] = 1'b0;
    assign tinyml_rsp_outputs_0[0*32     +: 1*32] = 32'b0;
end

else begin : Convolution

tinyml_conv_depthw_op#(
    .MODULE_TYPE                        (CONV_DEPTHW_MODE),
    .MAC_BUF_CNT                        (CONV_DEPTHW_LITE_PARALLEL),
    .MAC_BUF_AW                         (CONV_DEPTHW_LITE_AW),
    .AXI_DW                             (AXI_DW),
    .INPUT_CNT                          (CONV_DEPTHW_STD_IN_PARALLEL),
    .OUTPUT_CNT                         (CONV_DEPTHW_STD_OUT_PARALLEL),
    .OUTPUT_CH_FIFO_A                   (CONV_DEPTHW_STD_OUT_CH_FIFO_A),
    .FILTER_FIFO_A                      (CONV_DEPTHW_STD_FILTER_FIFO_A),
    .CNT_DTH                            (CONV_DEPTHW_STD_CNT_DTH)
)
u_tinyml_conv_depthw_op
(
//Globle Signals
    .clk                                (clk                                ),
    .rstn                               (rstn                               ),
    .op_en                              (op_en[0]                           ),
//Custom Instruction
//--Command Interface
    .cmd_valid                          (tinyml_conv_cmd_valid              ),
    .cmd_function_id                    (cmd_function_id                    ),
    .cmd_inputs_0                       (cmd_inputs_0                       ),
    .cmd_inputs_1                       (cmd_inputs_1                       ),
    .cmd_ready                          (tinyml_cmd_ready[0*1      +: 1*1 ] ),
    .cmd_int                            (tinyml_cmd_int  [0*1      +: 1*1 ] ),
//--Response Interface
    .rsp_valid                          (tinyml_rsp_valid[0*1      +: 1*1 ] ),
    .rsp_outputs_0                      (tinyml_rsp_outputs_0[0*32 +: 1*32] ),
    .rsp_ready                          (rsp_ready                          ),
//DMA Master AXI4 Write Bus Interface
    .m_axi_awvalid                      (axi_awvalid[0*1      +: 1*1     ]  ),
    .m_axi_awaddr                       (axi_awaddr [0*32     +: 1*32    ]  ),
    .m_axi_awlen                        (axi_awlen  [0*8      +: 1*8     ]  ),
    .m_axi_awsize                       (axi_awsize [0*3      +: 1*3     ]  ),
    .m_axi_awburst                      (axi_awburst[0*2      +: 1*2     ]  ),
    .m_axi_awprot                       (axi_awprot [0*3      +: 1*3     ]  ),
    .m_axi_awlock                       (axi_awlock [0*2      +: 1*2     ]  ),
    .m_axi_awcache                      (axi_awcache[0*4      +: 1*4     ]  ),
    .m_axi_awready                      (axi_awready[0*1      +: 1*1     ]  ),
    .m_axi_wdata                        (axi_wdata  [0*AXI_DW +: 1*AXI_DW]  ),
    .m_axi_wstrb                        (axi_wstrb  [0*AXI_SW +: 1*AXI_SW]  ),
    .m_axi_wlast                        (axi_wlast  [0*1      +: 1*1     ]  ),
    .m_axi_wvalid                       (axi_wvalid [0*1      +: 1*1     ]  ),
    .m_axi_wready                       (axi_wready [0*1      +: 1*1     ]  ),
    .m_axi_bresp                        (axi_bresp  [0*2      +: 1*2     ]  ),
    .m_axi_bvalid                       (axi_bvalid [0*1      +: 1*1     ]  ),
    .m_axi_bready                       (axi_bready [0*1      +: 1*1     ]  ),
//DMA Master AXI4 Read Bus Interface
    .m_axi_arvalid                      (axi_arvalid[0*1      +: 1*1     ]  ),
    .m_axi_araddr                       (axi_araddr [0*32     +: 1*32    ]  ),
    .m_axi_arlen                        (axi_arlen  [0*8      +: 1*8     ]  ),
    .m_axi_arsize                       (axi_arsize [0*3      +: 1*3     ]  ),
    .m_axi_arburst                      (axi_arburst[0*2      +: 1*2     ]  ),
    .m_axi_arprot                       (axi_arprot [0*3      +: 1*3     ]  ),
    .m_axi_arlock                       (axi_arlock [0*2      +: 1*2     ]  ),
    .m_axi_arcache                      (axi_arcache[0*4      +: 1*4     ]  ),
    .m_axi_arstrb                       (axi_arstrb [0*AXI_SW +: 1*AXI_SW]  ),
    .m_axi_arready                      (axi_arready[0*1      +: 1*1     ]  ),
    .m_axi_rvalid                       (axi_rvalid [0*1      +: 1*1     ]  ),
    .m_axi_rdata                        (axi_rdata  [0*AXI_DW +: 1*AXI_DW]  ),
    .m_axi_rlast                        (axi_rlast  [0*1      +: 1*1     ]  ),
    .m_axi_rresp                        (axi_rresp  [0*2      +: 1*2     ]  ),
    .m_axi_rready                       (axi_rready [0*1      +: 1*1     ]  ),
//DMA FIFO Signals
    .out_wren                           (out_wren    [0*1      +: 1*1     ] ),
    .out_wdata                          (out_wdata   [0*AXI_DW +: 1*AXI_DW] ),
    .out_rden                           (out_rden    [0*1      +: 1*1     ] ),
    .out_rdata                          (out_rdata   [0*AXI_DW +: 1*AXI_DW] ),
    .out_progfull                       (out_progfull[0*1      +: 1*1     ] ),
//Cache Update
    .cache_row_update                   (cache_row_update_conv)
);

end 

endgenerate

/*----------------------- ADD OP Region ----------------------------*/
generate 

if(ADD_MODE == "DISABLE")
begin
    assign op_en[1] = 1'b0;
    assign tinyml_cmd_ready    [1*1      +: 1*1 ] = 1'b1;
    assign tinyml_cmd_int      [1*1      +: 1*1 ] = 1'b0;
    assign tinyml_rsp_valid    [1*1      +: 1*1 ] = 1'b0;
    assign tinyml_rsp_outputs_0[1*32     +: 1*32] = 32'b0;
end

else begin : ADD

tinyml_add_op#(
    .MODULE_TYPE                        (ADD_MODE                           ),
    .AXI_DW                             (AXI_DW                             )
)
u_tinyml_add_op
(
//Globle Signals
    .clk                                (clk                                ),
    .rstn                               (rstn                               ),
    .op_en                              (op_en[1]                           ),
//Custom Instruction
//--Command Interface
    .cmd_valid                          (tinyml_add_cmd_valid               ),
    .cmd_function_id                    (cmd_function_id                    ),
    .cmd_inputs_0                       (cmd_inputs_0                       ),
    .cmd_inputs_1                       (cmd_inputs_1                       ),
    .cmd_ready                          (tinyml_cmd_ready[1*1      +: 1*1 ] ),
    .cmd_int                            (tinyml_cmd_int  [1*1      +: 1*1 ] ),
//--Response Interface
    .rsp_valid                          (tinyml_rsp_valid[1*1      +: 1*1 ] ),
    .rsp_outputs_0                      (tinyml_rsp_outputs_0[1*32 +: 1*32] ),
    .rsp_ready                          (rsp_ready                          ),
//DMA Master AXI4 Write Bus Interface
    .m_axi_awvalid                      (axi_awvalid[1*1      +: 1*1     ]  ),
    .m_axi_awaddr                       (axi_awaddr [1*32     +: 1*32    ]  ),
    .m_axi_awlen                        (axi_awlen  [1*8      +: 1*8     ]  ),
    .m_axi_awsize                       (axi_awsize [1*3      +: 1*3     ]  ),
    .m_axi_awburst                      (axi_awburst[1*2      +: 1*2     ]  ),
    .m_axi_awprot                       (axi_awprot [1*3      +: 1*3     ]  ),
    .m_axi_awlock                       (axi_awlock [1*2      +: 1*2     ]  ),
    .m_axi_awcache                      (axi_awcache[1*4      +: 1*4     ]  ),
    .m_axi_awready                      (axi_awready[1*1      +: 1*1     ]  ),
    .m_axi_wdata                        (axi_wdata  [1*AXI_DW +: 1*AXI_DW]  ),
    .m_axi_wstrb                        (axi_wstrb  [1*AXI_SW +: 1*AXI_SW]  ),
    .m_axi_wlast                        (axi_wlast  [1*1      +: 1*1     ]  ),
    .m_axi_wvalid                       (axi_wvalid [1*1      +: 1*1     ]  ),
    .m_axi_wready                       (axi_wready [1*1      +: 1*1     ]  ),
    .m_axi_bresp                        (axi_bresp  [1*2      +: 1*2     ]  ),
    .m_axi_bvalid                       (axi_bvalid [1*1      +: 1*1     ]  ),
    .m_axi_bready                       (axi_bready [1*1      +: 1*1     ]  ),
//DMA Master AXI4 Read Bus Interface
    .m_axi_arvalid                      (axi_arvalid[1*1      +: 1*1     ]  ),
    .m_axi_araddr                       (axi_araddr [1*32     +: 1*32    ]  ),
    .m_axi_arlen                        (axi_arlen  [1*8      +: 1*8     ]  ),
    .m_axi_arsize                       (axi_arsize [1*3      +: 1*3     ]  ),
    .m_axi_arburst                      (axi_arburst[1*2      +: 1*2     ]  ),
    .m_axi_arprot                       (axi_arprot [1*3      +: 1*3     ]  ),
    .m_axi_arlock                       (axi_arlock [1*2      +: 1*2     ]  ),
    .m_axi_arcache                      (axi_arcache[1*4      +: 1*4     ]  ),
    .m_axi_arstrb                       (axi_arstrb [1*AXI_SW +: 1*AXI_SW]  ),
    .m_axi_arready                      (axi_arready[1*1      +: 1*1     ]  ),
    .m_axi_rvalid                       (axi_rvalid [1*1      +: 1*1     ]  ),
    .m_axi_rdata                        (axi_rdata  [1*AXI_DW +: 1*AXI_DW]  ),
    .m_axi_rlast                        (axi_rlast  [1*1      +: 1*1     ]  ),
    .m_axi_rresp                        (axi_rresp  [1*2      +: 1*2     ]  ),
    .m_axi_rready                       (axi_rready [1*1      +: 1*1     ]  ),
//DMA FIFO Signals
    .out_wren                           (out_wren    [1*1      +: 1*1     ] ),
    .out_wdata                          (out_wdata   [1*AXI_DW +: 1*AXI_DW] ),
    .out_rden                           (out_rden    [1*1      +: 1*1     ] ),
    .out_rdata                          (out_rdata   [1*AXI_DW +: 1*AXI_DW] ),
    .out_progfull                       (out_progfull[1*1      +: 1*1     ] )
);

end 

endgenerate


/*----------------------- mul OP Region ----------------------------*/

generate 

if(MUL_MODE == "DISABLE")
begin
    assign op_en[2] = 1'b0;
    assign tinyml_cmd_ready    [2*1      +: 1*1 ] = 1'b1;
    assign tinyml_cmd_int      [2*1      +: 1*1 ] = 1'b0;
    assign tinyml_rsp_valid    [2*1      +: 1*1 ] = 1'b0;
    assign tinyml_rsp_outputs_0[2*32     +: 1*32] = 32'b0;
end

else begin: MUL

tinyml_mul_op#(
    .MODULE_TYPE                        (MUL_MODE                          ),
    .AXI_DW                             (AXI_DW                             )
)
u_tinyml_mul_op
(
//Globle Signals
    .clk                                (clk                                ),
    .rstn                               (rstn                               ),
    .op_en                              (op_en[2]                           ),
//Custom Instruction
//--Command Interface
    .cmd_valid                          (tinyml_mul_cmd_valid              ),
    .cmd_function_id                    (cmd_function_id                    ),
    .cmd_inputs_0                       (cmd_inputs_0                       ),
    .cmd_inputs_1                       (cmd_inputs_1                       ),
    .cmd_ready                          (tinyml_cmd_ready[2*1      +: 1*1 ] ),
    .cmd_int                            (tinyml_cmd_int  [2*1      +: 1*1 ] ),
//--Response Interface
    .rsp_valid                          (tinyml_rsp_valid[2*1      +: 1*1 ] ),
    .rsp_outputs_0                      (tinyml_rsp_outputs_0[2*32 +: 1*32] ),
    .rsp_ready                          (rsp_ready                          ),
//DMA Master AXI4 Write Bus Interface
    .m_axi_awvalid                      (axi_awvalid[2*1      +: 1*1     ]  ),
    .m_axi_awaddr                       (axi_awaddr [2*32     +: 1*32    ]  ),
    .m_axi_awlen                        (axi_awlen  [2*8      +: 1*8     ]  ),
    .m_axi_awsize                       (axi_awsize [2*3      +: 1*3     ]  ),
    .m_axi_awburst                      (axi_awburst[2*2      +: 1*2     ]  ),
    .m_axi_awprot                       (axi_awprot [2*3      +: 1*3     ]  ),
    .m_axi_awlock                       (axi_awlock [2*2      +: 1*2     ]  ),
    .m_axi_awcache                      (axi_awcache[2*4      +: 1*4     ]  ),
    .m_axi_awready                      (axi_awready[2*1      +: 1*1     ]  ),
    .m_axi_wdata                        (axi_wdata  [2*AXI_DW +: 1*AXI_DW]  ),
    .m_axi_wstrb                        (axi_wstrb  [2*AXI_SW +: 1*AXI_SW]  ),
    .m_axi_wlast                        (axi_wlast  [2*1      +: 1*1     ]  ),
    .m_axi_wvalid                       (axi_wvalid [2*1      +: 1*1     ]  ),
    .m_axi_wready                       (axi_wready [2*1      +: 1*1     ]  ),
    .m_axi_bresp                        (axi_bresp  [2*2      +: 1*2     ]  ),
    .m_axi_bvalid                       (axi_bvalid [2*1      +: 1*1     ]  ),
    .m_axi_bready                       (axi_bready [2*1      +: 1*1     ]  ),
//DMA Master AXI4 Read Bus Interface
    .m_axi_arvalid                      (axi_arvalid[2*1      +: 1*1     ]  ),
    .m_axi_araddr                       (axi_araddr [2*32     +: 1*32    ]  ),
    .m_axi_arlen                        (axi_arlen  [2*8      +: 1*8     ]  ),
    .m_axi_arsize                       (axi_arsize [2*3      +: 1*3     ]  ),
    .m_axi_arburst                      (axi_arburst[2*2      +: 1*2     ]  ),
    .m_axi_arprot                       (axi_arprot [2*3      +: 1*3     ]  ),
    .m_axi_arlock                       (axi_arlock [2*2      +: 1*2     ]  ),
    .m_axi_arcache                      (axi_arcache[2*4      +: 1*4     ]  ),
    .m_axi_arstrb                       (axi_arstrb [2*AXI_SW +: 1*AXI_SW]  ),
    .m_axi_arready                      (axi_arready[2*1      +: 1*1     ]  ),
    .m_axi_rvalid                       (axi_rvalid [2*1      +: 1*1     ]  ),
    .m_axi_rdata                        (axi_rdata  [2*AXI_DW +: 1*AXI_DW]  ),
    .m_axi_rlast                        (axi_rlast  [2*1      +: 1*1     ]  ),
    .m_axi_rresp                        (axi_rresp  [2*2      +: 1*2     ]  ),
    .m_axi_rready                       (axi_rready [2*1      +: 1*1     ]  ),
//DMA FIFO Signals
    .out_wren                           (out_wren    [2*1      +: 1*1     ] ),
    .out_wdata                          (out_wdata   [2*AXI_DW +: 1*AXI_DW] ),
    .out_rden                           (out_rden    [2*1      +: 1*1     ] ),
    .out_rdata                          (out_rdata   [2*AXI_DW +: 1*AXI_DW] ),
    .out_progfull                       (out_progfull[2*1      +: 1*1     ] )
);

end 

endgenerate

/*----------------------- MIN_MAX OP Region ----------------------------*/

generate 

if(MIN_MAX_MODE == "DISABLE")
begin
    assign op_en[3] = 1'b0;
    assign tinyml_cmd_ready    [3*1      +: 1*1 ] = 1'b1;
    assign tinyml_cmd_int      [3*1      +: 1*1 ] = 1'b0;
    assign tinyml_rsp_valid    [3*1      +: 1*1 ] = 1'b0;
    assign tinyml_rsp_outputs_0[3*32     +: 1*32] = 32'b0;
end

else begin : MIN_MAX

tinyml_min_max_op#(
    .MODULE_TYPE                        (MIN_MAX_MODE                       ),
    .AXI_DW                             (AXI_DW                             )
)
u_tinyml_min_max_op
(
//Globle Signals
    .clk                                (clk                                ),
    .rstn                               (rstn                               ),
    .op_en                              (op_en[3]                           ),
//Custom Instruction
//--Command Interface
    .cmd_valid                          (tinyml_max_cmd_valid               ),
    .cmd_function_id                    (cmd_function_id                    ),
    .cmd_inputs_0                       (cmd_inputs_0                       ),
    .cmd_inputs_1                       (cmd_inputs_1                       ),
    .cmd_ready                          (tinyml_cmd_ready[3*1      +: 1*1 ] ),
    .cmd_int                            (tinyml_cmd_int  [3*1      +: 1*1 ] ),
//--Response Interface
    .rsp_valid                          (tinyml_rsp_valid[3*1      +: 1*1 ] ),
    .rsp_outputs_0                      (tinyml_rsp_outputs_0[3*32 +: 1*32] ),
    .rsp_ready                          (rsp_ready                          ),
//DMA Master AXI4 Write Bus Interface
    .m_axi_awvalid                      (axi_awvalid[3*1      +: 1*1     ]  ),
    .m_axi_awaddr                       (axi_awaddr [3*32     +: 1*32    ]  ),
    .m_axi_awlen                        (axi_awlen  [3*8      +: 1*8     ]  ),
    .m_axi_awsize                       (axi_awsize [3*3      +: 1*3     ]  ),
    .m_axi_awburst                      (axi_awburst[3*2      +: 1*2     ]  ),
    .m_axi_awprot                       (axi_awprot [3*3      +: 1*3     ]  ),
    .m_axi_awlock                       (axi_awlock [3*2      +: 1*2     ]  ),
    .m_axi_awcache                      (axi_awcache[3*4      +: 1*4     ]  ),
    .m_axi_awready                      (axi_awready[3*1      +: 1*1     ]  ),
    .m_axi_wdata                        (axi_wdata  [3*AXI_DW +: 1*AXI_DW]  ),
    .m_axi_wstrb                        (axi_wstrb  [3*AXI_SW +: 1*AXI_SW]  ),
    .m_axi_wlast                        (axi_wlast  [3*1      +: 1*1     ]  ),
    .m_axi_wvalid                       (axi_wvalid [3*1      +: 1*1     ]  ),
    .m_axi_wready                       (axi_wready [3*1      +: 1*1     ]  ),
    .m_axi_bresp                        (axi_bresp  [3*2      +: 1*2     ]  ),
    .m_axi_bvalid                       (axi_bvalid [3*1      +: 1*1     ]  ),
    .m_axi_bready                       (axi_bready [3*1      +: 1*1     ]  ),
//DMA Master AXI4 Read Bus Interface
    .m_axi_arvalid                      (axi_arvalid[3*1      +: 1*1     ]  ),
    .m_axi_araddr                       (axi_araddr [3*32     +: 1*32    ]  ),
    .m_axi_arlen                        (axi_arlen  [3*8      +: 1*8     ]  ),
    .m_axi_arsize                       (axi_arsize [3*3      +: 1*3     ]  ),
    .m_axi_arburst                      (axi_arburst[3*2      +: 1*2     ]  ),
    .m_axi_arprot                       (axi_arprot [3*3      +: 1*3     ]  ),
    .m_axi_arlock                       (axi_arlock [3*2      +: 1*2     ]  ),
    .m_axi_arcache                      (axi_arcache[3*4      +: 1*4     ]  ),
    .m_axi_arstrb                       (axi_arstrb [3*AXI_SW +: 1*AXI_SW]  ),
    .m_axi_arready                      (axi_arready[3*1      +: 1*1     ]  ),
    .m_axi_rvalid                       (axi_rvalid [3*1      +: 1*1     ]  ),
    .m_axi_rdata                        (axi_rdata  [3*AXI_DW +: 1*AXI_DW]  ),
    .m_axi_rlast                        (axi_rlast  [3*1      +: 1*1     ]  ),
    .m_axi_rresp                        (axi_rresp  [3*2      +: 1*2     ]  ),
    .m_axi_rready                       (axi_rready [3*1      +: 1*1     ]  ),
//DMA FIFO Signals
    .out_wren                           (out_wren    [3*1      +: 1*1     ] ),
    .out_wdata                          (out_wdata   [3*AXI_DW +: 1*AXI_DW] ),
    .out_rden                           (out_rden    [3*1      +: 1*1     ] ),
    .out_rdata                          (out_rdata   [3*AXI_DW +: 1*AXI_DW] ),
    .out_progfull                       (out_progfull[3*1      +: 1*1     ] )
);

end 

endgenerate

/*----------------------- Fully Connect OP Region ----------------------------*/

generate

if(FC_MODE == "DISABLE")
begin
    assign op_en[4] = 1'b0;
    assign tinyml_cmd_ready    [4*1      +: 1*1 ] = 1'b1;
    assign tinyml_cmd_int      [4*1      +: 1*1 ] = 1'b0;
    assign tinyml_rsp_valid    [4*1      +: 1*1 ] = 1'b0;
    assign tinyml_rsp_outputs_0[4*32     +: 1*32] = 32'b0;
end

else begin : FC

tinyml_fc_op#(
    .MODULE_TYPE                        (FC_MODE                            ),
    .AXI_DW                             (AXI_DW                             ),
    .FC_MAX_IN_NODE                     (FC_MAX_IN_NODE                     ),
    .FC_MAX_OUT_NODE                    (FC_MAX_OUT_NODE                    )
) 
u_tinyml_fc_op
(
//Globle Signals
    .clk                                (clk                                ),
    .rstn                               (rstn                               ),
    .op_en                              (op_en[4]                           ),
//Custom Instruction
//--Command Interface
    .cmd_valid                          (tinyml_fc_cmd_valid                ),
    .cmd_function_id                    (cmd_function_id                    ),
    .cmd_inputs_0                       (cmd_inputs_0                       ),
    .cmd_inputs_1                       (cmd_inputs_1                       ),
    .cmd_ready                          (tinyml_cmd_ready[4*1      +: 1*1 ] ),
    .cmd_int                            (tinyml_cmd_int  [4*1      +: 1*1 ] ),
//--Response Interface
    .rsp_valid                          (tinyml_rsp_valid[4*1      +: 1*1 ] ),
    .rsp_outputs_0                      (tinyml_rsp_outputs_0[4*32 +: 1*32] ),
    .rsp_ready                          (rsp_ready                          ),
//DMA Master AXI4 Write Bus Interface
    .m_axi_awvalid                      (axi_awvalid[4*1      +: 1*1     ]  ),
    .m_axi_awaddr                       (axi_awaddr [4*32     +: 1*32    ]  ),
    .m_axi_awlen                        (axi_awlen  [4*8      +: 1*8     ]  ),
    .m_axi_awsize                       (axi_awsize [4*3      +: 1*3     ]  ),
    .m_axi_awburst                      (axi_awburst[4*2      +: 1*2     ]  ),
    .m_axi_awprot                       (axi_awprot [4*3      +: 1*3     ]  ),
    .m_axi_awlock                       (axi_awlock [4*2      +: 1*2     ]  ),
    .m_axi_awcache                      (axi_awcache[4*4      +: 1*4     ]  ),
    .m_axi_awready                      (axi_awready[4*1      +: 1*1     ]  ),
    .m_axi_wdata                        (axi_wdata  [4*AXI_DW +: 1*AXI_DW]  ),
    .m_axi_wstrb                        (axi_wstrb  [4*AXI_SW +: 1*AXI_SW]  ),
    .m_axi_wlast                        (axi_wlast  [4*1      +: 1*1     ]  ),
    .m_axi_wvalid                       (axi_wvalid [4*1      +: 1*1     ]  ),
    .m_axi_wready                       (axi_wready [4*1      +: 1*1     ]  ),
    .m_axi_bresp                        (axi_bresp  [4*2      +: 1*2     ]  ),
    .m_axi_bvalid                       (axi_bvalid [4*1      +: 1*1     ]  ),
    .m_axi_bready                       (axi_bready [4*1      +: 1*1     ]  ),
//DMA Master AXI4 Read Bus Interface
    .m_axi_arvalid                      (axi_arvalid[4*1      +: 1*1     ]  ),
    .m_axi_araddr                       (axi_araddr [4*32     +: 1*32    ]  ),
    .m_axi_arlen                        (axi_arlen  [4*8      +: 1*8     ]  ),
    .m_axi_arsize                       (axi_arsize [4*3      +: 1*3     ]  ),
    .m_axi_arburst                      (axi_arburst[4*2      +: 1*2     ]  ),
    .m_axi_arprot                       (axi_arprot [4*3      +: 1*3     ]  ),
    .m_axi_arlock                       (axi_arlock [4*2      +: 1*2     ]  ),
    .m_axi_arcache                      (axi_arcache[4*4      +: 1*4     ]  ),
    .m_axi_arstrb                       (axi_arstrb [4*AXI_SW +: 1*AXI_SW]  ),
    .m_axi_arready                      (axi_arready[4*1      +: 1*1     ]  ),
    .m_axi_rvalid                       (axi_rvalid [4*1      +: 1*1     ]  ),
    .m_axi_rdata                        (axi_rdata  [4*AXI_DW +: 1*AXI_DW]  ),
    .m_axi_rlast                        (axi_rlast  [4*1      +: 1*1     ]  ),
    .m_axi_rresp                        (axi_rresp  [4*2      +: 1*2     ]  ),
    .m_axi_rready                       (axi_rready [4*1      +: 1*1     ]  ),
//DMA FIFO Signals
    .out_wren                           (out_wren    [4*1      +: 1*1     ] ),
    .out_wdata                          (out_wdata   [4*AXI_DW +: 1*AXI_DW] ),
    .out_rden                           (out_rden    [4*1      +: 1*1     ] ),
    .out_rdata                          (out_rdata   [4*AXI_DW +: 1*AXI_DW] ),
    .out_progfull                       (out_progfull[4*1      +: 1*1     ] )
);

end 

endgenerate

/*----------------------- LR OP Region ----------------------------*/

generate 

if(LR_MODE == "DISABLE")
begin
    assign op_en[5] = 1'b0;
    assign tinyml_cmd_ready    [5*1      +: 1*1 ] = 1'b1;
    assign tinyml_cmd_int      [5*1      +: 1*1 ] = 1'b0;
    assign tinyml_rsp_valid    [5*1      +: 1*1 ] = 1'b0;
    assign tinyml_rsp_outputs_0[5*32     +: 1*32] = 32'b0;
end

else begin: LR

tinyml_lr_op#(
    .MODULE_TYPE                        (LR_MODE                          ),
    .AXI_DW                             (AXI_DW                             )
)
u_tinyml_lr_op
(
//Globle Signals
    .clk                                (clk                                ),
    .rstn                               (rstn                               ),
    .op_en                              (op_en[5]                           ),
//Custom Instruction
//--Command Interface
    .cmd_valid                          (tinyml_lr_cmd_valid              ),
    .cmd_function_id                    (cmd_function_id                    ),
    .cmd_inputs_0                       (cmd_inputs_0                       ),
    .cmd_inputs_1                       (cmd_inputs_1                       ),
    .cmd_ready                          (tinyml_cmd_ready[5*1      +: 1*1 ] ),
    .cmd_int                            (tinyml_cmd_int  [5*1      +: 1*1 ] ),
//--Response Interface
    .rsp_valid                          (tinyml_rsp_valid[5*1      +: 1*1 ] ),
    .rsp_outputs_0                      (tinyml_rsp_outputs_0[5*32 +: 1*32] ),
    .rsp_ready                          (rsp_ready                          ),
//DMA Master AXI4 Write Bus Interface
    .m_axi_awvalid                      (axi_awvalid[5*1      +: 1*1     ]  ),
    .m_axi_awaddr                       (axi_awaddr [5*32     +: 1*32    ]  ),
    .m_axi_awlen                        (axi_awlen  [5*8      +: 1*8     ]  ),
    .m_axi_awsize                       (axi_awsize [5*3      +: 1*3     ]  ),
    .m_axi_awburst                      (axi_awburst[5*2      +: 1*2     ]  ),
    .m_axi_awprot                       (axi_awprot [5*3      +: 1*3     ]  ),
    .m_axi_awlock                       (axi_awlock [5*2      +: 1*2     ]  ),
    .m_axi_awcache                      (axi_awcache[5*4      +: 1*4     ]  ),
    .m_axi_awready                      (axi_awready[5*1      +: 1*1     ]  ),
    .m_axi_wdata                        (axi_wdata  [5*AXI_DW +: 1*AXI_DW]  ),
    .m_axi_wstrb                        (axi_wstrb  [5*AXI_SW +: 1*AXI_SW]  ),
    .m_axi_wlast                        (axi_wlast  [5*1      +: 1*1     ]  ),
    .m_axi_wvalid                       (axi_wvalid [5*1      +: 1*1     ]  ),
    .m_axi_wready                       (axi_wready [5*1      +: 1*1     ]  ),
    .m_axi_bresp                        (axi_bresp  [5*2      +: 1*2     ]  ),
    .m_axi_bvalid                       (axi_bvalid [5*1      +: 1*1     ]  ),
    .m_axi_bready                       (axi_bready [5*1      +: 1*1     ]  ),
//DMA Master AXI4 Read Bus Interface
    .m_axi_arvalid                      (axi_arvalid[5*1      +: 1*1     ]  ),
    .m_axi_araddr                       (axi_araddr [5*32     +: 1*32    ]  ),
    .m_axi_arlen                        (axi_arlen  [5*8      +: 1*8     ]  ),
    .m_axi_arsize                       (axi_arsize [5*3      +: 1*3     ]  ),
    .m_axi_arburst                      (axi_arburst[5*2      +: 1*2     ]  ),
    .m_axi_arprot                       (axi_arprot [5*3      +: 1*3     ]  ),
    .m_axi_arlock                       (axi_arlock [5*2      +: 1*2     ]  ),
    .m_axi_arcache                      (axi_arcache[5*4      +: 1*4     ]  ),
    .m_axi_arstrb                       (axi_arstrb [5*AXI_SW +: 1*AXI_SW]  ),
    .m_axi_arready                      (axi_arready[5*1      +: 1*1     ]  ),
    .m_axi_rvalid                       (axi_rvalid [5*1      +: 1*1     ]  ),
    .m_axi_rdata                        (axi_rdata  [5*AXI_DW +: 1*AXI_DW]  ),
    .m_axi_rlast                        (axi_rlast  [5*1      +: 1*1     ]  ),
    .m_axi_rresp                        (axi_rresp  [5*2      +: 1*2     ]  ),
    .m_axi_rready                       (axi_rready [5*1      +: 1*1     ]  ),
//DMA FIFO Signals
    .out_wren                           (out_wren    [5*1      +: 1*1     ] ),
    .out_wdata                          (out_wdata   [5*AXI_DW +: 1*AXI_DW] ),
    .out_rden                           (out_rden    [5*1      +: 1*1     ] ),
    .out_rdata                          (out_rdata   [5*AXI_DW +: 1*AXI_DW] ),
    .out_progfull                       (out_progfull[5*1      +: 1*1     ] )
);

end 

endgenerate


/*----------------------- TinyML System Custom Instruction Region ----------------------------*/
`ifndef SIM_MODE
// Tiny ML System
tinyml_system_op u_tinyml_system_op (
//Globle Signals
    .clk                                (clk                                ),
    .rstn                               (rstn                               ),
//Custom Instruction
//--Command Interface
    .cmd_valid                          (tinyml_system_valid                ),
    .cmd_function_id                    (cmd_function_id                    ),
    .cmd_inputs_0                       (cmd_inputs_0                       ),
    .cmd_inputs_1                       (cmd_inputs_1                       ),
    .cmd_ready                          (tinyml_cmd_ready[6*1      +: 1*1 ] ),
    .cmd_int                            (tinyml_cmd_int  [6*1      +: 1*1 ] ),
//--Response Interface
    .rsp_valid                          (tinyml_rsp_valid[6*1      +: 1*1 ] ),
    .rsp_outputs_0                      (tinyml_rsp_outputs_0[6*32 +: 1*32] ),
    .rsp_ready                          (rsp_ready                          )
);
`else
    assign tinyml_cmd_ready    [6*1      +: 1*1 ] = 1'b1;
    assign tinyml_cmd_int      [6*1      +: 1*1 ] = 1'b0;
    assign tinyml_rsp_valid    [6*1      +: 1*1 ] = 1'b0;
    assign tinyml_rsp_outputs_0[6*32     +: 1*32] = 32'b0;
`endif

assign cmd_ready        = &tinyml_cmd_ready;
assign cmd_int          = |tinyml_cmd_int; //Interrupt
assign rsp_valid        = |tinyml_rsp_valid;
assign rsp_outputs_0    =  tinyml_rsp_valid[0] ? tinyml_rsp_outputs_0[0*32+: 1*32] :
                          (tinyml_rsp_valid[1] ? tinyml_rsp_outputs_0[1*32+: 1*32] :
                          (tinyml_rsp_valid[2] ? tinyml_rsp_outputs_0[2*32+: 1*32] :
                          (tinyml_rsp_valid[3] ? tinyml_rsp_outputs_0[3*32+: 1*32] :
                          (tinyml_rsp_valid[4] ? tinyml_rsp_outputs_0[4*32+: 1*32] :
                          (tinyml_rsp_valid[5] ? tinyml_rsp_outputs_0[5*32+: 1*32] :
                          (tinyml_rsp_valid[6] ? tinyml_rsp_outputs_0[6*32+: 1*32] :
                                                 tinyml_rsp_outputs_0[7*32+: 1*32] ))))));

/*----------------------- Select User Pulse Source ----------------------------*/
always @ (*) begin 
   case (op_en)
      6'b00_0001:
         begin : conv
            user_pulse_0 = cache_row_update_conv;
            user_pulse_1 = 1'b0;
         end
      default :
         begin
            user_pulse_0 = 1'b0;
            user_pulse_1 = 1'b0;
         end
   endcase
end

//assign rsp_outputs_0    =  tinyml_rsp_valid[0] ? tinyml_rsp_outputs_0[0*32+: 1*32] :tinyml_rsp_outputs_0[1*32+: 1*32];
endmodule

