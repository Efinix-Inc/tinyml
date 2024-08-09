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

module cam_scale_up_2x_nn #(
   parameter P_DEPTH        = 8,
   parameter IN_FRAME_WIDTH = 540
)(
   input                         clk,
   input                         rst_n,
   input       [P_DEPTH*2-1:0]   in_red,
   input       [P_DEPTH*2-1:0]   in_green,
   input       [P_DEPTH*2-1:0]   in_blue,
   input                         in_valid,
   output                        in_ready,
   output reg  [P_DEPTH*2-1:0]   out_red,
   output reg  [P_DEPTH*2-1:0]   out_green,
   output reg  [P_DEPTH*2-1:0]   out_blue,
   output reg                    out_valid,
   input                         out_ready
);

//Custom version for scale up by 2x on 2PPC using nearest neighbour method
//Non-strict backpressure for out_ready. Might have one/two additional valid data out after out_ready goes down
//Output data is valid when out_valid is high, regardless of out_ready

reg  [P_DEPTH-1:0]   in_red_r;
reg  [P_DEPTH-1:0]   in_green_r;
reg  [P_DEPTH-1:0]   in_blue_r;
wire                 in_data_valid;
reg                  in_data_valid_r;

wire                 even_row_out_valid;
wire [P_DEPTH*2-1:0] even_row_out_red;
wire [P_DEPTH*2-1:0] even_row_out_green;
wire [P_DEPTH*2-1:0] even_row_out_blue;

wire                 odd_row_out_valid;
wire [P_DEPTH*2-1:0] odd_row_out_red;
wire [P_DEPTH*2-1:0] odd_row_out_green;
wire [P_DEPTH*2-1:0] odd_row_out_blue;

reg [8:0]            ram_wraddr;
reg [8:0]            ram_rdaddr;
wire                 ram_we;
wire                 ram_re;

reg                  rd_data_valid;
reg                  rd_data_valid_r;
wire [P_DEPTH*2-1:0] rd_red;
wire [P_DEPTH*2-1:0] rd_green;
wire [P_DEPTH*2-1:0] rd_blue;
reg                  rd_stage;
reg                  alternate_read;

assign in_data_valid       = in_ready & in_valid;
assign in_ready            = (~in_data_valid_r) & (~rd_stage) & (~odd_row_out_valid) & out_ready;

//Even row data relay from input
assign even_row_out_valid  = in_data_valid | in_data_valid_r;

