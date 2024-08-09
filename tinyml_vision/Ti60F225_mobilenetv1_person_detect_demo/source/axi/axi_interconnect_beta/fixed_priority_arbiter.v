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
 
module fixed_priority_arbiter#(
    parameter                       REQ_NUM = 3 
)
(
input                           clk,
input                           rstn,
input           [REQ_NUM-1:0]   request,
input                           request_valid,
output  reg     [REQ_NUM-1:0]   grant,
output  reg     [$clog2(REQ_NUM)-1:0] 
                                grant_index,
output  reg                     grant_valid
 
);

//Parameter Define
 
//Register Define
reg     [REQ_NUM-1:0]           one_hot_mem [REQ_NUM-1:0];
reg     [$clog2(REQ_NUM)-1:0]   index;
 
//Wire Define
wire    [REQ_NUM-1:0]           grant_next;
wire    [$clog2(REQ_NUM)-1:0]   grant_index_next;
 
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
OMUy3kXn+QAKCqdwuuIcOmLe5g9rvM4uFepnFRK2xB76NPBbkNXnSk1P8j5fNxKz
LrLiqMtRXywta1NstcjmpfOTOIvcSS4dqE593cDKs+ksDsEKRJ3uSNfKBVq8DtfS
GxxiVbc9Zw6CDucsQyU1Ku5A1JIOVWMBSfu07M1kx7Zy946ozqCvwfquXxxDB5/G
mJWQ67d8tAx56tox4098lIw8sfhUBHWrjQRyGPypPpCzsoIzqJIYzoo7HGZbC8sJ
DsEtKWiLApYSqu2iuPCqfZ0AmArfmih+ExEDRfb65dBYcWPm6rsLo1qYj86oWH5W
m5rO/tKPlDRD2Qbz6tM8TQ==
`pragma protect key_keyowner="Mentor Graphics Corporation"
`pragma protect key_keyname="MGC-VERIF-SIM-RSA-1"
`pragma protect key_method="rsa"
`pragma protect encoding=(enctype="base64", line_length=64, bytes=128)
`pragma protect key_block
V1byt6Sb2wnUC2FihkGm1P8gw3ZVAp0VuZ25pj6hX/jgG88ptfMFxJ7Uacq38KLA
wsasjrQeOS9R0gT9pMqn1a5juDVYGKHWbWON00u+vQFX7CdBGQSfDP3+nShu4HfR
4nMFDvSq/AJpstnFEbj7LohOkuga/h2/QW6fKp2y0ig=
`pragma protect data_method="aes256-cbc"
`pragma protect encoding=(enctype="base64", line_length=64, bytes=1232)
`pragma protect data_block
lptoABZa9gA6hojEHLD8rWTU/DDa/2edFSSjJt1ePoK6ctYYVZzCkZRO966Op1iQ
2mtWjj0WN0FneTmiO1/xXFdyKa2W9GXWUU+A80GZu/KBjT9y07VZrElah8kaTuTf
mWnceY2peNHPSEm1ZUUP/dt0yH3NbSFqcc+xLrE77O47edVJQ9ZDPHRJAcoPY044
O9+V/ETIDrgWwPGrChpDSMzwkIpXWEbcr2sJWjWUUmjjCBokwIuUwsIrbfdBp88L
AqmnD5FCsvvSfKsFl4iPWSGRlHm6LJmRk/YAGnyAwhnKz+28q6AO+iID36oiqXsT
01AjeyFBZPMEswBAKxqlbPDgpFkbjThf58sm8KJ3Bpe1huK94FMqXg6J5JN3h/n5
r/miYQtenipGRA+34+7uTTJ/0rDm7JwMvykl7Otcyc6Ksp56m8HXQcC81SiTrR4P
7Me4iynT4TSq9EfWwTgwvHfiizfwE67t/jyVexQ29AMd7SqV3jCzASSXIncpfAWB
mpons5gKPBwdHYDL1z+uhPxxIoD4mYUFop/rUvNAxteMT/RUFMSnn4L8cyDWTFiZ
tWebN8CNfihfVTk6Q1B58DQ32ElSPRmJF62dBgC6xLxxw4gxUSe8U6s+es28v+Po
8Ic/PIbbhS0+XwBAf4upT8W02uumpLGulKaXsPPEYSbI9Iz0W9s3F7C4N0wgQ3Lp
7rLBVU62MejxIqgOa4N9Ai4FSCeFqpP9gMQ2zQbzpkATLg+uBLxYgzp/tvm2z1a/
39mUX+G5e/tpS6mtwzF/OtGaEbujSfvzPY3t3zLmDxE96Eu2T8dhq2IavqcUYif0
jrj2bfblXCz1axeksV2AN4LXGp/lNHRlflWw4zU02IFexYy1Ms05C+pYifFuonRV
31ea/fG66SLhaL5lN7y+wnrsxkH9i7rWdgzVm52XnyegEBH1f/zBGUU27KWh3f3k
ZPckHPNz2SIUXiBN5ChrG8zwtvzTNyf1y4a6r5c4t3pgNevvU1HbNH2OrBxBssxf
oSzbC+vjb3R4AsEnvrlRU62f55ec3i03XtdtemgJc93N+yRD2v2+4aW4zuAVqCK/
gcnVLjtBlnsdMNEMbW3RW9w8apruOylGCZQxNoOMrL6aX2yYiwz375Yy71Iyh7+0
Iam/7ehgjZZsmh2lU0M6zHfw6zipAWJaw9jDnn/tsrM9OR4dLLUPng1ZsaK1Ph0j
zXmXn+fjqMN9QVN/cEtA5Y+3Xj/Bzu7UvAwGmPwRTdgqF6xGYyekqHExIwRVho2X
oqtNEPWFUt7xaq3kw0a0lL0HYr5tSbbWhnmEu4GM8lceYnjM0uh7UHwsXUKNWJ+G
cz6+06iGkDeJ4TmBF+SKuB3r0F8t1VBLDba8yFAs3qzP1m8bC3zOL6BGvgYafkJB
sAGy0CnrcbHsgh76IoQgbhvnUe6xjVdL0tT4wqqcA0y3eWp6vL0YoyO+zRd26l5k
AoNYcnaCqOg8QIEwZQo9TnOIX9q+Up/AXg9bZoIRKc9H4WejWgHijQwj/VM1r8fc
sIz6N70Oor4/fN77pxiCUXCCBBG0k3KOFkjLVbey8KVl/0wspASMZOnPKKsd2QJQ
ZPgCxcCb7wGRVYslZfV0bHf6hapoJp4v71TOIeaQg50=
`pragma protect end_protected
endmodule
