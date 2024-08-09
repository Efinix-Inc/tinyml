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
 
module round_robin_priority_arbiter#(
    parameter                       REQ_NUM = 3 
)
(
input                           clk,
input                           rstn,
input                           rd_wr_flag,
input           [REQ_NUM-1:0]   request,
input                           request_valid,
output  reg     [REQ_NUM-1:0]   grant,
output  reg     [$clog2(REQ_NUM)-1:0] 
                                grant_index,
output  reg                     grant_valid
 
);

//Parameter Define
 
//Register Define
reg     [REQ_NUM-1:0]           last_wr_state;
reg     [REQ_NUM-1:0]           last_rd_state;
reg     [REQ_NUM-1:0]           one_hot_mem [REQ_NUM-1:0];
reg     [$clog2(REQ_NUM)-1:0]   grant_index_next;

//Wire Define
wire    [REQ_NUM-1:0]           last_state;
wire    [2*REQ_NUM-1:0]         grant_double;
wire    [REQ_NUM-1:0]           grant_next;

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
dY5AyXMv1z1CBtGzffY0GommV9F6xj83U/xL4HJWJExBaHv0Z5uH9ps0JNgHyw9Y
Gv7aqrdIvazsvrLxIp4puk01hivcD9McN20bZVaGRu7n0zxf1uKKK8JVOY0uFhmF
YiLsyeG2zSe1D1A0TTkLTqfgG3YKMiX3Hdx/JCKW8b6xomEZbJosoUGa2x0awE7K
yM25YS9ESaogP8Tj3azfrUYdFoTCO9NeKuXCFxEadr5mtrsl3z+yo2EBhNBURiUM
N+55U1r8Sd6dNIDE/gjP90i+YnUWCCC25Fj50/dvBZ64luad4Oz/2CLrf5N/ZSPr
B6BgFvNU4sKGotpzy3S+rA==
`pragma protect key_keyowner="Mentor Graphics Corporation"
`pragma protect key_keyname="MGC-VERIF-SIM-RSA-1"
`pragma protect key_method="rsa"
`pragma protect encoding=(enctype="base64", line_length=64, bytes=128)
`pragma protect key_block
PFhpxaHEsMt/TttyZU8eLgectuGXH5uMT88j+aK8TXh0ZBzliiwGFgTQhAYCcHUD
qcom/PT2d4CQP4VIhOVaOQjUv39eJAE0UK+rcP8SYW0HeM96NUwJ9nXYD0bQT03W
kUBAwkt9lZV2hc0VxBlNLQuYvw0iwgQ86A9mAiCHl7M=
`pragma protect data_method="aes256-cbc"
`pragma protect encoding=(enctype="base64", line_length=64, bytes=1808)
`pragma protect data_block
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
`pragma protect end_protected
endmodule
