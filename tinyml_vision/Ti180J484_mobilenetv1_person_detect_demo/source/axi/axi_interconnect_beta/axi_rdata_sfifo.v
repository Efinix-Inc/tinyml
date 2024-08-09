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

module axi_rdata_sfifo#(
    parameter				        W_WTH = 64, 
    parameter				        R_WTH = 32,
    parameter				        DEPTH = 3 
)
(

//Global Signals
input                           clk,
input                           rstn,
//Write Signals
input                           wen,
input           [W_WTH-1:0]     wdata,
input                           wlast,
output  wire                    full,
output  wire                    almost_full,
//Read Signals
input                           ren,
input           [7:0]           arlen,
input           [$clog2(W_WTH/8)-$clog2(R_WTH/8)-1:0]     
                                araddr_offset,
input                           saddr_init_flag,
output  wire    [R_WTH-1:0]     rdata,
output  wire                    rlast,
output  wire                    empty,
output  wire                    almost_empty
);
//Parameter Define

localparam RATIO        = (W_WTH > R_WTH) ? W_WTH/R_WTH : R_WTH/W_WTH;
localparam DATA_MEM_WTH = (W_WTH > R_WTH) ? W_WTH : R_WTH;
localparam STRB_MEM_WTH = (W_WTH > R_WTH) ? W_WTH/8 : R_WTH/8;
localparam RATIO_W = $clog2(RATIO);
localparam DEPTH_W = $clog2(DEPTH);

//Register Define
reg     [RATIO_W-1:0]           saddr;
reg     [DEPTH_W-1:0]           waddr;
reg     [DEPTH_W-1:0]           raddr;
reg     [DEPTH_W:0]             counter;
reg     [DATA_MEM_WTH-1:0]      mem_data_next;

reg     [DATA_MEM_WTH-1:0]      mem_data [DEPTH-1:0];
reg                             mem_last [DEPTH-1:0];

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
J3og1BH+EletKMLu0jLr/fyqNZauaURlKinFF/PQQhTwDx+UwxCmQkBUs9pumR4J
N7mAYabjOGGPbtYs6nNQ6nhR9aG/7A1jt8cim5u7UZEoCRQNN10ajATjaYLec55e
LE9JHyQDmClvoTlL8HvYefPRpa/rMmhIyH9qgU/K5hFXLpNru8j2fo+VV9HDIv/7
M8ftOv9PGY30UBKx1ablSEfdMywyYFJNpnfFm7Aqio5bDCGeJqWfYIH55D45Budt
2b73y1B4Zfr8jqbBUvMYlxlgnJ06TaCmQljJBkJNiA410bbCh167YOi8kimB7aHb
qUfI6TNGooIMyjpVq12kOw==
`pragma protect key_keyowner="Mentor Graphics Corporation"
`pragma protect key_keyname="MGC-VERIF-SIM-RSA-1"
`pragma protect key_method="rsa"
`pragma protect encoding=(enctype="base64", line_length=64, bytes=128)
`pragma protect key_block
HKeY0vKS6/i9Rl0TIQxe1LtuwijGqN+DEbxJxNxLNQNmfZeYIIOZCVpzt1UH/jDv
/fjoo9dCMpLgTiJcI7mSqAcHO4qzg49Bl06YMKrM3+Thed+olvNujQzg9xxwPLjC
ZaXuKLDGJpY1ekeVt0diTmzIcnXdogc4a3ChZoykE24=
`pragma protect data_method="aes256-cbc"
`pragma protect encoding=(enctype="base64", line_length=64, bytes=6288)
`pragma protect data_block
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
`pragma protect end_protected
endmodule
