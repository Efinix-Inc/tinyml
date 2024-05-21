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
 
module crossbar#(
    parameter                       CB_DW                   = 64, 
    parameter                       S_COUNT                 = 3, 
    parameter                       ARB_MODE                = 0,    //0:fixed priority , 1:round robin priority 
    parameter                       FAMILY                  = "TRION",
    parameter                       RD_QUEUE_FIFO_RAM_STYLE = "block_ram"
)
(
                                
input                           clk,
input                           rstn,
//Slave Local Bus Interface
//--Slave Local Bus Write/Read Address 
input           [S_COUNT*1-1:0] s_lb_arw,
input           [S_COUNT*1-1:0] s_lb_avalid,
output  reg     [S_COUNT*1-1:0] s_lb_aready,
input           [S_COUNT*32-1:0]s_lb_aaddr,
input           [S_COUNT*8-1:0] s_lb_alen,
//--Slave Local Bus Write Data 
input           [S_COUNT*1-1:0] s_lb_wvalid,
output  reg     [S_COUNT*1-1:0] s_lb_wready,
input           [S_COUNT*CB_DW-1:0]     
                                s_lb_wdata,
input           [S_COUNT*CB_DW/8-1:0]     
                                s_lb_wstrb,
input           [S_COUNT*1-1:0] s_lb_wlast,
//--Slave Local Bus Read Data
output  reg     [S_COUNT*1-1:0] s_lb_rvalid,
input           [S_COUNT*1-1:0] s_lb_rready,
output  reg     [S_COUNT*CB_DW-1:0]     
                                s_lb_rdata,
output  reg     [S_COUNT*1-1:0] s_lb_rlast,

//Master Local Bus Interface
//--Master Local Bus Write/Read Address 
output  reg                     m_lb_arw,
output  reg                     m_lb_avalid,
input                           m_lb_aready,
output  reg     [31:0]          m_lb_aaddr,
output  reg     [7:0]           m_lb_alen,
//--Master Local Bus Write Data 
output  reg                     m_lb_wvalid,
input                           m_lb_wready,
output  reg     [CB_DW-1:0]     m_lb_wdata,
output  reg     [CB_DW/8-1:0]   m_lb_wstrb,
output  reg                     m_lb_wlast,
//--Master Local Bus Read Data
input                           m_lb_rvalid,
output  reg                     m_lb_rready,
input           [CB_DW-1:0]     m_lb_rdata,
input                           m_lb_rlast
);

//Parameter Define
parameter                       RD_QUEUE_FIFO_DEPTH = 16;
 
//Register Define
reg                             rd_wr_flag;
reg                             rd_wr_prio;
reg     [S_COUNT-1:0]           request;
reg                             request_valid;
reg                             wr_cmd_arb_busy;
reg                             wr_cmd_hand_busy;
reg                             wr_data_busy;
reg     [$clog2(S_COUNT)-1:0]   wr_grant_index;
reg                             rd_cmd_arb_busy;
reg                             rd_cmd_hand_busy;
reg     [$clog2(S_COUNT)-1:0]   rd_grant_index;

//Wire Define
wire    [S_COUNT-1:0]           grant;
wire    [$clog2(S_COUNT)-1:0]   grant_index;
wire                            grant_valid;

wire                            u1_wen;
wire    [$clog2(S_COUNT)-1:0]   u1_wdata;
wire                            u1_almfull;
wire                            u1_ren;
wire    [$clog2(S_COUNT)-1:0]   u1_rdata;
wire                            u1_empty;

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
D+IsSOhZJPBfVvivxRmF3ceE/uJ4jUdTe87d/+FAD9EizFpCJDgyTXf1Cpx25xzk
/ZET+6VN4DINwIk12snohcI09tfLKjGjGkoIZj4Uwbm417IKQKv5w7sla0vx6sda
dWmggT4FSHkmmM55nFSBNOpto9jhNPVbAKlZ3ZMEPSAX3TLkk0seaAMD867V8UC4
O6+571wbnvCLf6SGB9qG9CM2ukGgRF41XYs3K/nVHjdbw9jpkKhaT3HLkdNRPhzV
Jf8QI88oo10nIr8c5AtjM1XsCFDf5CiLeWPze8yanLRSCzJMpfKBVZgrgN9APxJF
bdN6aNfBJub6J3hkjmxNGA==
`pragma protect key_keyowner="Mentor Graphics Corporation"
`pragma protect key_keyname="MGC-VERIF-SIM-RSA-1"
`pragma protect key_method="rsa"
`pragma protect encoding=(enctype="base64", line_length=64, bytes=128)
`pragma protect key_block
SgdKMbdWrXWKecrAYeY00BgXuGpKmmIoFKs9LDYmgVIYg9bkSwPxV2hCSvNrUYkY
7y9DsnhpE995PzcKbRQ67I8ap16Q++tyiiUhdyBcLvCCZYmPBztlx0oKGJrkSdOk
P0FI24NbuNiPEVNdfcuJ0k95KIXGroAkMv1g9y4rMz4=
`pragma protect data_method="aes256-cbc"
`pragma protect encoding=(enctype="base64", line_length=64, bytes=13600)
`pragma protect data_block
+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
jmoKCjhHKbDorisjNlZGtg==
`pragma protect end_protected
endmodule
