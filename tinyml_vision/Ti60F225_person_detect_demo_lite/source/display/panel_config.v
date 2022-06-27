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

module panel_config
#(
   parameter INITIAL_CODE  = "dsi_panel_1080p_reg.mem",
   parameter REG_DEPTH     = 9'd15
)
(
   input                i_axi_clk,
   input                i_restn,
   
   input                i_axi_awready,
   input                i_axi_wready,
   input                i_axi_bvalid,
   output reg  [6:0]    o_axi_awaddr,
   output reg           o_axi_awvalid,
   output reg  [31:0]   o_axi_wdata,
   output reg           o_axi_wvalid,
   output reg           o_axi_bready,
   
   input                i_axi_arready,
   input       [31:0]   i_axi_rdata,
   input                i_axi_rvalid,
   output reg  [6:0]    o_axi_araddr,
   output reg           o_axi_arvalid,
   output reg           o_axi_rready,
   
   output               o_addr_cnt,
   output      [3:0]    o_state,
   output               o_confdone,
   
   input                i_dbg_we,
   input    [39:0]      i_dbg_din,
   input    [8:0]       i_dbg_addr,
   output   [39:0]      o_dbg_dout,
   input                i_dbg_reconfig
);

localparam  IDLE        = 4'b0000;
localparam  WRITE_ADDR  = 4'b0001;
localparam  PRE_WRITE   = 4'b0010;
localparam  WRITE       = 4'b0011;
localparam  POST_WRITE  = 4'b0100;
localparam  READ_ADDR   = 4'b1001;
localparam  PRE_READ    = 4'b1010;
localparam  READ        = 4'b1011;
localparam  POST_READ   = 4'b1100;

reg   [3:0]    r_state;
reg            r_done;
reg            r_done_1P;
reg            r_done_2P;
reg            r_done_3P;
reg            r_confdone;
reg   [21:0]   r_timer;
reg   [15:0]   r_addr;
reg   [31:0]   r_read_reg;
reg   [2:0]    r_cnt;

wire  [39:0]   w_reg;
wire  [39:0]   w_reg_default;

assign   o_addr_cnt  = r_addr[0];

true_dual_port_ram
#(
   .DATA_WIDTH    (40),
   .ADDR_WIDTH    (9),
   .WRITE_MODE_1  ("WRITE_FIRST"),
   .WRITE_MODE_2  ("WRITE_FIRST"),
   .OUTPUT_REG_1  ("TRUE"),
   .OUTPUT_REG_2  ("TRUE"),
   .RAM_INIT_FILE (INITIAL_CODE)
)
inst_piv2_reg
(
   .we1     (1'b0),
   .we2     (i_dbg_we),
   .clka    (i_axi_clk),
   .clkb    (i_axi_clk),
   .din1    ({40{1'b0}}),
   .din2    (i_dbg_din),
   .addr1   (r_addr[8:0]),
   .addr2   (i_dbg_addr),
   .dout1   (w_reg_default),
   .dout2   (o_dbg_dout)
);

assign   w_reg = w_reg_default;

always@(negedge i_restn or posedge i_axi_clk)
begin
   if (~i_restn)
   begin
      r_state        <= IDLE;
      o_axi_awaddr   <= {7{1'b0}};
      o_axi_awvalid  <= 1'b0;
      o_axi_wdata    <= {32{1'b0}};
      o_axi_wvalid   <= 1'b0;
      o_axi_bready   <= 1'b0;
      o_axi_araddr   <= {7{1'b0}};
      o_axi_arvalid  <= 1'b0;
      o_axi_rready   <= 1'b0;
      r_done         <= 1'b1;
      r_done_1P      <= 1'b1;
      r_done_2P      <= 1'b1;
      r_done_3P      <= 1'b1;
      r_confdone     <= 1'b0;
      r_timer        <= {22{1'b0}};
      r_addr         <= {16{1'b0}};
      r_read_reg     <= {32{1'b0}};
      r_cnt          <= 3'b0;
   end
   else
   begin
      r_done_1P   <= r_done;
      r_done_2P   <= r_done_1P;
      r_done_3P   <= r_done_2P;
      case (r_state)
         IDLE:
         begin          
            if ((r_addr == REG_DEPTH) || (w_reg == 40'b0))
               r_confdone  <= 1'b1;
            else if (w_reg[39:32] == 8'b0)
            begin
               if (~r_done)
               begin
                  if (r_timer == w_reg[21:0])
                  begin
                     r_done   <= 1'b1;
                     r_addr   <= r_addr + 1'b1;
                     r_timer  <= {22{1'b0}};
                  end
                  else
                     r_timer  <= r_timer + 1'b1;
               end
            end
            else if (~r_confdone)
            begin
               r_cnt <= r_cnt + 1'b1;
               if (r_cnt[2])
               begin
                  r_state           <= WRITE_ADDR;
                  o_axi_awaddr      <= w_reg[38:32];
                  o_axi_wdata[31:0] <= w_reg[31:0];
                  o_axi_awvalid     <= 1'b1;
                  r_cnt             <= 3'b0;
               end
            end
         end
         
         WRITE_ADDR:
         begin          
            if (i_axi_awready)
            begin
               r_state        <= WRITE;
               o_axi_bready   <= 1'b1;
               o_axi_awvalid  <= 1'b0;
               o_axi_wvalid   <= 1'b1;
               r_addr         <= r_addr + 1'b1;             
            end
         end
   
         WRITE:
         begin          
            if (i_axi_wready)
            begin
               r_state        <= POST_WRITE;
               o_axi_wvalid   <= 1'b0;
            end
         end
         
         POST_WRITE:
         begin          
            if (i_axi_bvalid)
            begin
               r_state        <= READ_ADDR;
               o_axi_bready   <= 1'b0;
               o_axi_arvalid  <= 1'b1;
            end
         end
         
         READ_ADDR:
         begin          
            if (i_axi_arready)
            begin
               r_state        <= READ;
               o_axi_araddr   <= 6'h24;
               o_axi_rready   <= 1'b1;
               o_axi_arvalid  <= 1'b0;
            end            
         end
         
         READ:
         begin
            if (i_axi_rvalid)
            begin
               r_state        <= POST_READ;
               r_read_reg     <= i_axi_rdata;
               o_axi_rready   <= 1'b0;
            end
         end
         
         POST_READ:
         begin
            if (r_read_reg[11:10] == 2'b00)
            begin
               r_state  <= IDLE;
               r_done   <= 1'b0;
            end
            else
            begin
               r_state        <= READ_ADDR;
               o_axi_arvalid  <= 1'b1;
            end
         end
         
         default:
         begin
            r_state        <= IDLE;
            o_axi_awaddr   <= {7{1'b0}};
            o_axi_awvalid  <= 1'b0;
            o_axi_wdata    <= {32{1'b0}};
            o_axi_wvalid   <= 1'b0;
            o_axi_bready   <= 1'b0;
            o_axi_araddr   <= {7{1'b0}};
            o_axi_arvalid  <= 1'b0;
            o_axi_rready   <= 1'b0;
            r_done         <= 1'b1;
            r_confdone     <= 1'b0;
         end
      endcase
   end
end

assign   o_state     = r_state;
assign   o_confdone  = r_confdone;

endmodule
