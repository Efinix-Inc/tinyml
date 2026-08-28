////////////////////////////////////////////////////////////////////////////////
// Copyright (C) 2013-2026 Efinix Inc. All rights reserved.
// See https://github.com/Efinix-Inc/tinyml/blob/main/LICENSE.txt for details.
////////////////////////////////////////////////////////////////////////////////

module common_reset
#(
	parameter	IN_RST_ACTIVE	= "LOW",
	parameter	OUT_RST_ACTIVE	= "HIGH",
	parameter	CYCLE			= 1
)
(
	input	i_arst,
	input	i_clk,

	output	o_srst
);

reg		[CYCLE-1:0]r_srst_1P;

genvar i;
generate
	if (IN_RST_ACTIVE == "LOW")
	begin
		if (OUT_RST_ACTIVE == "LOW")
		begin
			always@(negedge i_arst or posedge i_clk)
			begin
				if (~i_arst)
					r_srst_1P[0]	<= 1'b0;
				else
					r_srst_1P[0]	<= 1'b1;
			end
			
			for (i=0; i<CYCLE-1; i=i+1)
			begin
				always@(negedge i_arst or posedge i_clk)
				begin
					if (~i_arst)
						r_srst_1P[i+1]	<= 1'b0;
					else
						r_srst_1P[i+1]	<= r_srst_1P[i];
				end
			end
		end
		else
		begin
			always@(negedge i_arst or posedge i_clk)
			begin
				if (~i_arst)
					r_srst_1P[0]	<= 1'b1;
				else
					r_srst_1P[0]	<= 1'b0;
			end
			
			for (i=0; i<CYCLE-1; i=i+1)
			begin
				always@(negedge i_arst or posedge i_clk)
				begin
					if (~i_arst)
						r_srst_1P[i+1]	<= 1'b1;
					else
						r_srst_1P[i+1]	<= r_srst_1P[i];
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
					r_srst_1P[0]	<= 1'b0;
				else
					r_srst_1P[0]	<= 1'b1;
			end
			
			for (i=0; i<CYCLE-1; i=i+1)
			begin
				always@(posedge i_arst or posedge i_clk)
				begin
					if (i_arst)
						r_srst_1P[i+1]	<= 1'b0;
					else
						r_srst_1P[i+1]	<= r_srst_1P[i];
				end
			end
		end
		else
		begin
			always@(posedge i_arst or posedge i_clk)
			begin
				if (i_arst)
					r_srst_1P[0]	<= 1'b1;
				else
					r_srst_1P[0]	<= 1'b0;
			end
			
			for (i=0; i<CYCLE-1; i=i+1)
			begin
				always@(posedge i_arst or posedge i_clk)
				begin
					if (i_arst)
						r_srst_1P[i+1]	<= 1'b1;
					else
						r_srst_1P[i+1]	<= r_srst_1P[i];
				end
			end
		end
	end
endgenerate

assign	o_srst	= r_srst_1P[CYCLE-1];

endmodule
