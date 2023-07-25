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

module common_shift_reg #(
    parameter   D_WIDTH = 1,
    parameter   TAPE    = 1
) (
    input   i_arst,
    input   i_clk,
    
    input   i_en,
    input   [D_WIDTH-1:0]i_d,
    output  [D_WIDTH-1:0]o_q
);

reg		[D_WIDTH-1:0]r_q[0:TAPE-1];

always@(posedge i_arst or posedge i_clk)
begin
	if (i_arst)
		r_q[0]	<= {D_WIDTH{1'b0}};
	else if (i_en)
		r_q[0]	<= i_d;
end

genvar i;
generate
	for (i=1; i<TAPE; i=i+1)
	begin: shift
		always@(posedge i_arst or posedge i_clk)
		begin
			if (i_arst)
				r_q[i]	<= {D_WIDTH{1'b0}};
			else if (i_en)
				r_q[i]	<= r_q[i-1];
		end
	end
endgenerate

assign	o_q	= r_q[TAPE-1];

endmodule
