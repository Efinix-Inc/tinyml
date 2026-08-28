////////////////////////////////////////////////////////////////////////////////
// Copyright (C) 2013-2026 Efinix Inc. All rights reserved.
// See https://github.com/Efinix-Inc/tinyml/blob/main/LICENSE.txt for details.
////////////////////////////////////////////////////////////////////////////////

module common_reset_ctrl
#(
   parameter   NUM_RST        = 1,
   parameter   CYCLE          = 1,
   parameter   IN_RST_ACTIVE  = 1'b1,
   parameter   OUT_RST_ACTIVE = 1'b1
)
(
   input    [NUM_RST-1:0]  i_arst,
   input    [NUM_RST-1:0]  i_clk,
   output   [NUM_RST-1:0]  o_srst
);

genvar i;
generate
   for (i=0; i<NUM_RST; i=i+1)
   begin
      if (IN_RST_ACTIVE & (1'b1 << i))
      begin
         if (OUT_RST_ACTIVE & (1'b1 << i))
         begin
            reset
            #(
               .IN_RST_ACTIVE    ("HIGH"),
               .OUT_RST_ACTIVE   ("HIGH"),
               .CYCLE            (CYCLE)
            )
            inst_sysclk_rstn
            (
               .i_arst  (i_arst[i]),
               .i_clk   (i_clk[i]),
               .o_srst  (o_srst[i])
            );
         end
         else
         begin
            reset
            #(
               .IN_RST_ACTIVE    ("HIGH"),
               .OUT_RST_ACTIVE   ("LOW"),
               .CYCLE            (CYCLE)
            )
            inst_sysclk_rstn
            (
               .i_arst  (i_arst[i]),
               .i_clk   (i_clk[i]),
               .o_srst  (o_srst[i])
            );
         end
      end
      else
      begin
         if (OUT_RST_ACTIVE & (1'b1 << i))
         begin
            reset
            #(
               .IN_RST_ACTIVE    ("LOW"),
               .OUT_RST_ACTIVE   ("HIGH"),
               .CYCLE            (CYCLE)
            )
            inst_sysclk_rstn
            (
               .i_arst  (i_arst[i]),
               .i_clk   (i_clk[i]),
               .o_srst  (o_srst[i])
            );
         end
         else
         begin
            reset
            #(
               .IN_RST_ACTIVE    ("LOW"),
               .OUT_RST_ACTIVE   ("LOW"),
               .CYCLE            (CYCLE)
            )
            inst_sysclk_rstn
            (
               .i_arst  (i_arst[i]),
               .i_clk   (i_clk[i]),
               .o_srst  (o_srst[i])
            );
         end
      end
   end
endgenerate

endmodule


module reset
#(
   parameter   IN_RST_ACTIVE  = "LOW",
   parameter   OUT_RST_ACTIVE = "HIGH",
   parameter   CYCLE          = 1
)
(
   input    i_arst,
   input    i_clk,

   output   o_srst
);

reg      [CYCLE-1:0]r_srst_1P;

genvar i;
generate
   if (IN_RST_ACTIVE == "LOW")
   begin
      if (OUT_RST_ACTIVE == "LOW")
      begin
         always@(negedge i_arst or posedge i_clk)
         begin
            if (~i_arst)
               r_srst_1P[0]   <= 1'b0;
            else
               r_srst_1P[0]   <= 1'b1;
         end
         
         for (i=0; i<CYCLE-1; i=i+1)
         begin
            always@(negedge i_arst or posedge i_clk)
            begin
               if (~i_arst)
                  r_srst_1P[i+1] <= 1'b0;
               else
                  r_srst_1P[i+1] <= r_srst_1P[i];
            end
         end
      end
      else
      begin
         always@(negedge i_arst or posedge i_clk)
         begin
            if (~i_arst)
               r_srst_1P[0]   <= 1'b1;
            else
               r_srst_1P[0]   <= 1'b0;
         end
         
         for (i=0; i<CYCLE-1; i=i+1)
         begin
            always@(negedge i_arst or posedge i_clk)
            begin
               if (~i_arst)
                  r_srst_1P[i+1] <= 1'b1;
               else
                  r_srst_1P[i+1] <= r_srst_1P[i];
            end
         end
      end
   end
   else
   begin
      if (OUT_RST_ACTIVE == "LOW")
      begin
         always@(posedge i_arst or posedge i_clk)
         begin
            if (i_arst)
               r_srst_1P[0]   <= 1'b0;
            else
               r_srst_1P[0]   <= 1'b1;
         end
         
         for (i=0; i<CYCLE-1; i=i+1)
         begin
            always@(posedge i_arst or posedge i_clk)
            begin
               if (i_arst)
                  r_srst_1P[i+1] <= 1'b0;
               else
                  r_srst_1P[i+1] <= r_srst_1P[i];
            end
         end
      end
      else
      begin
         always@(posedge i_arst or posedge i_clk)
         begin
            if (i_arst)
               r_srst_1P[0]   <= 1'b1;
            else
               r_srst_1P[0]   <= 1'b0;
         end
         
         for (i=0; i<CYCLE-1; i=i+1)
         begin
            always@(posedge i_arst or posedge i_clk)
            begin
               if (i_arst)
                  r_srst_1P[i+1] <= 1'b1;
               else
                  r_srst_1P[i+1] <= r_srst_1P[i];
            end
         end
      end
   end
endgenerate

assign   o_srst   = r_srst_1P[CYCLE-1];

endmodule
