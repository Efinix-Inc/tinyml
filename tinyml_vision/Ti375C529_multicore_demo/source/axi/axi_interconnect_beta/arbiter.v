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
 
module arbiter#(
    parameter                       REQ_NUM  = 3,
    parameter                       ARB_MODE = 0 
)
(
input                           clk,
input                           rstn,
input                           rd_wr_flag,
input           [REQ_NUM-1:0]   request,
input                           request_valid,
output  wire    [REQ_NUM-1:0]   grant,
output  wire    [$clog2(REQ_NUM)-1:0] 
                                grant_index,
output  wire                    grant_valid
 
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
Qtn8hDsz9kq/9hULZtTNI/bAD38vI/RGSJ78nVCUhBMtI6RF3tBjEum6fKv0QF0m
weo2kgOfvsHgSjxe8YRcBVjqSEKi+pDQuChboI3cRpJd9pN+QIKvT6fKF7Dz/yFF
7lcSwyGTmdgJ0RraBn6uBo2ZdkC1NVWje35sKzPUzXBkgtAIvenU0iChe1M/8tnj
VjEgxlvcseuO4V+Y06H4hxZGLzYp61IQFf+3fK0AxGKMkhRUAZJ9L/clx2NIBAGz
kN87/Tmhd8Ps/OVQJCaWXp3dKgKWnggV5AX4G7hxjlqx2H/8rdX1P2aevYzd7Qht
BQobRqlfsRRGDW3kC1cPxg==
`pragma protect key_keyowner="Mentor Graphics Corporation"
`pragma protect key_keyname="MGC-VERIF-SIM-RSA-1"
`pragma protect key_method="rsa"
`pragma protect encoding=(enctype="base64", line_length=64, bytes=128)
`pragma protect key_block
YZDNvq09rLfrxpP4BST/ulA1ro2Q0HvLK0j4a3Od+mRBEXXeum4ZndnSNLbjCQW7
UWDZwZ3DqKFUuiv70PoNcmpQuup2SsXRSDRQhjMLLHHNfYv57AB5+4gWJgQ/3FwS
B7ooV+aPTlZnC0xhVNiFEwUTqDDijG/z+o9lAZYSx0I=
`pragma protect data_method="aes256-cbc"
`pragma protect encoding=(enctype="base64", line_length=64, bytes=1984)
`pragma protect data_block
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
51d1Ad/AYHsAQVEW0GMhow==
`pragma protect end_protected
endmodule
