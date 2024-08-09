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

module axi_wdata_sfifo#(
    parameter				        W_WTH                 = 32,
    parameter				        R_WTH                 = 64,
    parameter				        DEPTH                 = 3, 
    parameter				        AXI_WR_FIFO_RAM_STYLE = "block_ram", 
    parameter				        OFFSET_WTH            = (R_WTH > W_WTH) ? ($clog2(R_WTH/8)-$clog2(W_WTH/8)) : 1
)
(
//Global Signals
input                           clk,
input                           rstn,
//Write Signals
input                           wen,
input           [W_WTH-1:0]     wdata,
input           [W_WTH/8-1:0]   wstrb,
input                           wlast,
input           [OFFSET_WTH-1:0]     
                                awaddr_offset,
input                           saddr_init_flag,
output  wire                    full,
output  wire                    almost_full,
//Read Signals
input                           ren,
output  wire    [R_WTH-1:0]     rdata,
output  wire    [R_WTH/8-1:0]   rstrb,
output  wire                    rlast,
output  wire                    empty,
output  wire                    almost_empty
);
//Parameter Define
localparam RATIO        = (W_WTH > R_WTH) ? W_WTH/R_WTH : R_WTH/W_WTH;
localparam DATA_MEM_WTH = (W_WTH > R_WTH) ? W_WTH : R_WTH;
localparam STRB_MEM_WTH = (W_WTH > R_WTH) ? W_WTH/8 : R_WTH/8;
localparam RATIO_W      = $clog2(RATIO);
localparam DEPTH_W      = $clog2(DEPTH);

//Register Define
reg     [RATIO_W-1:0]           saddr;
reg     [DEPTH_W-1:0]           waddr;
reg     [DEPTH_W-1:0]           waddr_1dly;
reg                             first_waddr_flag;
reg     [DEPTH_W-1:0]           raddr;

(* syn_ramstyle = AXI_WR_FIFO_RAM_STYLE *) reg     [DATA_MEM_WTH-1:0]      mem_data [DEPTH-1:0];
(* syn_ramstyle = AXI_WR_FIFO_RAM_STYLE *) reg     [STRB_MEM_WTH-1:0]      mem_strb [DEPTH-1:0];
(* syn_ramstyle = AXI_WR_FIFO_RAM_STYLE *) reg                             mem_last [DEPTH-1:0];

reg     [DATA_MEM_WTH-1:0]      mem_data_next;
reg     [STRB_MEM_WTH-1:0]      mem_strb_next;

