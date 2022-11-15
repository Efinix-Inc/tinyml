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

module user_def_min_max_accel_lite (
  input             clk,
  input             reset,

  input             cmd_valid,
  output            cmd_ready,
  input  [9:0]      cmd_function_id,
  input  [31:0]     cmd_inputs_0,
  input  [31:0]     cmd_inputs_1,

  output            rsp_valid,
  input             rsp_ready,
  output [31:0]     rsp_outputs_0
);

reg         input_type; //signed or unsigned
reg  [31:0] custom_result;
reg         custom_result_ready;

always@(posedge clk or posedge reset) begin
   if(reset) begin
      input_type           <= 1'b0;
      custom_result        <= 32'd0;
      custom_result_ready  <= 1'b0;
   end else begin
      if (cmd_ready & cmd_valid) begin
         case (cmd_function_id[2:0])
            2'd0: //Input type
            begin
               input_type     <= cmd_inputs_0[0];
               custom_result <= 32'd0; //Don't care
            end
            2'd1: //Max
            begin
               if (input_type == 1'b0) //unsigned
               begin
                  custom_result[7:0]   <= (cmd_inputs_0[7:0]   > cmd_inputs_1[7:0])   ? cmd_inputs_0[7:0]  : cmd_inputs_1[7:0];
                  custom_result[15:8]  <= (cmd_inputs_0[15:8]  > cmd_inputs_1[15:8])  ? cmd_inputs_0[15:8] : cmd_inputs_1[15:8];
                  custom_result[23:16] <= (cmd_inputs_0[23:16] > cmd_inputs_1[23:16]) ? cmd_inputs_0[23:16] : cmd_inputs_1[23:16];
                  custom_result[31:24] <= (cmd_inputs_0[31:24] > cmd_inputs_1[31:24]) ? cmd_inputs_0[31:24] : cmd_inputs_1[31:24];
               end else begin          //signed
                  custom_result[7:0]   <= ($signed(cmd_inputs_0[7:0]) > $signed(cmd_inputs_1[7:0])) ? cmd_inputs_0[7:0] : cmd_inputs_1[7:0];
                  custom_result[15:8]  <= ($signed(cmd_inputs_0[15:8]) > $signed(cmd_inputs_1[15:8])) ? cmd_inputs_0[15:8] : cmd_inputs_1[15:8];
                  custom_result[23:16] <= ($signed(cmd_inputs_0[23:16]) > $signed(cmd_inputs_1[23:16])) ? cmd_inputs_0[23:16] : cmd_inputs_1[23:16];
                  custom_result[31:24] <= ($signed(cmd_inputs_0[31:24]) > $signed(cmd_inputs_1[31:24])) ? cmd_inputs_0[31:24] : cmd_inputs_1[31:24];
               end
            end
            2'd2: //Min
            begin
               if (input_type == 1'b0) //unsigned
               begin
                  custom_result[7:0]   <= (cmd_inputs_0[7:0]   < cmd_inputs_1[7:0])   ? cmd_inputs_0[7:0]   : cmd_inputs_1[7:0];
                  custom_result[15:8]  <= (cmd_inputs_0[15:8]  < cmd_inputs_1[15:8])  ? cmd_inputs_0[15:8]  : cmd_inputs_1[15:8];
                  custom_result[23:16] <= (cmd_inputs_0[23:16] < cmd_inputs_1[23:16]) ? cmd_inputs_0[23:16] : cmd_inputs_1[23:16];
                  custom_result[31:24] <= (cmd_inputs_0[31:24] < cmd_inputs_1[31:24]) ? cmd_inputs_0[31:24] : cmd_inputs_1[31:24];
               end else begin          //signed
                  custom_result[7:0]  <= ($signed(cmd_inputs_0[7:0]) < $signed(cmd_inputs_1[7:0])) ? cmd_inputs_0[7:0] : cmd_inputs_1[7:0];
                  custom_result[15:8]  <= ($signed(cmd_inputs_0[15:8]) < $signed(cmd_inputs_1[15:8])) ? cmd_inputs_0[15:8] : cmd_inputs_1[15:8];
                  custom_result[23:16]  <= ($signed(cmd_inputs_0[23:16]) < $signed(cmd_inputs_1[23:16])) ? cmd_inputs_0[23:16] : cmd_inputs_1[23:16];
                  custom_result[31:24]  <= ($signed(cmd_inputs_0[31:24]) < $signed(cmd_inputs_1[31:24])) ? cmd_inputs_0[31:24] : cmd_inputs_1[31:24];
               end
	   end
         endcase
         
         //Output ready by next cycle after cmd_ready & cmd_valid
         custom_result_ready <= 1'b1;
      end else begin
         custom_result_ready <= (rsp_valid & rsp_ready) ? 1'b0 : custom_result_ready;
      end
   end
end

assign rsp_outputs_0 = custom_result;
assign rsp_valid     = rsp_ready & custom_result_ready;
assign cmd_ready     = rsp_ready & (~custom_result_ready) & (~rsp_valid);

endmodule
