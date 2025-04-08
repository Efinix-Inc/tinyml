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

module tinyml_top #(
   parameter AXI_DW                          = `TML_C0_AXI_DW, 
   parameter ADD_MODE                        = `TML_C0_ADD_MODE,
   parameter MIN_MAX_MODE                    = `TML_C0_MIN_MAX_MODE,
   parameter MUL_MODE                        = `TML_C0_MUL_MODE,
   parameter FC_MODE                         = `TML_C0_FC_MODE,
   parameter LR_MODE                         = `TML_C0_LR_MODE,
   parameter TINYML_CACHE                    = `TML_C0_TINYML_CACHE,
   parameter CACHE_DEPTH                     = `TML_C0_CACHE_DEPTH,
   //Convolution & Depthwise Convolution OP Parameter          
   parameter CONV_DEPTHW_MODE                = `TML_C0_CONV_DEPTHW_MODE,    
   parameter CONV_DEPTHW_LITE_PARALLEL       = `TML_C0_CONV_DEPTHW_LITE_PARALLEL,        
   parameter CONV_DEPTHW_LITE_AW             = `TML_C0_CONV_DEPTHW_LITE_AW,        
   parameter CONV_DEPTHW_STD_IN_PARALLEL     = `TML_C0_CONV_DEPTHW_STD_IN_PARALLEL,        
   parameter CONV_DEPTHW_STD_OUT_PARALLEL    = `TML_C0_CONV_DEPTHW_STD_OUT_PARALLEL,
   parameter CONV_DEPTHW_STD_OUT_CH_FIFO_A   = `TML_C0_CONV_DEPTHW_STD_OUT_CH_FIFO_A,
   parameter CONV_DEPTHW_STD_FILTER_FIFO_A   = `TML_C0_CONV_DEPTHW_STD_FILTER_FIFO_A,
   parameter CONV_DEPTHW_STD_CNT_DTH         = `TML_C0_CONV_DEPTHW_STD_CNT_DTH,
   //FC OP Parameter         
   parameter FC_MAX_IN_NODE                  = `TML_C0_FC_MAX_IN_NODE,  
   parameter FC_MAX_OUT_NODE                 = `TML_C0_FC_MAX_OUT_NODE,
   parameter ENABLED_ACCELERATOR_CHANNEL     = 4'b0001
  
) (
   input                            clk,
   input                            reset,
   //Command Interface
   input                            cmd_valid,
   input  [9:0]                     cmd_function_id,
   input  [31:0]                    cmd_inputs_0,
   input  [31:0]                    cmd_inputs_1,
   output                           cmd_ready,
   output                           cmd_int,
   //Response Interface
   output                           rsp_valid,
   output [31:0]                    rsp_outputs_0,
   input                            rsp_ready,
   //AXI Master Interface
   input                            m_axi_clk,
   input                            m_axi_rstn,
   output                           m_axi_awvalid,
   output [31:0]                    m_axi_awaddr,
   output [7:0]                     m_axi_awlen,
   output [2:0]                     m_axi_awsize,
   output [1:0]                     m_axi_awburst,
   output [2:0]                     m_axi_awprot,
   output [1:0]                     m_axi_awlock,
   output [3:0]                     m_axi_awcache,
   input                            m_axi_awready,
   output [AXI_DW-1:0]              m_axi_wdata,
   output [AXI_DW/8-1:0]            m_axi_wstrb,
   output                           m_axi_wlast,
   output                           m_axi_wvalid,
   input                            m_axi_wready,
   input  [1:0]                     m_axi_bresp,
   input                            m_axi_bvalid,
   output                           m_axi_bready,
   output                           m_axi_arvalid,
   output [31:0]                    m_axi_araddr,
   output [7:0]                     m_axi_arlen,
   output [2:0]                     m_axi_arsize,
   output [1:0]                     m_axi_arburst,
   output [2:0]                     m_axi_arprot,
   output [1:0]                     m_axi_arlock,
   output [3:0]                     m_axi_arcache,
   input                            m_axi_arready,
   input                            m_axi_rvalid,
   input  [AXI_DW-1:0]              m_axi_rdata,
   input                            m_axi_rlast,
   input  [1:0]                     m_axi_rresp,
   output                           m_axi_rready
);

//Function ID 10'b0x_xxxx_xxxx are reserved for tinyML accelerator
wire        tinyml_accel_cmd_valid;
wire        tinyml_accel_cmd_ready;
wire        tinyml_accel_rsp_valid;
wire [31:0] tinyml_accel_rsp_outputs_0;

