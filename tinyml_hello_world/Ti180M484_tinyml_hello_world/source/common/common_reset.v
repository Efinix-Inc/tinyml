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
