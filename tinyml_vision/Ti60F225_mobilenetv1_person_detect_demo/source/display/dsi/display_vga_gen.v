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

module display_vga_gen
#(
   parameter H_SyncPulse   = 8'd96,           
   parameter H_BackPorch   = 8'd48,              
   parameter H_ActivePix   = 12'd640,             
   parameter H_FrontPorch  = 8'd16,
   parameter V_SyncPulse   = 8'd2,
   parameter V_BackPorch   = 8'd33,
   parameter V_ActivePix   = 12'd480,
   parameter V_FrontPorch  = 8'd10,
   parameter P_Cnt         = 3'd1,
   parameter PW            = 14
)
(
   input             in_pclk,
   input             in_rstn,
   
   output   [PW-1:0] out_x,
   output   [11:0]   out_y,
   output            out_valid,
   output            out_de,
   output            out_hs,
   output            out_vs
);

wire  [PW-1:0] LinePeriod   = H_SyncPulse + H_BackPorch + H_ActivePix +  H_FrontPorch;
wire  [PW-1:0] Hde_Start    = H_SyncPulse + H_BackPorch;
wire  [PW-1:0] Hde_End      = H_SyncPulse + H_BackPorch + H_ActivePix;
wire  [11:0]   FramePeriod  = V_SyncPulse + V_BackPorch + V_ActivePix +  V_FrontPorch;
wire  [11:0]   Vde_Start    = V_SyncPulse + V_BackPorch;
wire  [11:0]   Vde_End      = V_SyncPulse + V_BackPorch + V_ActivePix;

/* VGA counter for the output display sync signals generator */
reg [PW-1:0]r_x_cnt;
reg [11:0]  r_y_cnt;
reg [PW-1:0]r_x_active_1P;
reg [11:0]  r_y_active_1P;
reg [PW-1:0]r_x_active_2P;
reg [11:0]  r_y_active_2P;
reg [2:0]   r_p_cnt;
reg         r_de_vs;
reg         r_vs;
reg         r_de;
reg         r_hs;
reg         r_de_1P;
reg         r_hs_1P;
reg         r_vs_1P;
reg         r_valid_1P;
reg         r_de_2P;
reg         r_hs_2P;
reg         r_vs_2P;
reg         r_valid_2P;

/* VGA counter for the output display sync signals generator */
/* r_x_cnt for HSYNC and DEN */  
always @ (posedge in_pclk)
begin
   if(~in_rstn)
   begin    
      r_x_cnt        <= {PW{1'b0}};
      r_x_active_1P  <= {PW{1'b0}};
      r_y_active_1P  <= 12'b0;
      r_x_active_2P  <= {PW{1'b0}};
      r_y_active_2P  <= 12'b0;
      r_p_cnt        <= 3'd0;
      r_de           <= 1'b0;
      r_hs           <= 1'b1;
      r_de_1P        <= 1'b0;
      r_hs_1P        <= 1'b1;
      r_valid_1P     <= 1'b0;
      r_vs_1P        <= 1'b1;
      r_de_2P        <= 1'b0;
      r_hs_2P        <= 1'b1;
      r_valid_2P     <= 1'b0;
      r_vs_2P        <= 1'b1;
   end   
   else
   begin
      r_de_1P        <= r_de;
       r_hs_1P       <= r_hs;
      r_vs_1P        <= r_vs;
      r_de_2P        <= r_de_1P;
       r_hs_2P       <= r_hs_1P;
      r_vs_2P        <= r_vs_1P;
      r_valid_2P     <= r_valid_1P;
      r_x_active_2P  <= r_x_active_1P;
      
      if (r_de_1P)
         r_y_active_2P  <= r_y_active_1P;
      else
         r_y_active_2P  <= 12'b0;
         
      if(r_x_cnt == LinePeriod - 1'b1)
      begin
         r_x_cnt  <= {PW{1'b0}};
         r_hs     <= 1'b0;
      end
      else
         r_x_cnt <= r_x_cnt + 1'b1;
      
      if (r_x_cnt == H_SyncPulse - 1'b1) 
            r_hs <= 1'b1;
      
      if (r_de_vs)
      begin
         if(r_x_cnt == (Hde_End - 1'b1))
            r_de  <= 1'b0;
         else if(r_x_cnt == Hde_Start - 1'b1)
            r_de  <= 1'b1;
      end
      else
         r_de        <= 1'b0;
         
      if (r_de)
      begin
         r_valid_1P  <= 1'b0;
         r_p_cnt     <= r_p_cnt - 1'b1;
         if (r_p_cnt == {3{1'b0}})
         begin
            r_valid_1P  <= 1;
            r_p_cnt     <= P_Cnt-1'b1;
         end
      end
      else
      begin
         r_valid_1P  <= 1'b0;
         r_p_cnt     <= 3'd0;
      end
      
      if (r_valid_1P)
         r_x_active_1P  <= r_x_active_1P + 1'b1;
         
      if (~r_de)
         r_x_active_1P  <= {PW{1'b0}};
      
      if (!r_de && r_de_1P)
      begin
         if (r_y_active_1P == V_ActivePix - 1'b1)     
            r_y_active_1P  <= 12'b0;
         else
            r_y_active_1P  <= r_y_active_1P + 1'b1;
      end
   end
end
   
/* r_y_cnt for VSYNC */  
always @ (posedge in_pclk) 
begin
   if(~in_rstn)
   begin
      r_y_cnt  <= 12'b0;
      r_vs     <= 1'b1;
   end
    else
   begin
      if(r_x_cnt == LinePeriod - 1'b1) 
      begin
         if (r_y_cnt == FramePeriod - 1'b1)
         begin
            r_y_cnt  <= 12'b0;
            r_vs     <= 1'b0;
         end
         else
            r_y_cnt <= r_y_cnt + 1'b1;    
      end
      
      if((r_y_cnt == V_SyncPulse - 1'b1) && (r_x_cnt == LinePeriod - 1'b1))
         r_vs <= 1'b1;
   end
end
      
always @ (posedge in_pclk)
begin
   if(~in_rstn) 
   begin
      r_de_vs <= 1'b0;     
   end
   else 
   begin    
      if(r_y_cnt == Vde_Start)
         r_de_vs <= 1'b1;     
      else if(r_y_cnt == Vde_End)
         r_de_vs <= 1'b0;
   end
end

assign   out_x       = r_x_active_2P;
assign   out_y       = r_y_active_2P;
assign   out_valid   = r_valid_2P;
assign   out_de      = r_de_2P;
assign   out_hs      = r_hs_2P;
assign   out_vs      = r_vs_2P;
endmodule