assign even_row_out_red    = (in_data_valid)   ? {in_red  [P_DEPTH-1:0], in_red  [P_DEPTH-1:0]} : 
                             (in_data_valid_r) ? {in_red_r             , in_red_r             } : {2*P_DEPTH{1'b0}};
assign even_row_out_green  = (in_data_valid)   ? {in_green[P_DEPTH-1:0], in_green[P_DEPTH-1:0]} : 
                             (in_data_valid_r) ? {in_green_r           , in_green_r           } : {2*P_DEPTH{1'b0}};
assign even_row_out_blue   = (in_data_valid)   ? {in_blue [P_DEPTH-1:0], in_blue [P_DEPTH-1:0]} : 
                             (in_data_valid_r) ? {in_blue_r            , in_blue_r            } : {2*P_DEPTH{1'b0}};

//Odd row data read from stored data in RAM
//Assume RAM readout data hold until next read request
assign odd_row_out_valid   = rd_data_valid | rd_data_valid_r;
assign odd_row_out_red     = (rd_data_valid)   ? {rd_red  [P_DEPTH-1:0],         rd_red[P_DEPTH-1:0]}           : 
                             (rd_data_valid_r) ? {rd_red  [P_DEPTH*2-1:P_DEPTH], rd_red[P_DEPTH*2-1:P_DEPTH]}   : {2*P_DEPTH{1'b0}};
assign odd_row_out_green   = (rd_data_valid)   ? {rd_green[P_DEPTH-1:0],         rd_green[P_DEPTH-1:0]}         : 
                             (rd_data_valid_r) ? {rd_green[P_DEPTH*2-1:P_DEPTH], rd_green[P_DEPTH*2-1:P_DEPTH]} : {2*P_DEPTH{1'b0}};
assign odd_row_out_blue    = (rd_data_valid)   ? {rd_blue [P_DEPTH-1:0],         rd_blue[P_DEPTH-1:0]}          : 
                             (rd_data_valid_r) ? {rd_blue [P_DEPTH*2-1:P_DEPTH], rd_blue[P_DEPTH*2-1:P_DEPTH]}  : {2*P_DEPTH{1'b0}};

assign ram_we = in_data_valid;
assign ram_re = rd_stage & (~alternate_read) & out_ready;

//2PPC RGB
common_simple_dual_port_ram #(
   .DATA_WIDTH (2*3*P_DEPTH),
   .ADDR_WIDTH (9),
   .OUTPUT_REG ("FALSE")
) u_display_scale_up_ram (
   .wclk    (clk),
   .we      (ram_we),
   .waddr   (ram_wraddr),
   .wdata   ({in_blue, in_green, in_red}),
   .rclk    (clk),
   .re      (ram_re),
   .raddr   (ram_rdaddr), 
   .rdata   ({rd_blue, rd_green, rd_red})
);

always@(posedge clk)
begin
   if (~rst_n) begin
      in_data_valid_r <= 1'b0;
      ram_wraddr      <= 9'd0;
      ram_rdaddr      <= 9'd0;
      rd_stage        <= 1'b0;
      rd_data_valid   <= 1'b0;
      rd_data_valid_r <= 1'b0;
      alternate_read  <= 1'b0;
      in_red_r        <= {P_DEPTH{1'b0}};
      in_green_r      <= {P_DEPTH{1'b0}};
      in_blue_r       <= {P_DEPTH{1'b0}};
      out_valid       <= 1'b0;
      out_red         <= {2*P_DEPTH{1'b0}};
      out_green       <= {2*P_DEPTH{1'b0}};
      out_blue        <= {2*P_DEPTH{1'b0}};
   end else begin
      in_data_valid_r <= in_data_valid;
      
      ram_wraddr      <= (ram_we        & (ram_wraddr == (IN_FRAME_WIDTH/2-1))) ? 9'd0 : (ram_we)        ? ram_wraddr + 1'b1 : ram_wraddr;
      ram_rdaddr      <= (rd_data_valid & (ram_rdaddr == (IN_FRAME_WIDTH/2-1))) ? 9'd0 : (rd_data_valid) ? ram_rdaddr + 1'b1 : ram_rdaddr;
      
      rd_stage        <= (rd_data_valid & (ram_rdaddr == (IN_FRAME_WIDTH/2-1))) ? 1'b0 : (ram_we & (ram_wraddr == (IN_FRAME_WIDTH/2-1))) ? 1'b1 : rd_stage;
      rd_data_valid   <= ram_re;
      rd_data_valid_r <= rd_data_valid;
      alternate_read  <= (rd_stage & out_ready) ? ~alternate_read : alternate_read;
      
      in_red_r        <= {in_red  [P_DEPTH*2-1:P_DEPTH], in_red  [P_DEPTH*2-1:P_DEPTH]};
      in_green_r      <= {in_green[P_DEPTH*2-1:P_DEPTH], in_green[P_DEPTH*2-1:P_DEPTH]};
      in_blue_r       <= {in_blue [P_DEPTH*2-1:P_DEPTH], in_blue [P_DEPTH*2-1:P_DEPTH]};
      
      out_valid       <= even_row_out_valid | odd_row_out_valid;
      out_red         <= (even_row_out_valid) ? even_row_out_red   : (odd_row_out_valid) ? odd_row_out_red   : {2*P_DEPTH{1'b0}};
      out_green       <= (even_row_out_valid) ? even_row_out_green : (odd_row_out_valid) ? odd_row_out_green : {2*P_DEPTH{1'b0}};
      out_blue        <= (even_row_out_valid) ? even_row_out_blue  : (odd_row_out_valid) ? odd_row_out_blue  : {2*P_DEPTH{1'b0}};
   end
end

endmodule
