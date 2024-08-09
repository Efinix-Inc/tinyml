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

module slave_coupler_wrapper#(
    parameter        			    AXI_DW                = 32,
    parameter        			    CB_DW                 = 64, 
    parameter        			    DEPTH                 = 3, 
    parameter        			    ASYNC                 = 1'b0,    //1:async , 0:sync 
    parameter        			    FAMILY                = "TRION",
    parameter                       AXI_WR_FIFO_RAM_STYLE = "register"
)
(

//Slave AXI4 Bus Interface
//--Global Signals
input                           s_axi_clk,
input                           s_axi_rstn,
//--Slave AXI4 Write
input                           s_axi_awvalid,
output  wire                    s_axi_awready,
input           [31:0]          s_axi_awaddr,
input           [7:0]           s_axi_awlen,
input                           s_axi_wvalid,
output  wire                    s_axi_wready,
input           [AXI_DW-1:0]    s_axi_wdata,
input           [AXI_DW/8-1:0]  s_axi_wstrb,
input                           s_axi_wlast,
output  wire                    s_axi_bvalid,
input                           s_axi_bready,
output  wire    [1:0]           s_axi_bresp,
//--Slave AXI4 Read
input                           s_axi_arvalid,
output  wire                    s_axi_arready,
input           [31:0]          s_axi_araddr,
input           [7:0]           s_axi_arlen,
output  wire                    s_axi_rvalid,
input                           s_axi_rready,
output  wire    [AXI_DW-1:0]    s_axi_rdata,
output  wire                    s_axi_rlast,
output  wire    [1:0]           s_axi_rresp,

//Master Local Bus Interface
//--Global Signals
input                           m_lb_clk,
input                           m_lb_rstn,
//--Master Local Bus Write/Read Address 
output  wire                    m_lb_arw,
output  wire                    m_lb_avalid,
input                           m_lb_aready,
output  wire    [31:0]          m_lb_aaddr,
output  wire    [7:0]           m_lb_alen,
//--Master Local Bus Write Data 
output  wire                    m_lb_wvalid,
input                           m_lb_wready,
output  wire    [CB_DW-1:0]     m_lb_wdata,
output  wire    [CB_DW/8-1:0]   m_lb_wstrb,
output  wire                    m_lb_wlast,
//--Master Local Bus Read Data
input                           m_lb_rvalid,
output  wire                    m_lb_rready,
input           [CB_DW-1:0]     m_lb_rdata,
input                           m_lb_rlast

);

//Parameter Define
parameter                       CMD_FIFO_DEPTH   = 16;
parameter                       WDATA_FIFO_DEPTH = 16;
parameter                       RDATA_FIFO_DEPTH = WDATA_FIFO_DEPTH;
//Register Define