assign tinyml_accel_cmd_valid = cmd_valid & (cmd_function_id[9] == 1'b0);

tinyml_accelerator #(
    .AXI_DW                         (AXI_DW), 
    .ADD_MODE                       (ADD_MODE),
    .MIN_MAX_MODE                   (MIN_MAX_MODE),
    .MUL_MODE                       (MUL_MODE),
    .FC_MODE                        (FC_MODE),
    .LR_MODE                        (LR_MODE),
    .TINYML_CACHE                   (TINYML_CACHE),
    .CACHE_DEPTH                    (CACHE_DEPTH),
    //Convolution & Depthwise Convolution OP Parameter          
    .CONV_DEPTHW_MODE               (CONV_DEPTHW_MODE),    
    .CONV_DEPTHW_LITE_PARALLEL      (CONV_DEPTHW_LITE_PARALLEL),        
    .CONV_DEPTHW_LITE_AW            (CONV_DEPTHW_LITE_AW),        
    .CONV_DEPTHW_STD_IN_PARALLEL    (CONV_DEPTHW_STD_IN_PARALLEL),        
    .CONV_DEPTHW_STD_OUT_PARALLEL   (CONV_DEPTHW_STD_OUT_PARALLEL),
    .CONV_DEPTHW_STD_OUT_CH_FIFO_A  (CONV_DEPTHW_STD_OUT_CH_FIFO_A),
    .CONV_DEPTHW_STD_FILTER_FIFO_A  (CONV_DEPTHW_STD_FILTER_FIFO_A),
    .CONV_DEPTHW_STD_CNT_DTH        (CONV_DEPTHW_STD_CNT_DTH),
    //FC OP Parameter         
    .FC_MAX_IN_NODE                 (FC_MAX_IN_NODE),  
    .FC_MAX_OUT_NODE                (FC_MAX_OUT_NODE),
    .ENABLED_ACCELERATOR_CHANNEL    (ENABLED_ACCELERATOR_CHANNEL)   

) u_tinyml_accelerator (
   .clk              (clk                       ),
   .rstn             (!reset                    ),
   .cmd_valid        (tinyml_accel_cmd_valid    ),
   .cmd_function_id  (cmd_function_id           ),
   .cmd_inputs_0     (cmd_inputs_0              ),
   .cmd_inputs_1     (cmd_inputs_1              ),
   .cmd_ready        (tinyml_accel_cmd_ready    ),
   .cmd_int          (cmd_int                   ), //Interrupt
   .rsp_valid        (tinyml_accel_rsp_valid    ),
   .rsp_outputs_0    (tinyml_accel_rsp_outputs_0),
   .rsp_ready        (rsp_ready                 ),
   .m_axi_clk        (m_axi_clk                 ),
   .m_axi_rstn       (m_axi_rstn                ),
   .m_axi_awvalid    (m_axi_awvalid             ),
   .m_axi_awaddr     (m_axi_awaddr              ),
   .m_axi_awlen      (m_axi_awlen               ),
   .m_axi_awsize     (m_axi_awsize              ),
   .m_axi_awburst    (m_axi_awburst             ),
   .m_axi_awprot     (m_axi_awprot              ),
   .m_axi_awlock     (m_axi_awlock              ),
   .m_axi_awcache    (m_axi_awcache             ),
   .m_axi_awready    (m_axi_awready             ),
   .m_axi_wdata      (m_axi_wdata               ),
   .m_axi_wstrb      (m_axi_wstrb               ),
   .m_axi_wlast      (m_axi_wlast               ),
   .m_axi_wvalid     (m_axi_wvalid              ),
   .m_axi_wready     (m_axi_wready              ),
   .m_axi_bresp      (m_axi_bresp               ),
   .m_axi_bvalid     (m_axi_bvalid              ),
   .m_axi_bready     (m_axi_bready              ),
   .m_axi_arvalid    (m_axi_arvalid             ),
   .m_axi_araddr     (m_axi_araddr              ),
   .m_axi_arlen      (m_axi_arlen               ),
   .m_axi_arsize     (m_axi_arsize              ),
   .m_axi_arburst    (m_axi_arburst             ),
   .m_axi_arprot     (m_axi_arprot              ),
   .m_axi_arlock     (m_axi_arlock              ),
   .m_axi_arcache    (m_axi_arcache             ),
   .m_axi_arready    (m_axi_arready             ),
   .m_axi_rvalid     (m_axi_rvalid              ),
   .m_axi_rdata      (m_axi_rdata               ),
   .m_axi_rlast      (m_axi_rlast               ),
   .m_axi_rresp      (m_axi_rresp               ),
   .m_axi_rready     (m_axi_rready              )

);

//Add user-defined custom instruction here.
//Function ID 10'b1x_xxxx_xxxx are available for use.
//assign user_custom_cmd_valid = cmd_valid & (cmd_function_id[9] == 1'b1);

//Output
assign cmd_ready     = tinyml_accel_cmd_ready;
//assign cmd_ready     = tinyml_accel_cmd_ready & user_custom_cmd_ready;
assign rsp_valid     = tinyml_accel_rsp_valid;
//assign rsp_valid     = tinyml_accel_rsp_valid | user_custom_rsp_valid;
assign rsp_outputs_0 = tinyml_accel_rsp_outputs_0;
//assign rsp_outputs_0 = (tinyml_accel_rsp_valid) ? tinyml_accel_rsp_outputs_0 : user_custom_rsp_outputs_0;

endmodule
