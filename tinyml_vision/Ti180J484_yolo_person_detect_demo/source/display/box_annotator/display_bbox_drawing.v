module display_bbox_drawing #(
   parameter FRAME_WIDTH  = 16,
   parameter FRAME_HEIGHT = 9,
   parameter MAX_BBOX     = 5
)(
   input             clk,
   input             rst,
   input      [63:0] bbox_data_in,
   input             bbox_data_in_valid,
   input      [63:0] pixel_data_in,
   input             pixel_data_in_valid,
   output reg [63:0] pixel_data_out,
   output reg        pixel_data_out_valid
);

//Input pixel data format {8'b0, 8-bit B, 8-bit G, 8-bit R}
localparam BBOX_PIXEL = 32'h0000FF00; //Set to green;
localparam COUNT_BBOX_BIT = $clog2(MAX_BBOX);

genvar j;
integer i;

reg  [63:0]                bbox [0:MAX_BBOX-1];
reg  [COUNT_BBOX_BIT-1:0]  bbox_count;
reg  [15:0]                count_x_frame;
reg  [15:0]                count_y_frame;

wire [15:0]                bbox_x0 [0:MAX_BBOX-1];
wire [15:0]                bbox_y0 [0:MAX_BBOX-1];
wire [15:0]                bbox_x1 [0:MAX_BBOX-1];
wire [15:0]                bbox_y1 [0:MAX_BBOX-1];

wire                       bbox_even [0:MAX_BBOX-1];
wire                       bbox_odd  [0:MAX_BBOX-1];
wire                       bbox_even_comb [0:MAX_BBOX-1];
wire                       bbox_odd_comb  [0:MAX_BBOX-1];

//Store bounding box coordinates
always@(posedge clk)
begin
   if(rst) begin
      bbox_count <= {COUNT_BBOX_BIT{1'b0}};
      for(i=0; i<MAX_BBOX; i=i+1)
      begin
         bbox[i] <= {64{1'b1}}; //Default no valid box
      end
   end else begin
      bbox_count <= (bbox_data_in_valid & (bbox_count==MAX_BBOX-1)) ? {COUNT_BBOX_BIT{1'b0}} : 
                    (bbox_data_in_valid)                            ? bbox_count + 1'b1      : bbox_count;
      
      for(i=0; i<MAX_BBOX; i=i+1)
      begin
         bbox[i] <= (bbox_data_in_valid & (i==bbox_count)) ? bbox_data_in : bbox[i];
      end
   end
end

//Function for bounding box coordinates comparison
function bbox_comp (input [15:0] count_x, count_y, x0, y0, x1, y1);
   reg top_bottom_lines;
   reg left_right_lines;
   
   begin
      top_bottom_lines = ((count_y == y0) | (count_y == y1)) & (count_x >= x0) & (count_x <= x1);
      left_right_lines = ((count_x == x0) | (count_x == x1)) & (count_y >= y0) & (count_y <= y1);
      
      bbox_comp = (top_bottom_lines | left_right_lines);
   end
endfunction

//Consolidate bounding box information
generate
   for (j=0; j<MAX_BBOX; j=j+1)
   begin
      //Bounding box format: top-left corner (x0, y0); bottom-right corner (x1, y1)
      assign bbox_x0 [j] = bbox[j][63:48];
      assign bbox_y0 [j] = bbox[j][47:32];
      assign bbox_x1 [j] = bbox[j][31:16];
      assign bbox_y1 [j] = bbox[j][15:0];
      
      assign bbox_even [j] = bbox_comp (count_x_frame, count_y_frame, bbox_x0 [j], bbox_y0 [j], bbox_x1 [j], bbox_y1 [j]);
      assign bbox_odd  [j] = bbox_comp ({count_x_frame[15:1], 1'b1}, count_y_frame, bbox_x0 [j], bbox_y0 [j], bbox_x1 [j], bbox_y1 [j]);
   end
   
   assign bbox_even_comb [MAX_BBOX-1] = bbox_even [MAX_BBOX-1];
   assign bbox_odd_comb  [MAX_BBOX-1] = bbox_odd  [MAX_BBOX-1];
   if(MAX_BBOX > 1)
   begin
      for (j=0; j<MAX_BBOX-1; j=j+1)
      begin
         assign bbox_even_comb [j] = bbox_even[j] | bbox_even_comb[j+1];
         assign bbox_odd_comb  [j] = bbox_odd [j] | bbox_odd_comb [j+1];
      end
   end
endgenerate

//Overlay bounding box(es) on to image data
//Assume first valid input pixel data after reset is first pixel (0,0) of a frame. Exact frame pixel data is expected.
always@(posedge clk)
begin
   if (rst) begin
      count_x_frame          <= 16'd0;
      count_y_frame          <= 16'd0;
      pixel_data_out         <= 64'd0;
      pixel_data_out_valid   <= 1'b0;
   end else begin
      count_x_frame          <= (pixel_data_in_valid & (count_x_frame == (FRAME_WIDTH-2)))                                       ? 16'd0 : //Compare with FRAME_WIDTH-2, as we do increment by 2 for 2PPC pixel data
                                (pixel_data_in_valid)                                                                            ? count_x_frame + 2'd2 : count_x_frame;
      count_y_frame          <= (pixel_data_in_valid & (count_x_frame == (FRAME_WIDTH-2)) & (count_y_frame == (FRAME_HEIGHT-1))) ? 16'd0 :
                                (pixel_data_in_valid & (count_x_frame == (FRAME_WIDTH-2)))                                       ? count_y_frame + 1'b1 : count_y_frame;
      
      pixel_data_out [31:0]  <= (bbox_even_comb[0]) ? BBOX_PIXEL : pixel_data_in [31:0];
      pixel_data_out [63:32] <= (bbox_odd_comb[0])  ? BBOX_PIXEL : pixel_data_in [63:32];
      pixel_data_out_valid   <= pixel_data_in_valid;
   end
end

endmodule