///////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2024 github-efx
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

 
`timescale 1ns / 1ns
 
module lb_to_axi#(
    parameter                       D_WTH = 128 
)
(
input                           clk,
input                           rstn,
//Slave Local Bus Interface
//--Slave Local Bus Write/Read Address 
input                           s_lb_arw,
input                           s_lb_avalid,
output  wire                    s_lb_aready,
input           [31:0]          s_lb_aaddr,
input           [7:0]           s_lb_alen,
//--Slave Local Bus Write Data 
input                           s_lb_wvalid,
output  wire                    s_lb_wready,
input           [D_WTH-1:0]     s_lb_wdata,
input           [D_WTH/8-1:0]   s_lb_wstrb,
input                           s_lb_wlast,
//--Slave Local Bus Read Data
output  wire                    s_lb_rvalid,
input                           s_lb_rready,
output  wire    [D_WTH-1:0]     s_lb_rdata,
output  wire                    s_lb_rlast,
//Master AXI4 Bus Interface
//--Master AXI4 Write
output  wire                    m_axi_awvalid,
input                           m_axi_awready,
output  wire    [31:0]          m_axi_awaddr,
output  wire    [7:0]           m_axi_awlen,
output  wire    [7:0]           m_axi_awid,
output  wire    [2:0]           m_axi_awsize,
output  wire    [1:0]           m_axi_awburst,
output  wire    [1:0]           m_axi_awlock,
output  wire    [3:0]           m_axi_awcache,
output  wire    [2:0]           m_axi_awprot,

output  wire                    m_axi_wvalid,
input                           m_axi_wready,
output  wire    [D_WTH-1:0]     m_axi_wdata,
output  wire    [D_WTH/8-1:0]   m_axi_wstrb,
output  wire                    m_axi_wlast,
input                           m_axi_bvalid,
output  wire                    m_axi_bready,
input           [1:0]           m_axi_bresp,
//--Master AXI4 Read
output  wire                    m_axi_arvalid,
input                           m_axi_arready,
output  wire    [31:0]          m_axi_araddr,
output  wire    [7:0]           m_axi_arlen,
output  wire    [7:0]           m_axi_arid,
output  wire    [2:0]           m_axi_arsize,
output  wire    [1:0]           m_axi_arburst,
output  wire    [1:0]           m_axi_arlock,
output  wire    [3:0]           m_axi_arcache,
output  wire    [2:0]           m_axi_arprot,
input                           m_axi_rvalid,
output  wire                    m_axi_rready,
input           [D_WTH-1:0]     m_axi_rdata,
input                           m_axi_rlast,
input           [1:0]           m_axi_rresp
);

//Parameter Define
 
//Register Define
 
//Wire Define
 
`pragma protect begin_protected
`pragma protect version=1
`pragma protect encrypt_agent="ipecrypt"
`pragma protect encrypt_agent_info="http://ipencrypter.com Version: 20.0.8"
`pragma protect author="author-a"
`pragma protect author_info="author-a-details"

`pragma protect key_keyowner="Efinix Inc."
`pragma protect key_keyname="EFX_K01"
`pragma protect key_method="rsa"
`pragma protect encoding=(enctype="base64", line_length=64, bytes=256)
`pragma protect key_block
kOL0PyTDFjWsyAKDmlC3VtUVfBlT0rKL/3G6AXvcIrG4kpKl9hUoo2RKj4Tayq9v
tIpoCold9Pr2rqYjbxbt914l9bQ11f1Uc9gFgjnGPoCaNtmLKReynTwG6icrQp03
buVezGKJSxt4/+dZK3LeGh5Vlq9iFNpJVlrUY+Q87QA3AE9BxoSFDklTkmq7x6IZ
tpw4l24yTDlOl3V+bC3Mdgdy/8gqaS1TPOREKM3PCBCAqIT2iJeq3UMUSzQxy0ut
VtBLeAK2npt5Td3HrAld3+NxYLhNUPbHApH3hwElrqSEKtEbZM975Nx6hboCZ5QY
YSGZ3bNhTNIfp4CTlpy90w==
`pragma protect key_keyowner="Mentor Graphics Corporation"
`pragma protect key_keyname="MGC-VERIF-SIM-RSA-1"
`pragma protect key_method="rsa"
`pragma protect encoding=(enctype="base64", line_length=64, bytes=128)
`pragma protect key_block
QsljCs/kKqPYPT4vSOwUfUuMk+yuDqoxhMaROpAjzSAcSN22r5fAv6ya1vJRfW0D
xp5Bm1dneNgXCrdEgTIrYV+R+bE0SwvmiKX4z5EElYkwtB6eLocY3NNqRC08Od4E
svZ1GJRvQJpwFO3gudmRfjfSzcjydbDwmVNCWPWg6pY=
`pragma protect data_method="aes256-cbc"
`pragma protect encoding=(enctype="base64", line_length=64, bytes=2144)
`pragma protect data_block
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
`pragma protect end_protected
endmodule
