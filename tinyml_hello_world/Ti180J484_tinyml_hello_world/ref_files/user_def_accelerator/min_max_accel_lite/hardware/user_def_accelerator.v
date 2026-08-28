////////////////////////////////////////////////////////////////////////////////
// Copyright (C) 2013-2026 Efinix Inc. All rights reserved.
// See https://github.com/Efinix-Inc/tinyml/blob/main/LICENSE.txt for details.
////////////////////////////////////////////////////////////////////////////////

module user_def_accelerator (
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


//User-defined accelerator example 1 : Min Max Lite
wire         min_max_accel_lite_cmd_valid;
wire         min_max_accel_lite_cmd_ready;
wire         min_max_accel_lite_rsp_valid;
wire [31:0]  min_max_accel_lite_rsp_outputs_0;

assign min_max_accel_lite_cmd_valid = cmd_valid & (cmd_function_id[6:5] == 2'b10);// base addr by 64

user_def_min_max_accel_lite #(
) u_user_def_min_max_accel_lite (
   .clk                              (clk                               ),
   .reset                            (reset                             ),
   .cmd_valid                        (min_max_accel_lite_cmd_valid      ),
   .cmd_ready                        (min_max_accel_lite_cmd_ready      ),
   .cmd_function_id                  (cmd_function_id                   ),
   .cmd_inputs_0                     (cmd_inputs_0                      ),
   .cmd_inputs_1                     (cmd_inputs_1                      ),
   .rsp_valid                        (min_max_accel_lite_rsp_valid      ),
   .rsp_ready                        (rsp_ready                         ),
   .rsp_outputs_0                    (min_max_accel_lite_rsp_outputs_0  )
);


//Add other user-defined accelerator here



//Output
assign cmd_ready        = min_max_accel_lite_cmd_ready;                                                                      // May AND with other user-defined cmd_ready
assign rsp_valid        = min_max_accel_lite_rsp_valid;                                                                      //May OR with user-defined rsp_valid
assign rsp_outputs_0    = (min_max_accel_lite_rsp_valid) ?  min_max_accel_lite_rsp_outputs_0 : 32'd0;                        //May default to user-defined rsp_outputs_0


endmodule

