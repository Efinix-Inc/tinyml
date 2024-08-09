////////////////////////////////////////////////////////////////////////////
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

module cam_raw_to_rgb #(
   parameter   P_DEPTH      = 10,
   parameter   PW           = P_DEPTH*2,
   parameter   FRAME_WIDTH  = 640,
   parameter   FRAME_HEIGHT = 480
) (
   input          i_arstn,
   input          i_pclk,
   input          i_vsync,
   input          i_valid,
   input[PW-1:0]  i_p_11,
   input[PW-1:0]  i_p_00,
   input[PW-1:0]  i_p_01,
   output         o_vsync,
   output         o_valid,
   output[PW-1:0] o_r,
   output[PW-1:0] o_g,
   output[PW-1:0] o_b
);

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// y -1  0  +1  x
// 
//   -1  0  +1 
//   -1  0  +1 
//   -1  0  +1 
//
//             r_bayer_11_11_2P                          r_bayer_11_01_1P                         r_bayer_11_01_0P
//             r_bayer_00_11_2P                          r_bayer_00_00_1P                         r_bayer_00_01_0P
//             r_bayer_01_11_2P                          r_bayer_01_01_1P                         r_bayer_01_01_0P
//
// r_bayer_11_11_2P_0   r_bayer_11_11_2P_1   r_bayer_11_00_1P_0   r_bayer_11_00_1P_1   r_bayer_11_01_0P_0   r_bayer_11_01_0P_1
// r_bayer_00_11_2P_0   r_bayer_00_11_2P_1   r_bayer_00_00_1P_0   r_bayer_00_00_1P_1   r_bayer_00_01_0P_0   r_bayer_00_01_0P_1
// r_bayer_01_11_2P_0   r_bayer_01_11_2P_1   r_bayer_01_00_1P_0   r_bayer_01_00_1P_1   r_bayer_01_01_0P_0   r_bayer_01_01_0P_1
//
//  R | G | R | G | R | G              R G B | R G B | R G B | R G B | R G B | R G B
// --- --- --- --- --- ---            ------- ------- ------- ------- ------- -------
//  G | B | G | B | G | B        |\    R G B | R G B | R G B | R G B | R G B | R G B
// --- --- --- --- --- ---  -----  \  ------- ------- ------- ------- ------- -------
//  R | G | R | G | R | G   -----  /   R G B | R G B | R G B | R G B | R G B | R G B
// --- --- --- --- --- ---       |/   ------- ------- ------- ------- ------- -------
//  G | B | G | B | G | B              R G B | R G B | R G B | R G B | R G B | R G B
//
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

localparam PIX_COUNT_BIT  = $clog2(FRAME_WIDTH/2); //2PPC.
localparam LINE_COUNT_BIT = $clog2(FRAME_HEIGHT);

reg                      o_e_pixel_cnt;
reg                      o_e_line_cnt;
reg  [PW-1:0]            r_r_00_00_1P;
reg  [PW-1:0]            r_g_00_00_1P;
reg  [PW-1:0]            r_b_00_00_1P;
reg  [P_DEPTH-1:0]       r_bayer_11_01_0P_0;
reg  [P_DEPTH-1:0]       r_bayer_11_01_0P_1;
reg  [P_DEPTH-1:0]       r_bayer_00_01_0P_0;
reg  [P_DEPTH-1:0]       r_bayer_00_01_0P_1;
reg  [P_DEPTH-1:0]       r_bayer_01_01_0P_0;
reg  [P_DEPTH-1:0]       r_bayer_01_01_0P_1;
reg  [P_DEPTH-1:0]       r_bayer_11_00_1P_0;
reg  [P_DEPTH-1:0]       r_bayer_11_00_1P_1;
reg  [P_DEPTH-1:0]       r_bayer_00_00_1P_0;
reg  [P_DEPTH-1:0]       r_bayer_00_00_1P_1;
reg  [P_DEPTH-1:0]       r_bayer_01_00_1P_0;
reg  [P_DEPTH-1:0]       r_bayer_01_00_1P_1;
reg  [P_DEPTH-1:0]       r_bayer_11_11_2P_0;
reg  [P_DEPTH-1:0]       r_bayer_11_11_2P_1;
reg  [P_DEPTH-1:0]       r_bayer_00_11_2P_0;
reg  [P_DEPTH-1:0]       r_bayer_00_11_2P_1;
reg  [P_DEPTH-1:0]       r_bayer_01_11_2P_0;
reg  [P_DEPTH-1:0]       r_bayer_01_11_2P_1;
reg                      r_vsync_00_1P;
reg                      r_valid_00_1P;
reg                      r_vsync_00_2P;
reg                      r_valid_00_2P;