//Wire Define
wire                            s_lb_arw;
wire                            s_lb_avalid;
wire                            s_lb_aready;
wire    [31:0]                  s_lb_aaddr;
wire    [7:0]                   s_lb_alen;
wire                            s_lb_wvalid;
wire                            s_lb_wready;
wire    [CB_DW-1:0]             s_lb_wdata;
wire    [CB_DW/8-1:0]           s_lb_wstrb;
wire                            s_lb_wlast;
wire                            s_lb_rvalid;
wire                            s_lb_rready;
wire    [CB_DW-1:0]             s_lb_rdata;
wire                            s_lb_rlast;


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
F39xxWICVcObk2m+WuEZbNhYVe1gXfgN3XAc4g9wyaQ6JJl0Lrx3IAn9MCoGgED0
E0ARneyMph1yhQlnG6RpxwYfD5wuD7IvnSkqxcJzVypjly7b3R65pxdAVHsFQmfX
P5J4fK8BMmo1vbFe8HimIHPdasG2dV0j187s4O/w1Yt9GVt7TDaPr6/AtpIglhAd
tX1X6UmcbetemkR1tpeBnQErX9CvTY0YdeYRLErCciqWQgVm/kwKR+E8SBROUWoC
dN1nNKuXQbcFqzbvr2F5rQN/8SbXQGMIoqnVNrEIDEDPPyWiIxhyavkZe5X1xaLt
wHQFbjuz5E6YgsJcl11Hdg==
`pragma protect key_keyowner="Mentor Graphics Corporation"
`pragma protect key_keyname="MGC-VERIF-SIM-RSA-1"
`pragma protect key_method="rsa"
`pragma protect encoding=(enctype="base64", line_length=64, bytes=128)
`pragma protect key_block
PRQycTZaoXlOg9wzIliOejdHZ1cDAEGtND40En0hHC9Vyi7dKJG7zyd8Ktib34Hj
88uqFZZ7HxI5g6jM0NoOfx9mooHIdwpQyyLhKVlxEjbe5Wr9HUc/kZ33xDPKLE0p
s1QB5r7PNWeVMKJ8opArrJQ5Yrgym7ds0ZQI7nFrMEc=
`pragma protect data_method="aes256-cbc"
`pragma protect encoding=(enctype="base64", line_length=64, bytes=19584)
`pragma protect data_block
qlP34QUnxZDwpNx5mu50R35GyPysjdzOiMnvsNco5+82BSrYxYj+QFIgC1myWdGn
xG1noP7YoouOx4E5nhChWowzRFRIshCG/iyUuTE3/iIil4Y/PXqVdsGMTYmNPNG1
OecKqaDUSGdFp0nmFulVi0VmjkhWnld7muZKazZaWZNkGlxUKz+SqCZ34sv7xSG9
/nKC7727h+jJM5XUyRVbo3qUGANFXm76eBJMR7SyYchiNo+VFqJVuEzeyYMrTcCS
gMnoecIVl0+9+Euk/0Fv2AJkXqDMQ5t1/NrP/KqyQ7Sdi4lbEep7O+hoMm/TiF4N
I0+1AA4HzF6ea2cuWWr8sxlQ6e8L0u2cgVDKgqxzsLlBVfAyAP2rvFNrMpRdeYxY
yyIVoAZJ8GwditTI7OaudMv56fr3dYOPwT6MnOOXT6LV92JdH4DvhUM81JQAXSei
U4lnk8YJIAeITp5AE5JB6JLM4kW/qzjV9lZre+CBuzXJicK/MvcI4i0W2EAampCg
sXfripIjK3tisskTHvNux3TINkhNkv75LZRJXwrMhzdD/zb4CtmOP03NUXle4T65
8U8x2/Dp8hs5BlhBw5LzPIKQRFq6W+qZJSGaMuaFhO3fzTLhw+kWR4QQMmlT5VmF
VYfY5aW/gO+KsmCTWjM18+3lBCl/u1J9N1U6jPnJyBfG/1i6v3+i7lnnhPGI+AP2
XMj/a5txAZJHzEoKKAz0FKNRq8WFenE6unTApCdYG/2DyTZ75H0BoENV/AQOUksP
soVsxRcesNiWPs3bQMwUN3zzHo8L5bOlvZmcLsxuNWE5geZIommYdcp2kqDWND9U
6li8bgBLcxyCu2UeNtW/JHTC74pMsdhAk9RhFmR3Ydqq2rcZpoxzCJuZvRrclsx5
iwyohBQAmeGAfIUeYYNhuGM+qXmRmatomGpFWZfjuN6AeoSL5HUAPR6x1iWcIC2V
PZtviC57k8IcI1KTL78cEGhpvvjiFzzNVwQnfteNNsCg1snYXJbOPQqHs0bWrBzF
kv6z8y9eut3uCci+zelguXhCu4kpdTo6nUPvdmP6kfw7Uu3fG7DhkT7t4jDBWteb
vCYTEwemFCLmDr2eCr5JqFlzEkB93lac/kl8aWYTuskcnG0Nze4UwEaxgrQZbfBQ
WEqvYi5JIjF+o+oRTEQgblVuiWQ7xPIT6lbX3ec0jqav0tSyzNKSJGsU5twvIN7a
/gDqH4L4tN7u6hHV9YxM6hnvmB8mAg91IuGiWUyWB5+RiCqEnDcFv1whLf54Bf9h
Zc73SczrlxjrNj1943W62+zzrLmTzExdQurjSHCDh++uI0ipcEnwldncC52Xdqtm
9w2FlJPsADlTP/HyLA8utT/gBpBDJLxE8BmEM3NhphoUWfetJ8blQwv37RJwgWdO
Uuf+x7F/7BPgkzZpa/TLFJ+sUyIadJpoZzMQCDr1GEwMCjlmRPUS62ETk+sQF0Ib
MltpHN+cMjpm3UNb1hNjWsCU07afIGFItzbv29LhQyZkLN+qQBI9M58W4XdVfyEk
rwYir0mO8auRMD03B8aYCUhg2plcXlS0HN1Eh0sOPRla986OYyC4d/aK9ExofKO9
BOpXRWXRQX9/eKMnFE4wO4JxeR/rBpQkUxGnbZ6Rh4+7lrntrXbSTu58IPJPff23
OJd37EBtEb+AlZ0MBFABhRyA69Q1tkuKD641mRHD2B8c2qy+zXuRzMJGJl5dixMD
zpAK9h/WYPxs6W4kAY86socFR8KWVAg9YWGACUQAgdQoQhTGD0uVCHYIhcDzdrNh
uURCTard50Mf0MDb+lt+XYWmc29FZYhPK3QklfRn6MJwJ5H8UQydfYUacx09BN7l
ZJ1Gqkc5JzZWVHA/v8RT3QKcASOPBRCwPuY+caYsQSf5R0JkUQ5AwbghUEqY7jW5
qlI2eKwYvvw99f8mOV9DAkR19is43m36PDkPQaUVJrGqfPuqpakFZ4ExdKHQtLQq
b7CYsBilWh0KC6z98yyt0mH9zeQo/AbrAVS18hGZsale98kUz7VodQP78EBcWIZC
onw/enkpKEf3JFxQsvYsrxenOC3gWDcpI5Gl7CAtwqjqGrBWACuncET4OPLS894I
sanGhRhLtMMCIl92oSz44ay07Xsh7L+TPbYicIfgnlO7dyasocn3V16b86f5y6oi
+bjCKIfgEQ4ayIW+p67wiIT5KZvlA3XUeCGncbX8jd0ZsEvPb8RNTnWS4Nh0CbTU
fA8nHFEjm3wJWgITfulFKa8TedhFO+CMn8rzzlNBzacVrl4zR5PFfpbxHhHWt0UU
RYgF3WspkoFQ656eCZoVu42jQula8tgSGl/YpZDslbiK4hSJHPrt+pLq2OXJTeH1
NHi5jT6seBqiPmra97KBOKWe9RlNfAUuhGHEvEeXZqUI+wlARLGbeEFJZX0Y7ABJ
zGSH+zgt5SIq+5VK03m6i417+JBpVtETKlf/sxc8lqiazdBxX9DKmBcARdz698Dz
8vo4uLYcLShpFOfFbWhwYakF2qOMsitK89Eo4RD5t2Ar14y/tmTwiXyA4kq1AdlZ
eoAeweuC18o0lthp+iFHR2RJalXOBaNO/87BC2/R3UfN1GllPDhHZxatU1UVcEVk
hJRLcooVzZK9fIUXg6zqbH4WFcKJlRhmktfchJFDIZmlpr+AOB3FO+MbPZVCCjcS
RY4SuUfazXBf7DckFfysXxi3oI4avFnX/64LODdEJ5QeNkqblAIiHhsF5N4XhdLS
Z93aSJnhi0gpSRAIhyi50muBDGx/CqNmWGECnsXLTBn7GbpzWWpnSiRcgMNpviFe
z5rIxRU7Kj/ysXnFpAZxKwosfFG56vzaxEvX2/qHLdROz7DkANxw6vLayAIEFlcd
YLUAjcfgAiNG3tI97Qeth/klzju+xJj4VjNVJnWMqvnWRNmN91XipuI1763MiQBs
qz17mzBYffLcdkbJfQnhrgz+qURAIRLwMkjlAj4hjq2POLyi/shqnQn9WH8qZmiB
1dYC6ozGrWTlhqzsmxlX8HDO4DFl7AxvHlR9b4sAmvrKYTkov5CQN8z6pB/zfr4B
1dIbpZ8DI9UQ76Rvu0D5EBrOpXz1+R0/mo+AlFzLgPMMviYDjE0Z1irlpi+jcNJ3
31TjAOTuX3y+f2lMLB65y01LlvtByU//16eM5tWkEFtybgzyHJqzlq9U8kApjcFQ
UtQsfNgPCXur3ng6QeaDcBz75ZnuPAdFEOVlw7X9JWv+G3W6RBihaUghx7N91S5R
njytt0a6t59jhDFdF57HDK5otq2N4x8+MUCWWrCqZlUpCvCuBTFKs86hTippNoE/
xL/sXTjQEGvC3cjNWu3CcraxLgSNe+3g0a6dr0jsNsLD0kryK6TaSlNHl/vbpCju
qZ1fhLKBYZwm5ouPL1ZqvzCWRNKIVWwklNvxDU7xLspUA5WvWLwAsKAhkcUyiSpI
Pt5fOi8G/nSlAIR9qPxI8pwj2euPOynpkpPWOVmYbFZVBilVrrdIjm+7uNQgUMLh
VNPogAqjFyCpYULtOlTyZ/c6BljH4evTEj8q5l3+Guk4FDFEV21jujTOXDs8tC9y
QEs7nnktyUCZrc0mwC6sNIUzXjmLxyskGfrRz+HlhA5N0WEPTwwaFHFhsGrBfk/g
E+CxnIlIYiydydNhwrwK5vDhWmUZntQUPAq2z1VdpC7pPLWfBw75edcpQG9Nk+6O
LmUffALY3LnGodf8Xnm64vt7hI+ZpX2vnA7OVatZRfooAJaKIpOUI8ANYXcpaThy
Rhisu7Wl2X0URERxgmiaL9eCtJEZ7loLAOSRphpba5riVoD8NMzJJgEovvBePSdV
hG3QlIVGeogROwUQwDnZjJYpxcyQRg1V/67zeZTRp6lKQ2h6nGEVfJMlj/DaVhjj
VgXgrlBUXGE/Tf/iMNToQ9imf5XtI0Qv5Nd5Rhq24dEm3AxyNNFJbHLsfcB9FJg9
yeql6o4EHEhXy/DrWccQzQ7KT3GSNH/f9E0ub149pxfOu20QYM0afyydM75rZ3Ti
8SSiH+uI7VPkuuLlJk33TtpHUXxs2QlAJIEQ+S2Dr2KiCFNyW/Nndlo5c/8LAWtf
hxssvQDpKY20XMvL7b0hXZDQb27DZiZKoDb5Jw29E0orj7n1kNuwCWQTHj2Jq31u
CIqrzPf9lmO1rEJV5ZO19KWtrNVdH6d7qTlQ/9ub1jUdCq062b+gyEnokrJakiu8
eDFA1AEOvRhpLUi2NcZzzvmtzEKTP+MdHxSo8gwh7xwbMqJjUyOJ0dyRx2qQ6Crq
03azrkajZLBE14QK5eK8peLStlpUtIMx9BwmjSgtzgt58MOhRAlmf8enkwaD5T6e
ayC6IHRe47Ifsi7pj9rIgDcOmwy1u69i1XQEKGQh5WtoTpA5qlyW1SZN83d3n1MO
JPMElbWHE4o36+/o4Ywh4Jf3uWhkyppd7sia6CYCHe70GQNuwSTv4ZVtQZape54J
cW+OP82PTUuX6IE9rq34iiowsGGrr52XuguJaMFMCbHlK6dVL2lBNAfuZhPN2TvO
BGLyQY4VrMBr36Grx4VARfjvhmi7WadphgbOj3zUaXFsHsf9hSAH9T4JmpNaXE7Y
EB4AYNFdK8oND8odtd+tRGJjSm/qQ40Yjh76rT/LGi8vs7kPqFDUIglUyuX2zStj
Rc5Lav/KK8R8NaAjxLkJbI5Z5Z0YY82vSH50iymIouQ3KtxIKPvVSj0RzeizpbwQ
r7btzvuuOV2r9+MAsgMAI4/oZ6+Syb07iC4fRLhJNAQ6t3H9+qqcOJcmAWqmbgfR
qhptPVFnfk+Po62k4U78E66cp0yHwooFsMdfw33UsJjbwEcIet1aIiME2IatLej/
X2/mJH/jQtJbAfg7zPh8Y3Hn+NyLY7ck6j7ToUPobHymD4dKqPUEgTdRagCuIpZq
rO/4XPdkcJx5uFbbseZZYp7eQ5Wbcvsf82bSO1qNyNFbhCKujZYmz0vybEQ1K9Sd
DLA4p4uLm7T4gJ3gi847pcI4CyZR0aaInvrSjaOElX8pTAX4XPrpQd4l/bvs1Xst
eRvQY8Psmm8whSkuz64hqGiCgCGf5i6BexpTah1DxTLj5IrmpTIUDMKYxmWwYmkC
aUqd+xIuT0S8aArGa5SoCP7pRu+NuODC+ruawRQoXciWlcTVu3QKYKumjzcK2ofc
1bdWMGT0SrBI5fR4u4tzP7xO+DWGom+uU4BMwp2r1G+GaiajuvEvfpt9rrMZHdUd
iV4a9q1W2lVUiyF6bceFafOM4deejZrWY28muBXfYDGTIqtY8sJfoR4+0HYZWPmf
E1Hi/MeFVm4r9ld1jhSny3bBHfV6HtcsxGwgWBGfeCuk/6MpHiHxNhsSg+t/HLB2
XG6T+N86Q4GryxQ96fQMXf5uSS6mdLs2hSr5FMJb5eolYutzOfBJnxy+4DFJOCX6
t1PV7nhqTnmGEziZyx5ggKeKBLjCS5pz1p5p9cZTzQXyyJj76dFUosSViw+NS2pJ
AnjcN3jNF++eiJmjJ2k/MljoTseeDaG3aiYt4W6lF50RY/CGE5huaGDcwl0iIMwN
q+voeU1QxkZua3yRnLnwWT4G9T7PJZ7mAzPKPZI+gf8VKZt+szvJ+nD4sdoP1GJQ
dqCxtCdL9B6MyctKx4CuPYon28LoMZJR2SsbOL9uwcKCuIfjTTyz0xuFboLC2VxQ
twVo8eI1DNPzsorvLbV319fkKsW3KLf+k87CKoD+uVS7OmWoyObbM7SJnIc27/on
O6WqzL+/sLTOKJGAmPnmm2ACCSW0v/O/g/8LxEO+w0qeN9Ky6apZR0DgA+x6uIEr
yFYJCtRGR+468r1qdZUGVbJJ4QvY7zFeab2aVejT78BLUqNHn0BuRwgyboBMJZzh
k3mLcQ+IHCU+wrkCdUxSK+YAHdhJ8jp7E0C5awcnSa9o2602OtE3L81uZHQkKPnY
1xoSjv+f7cTYvSPCrf5pBgwRwxegaUpwZP8XOSFUrK+ojcrApmKnK1eSuga9dO51
LjFEkvOMx9EaDCVH42sNOukK8rPq4WgGXbOyIKQiT4gUmaBud8kOCw14RJqzFPHq
3y8a35NzmJ8lWp1rkrhVU22u/acl8xQV8ZLwXRwJIy9r7KInMydcgX36fzWCkV93
MZ406R1vEkXvIYTpwhryBmwrcsTSNQG7uZLshuIA2JkHRyFfYNtuLy00CaM3ftMD
ToOXa4o0UUBLvqCWKTeplRl+1vcfeG06bZ/Onl1h+hxdsOTHdN/gpx+wTYiw93/B
i4lAOyLcEPzO58MKFaxGpz3Yp6egc8lbJ0YrQ+7WtfE/WUWkGlpWmhVA6LMmoEgA
Rw+dbv/zfhV3Bi25qK/o4TATQ2fuDRXfC4JYCt2HUc56wxXASTQgAMZTXyftz5Nx
9VA0SZnJ5jxyn4soejQ+C13yDj6yicidKP2MFPjRnjoWXwQlUkohg01ibRC88ZBF
WTow7AJoml5kto5x7zT5AFN1EZOtAWFvMgMnNSOj1rWFWLlNVj59LT2eDnXBGYSn
E8nntqL/zjaTdgDHUo6ttxs8IBfnvKvE+jArMt3NGBR14er2vDHa+tnYNX3nj1oE
XJpUq/w97QVghU7/NqZJaz9iPuqY/hWPMnJZ3NGfJw+ORPqkJBsWe3bksulC24Yp
AgzWnfU/AkNW/Z3fAz82pQTD6P1edDW+MUfjkH2seTdT3O+ReEqM1ggVt7xtu1K9
m24auvK0pmDKJhXnL+u8Tf70iN/4ZrBCP++J/t38hkMhYyB6IRRi4hnYzmz87+Lf
Qrjju2NfiX41NNESVCVOAq+Ab05jwxaZ76I1XZ2+ZDK8SxNn+Bq+P//9sZqNBQM0
/Kycw1drp1mCmIYJqxGX0ennZgliO5l8FvWGzxuEg527TcU5dzHGf5dgiZ9/gnE7
05g1FeJUG5uqaY7Fmx0bbVcJQTMBx9HcUBIVFachN8YBYkC2+WnVezfBLDaEzleM
nttXxrr4psdqW0X+UgEAtyLFf+aeAd+cG78zZ9PncuKxl038EvLDGjO06bm95VeC
SuS6S1YbkIcGa8cbNbGw5YQLFp1FlqBQy2c2R0adFLtWCGCpawC5Xt1wvSDWew+Q
2NR+9R90VF9bBhCaa46Ulz3EG9wV85CSYc7YsJI33hpaF/f9wxgrJmkF7t6Dga5b
wrdwmVcp0SMgenzBX6/chRPbZR79nw+MIQPS2CnPJITFIZ5wS+4Z6OtPlvPKFOsH
pHGoT/bhAzrc1wlLwuYzDr0scV3iNF1WUcRskJA0C3e6iMFOdPjFb+bP3tHRDdPN
fUsZnZw4ZXh9q1cAzGfJJsLTPoXbChm1lp2hW4Xh4qBVNtVoSnsbQIxd+rb4IccX
tQf7J/isgUo2ATITizuWjzfntgOc58P8dTKuGnkJBNavwrYo5BKAT3Ldp2Q2wlwO
wutjP+z4VI307N1T5KYzp1P0OWBGxkQ8NSmE4rpApSqFlozzYAIITDYRlarHuowz
YGrYTlanabYxAGJpsrtuddiMwOTV2IEpYfhNZhtUSRSMJQRqaeB7iDt3uf985aNA
WJuARvVGklFIQBHjn0jiwJfTJZMW7UeS7wJl1ox3WMv81cnk4vxpOzMosFOmmtCC
Uf5mPN7d0bGIMhwgs7LufXQfOlIC1HASiglMLal3NE270o2421YRBlVn/hdsSvpU
k1Thq4s23wawVfzkxnKg1fvZdt1M83bBsvukC2pKJgUPMt0DOLacItjnUoN5AwnA
q7a1PUXpBq7Sz/m1bKSzMKs6xprzBWuoRCZflnKuoTewypMJDFGsns2n4Spld1dR
Fpbmo6HzQmx5PaZBIFkaDQUxOGeCBxoGzTLhIVUhZAP+9cwsuJKFNE2nmO0RtzKj
RmM6MJs7BeaeraJxDqlh/P81E6DGBg8tvQKawHz9Cpi8Jgm2nsAArdoN3+7Rayun
oD5QqTF6w8hmxsFoVCNIEmD9beL2QuXtosOWq5NxxggZfg+koDQOR44KCD8ETJ7B
XqbjJlKfxPIrBYRjQixkS5pREveYW4nLLsW/1TNF1FJnCadLInbSqyfh/oQaCVEq
khnOaNK+DWt0kZSNq+wtOsKaSPU2/SLXCwe8cx8BDvabsPC+3PamS9hvIi8FZESS
D2JqcMAYF15NUreU92oM5FucxFLMtg6pfE4QOjY6MtMGLjxs2IWLuAhbVCvjoH54
6/OtOqR/da7lkdkZUHLEqDfsrzY0m/Hr0lXQFkBcNYcHfQM2qJqA/eqe2XfUSdvn
KW6JG+DcnKritgjhJpYlwSU7U2s1dUFThxTwLRANJu6vLA1m5kBSD4Gy/M5sctU4
Hw3yo1AFszJaFb1Y428d85wxFheoXI6ZMnTRIlcOwascvRH3gV1FuTUOAOxVaI/r
DzSsBRhTDgWFIQE2z+8mFP4/hRpmf+IE6jeUYP9lxQH3DC2B0KnwviFHyIZ9UobF
69diZ28DTJ6izKQD5LKUQVeLG882TxRy12egXnCY8Qj3FXhLNrg4JDn9rhfUpaO7
CQL3u5eiYzdewO2NELJPnPUdpmtPznh1CZ0s4XHSjWcPiq0D7aePIIhLQZDwQJqD
eZbnR0Yq7Hkq7cRL3AP6MvUViGFekY9qiuJWLcR3cS2OZuUxM1MZaUly+yEJjoFe
oI+Exssrf1BM94ajzDgN/hLOeX2AXKJ0+B2Ng6ng3sJfMTEFagj0IugcgKIqcvro
lfvMeE5i7oI0H58QO06rD2NNQYpcfK4qbp+N0HbFHNhQcP1zuw0rpg7uPHFnriXV
5r5Ma4h8CeoX38CS4ZO9bcKkZv2On0+rmvNjtvwt+jHKb1YbItgklL+yaEZx6Xdc
lTfCA+H+IwPxdnq6NFkvIYM/mG5RnDs9uGX5/XSPT409+UUwKxh9VJEw2ViukLvi
G8SE/Da29+KA8FMp93x8faZfDUFiVaoDdBXw7yGBc7XWRg8GgZ5kRrlQUPd5ZCQI
mxz9ht66TPWTzbbo2xaswUwBMFDJubjdd/QySkWaMio0WA4FX0l3gYFSxBrKo+m9
dShMdaCfRK6OpkAolG4U2MS4zjXgdLlhqaZuLzhoqjrcqO2+g5tn6kdl14GqUVAu
xjUce8Ur2OnlYqkG9dLdcDQh8uvvle9Fvpta91tSwpDQrMcyoTz4HpogaCCOZEOq
wtgriaWBNjggNXfgDiIin+nWYKFIJtpmpfJAojGegFSIUS0nis5F2P0Xh3bqSbaD
2slVP4bsRE0e5254H+jspzCeGjlzGMf/GKq5ayp2ayve4S8r0ePp40YVViyHds6t
c9CUzUbNYnv6UnkoG3NMvOyHUbepJGaEcRzQ/zL9LDp9EPONgVEMBt6Il1ysZfPi
brjfeT2JfxkBYzevQpsRZbaWlV2daxUfQxG43BNb5Q5ModiqNUPYzjo3lpUgWr1s
Q+MhniZ2xm8VRQi1/z22dJF+fbaSipSoGYfhdUp4t7xv0fXX5lRQCp7hDwvQEgX/
H4qX4+YEdjwhthjTG066S4LS+pysJTOofa7N0+Pg73AC4hBEp/LTfE94kG9YV7n2
fbbMpDond6pwHHed625LOWZX9cnTu1zlAyuHF1kIOTR/jQGpEjXhgaUYpRIaov/M
/WWQPc9AJ4vodtHo7yNz8cmvTWYu5xtbUL2n8uqjL9noqo3++UX73MJb/8BjPDln
5+iIpvhbDZv+UMvDUG12WEkm0RPY1DtAOPPWt5BUweO2ARRJ7rMXRPbTom5/2LtN
Km68H8eAqRIJiA9hDxI/mwCS8UF/uZ2HG+d4jEIzCAJqpMI+jwkwcq2llY+E9LHe
uGzb2u6n1iYAaakX79A4s3gZIgUn9N//bNGm+w9HkhtSotbSb2ZhFgTF5aGy8MVv
nddaKIpCQXvqJaphFgEEIKHU4ZnylHISO2tyhpgjEVHkAPo6PIqF8c3wZbxkLG/B
jU3G29w9dR42RRrEq+oa0wX6ws/xDa8FGChycuS+fIyCGDJXOsCQZ6vL4Bva8QG+
tJIy6RuofsZiiG9cYSBxC+TaWlO85jwZb/6E6v1Mu7ySp3aA2zbhuXxOzrK0jUPm
yxcVRgk30qWim0AmJUgxI3CrWPsmvYUCgpHs7jdExyknxeXVEG+vtnJbEUzzu5kL
DYwu7qYkcTEWI3p4hr/ZbPLlfHnd9HSSMd+sTmxVzVSMSmw+Ti3WMVEjU0T7cFm5
G7XUx34h3+OWPKuQLOBBA66HD6Ngul+WgJaCD3l4Sdx0jFg0olxnVcoUTJmbL9pu
aQK0daSvKRnUq8A3WJ96r/KbJMZ1jIeYd6PbeEo4WFDlzaoaBPslIL2WEpOssJS3
/y76ATuW14diqJBD3iGKqwGY7DmiwyOWCPPy6TEGDZ/lkesVl6Q90Dtx9Uni0uhG
anaynVsRR5msHHPwyk72cJwP+d5t2hda5gub8fo+ApR5kg9uSoq+5NHC5uo/aVck
e8vI4X7bo+4sgaBrGhi936ZuZyWLBU5kv3j4+37Ku+IUXfdidEiqhFy4e9UrfYXw
UmtLWehKkrOU3hDVSdgk8MJ19DpZYfAq5+jpnrJHxPO3zXFwUoXriiBP2DRr+jRB
6NFvDmrnJdjFGbID92SZM+v5QxhFaGQ5+1RKbUQW1kWrpQ4ekbuzIgSeLDSo+ZsU
YPwoZAK5SkFTKDEbvw5h2R4WtiUGujPAYsNXfEwFTdEGAbviXmsBEqzte367E15U
KQAzboFaxoh105b4sYV1bDmL4Jqfs48/NzwsWOpHOO92xUIOhpFdtFxhPrJD+yGH
0CPbF1ebNJfPE6X+nJHfSfxEHckyBplesARkZTxE/SyJC6F70YEXWZZgL0LUuFjn
JxRtQ8Ihp0i0Bs7T9VNI8wLWt5crmpEMC7OZVbqEuSDeBM4cHzMSGs/IezKI3lu/
KQLtVEMvmMlschcwYaCzMcOuvgOaQFZ0ZDn6vPuXcGi/j53y0n0QEeKVKxc77Iuc
3JMmJ1ozjKcqiZt1pjtfh0/iuf5rGDapEubws4oJJIPzSFJETfzKAQgomLQF+T07
8kgNOOTI9eoGCuVN2jHOldeMD7Crcog4hl4/1/PYYjIejn9WBM8yFpRnekhOFkGo
FABu/sOLaNlB2FZ5qxaoWNg1/cjsDr/RAvjmAPwJMEqUJNhSmmm/058JOPuqwXzG
l5XvMLUONbwkK0b1sy92Z9ayvnxJO5rptMox/Nd/AH4CBjDJnVc25NzNLiE+FYWZ
2+7FDbUO45//SflZaVRROSBoJIgwg6E659NaWVFs7FgPcHrk86U6cTl+F7AEQHPc
CJRkD9/5RzVp5TDM9+0ppltIGzhNeztPgl5BHN2usmXOFJpaxYUcifiGv4ncGEpZ
PUJegBHgh95GfNXAvyJRKKDgd5xNFV7AI+BzfnsHkt2Wq2ddmOvYJ7/e/LpoawMC
lFbxdm0eEGoRNfWhTRvFlMKrT6Jha0UNO292R0IhAHqzaLISj15BEITCNLmuoGV/
C+AzruzIVwYVuakVmSBuFDrsQ/CWL5WyOGPJFOhk5ZcOr9Jlj4yPJVk3FpnF+OcQ
MyLR2KZOofUtTBnSGHXpm4skcPeW793Ek8tIF0+LEbmwF4ntc4ObMVicsz4F6pQG
77XQvzw/t8MV38m/+odK5k0M+nkx/57UfYWRi2YElaUqPbLmCZumyBvf+WQh5thK
/aPXrocV4LhBfe0vaCzC3ocMERfKd3EFfPx0Pe4138qTTzs/hJ5br9848qka9hRP
2r80qKnvH1gDDnyIbVlec0vl9A08z56DVa0HhMvQl1hNlfpZ4+XT4rK9t20KoNiC
PBWuf3ZYLUbr+zG2luM1fbZPfCl1hwENEsFf3sbymNh0QZCFKCVZW67K53PKVhvD
DH657q79QxH/1luFAdlv5wiDxqQxvXvStcEvmxmLlrFXFC+3FUGlX53/hi6OaCcg
Ci4nN2eE+UWe/lhTqtkvtyNnaDpWvdUBYeP+10gDbNIH/rN5ePlcJMfwNbjKevO1
7Y54crHLKXBqM1vI1oK5i6Tf2l7EP9fM56/sIVxyUI7Kw7ncPVpLAhsmwD6ZR8k9
wm+A53+JzyPE5IVY7UAMDsOR2kudlYGG7k8WFvbunoR8Jv+mcLx+uIY6hqWz3efU
4sTxdz2d9lfPh+hTik/agnyaRjJ9aU+f45z+IMBRatRyvFLF+4yQyxgcq7wuS41I
dN0/zbDZ7aeIDtQ7Q8b0xRZAj63/p0S4zbVswIpoYOcLdTEVrY4Ddo8J1P5zX7Ai
8QXjV5eQx+3//c6fiJCiVMZMvEC03g6wz7wmUllG+DiUdez4JKZBVxi0kfWZ/qql
S2InrbgsjntZp2MTCUH+HgxNhj8JjZEc21KFrg57nHTzrJA/6zjE2VSf9huHles6
CPZe3w3uGk7jzcdpquPzzl9GZiFaHZvgnHcc0zTSjRKdCRsGXIb5wAHfQTckn9fs
SD88AdhJbrCFE8l8Z0gN9RhrbPQjtweydOWgEaO+ABqZ4MOhZQS4790ZtLzPzsyc
u53bLA2V8mUseVFZCapJwODzGoZudKOzb5Qsy2VDC0+8/f/ZBz6F+cuxOtzQO1Ha
ef6mV0Hax9lKXUC84PnguATWQWybEpuB+ZIEUVD+qNGoESjusZJa2hQ/LM3+jQyc
WbNLnubT8j9LwZFA3fY8FrCrGnXkr1zB8nUMeG5GIWqsY5dhClctUfgc4Lm5zz9T
yzhWRMnRXrjX3mzVQXyR/yZGIOiITFaBtzImkUi/tHGNe8Two/GyOhUBjzrTECm0
cMmIrve5r4OGdM7Y9nnGca+OlcQLQVRMWML9qxrRNo+xNS0K40FcAtqiuRcHOAc2
Wo+mQkiIsLT+3LugtEqYjNT8sRnNqKs+o9FMP1rGJ8npOsrsyNtumAGW/H6Wcrdf
1QP4Kml5ratujzGu5gNprfVB7rZu2vcF8JDEPOXaZ1chOxzIA9XpiaiAz8sER1dT
ergaPmEAT25hy1849wXiRto8OjpJFosdauKZFtc4KAnAOSip7jNNEGM+W3qMuint
ecULFa0fbUDX6yaTBCoMjF20lGUEZ69tl5CtJLyCAkpqqnW/HKKEpc93MF/S7KSg
PO813WqrBSTP4tJWK8gGqwWIWcpWOTQOjWxMEB1IhhAPY8YobLVK1pEUOaNT+GvP
j/s9aku/xPD4e/iXr2SNoRETZYSLnpek3G1d5QKsccHwDEE0Af+0VUdS6xznXTA7
lKwsW10BNqj6aNU7zbu9f4R8jCQG9VD7qc7u4nQFny+A1AMuurcENhjU3WzmtCgW
iBTOZikQLyjC7Vz16C3KrWsdbCPqg8OSqb9NBUr2B1Ly+n8Pl/j+lBoZF/2Fh6o1
xghH8KOq/BRZDecPQKHlyzKqGxDE2Gny2tUB+LYyN5ifPzv5uImmGbTOQt60RgiN
d7Iecudya1WP3ZDg5wBFKmJ/phs2zfj2dGJQHNTSZBs7rHoYv1ZAd08S9TIICXIK
3/xlM8wYjE3jrYRJL7QGhPR+WFWi6E0SPBtJo/dCYcZhiHpHEzVtuJkNhhreSLUy
UBOnZGMYDchYOluGIQqZt6Rb668B+7zTpYiQTNtnPgTsjzSIAJ9R7Dc9B1A+krBP
qayXj8Y9yMkVXZUuGgl1A0TetRi5X86pBw7/5AW5GDCxJm/qMQ1RxEdBQbWXMAbE
FzA7JW2icACNIBJVMIlrDzYryKwuvVK/r4jpBoYy07Fp33z6BBSi32l3m2Qpf5Qv
nM7CfC34ZtFfL4Heb+WQgeugP2kwl/jdgJ11Nhg7LxIDasvYpX2/nVdY2BvkmBe4
kAfLA+BRy1mQjZNE4+9/1pBT8h1/sj06adHQSYVm6i/hXkeat0KO/iCFrBrMhnly
Xz4dxtuE8QfsWOSyv9QgBOgYbVboxHuUTHU27zjDxQbBA2TeXTonC+xQsL7EFG6k
NGBpiOaWOASoj/FH5xm7L+gHrmnQPzjovx7citK9j0CKRBoZMl6CJS4tHfauwGps
qzHSUNJ60elteHRgRUgS44LGuEXay/MNDLtZqlRv6nyKgHlGO1YEQ00kAvHdtDbR
+4XqXNkyyIcmcEnUD6VrrDzMPWUL1q4Ss5G+G903KwCj2Bq4OTkSzfpeXmUGprLU
OTciM1I4iOVAZdXaqO70MV9payJKamm2BwTM+lRK8XGT413OaXzkYxNdniBdJaKa
Sqa0BwAjjMDR2UNy/CCC/BJSsmEb9E35S/8mfSj2BG1BNy/AcXRb4q9jPY8ngkxZ
aP+eGD4vHYVEXJw1GuH6gzsrgphVDoNkgT9hU0ytvt2Bw5KVxKp6iPtYmGrjRkqZ
sz9rMHbSCvsB/43BHt5MTJFNnd7pSDcW3h9DnUxBa87XMpAiYNJDt2/v62z0xIxN
AjpsX4bcKVRyyxL/2LjHf/QESu2ZfqA9hYTvNvF1QxdAstzUeFe4MFAa8x+/SBrC
jK1lfply5QU+h/nTZqKlmyCmGD4Z3A+ELG168hb7hS/z55DU0K0/oIm9EEUkHtBN
MZwpNPrDkNeak0Efjl+lXVz6EhtCJSJiIBin1IxHaXo7VclheIEXFepIoYLw3Php
dtiJXMooGlg3g8IB3jFxJI5PwHogf/A2UspWSH5k/mh9ILJkJByrEZx7ZKJf0hBO
810oO5afGot8UCpTWyymKg82XdH1oFoaGfuWpI4JvoBabQcVyhIehlTG7l5K17Hk
T3oga7ePbRlrY6IBoM+iFKbNnwDNk4Msa4VrRgY8BnSLCtz67FCkg/K8Bm6/4NmV
F8/OVRAQLip4FaVv4GpOA9pNWGzrxslFDesGWPNB1WVFk4q/4TaMXIaY3+h1Q5Q2
xl9iG511ye3tlzNtygLTZ19qN6dQqX1CZ42/PmJvHpvlbCqO9TG87SNWFsjld607
cH2R7dMaqTRGaJqh9gXUkjfZbsM2O/0BpaslY+gPmaJOGnRKpbKVQYFvqq4hzqRu
kkjjNnpwLxs17Ep/NLFyaTLD2sDDekz263onhQZa8ALq2R65ile0Ey1fIijDfB39
FNGMB12J5bTO91syG6kehVz6joi9p50EeP7wxJJ59tiB6kPnnD1kGAPY2Q2xSzkt
4B53Jrobm7f7UpwbwErLc6JsgcXJiWNQzzmNTL+33ks8WPfUQiWaxIUAekEaA8YI
X/n/RXqjmKqyTO0R/rCWet7k9jGZP8rl1efj/xf2RoMxp82gaO9NbdfLXpkLFZxU
KVravL0u6tJd0a5hvK2mNrELpCOLdwwZJiDYo46fyIpLKOACx7FaWhfYlfe2p0f5
FtK86ZNbSWKoTQjYQ+HdiXdVlh6WiAWq2MfLRryTJxTOWMei+cjUb5V3WLc7WHt2
/6Wh/NuYq7ougDnNtIF1yFUp88tYaYHaepdMRzjXVScjH+QGn30RBtNVPsGN43E2
sc1jjfIrbydM2ROJgCU+beWGqB82lNgVvYW/Ij8jiYi0bgLwhVSYlr1EJZO95uWv
hIi5LpJuHaBbs423fe5bbTAa+MBxK7oF+6uGnT198jXl9mkYNB7/a12ICIdphfFh
ijgO+K776Iu/+mudLXu8+J6KhVnC+mq9La0YcIF6bTDNe6PJCSQRFkaw5mlUtLCz
7ynZhkUgz+/+0mmfP6aoskOVR36o4ofiQkUTZbSlJMjkoQ+uXMlnshB+HzdHaV2m
GPkJ2G3/4nYPH/FHPkDSln5jn/XdRGvPI527APif+EjDkMTnbF1C10KN5nWnHFIL
pHxPyN8xvAbKxVRz029n+5mDtGzJPdqHm+oWY32MN508qC0n1HucWdYhEpXY+LMK
Ea39QJnwKK44PRE6YAavADPp55CYCuPvmlZKBUYF0hC0CeyHID2b2E2ksuvSYlLr
N9ginJcQsGiM1WW9OXv4Q9x8i2+qNdPYMIa1X/YauHwKLYe+eleATwXbDjsMgFNN
ouhDkhuGF7WoZ/H/Q3Vl/EYkut8dFL9zPhjLAsHIB95skcDE9I5JCbkHp7/GDxCj
Jo0n4qT9eN0pixUfMst5uKyI6jKzUjKOEGa9eGjtuT6vfkW2mRa5M9icSpSg2XtC
yt1JUDWHoFiPb06Z4t8t4CBoCGhIxESW6Th7ol+lrFjKJT6e/W9Ab7yfevVA2J4y
BkUgFRqHRuK0NPgPoyxIIdKDLeHZkDXYUsnYlvmO/jtbHelXPIIYRffSr1dldj1E
5kOhRb37yl8NsPUms5GtZbhViKUUacsOiEjVWa7+7sj83nUj0h1MCRXlnL3mdyR+
qHfR/DitYe+f6K4HlznIjdm3CJX/en7A1lQejo3c17huABz3u0+LNYPAsJ4Dh6uP
bW/GI0Qf8/LzuzAoXRxQtuj83zsAgK8gKSCXrAMnQh7ckZCm3LanprU5U6D5+tKk
q6chBxvnyJHs+Knj2kLBY3ceG1wN++QB3zcfR2YNnVVrrNGYJWuak/JaZ+us7CB0
HO5nkGXFTlt76uyakee99SjM15s2/MoAiI/CcTb6louQuVnStIDXUiZhB7PuY2+A
G8LIjWhzkXHuOQBdJSHoSpP/VY1A37mkOOCtTwj5EV8rSy92em+7wjqowVDZnxJA
+nPyTj84sWMWu78dJgcQJ/6XyqbSOR+aLxZRRCIO9yzJKLSRO2j7dbgBpgpJSH41
dxAIgRSp02ctl5uE1aPANf0CJAN1Ve3DdhahsriocjFQ3ZQiz3L4LphCnTcSpHLA
K6DQtuwJ8/ao/3brz/b2pFzUhHmc7E0cVf/5ItJDnPih88ffdnZ3EakewD6JQR66
yTb2XGaDq/7F+qli32/hscU8x1LHNIioftSPEcd26m5fJWuylIxBQKaXOhySpRwN
O0g1/aDKMLzXP9ZyIUFQYERxcg14OLHQtaz+vapwI0ErX4yygb1IV5NsCGHAtfzw
a2WEDQo6hwWwf3VUZ/f7sJgExDR+hbVcScAH8o2q+UrTnsvNZWWt14VHJrIZOBUj
iUeOcOw0D3epA0kuRaJ+CW3C5MS0bLHCNZSdsBcVJcY1nLu9FOatiZzFCc0fCbbF
dB17YHXqvmtlLgryO1N6qzo6qGFZCcd4hXMeN+ZV0ylKLY5sSJ2IWW7QdLG4h7KB
MyJdg+gmvKN4YERF9y2oduyeQOIeiLMzrQ/jLRoGoJE0ZKo/OykJaYFuVvybzatY
ew6ra2UwLTfekvQ2WHA7QVmBz18QOw43vNXNRy6LdW/G5wz6tyLZXSFPWdpwrIag
zpLPOJF36SiJN7Rv3NzjQkK9B5hHsMwmDPEsk3LjbFALFMiZwToXIKQvhN94akqY
PiYYpF09OETJRYpp0y2nLyJYd9Kjfr5NJTECJpg01oingb9T091chD9biz9D1erS
NotMZU+147EJm/xMvS80USR3TRpnjmoUxfKtUXWGmH56ZgAVcNF0ckIATvPOdC2h
2cmQjlRTp06keLBTCnGjfWUTGvZDthQlnuiX3TcJmoYvWDHHLhvNt8k0wPUxYCXF
P2l+xrjtfbidydCKRcncWYytxu12+BaWE1DdkblG1l+i1CApt3bCfH9xN68iAM/m
qcy9P7A0t1lt9s+kEgxgyBN0POX9SFBqfGEfgmr4yZW2x+xglwpwXEiRVwxtzKON
HGCWxz6kAtuQk88ZNmY09zQhHzaxAWbDap3+xgo9q+JFLWCNogoYxBYcKBctdcyC
WTvHet0M+sFgwb2EnWDBmx6IgYO8/Zrf7D3Bgz5iTozjS9sXFgyJpSfn8x6MgAXZ
vS/OP87wJr9wJfGU7K+K5k/1fhVFYzvKcqYB4NjdkavlGre6yKHlXgwOMzK8YQzv
2pDpLaPpceO8GEB1xYazMk2SRKmsAfwW0POtWn0jMUI3GZq+yROgIlsLNqm4Fk0T
urXi7hueSxxFFbLTDGdJiaBZrJMuebVRwv+DoC/PcXK/OfWn4M4JUNIElEURKxbk
/sNRcMgg8g2M76yq/DmiuIVaMTjuzbtW8WGvi0t1z7me1wJ3j34/+x+JdEdAMHVZ
vjrvK8vBthNzmx0T68ISU1vnDk/C/X0z4AIAz8YPe4dpQkeBqLTnWANBIcthHx8i
9dC4b3DxsA3zKOtnjxxUf19pBtL/eLdvW7B54ak1xLrWL8yLUPdSKN8YTiwZK863
FbBNDqbYOcB0UVNjbNKmQBFeeYofF5vFlnHe03uCPnnbGgbCco5Vs/9bRQnw+pOE
Tfu5frqtbYzSKpuc5DAJGsmsaIgJ0s7XKhaY9FvOe2zv64wE2XzzJr7aO4sIMzGA
I0xy8RzNChYwu+ORylPdPxG3AFm0W02rviR0n3UqTPEOBIr0MhKwUkNiL3gq/cfJ
PKddDFPd7qevZ5CW8SD6FLmFLMqSq9IfGTfWssEWzf2/OVAgir5d4kPgurKSHWsc
irWs42+z8inpAzr6ee7vz5YNAJfNPHvDVltjbFJQ12F2TYSvtzoUOKPhWFPISq5R
HauCSmem0blj7HClLtxWlHvzgauxRFGciVc4remPAfULx72bd+2rFYP9RTbqVP0P
HANvobgVcvmGp02L5xY4/vUZGsrZ7Y1PflmQKxleGuq51r/gmLQY9EtLZwj6yJSZ
0PQcV3mQ0xrTC9l/DU8J4S199Tcq5ESsbCf3wuEirDWW7sHddTPT6T7aY9b+dTyR
Wmh4qP3CFGDPTuEAgTSepL0zV7zyHFuYLPFMVDz6TG7tp0kCzbFtSbl8fbYbGuAD
QUHgvNcFcNmLBOlH2twt+JWQrZJ1PAtFTraahANma+RxLZ06+EGkQr2qxLyaK5Bv
5N8umyCy+PRSz7ZTrKS/v5nzAjCleUkFuFv1y+mUtKX2zBpYfuYzK3fo5oH41oVN
EfFwZYt7S89PagGy9OboLOiApzfwR6SpA8zGR7Csrw5zKeTK8mES92LQp2pAThz7
rUGnzn+4FSOTIh+B8qkSpIEF5xJS6ONX79eKGKpgg59h3wqWNeAkvdW1aT2r9gGu
u7glKmhzmM5UFJSEx51ChFaPYXC4me5MHgDXqXlTB//J2KzfxYM1LgEEW9/uThEY
gYgkiNvJ2OwBuXP3fbmHlPc43FTiyrhXjgy8+7h2LZFN1n3GSjHf4xZVw1pcvla5
q2DINbck1cyoPWPTcxITo93W7kz9PQqQGSHELUeufm1CGicQei3Z1tkN+RFSC5ut
zDDQiwQkSEH554zXim6wOnbaHhyJi9j3WRhmzRo56sUhKQC+mGmsYpAKDFir33o0
eI/6gPz/35yGA5VzFYHMwAVD9Sh0sq6XVaZ6ewAV0TEa3VlaFHdUOEfcYkjIvFPW
A4eU7Gou95eui7crDz5eDVRFl9R+o5mXRwcLPyZ2ORi5JexiWDyP7ADQwfm8AmBY
nZcDcg2sRfEkxt4Y6l7n+aboUSbvLd7HDkYOvEZZhgzOxny54Ly7qE7ovieR3+qX
6gif5txh3ZAyYGUjsI1JX7BKW5sEpw75XKuYzA578gwFSlALp2CTYKlo56cb7a+0
tpFbu7U3PxizQpqmgF2czv8a0+YB06CbekUuKCnUzr268Zmyh6F3FgdaeS9qdaFS
8IWFvpv108E8oDTQH2x6VJURx1qhAJ2QMhHcKusJN8wXvTm3KFUp1bTQcerB+5m0
2NAGL+bBvIK/6RQquJZ6WK27vol5FoMnekxaUWIajtCrwTHPiT4IWckDJ0HMq3u8
NrozQOfKtz8zoT114tAiSSMrwasidc7DdKssvuq5aNPSqGCizz4OaHGIG954t5o6
Y53QayxUEz/dMy0oWhIwDE1/qfhR5I6OYplw2AmfvKytRz0xAOIk+ikiLR5Ei+ZB
cjdjJuHO0WKPSkLgV1j9a+SiQK+D2rSYFcXAjCkz/t5HRgkbdzR7FmLSKAXy1wpT
utATtzYSG1R8McllCGEnxIS7xZRRoSsBMCa0QNj/3uLJK9piI2YmyNF5yxIxW7+o
pQsGie1tJYkI9i7vbE0v7YIXMQ/l29tBumsBOUSGMgb24TNizxpgVNbbb5bbs+fu
x/1WawmYsoKGaRnEeB7vjDGv4DUrKNqh3F0bzIm3fiFc0SjLOafmh/Z7JXVGDs6s
22/qH1wAJ6w2zp17OU/uVMtZ051t1UucN1Ct+ecIyBnRjPPyjYRRuQzzcQjWDER7
nIKA/NBDJ6NqgQ+jcKLiZl2VUT/3/PG/KbiffvenuUhUfYzj8EaTGIW2vufszQsl
XKmp8HNfSUIn8GeCwYuRBBEra/D4Zso/yNnH7+yhOamrcjMTFfgyOTrVN6W3Kj1L
WHj9O86mJOMTK6WGxrpBzcUZoWfFAK43AOP36/5TiT2+bqQpZWnDUfKp5mNQAUg6
ZruJFlPYyOyjx1VCfcPp51nqcSIBTCmDxfDaf1K2/N0xfcbbFOpQpGR2FvCs+Wg+
GqzTpu8HrEYvyDlM1OKOQR3XUFi3adk02InqH/EcwJj7FBLYSQu8egyZeKxitoU7
XVGHXJHz2mc+bnk+jLQGkCFuPfLdBm6PcQuFs8wkLPolVsvTEyCQx5OSHlZKLkB0
G4d7zo2GtLy+rlWpc5rR9ouc9zkOR0/0CPaT2M8obrI5lrV1hIYJHuTk6cGh/6qC
rVgZpiAu723lQgkRerHR+u636QCC3oJaUFC4HO8UN1vTPXLVhE6yjnR3bQpGnoEh
0ep1PmM9p4pyX3YshMlN+UqBbXzGdK274HAQEdfrZcL2HZ3s+sXxRwG4wVzP41MK
Xmj7FrbeYCMXmCqrgO/W4BO4y1rXakLlEXFOrBPIPJwqvjAcgHJDmk/unI7jWjyb
PARpDOrlFWkJqm4zdkqRzvOwcoRWV/bHrmAEjNsEZwFs5btxyxjbaZ3jP7YBiWhL
Y+refDSJf3bJLrTcJMH4s8UJdgZkV3v1uI5hf0YIvmekkBwmHM2EN9SWZ7OvniBq
CJ3iz73Qsjg9hxlaTOPXb00kCh387K6XuPpbzhYnaw9pZw6zl7vYa1srSYoMyM8m
NpAGMLpsfcBjWZEUJEOlIca6pNNDWsLK8OWr6Cplk/0urHQnFStpgXYRJKz+qumc
xOsr0butZ7WlenAOTp/dFG7eh3BSgBT8LxtrQ/PFRehZ8Zk4f3n5+aFVVZZoxY9D
iIj6GUSJrmVagyTOzjDD7Ll9T5MPCkfy41v1/CS4CxpMdVKMMryS05mABJFci2rC
Lyw8PajGeqfZ7edN9NJOI3Gy9uRch7Y6r4FHgNxEzJw0MOsF0GmkjwSCmNuelebV
1IYIK3rYPOZDcRKaSiA96NCKdPBYYCKxQgAEN3Sdri9QQKjCFopLh89e6Rbqq0is
vf4CGCGTCyxFKhy5Vkem1cXp6fVRbqoIpq/rSu05WZNXNW00GJv8MAXY6dsMwZhH
ynp2jZnP3tAe3s++fpkdVYesLch22yARE02ZFzlUiP7Svy849oxeaaEMxqCxSzCe
Gny/IR0yLDsIy9h3iZ39B8q9boKYsfhjYf1x03u23/BZS1K+VWF2nxmgLWyvG+UF
CmEPEOgqhP4a0DUtwFmK/GRSia0nmBCfYnHaDmeC258BNbXHfn2jl/Y+KoJywWuf
axXutDfBr3axbAMAvJumELktNXuQNt0LAjxzB35VFBLAwHPMrFaYft2vd0I0iv48
6ZC/v+/r+dY9l42dKChHT7Tz3PR4Zb4bxwjtg1isLwT1SgglfzoAHtzeFxPA7IAz
sfRt0Y1Kn9iw6EAWi8C6c/mLtykAPOO7IpG6jxTuMRo2K+441a80da2cY7OqUTjr
d3Q5Flyms35FfppjEAY9mVB4VgO8SOzzG1q1I+tVWJfesnumGXeG3a3y6XBnfmYv
Pu0wtvaT99uHs4xHkVmwwZA3W2lgbtA7nnAR+6HpXbNqJ9T9CnxsAJhTcJy2uP5O
JNsn4upXPMUqSrMMPy1bIT7v+HtcDtkOUj7vMlayLx1z0GVNPJ54cAKTNblqtPYq
0O5gV8FZ4/ckuG8E1fztCWt0GqacECK6l3sPylsDkRXabQP2HJSKRk8BB2bm9owO
pYwxciW5IkuspZ3AcKsyylM1zCAvGRMBMQi2UsPLVGiE0O9tcyQZmogxL/j8Pwys
tVpIhg4vR/wHi/PY5afvlPz3wUGYmTu1MQO/fsJgec1GTCL/+Tcq8VTlhkPzGWdP
QQtJaHwroWzqaZVvvItScgJ56R0NQgoZOb/oH1nBN3btMbrCNbxg+PaMRpGxdbke
3sma61JeSPzba+x99RhDRzUsHppyVazpBZSem8za8dZDKdafl7R9QYkGmihwAgim
XB6mU48nJLCgbFFxSlx9zXmCVWSgU8HAGrtgKq4Q3JqU7Zg1Gw1O9yJnDaC1v9zt
4US6Q2KXy/lZbF32j1vuW3O/jzCunqcyMsLpxGn+SwEZCZ7fz3IDYi7gThfhA1GI
XUcnNqNeGlIJpV4o2Z+0fmr+dJ3UBhOT08WnZpKa6UL1iTrgR2gC6Z0zz5mAOahh
p5cVm0uw0/KlxhppjHNqvjHVy40PAUrvNEBi9eaYT2FrFZDBuhcAESbydNqM/nqq
efl4mr3yx9h1VMajmx2JLXaJw3PPmlkrCkzjwSuPkO4JYzeV4BpX2OBJe+36BVzP
JMHReXZTRELzc9mSnvbUqSu1q14thTJkHhb+oOsEResZptEXKWAD5JiKoTcJQTuN
yIYKxIbzPEmlt2yqxAwcKYEp4XLrAyPZ9rMdIY5kWJBzxdiur8jdRIb+TfP955SD
zkTGND2Ohn4oP8WGKmVnN0i3FeA3welJX7Z7kWW31jH6mhNx2BXZBWrSpRy7KeKv
Q5eUL88P/sQMN+GrzPNsg5H6ZpFiVPmBgZGwUMlF32zHAbfDR8Frf0Vt5woqGOrX
pw/GK6l9WlcFZvPtjbwMDtbr8pY8evwE57Td6QEa1IyjQs+pGb7iSViwef70tm3T
5Y5bQTMPk27EjtEXRNrVUKh04Eful65fHL95VWeHV3a0ANanR/XbEZNvxiWVyEuu
53rqh/Z2x4b76Rh0d6aIIXTELR/bNNE2/s/GFgc7wf846WieVjRo4+X7sauYbYRy
B0/PKzVhE0hZMIc+6v5/EDmsEkjMu4cLZGveOOUw4gEPuiM706iBhNb7G7ilQ4Di
JklKCz0VqukDfE6U/FtE6AMdPVC/jzzYq3uKJc1ijRGVb+FIzp87nvinNZIpKYmm
jkO1+9vnPy7OHtDgs2+1ufsm/30r6rYPelSi/Mexz/pKrv32cKvHXV3l2wpYMLa+
YGK0yXmstTM5Vbif1X54iQmxeclZfPfht4V5g0uU18EFjrvHs/wYalrqkoegrG9I
cuN71hLLk+NUYbqDeXHpKLlboANJsKz37xuKZNEP4ZLCIHAJJmIzWC9B2DQe9ZAD
/b0+8gp+1iPALFfm18soclvp1u//aVHbemzgEUr/TjZUM6j+vNU6PFkykV2PrFzY
cEwVtuQf+v42clWp68l5WQyx5ddcfkUaLKRQfcjLxUhrjcvnMvJLBDSaBmGSpSFG
A5E3I1ANVvaGUSC74uEu5j4JEvM/nNEgE9u7OFL/hw4jvuwyH34+a9MmtJrZbsW2
ZvYlcE85/AT67XtlGjj6lcgwoQdOl6Xvn7+3KhFqPJ9LAhPYRioTQBAszzmXI1uY
2p/B2GWVLx2z5QXU6rolTMSakeklEEoldxb7H9sJ/s3NW3FpMryuEgkhPr3GcO+X
KKkL1y8VtkHEFPwn0F9h8TBWEB2jNGEc2PF0J/XSqfLc+B7FEE52dmzFpSjUUcIk
md2MKgINufW5R81OzN/LSqae9TUZlB0AgVQ9lkBhAM5NLqWV+YdgDDyuSBHn42Hs
9AlIH9wk7OvHAUuuAOjmqVTnecOHDhlL+OLyEz9uCKUQtn4K6oLL1IQpyrz6kjig
056OKxXh5GDgi4MKma1pX6O3t+DL9ggMRhL8Iy0TlCUKr2eW93RsYLoq/s7JpDkQ
IP6u+MSeIs8+xyS6Vm+yA+9UugMlhSS348iVH+owzE6gmyJurcVX2tZpM5BWO7di
NCX+NtDY04s8vPSbw38TjDsX3S5tNPOxRN57GTJ9Zq17MeFPKNUFiaaIAceOkfcr
V2LTKCdsgCJF2cUyUQb48fWU3MM89IvqMg8FGrzus1pGwZEbn+xf6vy3Z9FimAXL
uZrskj7xByT+6sW0LTCvtYT1v6NzFwc+mhw4+eVlFCpgrWpDog05bw8cT3GMWfxU
R2/zFzi5Q20nVaYKxAe5LXAaqfHMuudk7PBQ2sB6v654G8I1DdUXNn5Nqc3wuQDl
XErUljzZAgPk+AGZsP3ZHDiwg8stxnlmhi+GZBXt4uhOlKnRxn9R8ETcJcxnQBY/
Wkovm3hcCBOYsaeg6eKHRvpG+KNnEtUoj+Mkk5atHHLozoG7kLr+2vSYZFBSBgu9
KPGTH4Q1ty8AmLFCwuFCYRDNON+lvkkbK5qOHYLAOLhGjy+8Rj0Wa9qt2iSwSgWB
CMCrIh2xDDklvjT9j1HtsrgMl9LaeSxbOGCdNqDUG7p+0Kg8xN8cCxvDPI+KOyf+
+pSNAFIdxoZa+BV6UCmPNyRmt2e5iVYLmWxwLMHc4+i4JfOF2RzFjIi7KtdF1ONj
RzzIXsyecqKEMa5mPm9SurxvcSKpOjXrRcMQRitgxg1fuSde6biTfzp8tJK/9/Uh
MDI4GDQSGRi+R7dTIo5rtkJ612cLjVIrCrBzvKgc39cDyS+bgvdubuNem8xm8K3s
vFmfz+KHv2A0z4uLu01Jc85Vb51ywUuQS7pG7x89OR2HU5DssDakvmBXs3QmwONL
WIgDRp7xS7Z32X94KYvu900LU2oMhRn3f7b6Z80LN2t2f+F/lv8ULfoUKImpypp2
Gipz1kiSulQgL9PNbNKSg97mqrOJvvwE9U5OgRlb5ayXZoD54zHWsmRJysO2RKKt
TuHnU3++k/wmXxPkI+IzeGWMgb/pIXi1PD9p/razx9sLoiWP+HwFuFP943oPkXih
aNm1hvKuFMcjs7LWIOMnyTajFJs7wj7ijfyB/82QJNnOetXToZkUQy7RC/Yu+UU9
RLJkSANUMrqmLkfiYSuHHRtnKLtXC/KI1eZ+Y8ugOunWBzo6hExEnw23l1NFm49w
qnV1zysNWDzhVxBKddqhKRus1Y+CSs5KUaryaoyzEeSx5/fK8O+sgeY2C3uS7fXo
CZ6cs6Pf0YyCydZuE0HCeKbg09ZhfHOpjY/TOqJTAwI4DObWpwOlWh86zp3IU1dI
BUCg8b51E451CSr4OL051j7eDnI3/vkUa4g/NAxDq/HWfVFmiTOnNcaCXXYf9S2r
+RxCueGOdKNFS/vFSsBs9lH3Ad/abKuTTZcoW3Ldtz0NLLDMVNW+LFKG6gOEF8N+
Fe57t1SBcin2MfvyN7Wh4pXOPknM0oHktRrW8FJF88xvAB7RxzZLSpv6uT6+euUG
D7a4vrINGfffvgxXIplhMXn65hwVil7gEdNZf5u64isoeb2hh+/RJI031yjPHdyh
ymWoY3a1FvtJdXZFB5zHUHf9ppiq53saWGfLZKjoFBQHQYgJSvEMjp3bPMhdtZOU
QSOWyRv2Pa+jyNUzi5tZl98nUMawpvA30HBhGr4GqqFWEszil83L23rCjmUymIdq
KFwJ1HcxCMmQUSF/D5FljQaOcNHPliViygCB4YeIfW8t87nfXjJCpetuQXO+Aq5L
It9oXUOIwQijVHmtSJ02O16O1jdAk1zAuGpaVlCnXyGsKBMai4a76utsFexrHYd1
mXBI5H/J9+Yg1O5fY8KkwxQf1AMOOR+dA2Vxl7POpt1kthJtBQZ57JtwiajTm3sp
wO4HLbHw93NTh6pTyCfUG/0qJVNNwWs2imvFh35kdORA0GpGV09Dehxzmu5dK/Wl
nETBb6AMdtmHTpRyUuMONNYHqFxcP6+QWckMCSBBndPorPc+Uw/XbA9LjLMKIpgQ
ZX7YTic1jB3mwE/9V5XbCjscUrlQAqywX3LlDfyD9P8B06fzbTdTA2A9Dnt1sLNA
+ejWyBITljIS8ZEy6d6bixNsT00E7rV9+ymwNI+QwHKwKQv0Nj1irfvc0q9h92Aa
gEAVgHk+8bBUxcbuiES7s7qNPBgQdAvFSM7l9MGk/lQejQGSknLmUYhZPil9G8FP
klPnyb89fDvE7FzbZ9KJ1RR455rMf2ITZQFcI9VLnTOGVsXb9DY2o/GE+pthX855
OFu0NfjuJyQ4lNn2dA3GfrwlGp5eCza42KSurYBLUdqL/sgpJrRkjA74v5pQQFty
`pragma protect end_protected
endmodule