reg     [DEPTH_W:0]             counter;


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
WkhkjSzDOoKeQHdkGbQolhvaTtCNWdffwlejXH+FN8fYqaSvNksYjHUp+Z3JmvNt
Ckn9aW2zXe/DwYvAbSm6ldTZEXS70SFwZZ+brEud1T69efy55Nmy51EwoBHKmfy8
+k07vR2pWsAUUa0heho275ZkUD84DrjXiq730Ez1JDTl/SYctTp2HM9STDYF1OQX
Rkc4ng20Eec7P47mnngM9bXNrhZmj0nB9y4RudnOFWKcK8aYh3o9lVuoNZdKt19s
OfUcFmN9nADYvfoUxEAMRHa8JdD1QxsCfX7Zz/gZEjZUzn+3FaH5z9JK05nMrCsA
B9jgcLtylCGqsHqzFdqPKw==
`pragma protect key_keyowner="Mentor Graphics Corporation"
`pragma protect key_keyname="MGC-VERIF-SIM-RSA-1"
`pragma protect key_method="rsa"
`pragma protect encoding=(enctype="base64", line_length=64, bytes=128)
`pragma protect key_block
MOo4oKn8Sxdxrx/9ln4AF03egrmUMvchTqHba/dm8csAlMwhBuKs21ynpwz5n8i7
dcCKp5xLbTT7tWysx13st1HEWjkWgBCt+6fA64uxBw9WsEuTemGgoFDFY5ijWn2+
3tYJQ4SHsCz5ll4SxkMMPA53h3xk4VAOlsi/GuR9da4=
`pragma protect data_method="aes256-cbc"
`pragma protect encoding=(enctype="base64", line_length=64, bytes=7600)
`pragma protect data_block
9IW8ow90IKcGVpapXrm8bqsl2XKflM7Ax1nzu6h+Ch8VUXpVAXaWZ6hLWYcufAoT
dIrw0MozMH2x112IRqef0RUnmB1u08UwG4LS/ZxJfbC+TC2IwWvFnLcCXaKBJdS4
mbuY0UVByDppmi3bFaEdq8LCns36HbRyvwR9V+Hslr1xqCcqN+D0E4NdkfQs1Hgz
Fob21pOTZWrg5cNR9wsb129koqJiZ8/9Wen9tzm0DHvyIlwhZRGg3nUyPP2VdFpO
etz1bQRp2bIImoGYz78NcyaI0887fb1JFvsDzYYq6aSjet0YK0FdrzZYsUDKtcYn
MXMGuEzYLISaTcC80JWxJbrfdF+fFI9Y3vr1gwZ1I23mdGcAorLnncY6YprJ9lOv
eSO71OBtKHkVjfv8oI7HkadY4TfYoKSfwGo5I4Yqlmim1dEdwzbYtMe04ljBSccz
hJakGxxCF3iJAYSnL6BcXZ8j7usQgUz4lgnFxc9/Ue+h5TgTIlXFl45F7jtgzH1+
92r15n+DdlfcQz1Ym7sC0IfnzAKOa8QN84VZMna+MFVvLH8ssbmff2fZfSzuKKsN
TPrfp19fSIwcFTQm0GRWu45mVRB0HTJZ8UdFPa4mL9IZB1oYAD0H6RktlV1lsRRa
JY0SQYfRNjqrgQz/quF+mIDU0a0RqbL+gnDbbzu8Os4csmsnwex785b+84fd8j35
7LIFbcVy2cQ1awTsMF9REtdr7VJe9j39jbSCobZOpH2RbigbrEvNQpBqCW9INQtd
bHPte/u55NG1dbYZGpza/QbHyQzpB5BGPFqEBqCK7/2XekHo/Tsi80iiQiu0kXz1
GSyNdTaL2Lsi2Rp/+qn+axCFkQRBG+ojmzMBf+wwxLShhRMGecCU0D2CLDfY0usS
udWN2TTH7zR/3x9Lwek1CbZESTUGviCpOMBoPqLC2l4m8ROrg5Zpl4O9MfvFWit7
AZq8SGXufrIFgVg2iz4zkoHzRmB4ifco+keQnR7zG92G+F4ZjcearutZGGprbXzx
kwBIq/scC7waWdNQsOtiCh6lPDEtj3+U512v5MmtWkEaIGORNMT/NJxprXg9tRn7
vDCT8aylw/86y1OIhRjvI4I72ZbWs55tH1cG8HrqDRDOmpFeCoHgYZwGYx8+SrDh
na3rGakEtOCZknJeo7MqFC9JcGO5bYQVVN91Zj68AzQqvQDJfX7EprkzM4GR/ovI
DbdTAuc5+hUQPEJ///jhRU4SW8G2tj4vhw60Cezg7oetMxPLHpHiIFZ7jCdFLSQ1
9bT9pph3JDJSDYPjmp+zoBIlqQ9dFfMkK3PhJd7wrVv6mTEZoTPaI8etjfe7gHaH
vKmww6KCVgbq/RjfWvNa0YD+ApEahA5EQG+Mw8t4pLMIVxNLB0iOh2cdmjJYAhf7
dzJOZMhHtwSi7WQETbzVwrqwRmM4R9HOdBidxdTeI3043RfK/I0CTJfRCkV/s9wI
0UyVXRheE3YiZV7URI4PDgJ5MkTdJOkhbfAOqqd2lauh1gS9Akf7vHgIbEfrSc/p
9rngi/CBZWLg8f4HJk8MdwynVD2noPTJENwnAonCmayfh7gGfHv/WEkdcTl1wWjT
lSr5nHJaP8m5CKVJY0dacWKVnSl0vhgnJtKlRgnwfTLD4uQMuFhzME9FgjPtdstg
/+x+/WlDW6HFjHMDKJqpfQXaNla+JQZUASKD11kTOd0J6kI8w4TSNqHsVPwONxpC
m1Ni49KZhFLYTRxwLhM2wMkc6EQPoCPlyz9gXw2JSFt6EpU//zzXw1lAjVcrfT+Q
MTrjPYy3vu8aeYDmEwjPd7W2N2a8Ul19G9JGZwGNA0iAuaCoy2b2qGVYFRAlPRvA
qtVQ5r2r/fjgfcDLrD0/l8mlFy31tIVlxXLKtJBk/zgYj1a8uPSSNqZWy1qrG/AM
65IrdsWXB3e2R1QpI/diAeTbbd0dm4MZqwBT1Ptsadg9q2lm5L+BU5OIJj7AXJhP
PrIPzX49qD0KucpG1HxShRjr8WF6mW9u+JM9b0Kb6QZXXgUJfkFSpA3rH6PRnThe
G2/vryqBRdEGCyhA0pUa2UMO4V8c7tJLzzQDaDRMkJuN7dQRcpATnaabyclw4Hlk
6h2Yph3//iKtefODw3CwvLEqZaJDFypUHTjXk3GU41WdxPeKyvx0PDVsJF1iEO96
ok+BKXBRxyC9U85fU5/4MqY5Bg5C/BDFl6fBfmk8TjvlcP9Ladt1s7LIw2HotSYg
TD7h8xFpnmxan+gXzRGJ1W5wdvb5oFAT19O929T8uxEZ/jFT9NJxgS2CoO5nfT2O
NSs4LgrnyiGnCkge+Hxk5LbqkLSod/4CjFKXPw1Llj2Hldpu/035slrueOzwYT99
WhdwfiB3T7Zc+WS3ttrXz27LyWSRU37msDZeX9PUZvjjzSzk//VgQ3NZoICTtKWa
/o43V4TtOpMbB64lNSlNT8uFkmCCMY2m/DXwGMsyU5ZnjYpltG7VraDcQuOIbK2z
jJrEeKbZFBJPkC6JT5zS+L9iM6+O4+VvoImbrmVpM0QIiKpEo3vRn1S1uAZPbRC2
AAWMgPCtZyNpabPjZmyQK2yeAxXj+wXXuE3yiUPIc2ADqhTbMvwIX28ZqGkFlZiX
cr57XehcFR/Hpgj5V/TG1TGWJw1Yh1lt0g1o31uK4PTtbAU0Icl/CSNhkGyDN2Or
k88vA2vLE0WH/Ohbwlh7VoGX8nlNBsLjW2CudWFQK4cFdJdcuJ9skP7LgvXo2PKM
cqC7aiS141IKfvDSQpiQ+mQDU5oCTo2iiIshsbynO2PgxeO5LzWnkIlLmZ4khFcZ
EjCSYXbvv3oxbKujT7+e2z+T/ALzy6VN+OhmYxKNjpYRNPXRt+aR2MCwyNnhOBOv
5V0oxk/jQZNFrwxF4EMQg8ucip8upppvQNVhgTxQ01BqmLHhVSVYpVm4INb8Xrkv
nbIDtXbPpNyFddpUjUZpW6iUccoY8C5MCe15hJA4Wu1eEfxwd/I60qS3dbo9q2JL
2SfoRfdPa+X4sqFKBVlYvBS94FXXwUve9WURqO6fNZQn95QcXfF5nLheXHhQUB0d
nPFQ9TEe1zdLvKN2qY6v+LoNoam7aUSWpJcJ+LcFuR6JaSpjdUmf2lnwBBJ8FzPA
6poQHszHO+hWtt8w2hrdIjw+kay+Q+lWkDN/gww1r6+oKu/xEEXeHyWKZpHbvvwk
/XIkrwYwrBaF1QOv/Nma3WAkZA/yG9y9TRPbEXbcFPbGPrD7q+SDwCbVTjNPGDv7
dr6d2NgdAMUclycU5+snSZijFQrwTpR1du14I72c79+yh0R74UFqglLAbC2yqD6o
3xgDn+3129hiZjl7kV95sBECr7P3cfXTalMXXSmA/83CuW/QE5DS3gpBj34Htbi1
cy6/FokFzW89L0xPM1wNgAApMc+APSRzY5wOFvFlQy9+G/ghKxzfbt95GB0DhzKl
90JCJAloA1pZcoHjrwzwimvKkCJX99EcTr5sKmW5Sv6PLDZ28F4EuqYRm5BsAqpi
Y+Mhg19wiXcWP9nDis/UuoKvTSjqtQoTIXzeZEhiE2J5RIXipYuBqxu3eccIsxoI
BqZ7pdZtnyovjrxB1j6QwbR63iY4t+X2M3uTaf1cxVkiZ47NEEc5Ywd4MQS80el/
6u3pqoTRTi/aoy+qQJtvkD5PncG+1COokXRo4f+boTYdfFMAzzw84YZLwjUWznRa
LnoChoDZCQ5fZYekKdBJH/5xHQtjfGmJXXIECW8IH8IcsNCkJUk4SNuWum3VnQAV
fYiR3Kwl8WhTle06BNqMLX0LS/zhjxQ/+2PbP+eXP+WtGxanAa9VbTN6tZ3zn0Qm
KKbEGqoGdSmfgjQZAsi0vM+YIHIFInON9KpSjke8MJDesy7XsoSJxiuSNaq6DXGS
lD0fbv588lrQ5LbtmUlze2E2WpQ/I5CR9ypXI5FCGnrYa22voWFG/APrPRWrfgFW
Ef7+znHnM5zhz3b2pBA9OuCzfOvtFU3iTHmhE9ksOC7xB/uzIFEYcxJpiwps5TCf
fmmo9I7H1LrUfRPeqj606oaSP3x68ULAyN9QDhViNUtMmXbJA4vQso9RThBYqk5S
BAmD3tDlC2sCNEOclwnSGTsdnZVAzNmUIh5ahMRjYdIgUl6YKsdqk46qBWDVl5VI
dvqll23dV6PfYn3YPOyznvlav6cxr/SgEDmurNQuvc14Nctg7GY2/A7/2vEiwGbI
EgWHEaWmnDOOND5W+KCPWP8+LiGzhcmaCAVqxkG46EpgJ0cV67oG3BOO6AGVOACQ
vxKzybg+ebog8Xy+st82m48nYPTg9cvtOVUfKE9oTIZtmrpmsa6idmQHkUZC5bk+
cvqFJYXXQY6Bv/TiVhdu15rzxFVqBOUA3QzDp/CpakBEfiiM7NBc2q3UBuiPUYtY
QfwwM37mKYRHZ8Fmi1SPIpqKK4IJUbimDPXzpCyrX4ayW94cEEmA/npc4vo0y5WK
vCItaHpVN6D2nz5/HOU2QDuedxlZ5Gwhe4T9VAarIEL0ivth5wqFG4lStk0qEk3j
68Mwk+SK8flJHPE51Xx19M+WVsvPvxMqQ7dnEVfSZ7QZDy9EZ9rK55m/oWymqj6x
EaYz/jbnX8wYaI8iEq6Ikqb3ypdHkmx9PGjrkxGQNHkrD8QKff8eQYjJbSduasn/
d8PelwGlrvn8wnmyLz1kWGQcOYPwT0U5zkVuqrEGrUKy6fzAq6xWb7w9EnDsD7za
5ff6JkxgpDq9dEvgLdAJkGu6pj7LXNwWdcyZ52NukVgxj1Kfzia1K7GHc6+HImEo
ePQ2twDV4icROee2oyLI3ypXqvIxEMcCTHyseR/S5klzOU8E1I1iTlQSRjwkYt5M
0T0FrqABpw25gK9ilpcyAJsMoX9DhQ0C/Mj6uOI90l1dsRuujnuH9hE+9Iv+q337
ZpMaa8nX2ySqL1fMG4DVaA+UE3FnJmKizuTCo5WZgOfyo3QFPn8hT9TRpuPniSms
LpB3Uj6/LD2sIWl6UCPmL0C1sgybQAFQ9kGydT2C8okdqMSyj82YSbghMjuAhyPX
mtBtuJrGPSmiFPbnTwUn+aytSIj27N537YSSAYZQRiP4Sc7L/DxAfpT12QFFLQ4A
+a8mWJhLL8CAxEKqKfegr+RHo7SjI6PMpJIN5uOYMl0xSqChREt3EvXXVGcj7CkL
fPtLII56zzFMmULewQg60bejxPCHkec2EQzgJVtoLSL0Mu4Z5T+ofrdQjOxc9+ms
q0p76Pfav2HgvhxfBNvtfEvInX9achxQxxSsgCQINNHV6lCzP5aRbay8c2vH/Mh5
houcsgAGIEKAyHcI+ojzhSMM+PyR+EILpVWPoA0YvFhaUHXZBVaF2/iWXqXbpCiW
oSEhOX9WnVMdra5k9fPHj1FOYJYh4V8eblC/1fs2l+15EtFrqsDPmkkkA78eNH3r
C7tf71rP27XioS+X5zbH1VvkhgKQN4UkqrCgM5ZXmbZNxHCtQ8qXfR2LWOPuFdE3
L82yUsUsYQ4Xe2nw1AYZ+fwPdzsXsncb+7E4t6ABlurewfHHsmhVDsf2wLCJRaxF
LUsyI0FK3DuXSAn0/Kf/SVwXOsanYK83n+AK6oiYp8+tVxNYsgBOroVksscIzox6
3Gm4h20e1b11AOXqB78ayEJ1oiMecUHJJHAuzn2//c0gBTzSyg5ISmG0irsswi+A
xNL9XjSsoBfdoiYimb42B+3RT+Zt9QDaoR8spw9PUQCs5/I7dyyDJO0lWE6u+6m0
IcKW/OEh87ohxYeOnwobkowtAcFQSO+8nxWr9uYhnGdcHm2xGtRWWzwb2qPfx0Qi
/sR4kK1o/e4l1UhQ/C4A997jEkcoT8K5sIK1SnUDIQVTidDJeeH66vP4vwHUaHH9
fjsI84FkiqKALb1c3l1i+/tslpCeRr5N37NQQi7ZxbVx8mIOAvvceaT2yPSajpU9
2Sz0RJiHNSxFD4ZVhqLLuf4KldYENjxMsPJCpaJM8sccwSckkpyrCnQb5jOFKDgp
wfpk7hHGEHNIms3OZaN4+Hob7vkaVXyOJwJRNp59YSTIxee0yQdmId/pkpgip2s+
e4VSpmQhEjRBZut4J2X5casW/LtQagCXFHikcg7OxDCm1eSkHmUuoIqpwEMYTVpQ
IOtCJnHJC6k+/u6Ia3JmNmljn6EQxbJQ8uMvcpfM+pEezLH/DKypnP1sofYCwE+v
BQJcceAL0e8rfjkmE13Hj3DE8WS4tMtkG/hKlxbOvdlDhRH5bs8Pj3NE6zmsoRkq
wDe29sb0CPeCzgT8lIKxiReZvskx57VXSsv91rt7v8gQXDO5yAjkZ8/3TyYGS2eB
iWuHTw2+NTyEWXQmwhcGdiGEGPFNKLBpv3IFFpkZOIyUqCCFyDKpnq8UkcgEGrqW
/AYsm7MEik4xYCzGZdcnoHtoW7Ht4CxKVdhTk2ejacEDW1CkkbknaHZYsbJt8oKv
Va7UFmH512Cx/ojtDc5NPYsvJOqrGAYZ2cZBy/ZBcTdoiNctJUu5l6BSpXEsRf4d
cDZXb7U1gb5MceeO3LqFaogCYBL+NqtYqRRFurUUgMn31W1eFptbBHXALMxjZaDd
nhVynZ53Bw7OPWE3azgKC4jZwTB2dzvML6o4RELgmZv5mDg4b1DnAIlVkphB2GF2
Kvv3FZSRJLMxdzjD0LBtMAN/yT0hSkR9JLColGInLDyTeNWhKtH3smwCbwU829Uj
HLlpDr2nOm8z7UgChg4FfGwW6f2WUcONCoix7Vf04GViH9EzzUjS5FM7KpexhIm6
+isLtMq+FyaVYZZr7Hrp9U/AkKPQu6IJm/ptodTWoK2k5cndLIY5t3UWn7i3k41i
4jRLw+KY2Tfsj0o5rNZkoErX5dobK6y1dn0Utzxfe5kpr7CAcZn14ppwSWpOaxTL
Fzlt2JFg82hCbxdyl5e7OCaa7bHshsJgnoVk2x3DUdQxu40SFg7zs954/90zzCS6
SsF7zzP/vJjre5Rtu3c9DUFaYf2zv7L56bExuXyiHbL/YtbOCNfQDrRZJ7N//IUe
ofr3yG0jYUay/HyN7JfgH3v/Z54KPSHAl8ONeIvhBDWO5YGe6D/390bM6bPhqkoe
AgsmgfvGskyo7V4k6M7dNvVRLlt/V5TgndvafN35JLYNNjPbZ7Vf0LpZt0B+k7N8
2daLtmUbFF+5UOkRjX5WX007W/8sDZpYpTPIHh1cDdOwgV/74Z9G+Isr0koIJ2xz
JLt4OeYuBjzE+PYbiDtbXjXVYobHOI6cy8IPsp3/5XP1HEwm9iAGStoyuGSiWuMx
NPvFgE4Pfo+QhiK3c4LS7hBTsPyVbzHAlZfqDeW7JHM0mkJffclAZxlI6Z8LUBWP
l9bnTvsFCc79CZwBP5fapVAXELHwvPAVLI6r4lxxbHOitOw+dBOlv52CxvsiZIWx
GsFgvS23wgjSPVIktMv0nOJmfBRkZrzVmkbq0q3iVWH/7bjczsMKcMhM5i0A+bTh
IF/4hbkAlF98u060fmN1cXpPJccNUaDneH6iSIZmMqagX9pyVYJoU/LBbf4Mj0d2
4fCYsQlfU0id03r2jNoG/BQypM1m+3ho0SFmIdEO1tYU1VRupBaa//XkTeBurzjA
KKocxWy5TcmJbNRlolLA9Dcr8mJibFm1en8WQU1EaLF7CaeLpXNdF184l6MY4gQf
xBy9g9+gjVHz6UQ58oK8zTOHOprL2EvnHlcSQBi936u1Yn8dRMZDIbDjr7UxOMbL
Ddf08ksMix3D3+r4683wkBLKSGoXledndb8rSo8MSgvmVumCm6z//kPiJRjYbcKW
zZJmCFKI5mD/6K/4OzrhfDaXT6f5aE5VZbTBD599RNcmVEm8nJH8+IqittXRZl6U
+V0vMjb9NXdMojSnDoKxuaSJa/qaOA7dRGpcX53Z/gBiiYzO0Fe7AbAFwgb9Hlw7
Z2ZRGhCLa6lQ/ZP38okYqWh/Ho+D9yLnoS7YF9C6H/Bzm1xVphCMNKdyB4Vgx5g+
epXNbLfddRZc01t9n5gzGp+gYJvitzP8flfzkejF4MsRcYxISjxNNkYsDt1Nyf5z
jVcsvIRB3PEwpU1YWo14UQt6S6lO+CtdWcDPIq40gWDeEPUg4eDnWatIvw2YbAN2
Vkwhaw4JXHr8y7L9vRspVjXPGg7gzLY85Bjxq6mfkkb6j7eUMSi9P9PxoD0e5YL5
1ajO2LFH5LkPT0Vh6i8pt1U3xK73ePOi9YEa5i6VLI5BT3XJamY5phs6RcqLy/nE
5A2NESlj8YXZYXIvI1S2L+QHiFKaECy06nLAOI1nI9oc6qggOORxDtuXZIHvAR8z
kC+9RUwz9rF5EB2+kBIVACRWsZIgLVeSNpBqxZXfyVxHL/oi7m/Dt4Wjwtl30COa
3wVDY7OCbXIhKd9a1hnor0PT2kzvVf9Tr2RXA8und0JPlZ6l8KUBi4AuaOWqfVdJ
ERq2vqGoJhqH7RXhENct24ch8BFwCLBxjYYtEfiZIbPbPooE0jDAflz4gT/GgEwf
jQFW3GJaoAeY0P1SNm3OwiO3cWPZxKkzhH47GR5mSiCPxiym7pxExx7+6D3hFhiK
53sUCK0vARIXc+yyZuDrUMam+4kXYo1eNJzIn5LsDIkOXNIPR+Tdq5xIzfOzm8Kk
mMaUWxU3Nz1arUxrIV5tF7zeYaxviXezGpKTaoM0w8AbL49Md8E7Gx7kJhswX6+w
P9vv+exJQLLOeqa9+ER1s0t44M5CK6HnN+a126L4+ZrUmAyuHAuVQaPo4w3s0ipr
+emQPFZGzKP1OWG2qjs5/rR38haRngtNmhEMmqBKeNkIykt4xaXtJ93wP81PWKcQ
7MLeuDBpChVIRy+uVqJucmpsaHesahIO5hwAahyD4hgGnFRnHQTlceVfI8Wdc/tZ
pQORTiDi/yLy4ROKdtGctHKHuJ/gAFCGFZXwb9dW1+6zGO+/Zm66+DgT7nePm7zd
fiZbPA4mu4ksynJl3YxqB+IFpCksUqrVrdAYG3U0IjPz7NB/I7GQWRVR2E0+URZ0
7ZVE36IICXzF+RYEWSGKFRf+v0sUBOSlpLWgVKMTpcfCU12H+wkiNV3g0zGoyFp4
3aOSPR+bPtgtI5PdbePoW76thzVMvCqZDwoybQD9tGoB2eYVYGGSUp7vcT/RjWMd
M5vcJeFjAzRN0S07IT8Ls7+KiRPRlgaae5PlNZlemLdrV5aLhz6M2GuT50s49KNR
5qnVOFlYWHGvsMbUv8kj+nXk3dPQC38E7UyHSyQ9+ELE87GOrnuHzEGFR9XVRCsw
thCAtnYLWKDs9DG7iVQiaMT/DiUnpiEqXZFoImZxzb3ZwQtWBcP3iB1BT3eF/dSs
QxHQGGIW4FsciemQGZ//ps7ByE8uPrq1gijujmmNm7QKa/I+pSQj36z9L0RlqoFx
ULkN4Wl9il6o7349h0KskknBRZJgPF7zzEUEEZfNgrz1fNFt/xnpQ/Z1tEVH4FSX
X4sMSI4XLYKkZAsJkVGRzoKDpY4xRDwWbYPVi92GSgtMmiHWAIAONpSAf1ZtLNvi
Qr1HkuiSh5MEv2e9EacQ3j0aZ2WoHv24w0gMQApV5IQ3PIGzSfeHJQcvisLoCBIZ
KjVdULgJdWQ5EzVnUPwRV0e04babGN6lQiMnWfYoX5kGyZKRIo6okyJUsEhcM7hC
WOYgciJWLXJRQQ03L/Y67ymd/almWq0cNF9O3Eee8vVmNuCeDwqcMEEX3LNEAMct
shs6GpVZ3+gDYDad+a/ZHVqd7uAdO6NkfJdgHBR/Qs3BC0EbO5+ClVcSuAC2KcEy
IGa2g9BPCtSBTOEH8zJ4iTjQv/lLve6pxrOxvhzVZgip5z9PlU+/JpTwwos7yzo6
G5BJ5cGffrUSef2TiMlTV7XZ8C/wFCPukS1pb746vz10ne3PrnI3PzwO+cT2WmDG
PXJuhOzvOeygZuP54VX0cjtwvDfgW4P6EIQA6vkd25FWPIe7sU0osofIz6nQV+15
fDc7pjQiGMydmIyoky4M+BUjua3n53OJY2zYahLmcrF2cmgrNCOgQcttDpU20ZBP
5TJ/45OXe92zGcyTW8K2IqbtqquJG153nX4atmgZpaiTyEhUlCsEMf0ODS4dhgzg
aMtnqrFy8JpDSUzCHaTSbA==
`pragma protect end_protected
endmodule
