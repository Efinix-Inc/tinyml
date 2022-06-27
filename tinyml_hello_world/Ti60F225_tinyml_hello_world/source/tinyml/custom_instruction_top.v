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

module custom_instruction_top (
   input          clk,
   input          reset,
   //Command Interface
   input          cmd_valid,
   input  [9:0]   cmd_function_id,
   input  [31:0]  cmd_inputs_0,
   input  [31:0]  cmd_inputs_1,
   output         cmd_ready,
   //Response Interface
   output         rsp_valid,
   output [31:0]  rsp_outputs_0,
   input          rsp_ready
);

wire        tinyml_cmd_valid;
wire        tinyml_rsp_valid;
wire [31:0] tinyml_rsp_outputs_0;

assign tinyml_cmd_valid = cmd_valid & (cmd_function_id[9:7] == 3'b000);
assign rsp_valid        = tinyml_rsp_valid;                                   //May OR with user custom instruction rsp_valid
assign rsp_outputs_0    = (tinyml_rsp_valid) ? tinyml_rsp_outputs_0 : 32'd0;  //May default to user custom instruction rsp_outputs_0

//Function ID 10'b00_0xxx_xxxx are reserved for tinyML accelerator
tinyml_accelerator #(
   .MAC_BUF_CNT   (4),  //MAC Buffer Counter
   .MAC_BUF_AW    (7)   //MAC Buffer Address Width
) u_tinyml_accelerator (
   .clk              (clk),
   .reset            (reset),
   .cmd_valid        (tinyml_cmd_valid),
   .cmd_function_id  (cmd_function_id),
   .cmd_inputs_0     (cmd_inputs_0),
   .cmd_inputs_1     (cmd_inputs_1),
   .cmd_ready        (cmd_ready),
   .rsp_valid        (tinyml_rsp_valid),
   .rsp_outputs_0    (tinyml_rsp_outputs_0),
   .rsp_ready        (rsp_ready)
);

//Add user-defined custom instruction here.
//Function ID other than 10'b00_0xxx_xxxx are available for use.

endmodule