reg [PIX_COUNT_BIT-1:0]  pixel_count;   //x_count
reg [LINE_COUNT_BIT-1:0] line_count;    //y_count
wire                     vsync_falling_edge;
reg                      end_of_img_line;
reg                      end_of_img_line_r;

assign vsync_falling_edge = r_vsync_00_1P && ~i_vsync;

//RAW to RGB Debayer filter
always@(posedge i_pclk)
begin
   if (~i_arstn)
   begin
      pixel_count        <= {PIX_COUNT_BIT{1'b0}};
      end_of_img_line    <= 1'b0;
      end_of_img_line_r  <= 1'b0;
      line_count         <= {LINE_COUNT_BIT{1'b0}};
      o_e_pixel_cnt      <= 1'b0;
      o_e_line_cnt       <= 1'b0;
      r_vsync_00_1P      <= 0;
      r_valid_00_1P      <= 0;   
   
      r_bayer_11_01_0P_0 <= {P_DEPTH{1'b0}};
      r_bayer_11_01_0P_1 <= {P_DEPTH{1'b0}};
      r_bayer_00_01_0P_0 <= {P_DEPTH{1'b0}};
      r_bayer_00_01_0P_1 <= {P_DEPTH{1'b0}};
      r_bayer_01_01_0P_0 <= {P_DEPTH{1'b0}};
      r_bayer_01_01_0P_1 <= {P_DEPTH{1'b0}};
      
      r_bayer_11_00_1P_0 <= {P_DEPTH{1'b0}};
      r_bayer_11_00_1P_1 <= {P_DEPTH{1'b0}};
      r_bayer_00_00_1P_0 <= {P_DEPTH{1'b0}};
      r_bayer_00_00_1P_1 <= {P_DEPTH{1'b0}};
      r_bayer_01_00_1P_0 <= {P_DEPTH{1'b0}};
      r_bayer_01_00_1P_1 <= {P_DEPTH{1'b0}};
      
      r_bayer_11_11_2P_0 <= {P_DEPTH{1'b0}};
      r_bayer_11_11_2P_1 <= {P_DEPTH{1'b0}};
      r_bayer_00_11_2P_0 <= {P_DEPTH{1'b0}};
      r_bayer_00_11_2P_1 <= {P_DEPTH{1'b0}};
      r_bayer_01_11_2P_0 <= {P_DEPTH{1'b0}};
      r_bayer_01_11_2P_1 <= {P_DEPTH{1'b0}};
      
      r_r_00_00_1P       <= {PW{1'b0}};
      r_g_00_00_1P       <= {PW{1'b0}};
      r_b_00_00_1P       <= {PW{1'b0}};      
   end
   else
   begin
      pixel_count        <= ((i_valid && (pixel_count==(FRAME_WIDTH/2)-1)) || (vsync_falling_edge)) ? {PIX_COUNT_BIT{1'b0}}  : 
                            (i_valid)                                                               ? pixel_count + 1'b1     : pixel_count;
      line_count         <= (!i_vsync && r_vsync_00_1P)                                             ? {LINE_COUNT_BIT{1'b0}} :
                            (end_of_img_line_r)                                                     ? line_count + 1'b1      : line_count;
      end_of_img_line    <= i_valid && (pixel_count==(FRAME_WIDTH/2)-1);
      end_of_img_line_r  <= end_of_img_line;
      r_vsync_00_1P      <= i_vsync;
      r_valid_00_1P      <= i_valid;
      r_vsync_00_2P      <= r_vsync_00_1P;
      r_valid_00_2P      <= r_valid_00_1P;

      r_bayer_11_01_0P_0 <= i_p_11[P_DEPTH-1:0];
      r_bayer_11_01_0P_1 <= i_p_11[PW-1:P_DEPTH];
      r_bayer_00_01_0P_0 <= i_p_00[P_DEPTH-1:0];
      r_bayer_00_01_0P_1 <= i_p_00[PW-1:P_DEPTH];
      r_bayer_01_01_0P_0 <= i_p_01[P_DEPTH-1:0];
      r_bayer_01_01_0P_1 <= i_p_01[PW-1:P_DEPTH];

      if (pixel_count == {PIX_COUNT_BIT{1'b0}})
      begin
         r_bayer_11_00_1P_0   <= {P_DEPTH{1'b0}};
         r_bayer_11_00_1P_1   <= {P_DEPTH{1'b0}};
         r_bayer_00_00_1P_0   <= {P_DEPTH{1'b0}};
         r_bayer_00_00_1P_1   <= {P_DEPTH{1'b0}};
         r_bayer_01_00_1P_0   <= {P_DEPTH{1'b0}};
         r_bayer_01_00_1P_1   <= {P_DEPTH{1'b0}};
         
         r_bayer_11_11_2P_0   <= {P_DEPTH{1'b0}};
         r_bayer_11_11_2P_1   <= {P_DEPTH{1'b0}};
         r_bayer_00_11_2P_0   <= {P_DEPTH{1'b0}};
         r_bayer_00_11_2P_1   <= {P_DEPTH{1'b0}};
         r_bayer_01_11_2P_0   <= {P_DEPTH{1'b0}};
         r_bayer_01_11_2P_1   <= {P_DEPTH{1'b0}};
      end
      else
      begin
         r_bayer_11_00_1P_0   <= r_bayer_11_01_0P_0;
         r_bayer_11_00_1P_1   <= r_bayer_11_01_0P_1;
         r_bayer_00_00_1P_0   <= r_bayer_00_01_0P_0;
         r_bayer_00_00_1P_1   <= r_bayer_00_01_0P_1;
         r_bayer_01_00_1P_0   <= r_bayer_01_01_0P_0;
         r_bayer_01_00_1P_1   <= r_bayer_01_01_0P_1;
         
         r_bayer_11_11_2P_0   <= r_bayer_11_00_1P_0;
         r_bayer_11_11_2P_1   <= r_bayer_11_00_1P_1;
         r_bayer_00_11_2P_0   <= r_bayer_00_00_1P_0;
         r_bayer_00_11_2P_1   <= r_bayer_00_00_1P_1;
         r_bayer_01_11_2P_0   <= r_bayer_01_00_1P_0;
         r_bayer_01_11_2P_1   <= r_bayer_01_00_1P_1;
      end

      if (!r_valid_00_1P || (line_count=={LINE_COUNT_BIT{1'b0}}))
      begin
         r_r_00_00_1P <= {PW{1'b0}};
         r_g_00_00_1P <= {PW{1'b0}};
         r_b_00_00_1P <= {PW{1'b0}};   
      end
      else if (line_count[0])
      begin
         /* R Gr RG r */
         r_r_00_00_1P[P_DEPTH-1:0]  <= r_bayer_00_00_1P_0;
         r_g_00_00_1P[P_DEPTH-1:0]  <= (((r_bayer_11_00_1P_0 >> 1) + (r_bayer_01_00_1P_0 >> 1)) >> 1) + (((r_bayer_00_00_1P_1 >> 1) + (r_bayer_00_11_2P_1 >> 1)) >> 1);
         r_b_00_00_1P[P_DEPTH-1:0]  <= (((r_bayer_11_00_1P_1 >> 1) + (r_bayer_01_11_2P_1 >> 1)) >> 1) + (((r_bayer_01_00_1P_1 >> 1) + (r_bayer_11_11_2P_1 >> 1)) >> 1);
         
         r_r_00_00_1P[PW-1:P_DEPTH] <= (r_bayer_00_01_0P_0 >> 1) + (r_bayer_00_00_1P_0 >> 1);
         r_g_00_00_1P[PW-1:P_DEPTH] <= r_bayer_00_00_1P_1;           
         r_b_00_00_1P[PW-1:P_DEPTH] <= (r_bayer_11_00_1P_1 >> 1) + (r_bayer_01_00_1P_1 >> 1);

         /* Gr R Gr R */
         //r_r_00_00_1P[P_DEPTH-1:0]  <= (r_bayer_00_00_1P_1 >> 1) + (r_bayer_00_11_2P_1 >> 1);
         //r_g_00_00_1P[P_DEPTH-1:0]  <= r_bayer_00_00_1P_0;            
         //r_b_00_00_1P[P_DEPTH-1:0]  <= (r_bayer_11_00_1P_0 >> 1) + (r_bayer_01_00_1P_0 >> 1);
         //
         //r_r_00_00_1P[PW-1:P_DEPTH] <= r_bayer_00_00_1P_1;
         //r_g_00_00_1P[PW-1:P_DEPTH] <= (((r_bayer_00_01_0P_0 >> 1) + (r_bayer_00_00_1P_0 >> 1)) >> 1) + (((r_bayer_11_00_1P_1 >> 1) + (r_bayer_01_00_1P_1 >> 1)) >> 1);
         //r_b_00_00_1P[PW-1:P_DEPTH] <= (((r_bayer_11_01_0P_0 >> 1) + (r_bayer_01_00_1P_0 >> 1)) >> 1) + (((r_bayer_01_01_0P_0 >> 1) + (r_bayer_11_00_1P_0 >> 1)) >> 1);        
      end
      else
      begin
         /* Gb B Gb G */
         r_r_00_00_1P[P_DEPTH-1:0]  <= (r_bayer_11_00_1P_0 >> 1) + (r_bayer_01_00_1P_0 >> 1);
         r_g_00_00_1P[P_DEPTH-1:0]  <= r_bayer_00_00_1P_0;           
         r_b_00_00_1P[P_DEPTH-1:0]  <= (r_bayer_00_00_1P_1 >> 1) + (r_bayer_00_11_2P_1 >> 1);
                  
         r_r_00_00_1P[PW-1:P_DEPTH] <= (((r_bayer_01_01_0P_0 >> 1) + (r_bayer_11_00_1P_0 >> 1)) >> 1) + (((r_bayer_11_01_0P_0 >> 1) + (r_bayer_01_00_1P_0 >> 1)) >> 1);
         r_g_00_00_1P[PW-1:P_DEPTH] <= (((r_bayer_11_00_1P_1 >> 1) + (r_bayer_01_00_1P_1 >> 1)) >> 1) + (((r_bayer_00_01_0P_0 >> 1) + (r_bayer_00_00_1P_0 >> 1)) >> 1);    
         r_b_00_00_1P[PW-1:P_DEPTH] <= r_bayer_00_00_1P_1;

         /* B Gb B Gb */
         //r_r_00_00_1P[P_DEPTH-1:0]  <= (((r_bayer_11_00_1P_1 >> 1) + (r_bayer_01_11_2P_1 >> 1)) >> 1) + (((r_bayer_01_00_1P_1 >> 1) + (r_bayer_11_11_2P_1 >> 1)) >> 1);
         //r_g_00_00_1P[P_DEPTH-1:0]  <= (((r_bayer_11_00_1P_0 >> 1) + (r_bayer_01_00_1P_0 >> 1)) >> 1) + (((r_bayer_00_00_1P_1 >> 1) + (r_bayer_00_11_2P_1 >> 1)) >> 1);
         //r_b_00_00_1P[P_DEPTH-1:0]  <= r_bayer_00_00_1P_0;
         //
         //r_r_00_00_1P[PW-1:P_DEPTH] <= (r_bayer_11_00_1P_1 >> 1) + (r_bayer_01_00_1P_1 >> 1);
         //r_g_00_00_1P[PW-1:P_DEPTH] <= r_bayer_00_00_1P_1;            
         //r_b_00_00_1P[PW-1:P_DEPTH] <= (r_bayer_00_01_0P_0 >> 1) + (r_bayer_00_00_1P_0 >> 1);
      end
   end   
end

assign o_vsync = r_vsync_00_2P;
assign o_valid = r_valid_00_2P;
assign o_r     = r_r_00_00_1P;
assign o_g     = r_g_00_00_1P;
assign o_b     = r_b_00_00_1P;

endmodule
