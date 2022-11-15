module tinyml_display_annotator #(
   parameter FRAME_WIDTH  = 540,
   parameter FRAME_HEIGHT = 540,
   parameter MAX_BBOX     = 16
)(
   input          clk,
   input          rst,
   input          in_valid,
   input          in_last,
   input  [63:0]  in_data,
   output         in_ready,
   output         out_valid,
   output [63:0]  out_data,
   input          out_ready
);

localparam IMG_DATA_COUNT  = (FRAME_WIDTH*FRAME_HEIGHT)/2; //2 pixel-per-clock

localparam [2:0]  S_IDLE  = 3'd0,
                  S_IMAGE = 3'd1,
                  S_BBOX  = 3'd2,
                  S_LOGO  = 3'd3,
                  S_SKIP  = 3'd4;

localparam LOGO_WIDTH  = 540;
localparam LOGO_HEIGHT = 100;
localparam LOGO_DATA_COUNT = (LOGO_WIDTH*LOGO_HEIGHT)/2;

wire        annot_out_fifo_empty;
wire [3:0]  annot_out_fifo_datacount;
wire [63:0] bbox_drawing_data_out;
wire        bbox_drawing_data_out_valid;
wire [63:0] fifo_wr_data;
wire        fifo_wren;

reg  [2:0]  state;
reg  [19:0] counter; //To check if sufficient for targeted implementation

assign out_valid = (~annot_out_fifo_empty);
assign in_ready  = (annot_out_fifo_datacount < 4'd10);
assign fifo_wren = ((state==S_LOGO) & in_ready & in_valid) | bbox_drawing_data_out_valid;
assign fifo_wr_data = (bbox_drawing_data_out_valid) ? bbox_drawing_data_out : in_data;


//Bounding box drawing
tinyml_display_bbox_drawing #(
   .FRAME_WIDTH   (FRAME_WIDTH),
   .FRAME_HEIGHT  (FRAME_HEIGHT),
   .MAX_BBOX      (MAX_BBOX)
) u_tinyml_display_bbox_drawing (
   .clk                    (clk),
   .rst                    (rst),
   .bbox_data_in           (in_data),
   .bbox_data_in_valid     ((state==S_BBOX) & in_ready & in_valid),
   .pixel_data_in          (in_data),
   .pixel_data_in_valid    ((state==S_IMAGE) & in_ready & in_valid),
   .pixel_data_out         (bbox_drawing_data_out),
   .pixel_data_out_valid   (bbox_drawing_data_out_valid)
);

//FWFT FIFO before output
tinyml_display_annot_out_fifo u_tinyml_display_annot_out_fifo (
   .full_o        (),
   .empty_o       (annot_out_fifo_empty),
   .rdata         (out_data),
   .clk_i         (clk),
   .wr_en_i       (fifo_wren),
   .rd_en_i       (out_ready),
   .a_rst_i       (rst),
   .wdata         (fifo_wr_data),
   .datacount_o   (annot_out_fifo_datacount),
   .rst_busy      ()
);

//FSM
always@(posedge clk)
begin
   if (rst) begin
      counter  <= 20'd0;
      state    <= S_IDLE;
   end else begin
      case (state)
         S_IDLE:
         begin
            counter  <= 20'd0;
            state    <= (in_ready & in_valid) ? in_data [2:0] : S_IDLE;
         end
         S_IMAGE:
         begin
            counter  <= (in_ready & in_valid) ? counter + 1'b1 : counter;
            state    <= (in_ready & in_valid & (counter == IMG_DATA_COUNT-1)) ? S_SKIP : S_IMAGE;
         end
         S_BBOX:
         begin
            counter  <= (in_ready & in_valid) ? counter + 1'b1 : counter;
            state    <= (in_ready & in_valid & (counter == MAX_BBOX-1)) ? S_SKIP : S_BBOX;
         end
         S_LOGO:
         begin
            counter  <= (in_ready & in_valid) ? counter + 1'b1 : counter;
            state    <= (in_ready & in_valid & (counter == LOGO_DATA_COUNT-1)) ? S_SKIP : S_LOGO;
         end
         S_SKIP: //Workarond to ensure tkeep from DMA always all 1 by sending even number of 64-bit words (aligned to 128-bit interconnect). Skip the dummy word
         begin
            counter  <= 20'd0;
            state    <= (in_ready & in_valid) ? S_IDLE : S_SKIP;
         end
         default:
         begin
            counter  <= 20'd0;
            state    <= S_IDLE;
         end
      endcase
   end
end

endmodule
