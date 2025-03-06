module BlockRAMModule(
  input         clock,
  input  [7:0]  io_addrr,
  output [63:0] io_data_out,
  input         io_enw,
  input  [7:0]  io_addrw,
  input  [63:0] io_data_in
);
`ifdef RANDOMIZE_MEM_INIT
  reg [63:0] _RAND_0;
`endif // RANDOMIZE_MEM_INIT
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_1;
`endif // RANDOMIZE_REG_INIT
  reg [63:0] ram [0:255]; // @[BlockRAM.scala 20:24]
  wire [63:0] ram_io_data_out_MPORT_data; // @[BlockRAM.scala 20:24]
  wire [7:0] ram_io_data_out_MPORT_addr; // @[BlockRAM.scala 20:24]
  wire [63:0] ram_MPORT_data; // @[BlockRAM.scala 20:24]
  wire [7:0] ram_MPORT_addr; // @[BlockRAM.scala 20:24]
  wire  ram_MPORT_mask; // @[BlockRAM.scala 20:24]
  wire  ram_MPORT_en; // @[BlockRAM.scala 20:24]
  reg [7:0] ram_io_data_out_MPORT_addr_pipe_0;
  assign ram_io_data_out_MPORT_addr = ram_io_data_out_MPORT_addr_pipe_0;
  assign ram_io_data_out_MPORT_data = ram[ram_io_data_out_MPORT_addr]; // @[BlockRAM.scala 20:24]
  assign ram_MPORT_data = io_data_in;
  assign ram_MPORT_addr = io_addrw;
  assign ram_MPORT_mask = 1'h1;
  assign ram_MPORT_en = io_enw;
  assign io_data_out = ram_io_data_out_MPORT_data; // @[BlockRAM.scala 22:15]
  always @(posedge clock) begin
    if(ram_MPORT_en & ram_MPORT_mask) begin
      ram[ram_MPORT_addr] <= ram_MPORT_data; // @[BlockRAM.scala 20:24]
    end
    ram_io_data_out_MPORT_addr_pipe_0 <= io_addrr;
  end
// Register and memory initialization
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE_MEM_INIT
  integer initvar;
`endif
`ifndef SYNTHESIS
`ifdef FIRRTL_BEFORE_INITIAL
`FIRRTL_BEFORE_INITIAL
`endif
initial begin
  `ifdef RANDOMIZE
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      `ifdef RANDOMIZE_DELAY
        #`RANDOMIZE_DELAY begin end
      `else
        #0.002 begin end
      `endif
    `endif
`ifdef RANDOMIZE_MEM_INIT
  _RAND_0 = {2{`RANDOM}};
  for (initvar = 0; initvar < 256; initvar = initvar+1)
    ram[initvar] = _RAND_0[63:0];
`endif // RANDOMIZE_MEM_INIT
`ifdef RANDOMIZE_REG_INIT
  _RAND_1 = {1{`RANDOM}};
  ram_io_data_out_MPORT_addr_pipe_0 = _RAND_1[7:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
module BlockRAMModule_1(
  input         clock,
  input  [10:0] io_addrr,
  output [63:0] io_data_out,
  input         io_enw,
  input  [10:0] io_addrw,
  input  [63:0] io_data_in
);
`ifdef RANDOMIZE_GARBAGE_ASSIGN
  reg [63:0] _RAND_1;
`endif // RANDOMIZE_GARBAGE_ASSIGN
`ifdef RANDOMIZE_MEM_INIT
  reg [63:0] _RAND_0;
`endif // RANDOMIZE_MEM_INIT
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_2;
`endif // RANDOMIZE_REG_INIT
  reg [63:0] ram [0:1147]; // @[BlockRAM.scala 20:24]
  wire [63:0] ram_io_data_out_MPORT_data; // @[BlockRAM.scala 20:24]
  wire [10:0] ram_io_data_out_MPORT_addr; // @[BlockRAM.scala 20:24]
  wire [63:0] ram_MPORT_data; // @[BlockRAM.scala 20:24]
  wire [10:0] ram_MPORT_addr; // @[BlockRAM.scala 20:24]
  wire  ram_MPORT_mask; // @[BlockRAM.scala 20:24]
  wire  ram_MPORT_en; // @[BlockRAM.scala 20:24]
  reg [10:0] ram_io_data_out_MPORT_addr_pipe_0;
  assign ram_io_data_out_MPORT_addr = ram_io_data_out_MPORT_addr_pipe_0;
  `ifndef RANDOMIZE_GARBAGE_ASSIGN
  assign ram_io_data_out_MPORT_data = ram[ram_io_data_out_MPORT_addr]; // @[BlockRAM.scala 20:24]
  `else
  assign ram_io_data_out_MPORT_data = ram_io_data_out_MPORT_addr >= 11'h47c ? _RAND_1[63:0] :
    ram[ram_io_data_out_MPORT_addr]; // @[BlockRAM.scala 20:24]
  `endif // RANDOMIZE_GARBAGE_ASSIGN
  assign ram_MPORT_data = io_data_in;
  assign ram_MPORT_addr = io_addrw;
  assign ram_MPORT_mask = 1'h1;
  assign ram_MPORT_en = io_enw;
  assign io_data_out = ram_io_data_out_MPORT_data; // @[BlockRAM.scala 22:15]
  always @(posedge clock) begin
    if(ram_MPORT_en & ram_MPORT_mask) begin
      ram[ram_MPORT_addr] <= ram_MPORT_data; // @[BlockRAM.scala 20:24]
    end
    ram_io_data_out_MPORT_addr_pipe_0 <= io_addrr;
  end
// Register and memory initialization
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE_MEM_INIT
  integer initvar;
`endif
`ifndef SYNTHESIS
`ifdef FIRRTL_BEFORE_INITIAL
`FIRRTL_BEFORE_INITIAL
`endif
initial begin
  `ifdef RANDOMIZE
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      `ifdef RANDOMIZE_DELAY
        #`RANDOMIZE_DELAY begin end
      `else
        #0.002 begin end
      `endif
    `endif
`ifdef RANDOMIZE_GARBAGE_ASSIGN
  _RAND_1 = {2{`RANDOM}};
`endif // RANDOMIZE_GARBAGE_ASSIGN
`ifdef RANDOMIZE_MEM_INIT
  _RAND_0 = {2{`RANDOM}};
  for (initvar = 0; initvar < 1148; initvar = initvar+1)
    ram[initvar] = _RAND_0[63:0];
`endif // RANDOMIZE_MEM_INIT
`ifdef RANDOMIZE_REG_INIT
  _RAND_2 = {1{`RANDOM}};
  ram_io_data_out_MPORT_addr_pipe_0 = _RAND_2[10:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
module AnnotatorController(
  input         clock,
  input         reset,
  input         io_in_pixel_start,
  input         io_in_pixel_valid,
  input         io_in_pixel_last,
  input  [63:0] io_in_pixel_data,
  output [10:0] io_framebuf_addr,
  input  [63:0] io_framebuf_data,
  output [7:0]  io_fontbuf_addr,
  input  [63:0] io_fontbuf_data,
  input  [63:0] io_in_box_data,
  input  [4:0]  io_in_box_counter,
  input         io_in_box_valid,
  output        io_out_pixel_valid,
  output        io_out_pixel_last,
  output [63:0] io_out_pixel_data
);
`ifdef RANDOMIZE_REG_INIT
  reg [63:0] _RAND_0;
  reg [63:0] _RAND_1;
  reg [63:0] _RAND_2;
  reg [63:0] _RAND_3;
  reg [63:0] _RAND_4;
  reg [63:0] _RAND_5;
  reg [63:0] _RAND_6;
  reg [63:0] _RAND_7;
  reg [63:0] _RAND_8;
  reg [63:0] _RAND_9;
  reg [63:0] _RAND_10;
  reg [63:0] _RAND_11;
  reg [63:0] _RAND_12;
  reg [63:0] _RAND_13;
  reg [63:0] _RAND_14;
  reg [63:0] _RAND_15;
  reg [63:0] _RAND_16;
  reg [63:0] _RAND_17;
  reg [63:0] _RAND_18;
  reg [63:0] _RAND_19;
  reg [63:0] _RAND_20;
  reg [63:0] _RAND_21;
  reg [63:0] _RAND_22;
  reg [63:0] _RAND_23;
  reg [63:0] _RAND_24;
  reg [63:0] _RAND_25;
  reg [63:0] _RAND_26;
  reg [63:0] _RAND_27;
  reg [63:0] _RAND_28;
  reg [63:0] _RAND_29;
  reg [63:0] _RAND_30;
  reg [63:0] _RAND_31;
  reg [31:0] _RAND_32;
  reg [31:0] _RAND_33;
  reg [31:0] _RAND_34;
  reg [31:0] _RAND_35;
  reg [31:0] _RAND_36;
  reg [31:0] _RAND_37;
  reg [31:0] _RAND_38;
  reg [31:0] _RAND_39;
  reg [31:0] _RAND_40;
  reg [31:0] _RAND_41;
  reg [31:0] _RAND_42;
  reg [31:0] _RAND_43;
  reg [31:0] _RAND_44;
  reg [31:0] _RAND_45;
  reg [31:0] _RAND_46;
  reg [31:0] _RAND_47;
  reg [31:0] _RAND_48;
  reg [31:0] _RAND_49;
  reg [63:0] _RAND_50;
  reg [63:0] _RAND_51;
  reg [63:0] _RAND_52;
  reg [63:0] _RAND_53;
`endif // RANDOMIZE_REG_INIT
  reg [63:0] coord_reg_0; // @[Annotator.scala 118:26]
  reg [63:0] coord_reg_1; // @[Annotator.scala 118:26]
  reg [63:0] coord_reg_2; // @[Annotator.scala 118:26]
  reg [63:0] coord_reg_3; // @[Annotator.scala 118:26]
  reg [63:0] coord_reg_4; // @[Annotator.scala 118:26]
  reg [63:0] coord_reg_5; // @[Annotator.scala 118:26]
  reg [63:0] coord_reg_6; // @[Annotator.scala 118:26]
  reg [63:0] coord_reg_7; // @[Annotator.scala 118:26]
  reg [63:0] coord_reg_8; // @[Annotator.scala 118:26]
  reg [63:0] coord_reg_9; // @[Annotator.scala 118:26]
  reg [63:0] coord_reg_10; // @[Annotator.scala 118:26]
  reg [63:0] coord_reg_11; // @[Annotator.scala 118:26]
  reg [63:0] coord_reg_12; // @[Annotator.scala 118:26]
  reg [63:0] coord_reg_13; // @[Annotator.scala 118:26]
  reg [63:0] coord_reg_14; // @[Annotator.scala 118:26]
  reg [63:0] coord_reg_15; // @[Annotator.scala 118:26]
  reg [63:0] coord_reg_16; // @[Annotator.scala 118:26]
  reg [63:0] coord_reg_17; // @[Annotator.scala 118:26]
  reg [63:0] coord_reg_18; // @[Annotator.scala 118:26]
  reg [63:0] coord_reg_19; // @[Annotator.scala 118:26]
  reg [63:0] coord_reg_20; // @[Annotator.scala 118:26]
  reg [63:0] coord_reg_21; // @[Annotator.scala 118:26]
  reg [63:0] coord_reg_22; // @[Annotator.scala 118:26]
  reg [63:0] coord_reg_23; // @[Annotator.scala 118:26]
  reg [63:0] coord_reg_24; // @[Annotator.scala 118:26]
  reg [63:0] coord_reg_25; // @[Annotator.scala 118:26]
  reg [63:0] coord_reg_26; // @[Annotator.scala 118:26]
  reg [63:0] coord_reg_27; // @[Annotator.scala 118:26]
  reg [63:0] coord_reg_28; // @[Annotator.scala 118:26]
  reg [63:0] coord_reg_29; // @[Annotator.scala 118:26]
  reg [63:0] coord_reg_30; // @[Annotator.scala 118:26]
  reg [63:0] coord_reg_31; // @[Annotator.scala 118:26]
  reg [31:0] box_pixel_overlay_0; // @[Annotator.scala 128:30]
  reg [31:0] box_pixel_overlay_1; // @[Annotator.scala 128:30]
  reg [10:0] image_x; // @[Counter.scala 60:40]
  wire  wrap_wrap = image_x == 11'h436; // @[Counter.scala 72:24]
  wire [10:0] _wrap_value_T_1 = image_x + 11'h2; // @[Counter.scala 76:24]
  wire  _GEN_66 = io_in_pixel_valid & wrap_wrap; // @[Counter.scala 137:24 Counter.scala 138:12]
  wire  next_line_start = io_in_pixel_start ? 1'h0 : _GEN_66; // @[Counter.scala 135:17]
  reg [10:0] image_y; // @[Counter.scala 60:40]
  wire  wrap_wrap_1 = image_y == 11'h437; // @[Counter.scala 72:24]
  wire [10:0] _wrap_value_T_3 = image_y + 11'h1; // @[Counter.scala 76:24]
  reg [2:0] char_x; // @[Counter.scala 60:40]
  wire  wrap_wrap_2 = char_x == 3'h6; // @[Counter.scala 72:24]
  wire [2:0] _wrap_value_T_5 = char_x + 3'h2; // @[Counter.scala 76:24]
  wire  _GEN_75 = io_in_pixel_valid & wrap_wrap_2; // @[Counter.scala 137:24 Counter.scala 138:12]
  wire  next_char_start = io_in_pixel_start ? 1'h0 : _GEN_75; // @[Counter.scala 135:17]
  reg [3:0] char_y; // @[Counter.scala 60:40]
  wire  wrap_wrap_3 = char_y == 4'hf; // @[Counter.scala 72:24]
  wire [3:0] _wrap_value_T_7 = char_y + 4'h1; // @[Counter.scala 76:24]
  wire  _GEN_79 = next_line_start & wrap_wrap_3; // @[Counter.scala 137:24 Counter.scala 138:12]
  wire  next_row_start = io_in_pixel_start ? 1'h0 : _GEN_79; // @[Counter.scala 135:17]
  reg [7:0] image_col; // @[Counter.scala 60:40]
  wire  image_col_wrap_wrap = image_col == 8'h86; // @[Counter.scala 72:24]
  wire [7:0] _image_col_wrap_value_T_1 = image_col + 8'h1; // @[Counter.scala 76:24]
  reg [6:0] image_row; // @[Counter.scala 60:40]
  wire  image_row_wrap_wrap = image_row == 7'h43; // @[Counter.scala 72:24]
  wire [6:0] _image_row_wrap_value_T_1 = image_row + 7'h1; // @[Counter.scala 76:24]
  wire [14:0] _framebuf_sel_T = image_row * 8'h87; // @[Annotator.scala 149:32]
  wire [14:0] _GEN_128 = {{7'd0}, image_col}; // @[Annotator.scala 149:56]
  wire [14:0] framebuf_sel = _framebuf_sel_T + _GEN_128; // @[Annotator.scala 149:56]
  wire [14:0] _io_framebuf_addr_T = {{3'd0}, framebuf_sel[14:3]}; // @[Annotator.scala 150:36]
  reg [2:0] framebuf_index; // @[Annotator.scala 152:31]
  wire [7:0] char_data_0 = io_framebuf_data[7:0]; // @[Utils.scala 24:25]
  wire [7:0] char_data_1 = io_framebuf_data[15:8]; // @[Utils.scala 24:25]
  wire [7:0] char_data_2 = io_framebuf_data[23:16]; // @[Utils.scala 24:25]
  wire [7:0] char_data_3 = io_framebuf_data[31:24]; // @[Utils.scala 24:25]
  wire [7:0] char_data_4 = io_framebuf_data[39:32]; // @[Utils.scala 24:25]
  wire [7:0] char_data_5 = io_framebuf_data[47:40]; // @[Utils.scala 24:25]
  wire [7:0] char_data_6 = io_framebuf_data[55:48]; // @[Utils.scala 24:25]
  wire [7:0] char_data_7 = io_framebuf_data[63:56]; // @[Utils.scala 24:25]
  wire [7:0] _GEN_93 = 3'h1 == framebuf_index ? char_data_1 : char_data_0; // @[Annotator.scala 155:58 Annotator.scala 155:58]
  wire [7:0] _GEN_94 = 3'h2 == framebuf_index ? char_data_2 : _GEN_93; // @[Annotator.scala 155:58 Annotator.scala 155:58]
  wire [7:0] _GEN_95 = 3'h3 == framebuf_index ? char_data_3 : _GEN_94; // @[Annotator.scala 155:58 Annotator.scala 155:58]
  wire [7:0] _GEN_96 = 3'h4 == framebuf_index ? char_data_4 : _GEN_95; // @[Annotator.scala 155:58 Annotator.scala 155:58]
  wire [7:0] _GEN_97 = 3'h5 == framebuf_index ? char_data_5 : _GEN_96; // @[Annotator.scala 155:58 Annotator.scala 155:58]
  wire [7:0] _GEN_98 = 3'h6 == framebuf_index ? char_data_6 : _GEN_97; // @[Annotator.scala 155:58 Annotator.scala 155:58]
  wire [7:0] _GEN_99 = 3'h7 == framebuf_index ? char_data_7 : _GEN_98; // @[Annotator.scala 155:58 Annotator.scala 155:58]
  wire [15:0] _fontbuf_sel_T = 8'h80 * _GEN_99; // @[Annotator.scala 155:58]
  reg [3:0] fontbuf_sel_REG; // @[Annotator.scala 155:74]
  wire [7:0] _fontbuf_sel_T_1 = fontbuf_sel_REG * 4'h8; // @[Annotator.scala 155:83]
  wire [15:0] _GEN_130 = {{8'd0}, _fontbuf_sel_T_1}; // @[Annotator.scala 155:65]
  wire [15:0] _fontbuf_sel_T_3 = _fontbuf_sel_T + _GEN_130; // @[Annotator.scala 155:65]
  reg [2:0] fontbuf_sel_REG_1; // @[Annotator.scala 155:112]
  wire [15:0] _GEN_131 = {{13'd0}, fontbuf_sel_REG_1}; // @[Annotator.scala 155:103]
  wire [15:0] fontbuf_sel = _fontbuf_sel_T_3 + _GEN_131; // @[Annotator.scala 155:103]
  wire [15:0] _io_fontbuf_addr_T = {{6'd0}, fontbuf_sel[15:6]}; // @[Annotator.scala 156:34]
  reg [5:0] fontbuf_index; // @[Annotator.scala 158:30]
  wire [7:0] overlay_value1_data_0 = io_fontbuf_data[7:0]; // @[Utils.scala 24:25]
  wire [7:0] overlay_value1_data_1 = io_fontbuf_data[15:8]; // @[Utils.scala 24:25]
  wire [7:0] overlay_value1_data_2 = io_fontbuf_data[23:16]; // @[Utils.scala 24:25]
  wire [7:0] overlay_value1_data_3 = io_fontbuf_data[31:24]; // @[Utils.scala 24:25]
  wire [7:0] overlay_value1_data_4 = io_fontbuf_data[39:32]; // @[Utils.scala 24:25]
  wire [7:0] overlay_value1_data_5 = io_fontbuf_data[47:40]; // @[Utils.scala 24:25]
  wire [7:0] overlay_value1_data_6 = io_fontbuf_data[55:48]; // @[Utils.scala 24:25]
  wire [7:0] overlay_value1_data_7 = io_fontbuf_data[63:56]; // @[Utils.scala 24:25]
  wire [7:0] _GEN_101 = 3'h1 == fontbuf_index[5:3] ? overlay_value1_data_1 : overlay_value1_data_0; // @[Bitwise.scala 103:21 Bitwise.scala 103:21]
  wire [7:0] _GEN_102 = 3'h2 == fontbuf_index[5:3] ? overlay_value1_data_2 : _GEN_101; // @[Bitwise.scala 103:21 Bitwise.scala 103:21]
  wire [7:0] _GEN_103 = 3'h3 == fontbuf_index[5:3] ? overlay_value1_data_3 : _GEN_102; // @[Bitwise.scala 103:21 Bitwise.scala 103:21]
  wire [7:0] _GEN_104 = 3'h4 == fontbuf_index[5:3] ? overlay_value1_data_4 : _GEN_103; // @[Bitwise.scala 103:21 Bitwise.scala 103:21]
  wire [7:0] _GEN_105 = 3'h5 == fontbuf_index[5:3] ? overlay_value1_data_5 : _GEN_104; // @[Bitwise.scala 103:21 Bitwise.scala 103:21]
  wire [7:0] _GEN_106 = 3'h6 == fontbuf_index[5:3] ? overlay_value1_data_6 : _GEN_105; // @[Bitwise.scala 103:21 Bitwise.scala 103:21]
  wire [7:0] _GEN_107 = 3'h7 == fontbuf_index[5:3] ? overlay_value1_data_7 : _GEN_106; // @[Bitwise.scala 103:21 Bitwise.scala 103:21]
  wire [7:0] _overlay_value1_T_12 = {{4'd0}, _GEN_107[7:4]}; // @[Bitwise.scala 103:31]
  wire [7:0] _overlay_value1_T_14 = {_GEN_107[3:0], 4'h0}; // @[Bitwise.scala 103:65]
  wire [7:0] _overlay_value1_T_16 = _overlay_value1_T_14 & 8'hf0; // @[Bitwise.scala 103:75]
  wire [7:0] _overlay_value1_T_17 = _overlay_value1_T_12 | _overlay_value1_T_16; // @[Bitwise.scala 103:39]
  wire [7:0] _GEN_133 = {{2'd0}, _overlay_value1_T_17[7:2]}; // @[Bitwise.scala 103:31]
  wire [7:0] _overlay_value1_T_22 = _GEN_133 & 8'h33; // @[Bitwise.scala 103:31]
  wire [7:0] _overlay_value1_T_24 = {_overlay_value1_T_17[5:0], 2'h0}; // @[Bitwise.scala 103:65]
  wire [7:0] _overlay_value1_T_26 = _overlay_value1_T_24 & 8'hcc; // @[Bitwise.scala 103:75]
  wire [7:0] _overlay_value1_T_27 = _overlay_value1_T_22 | _overlay_value1_T_26; // @[Bitwise.scala 103:39]
  wire [7:0] _GEN_134 = {{1'd0}, _overlay_value1_T_27[7:1]}; // @[Bitwise.scala 103:31]
  wire [7:0] _overlay_value1_T_32 = _GEN_134 & 8'h55; // @[Bitwise.scala 103:31]
  wire [7:0] _overlay_value1_T_34 = {_overlay_value1_T_27[6:0], 1'h0}; // @[Bitwise.scala 103:65]
  wire [7:0] _overlay_value1_T_36 = _overlay_value1_T_34 & 8'haa; // @[Bitwise.scala 103:75]
  wire [7:0] _overlay_value1_T_37 = _overlay_value1_T_32 | _overlay_value1_T_36; // @[Bitwise.scala 103:39]
  wire [2:0] _overlay_value1_T_39 = fontbuf_index[2:0] | 3'h1; // @[Annotator.scala 160:112]
  wire [7:0] _overlay_value1_T_40 = _overlay_value1_T_37 >> _overlay_value1_T_39; // @[Annotator.scala 160:90]
  wire [31:0] overlay_value1 = _overlay_value1_T_40[0] ? 32'hffffffff : 32'h0; // @[Bitwise.scala 72:12]
  wire [7:0] _overlay_value0_T_39 = _overlay_value1_T_37 >> fontbuf_index[2:0]; // @[Annotator.scala 161:90]
  wire [31:0] overlay_value0 = _overlay_value0_T_39[0] ? 32'hffffffff : 32'h0; // @[Bitwise.scala 72:12]
  wire [15:0] y1_0 = coord_reg_0[15:0]; // @[Annotator.scala 168:36]
  wire [15:0] x1_0 = coord_reg_0[31:16]; // @[Annotator.scala 169:36]
  wire [15:0] y0_0 = coord_reg_0[47:32]; // @[Annotator.scala 170:36]
  wire [15:0] x0_0 = coord_reg_0[63:48]; // @[Annotator.scala 171:36]
  wire [15:0] _GEN_137 = {{5'd0}, image_y}; // @[Annotator.scala 86:32]
  wire [15:0] _GEN_139 = {{5'd0}, image_x}; // @[Annotator.scala 86:70]
  wire  even_0_top_bottom = (_GEN_137 == y0_0 | _GEN_137 == y1_0) & (_GEN_139 >= x0_0 & _GEN_139 <= x1_0); // @[Annotator.scala 86:58]
  wire  even_0_left_right = (_GEN_139 == x0_0 | _GEN_139 == x1_0) & (_GEN_137 >= y0_0 & _GEN_137 <= y1_0); // @[Annotator.scala 87:58]
  wire  even_0 = even_0_top_bottom | even_0_left_right; // @[Annotator.scala 89:16]
  wire [10:0] _odd_0_T_1 = image_x + 11'h1; // @[Annotator.scala 174:44]
  wire [15:0] _GEN_147 = {{5'd0}, _odd_0_T_1}; // @[Annotator.scala 86:70]
  wire  odd_0_top_bottom = (_GEN_137 == y0_0 | _GEN_137 == y1_0) & (_GEN_147 >= x0_0 & _GEN_147 <= x1_0); // @[Annotator.scala 86:58]
  wire  odd_0_left_right = (_GEN_147 == x0_0 | _GEN_147 == x1_0) & (_GEN_137 >= y0_0 & _GEN_137 <= y1_0); // @[Annotator.scala 87:58]
  wire  odd_0 = odd_0_top_bottom | odd_0_left_right; // @[Annotator.scala 89:16]
  wire [15:0] y0_1 = coord_reg_1[47:32]; // @[Annotator.scala 170:36]
  wire [15:0] y1_1 = coord_reg_1[15:0]; // @[Annotator.scala 168:36]
  wire [15:0] x0_1 = coord_reg_1[63:48]; // @[Annotator.scala 171:36]
  wire [15:0] x1_1 = coord_reg_1[31:16]; // @[Annotator.scala 169:36]
  wire  odd_1_top_bottom = (_GEN_137 == y0_1 | _GEN_137 == y1_1) & (_GEN_147 >= x0_1 & _GEN_147 <= x1_1); // @[Annotator.scala 86:58]
  wire  odd_1_left_right = (_GEN_147 == x0_1 | _GEN_147 == x1_1) & (_GEN_137 >= y0_1 & _GEN_137 <= y1_1); // @[Annotator.scala 87:58]
  wire  odd_1 = odd_1_top_bottom | odd_1_left_right; // @[Annotator.scala 89:16]
  wire [15:0] y0_2 = coord_reg_2[47:32]; // @[Annotator.scala 170:36]
  wire [15:0] y1_2 = coord_reg_2[15:0]; // @[Annotator.scala 168:36]
  wire [15:0] x0_2 = coord_reg_2[63:48]; // @[Annotator.scala 171:36]
  wire [15:0] x1_2 = coord_reg_2[31:16]; // @[Annotator.scala 169:36]
  wire  odd_2_top_bottom = (_GEN_137 == y0_2 | _GEN_137 == y1_2) & (_GEN_147 >= x0_2 & _GEN_147 <= x1_2); // @[Annotator.scala 86:58]
  wire  odd_2_left_right = (_GEN_147 == x0_2 | _GEN_147 == x1_2) & (_GEN_137 >= y0_2 & _GEN_137 <= y1_2); // @[Annotator.scala 87:58]
  wire  odd_2 = odd_2_top_bottom | odd_2_left_right; // @[Annotator.scala 89:16]
  wire [15:0] y0_3 = coord_reg_3[47:32]; // @[Annotator.scala 170:36]
  wire [15:0] y1_3 = coord_reg_3[15:0]; // @[Annotator.scala 168:36]
  wire [15:0] x0_3 = coord_reg_3[63:48]; // @[Annotator.scala 171:36]
  wire [15:0] x1_3 = coord_reg_3[31:16]; // @[Annotator.scala 169:36]
  wire  odd_3_top_bottom = (_GEN_137 == y0_3 | _GEN_137 == y1_3) & (_GEN_147 >= x0_3 & _GEN_147 <= x1_3); // @[Annotator.scala 86:58]
  wire  odd_3_left_right = (_GEN_147 == x0_3 | _GEN_147 == x1_3) & (_GEN_137 >= y0_3 & _GEN_137 <= y1_3); // @[Annotator.scala 87:58]
  wire  odd_3 = odd_3_top_bottom | odd_3_left_right; // @[Annotator.scala 89:16]
  wire [15:0] y0_4 = coord_reg_4[47:32]; // @[Annotator.scala 170:36]
  wire [15:0] y1_4 = coord_reg_4[15:0]; // @[Annotator.scala 168:36]
  wire [15:0] x0_4 = coord_reg_4[63:48]; // @[Annotator.scala 171:36]
  wire [15:0] x1_4 = coord_reg_4[31:16]; // @[Annotator.scala 169:36]
  wire  odd_4_top_bottom = (_GEN_137 == y0_4 | _GEN_137 == y1_4) & (_GEN_147 >= x0_4 & _GEN_147 <= x1_4); // @[Annotator.scala 86:58]
  wire  odd_4_left_right = (_GEN_147 == x0_4 | _GEN_147 == x1_4) & (_GEN_137 >= y0_4 & _GEN_137 <= y1_4); // @[Annotator.scala 87:58]
  wire  odd_4 = odd_4_top_bottom | odd_4_left_right; // @[Annotator.scala 89:16]
  wire [15:0] y0_5 = coord_reg_5[47:32]; // @[Annotator.scala 170:36]
  wire [15:0] y1_5 = coord_reg_5[15:0]; // @[Annotator.scala 168:36]
  wire [15:0] x0_5 = coord_reg_5[63:48]; // @[Annotator.scala 171:36]
  wire [15:0] x1_5 = coord_reg_5[31:16]; // @[Annotator.scala 169:36]
  wire  odd_5_top_bottom = (_GEN_137 == y0_5 | _GEN_137 == y1_5) & (_GEN_147 >= x0_5 & _GEN_147 <= x1_5); // @[Annotator.scala 86:58]
  wire  odd_5_left_right = (_GEN_147 == x0_5 | _GEN_147 == x1_5) & (_GEN_137 >= y0_5 & _GEN_137 <= y1_5); // @[Annotator.scala 87:58]
  wire  odd_5 = odd_5_top_bottom | odd_5_left_right; // @[Annotator.scala 89:16]
  wire [15:0] y0_6 = coord_reg_6[47:32]; // @[Annotator.scala 170:36]
  wire [15:0] y1_6 = coord_reg_6[15:0]; // @[Annotator.scala 168:36]
  wire [15:0] x0_6 = coord_reg_6[63:48]; // @[Annotator.scala 171:36]
  wire [15:0] x1_6 = coord_reg_6[31:16]; // @[Annotator.scala 169:36]
  wire  odd_6_top_bottom = (_GEN_137 == y0_6 | _GEN_137 == y1_6) & (_GEN_147 >= x0_6 & _GEN_147 <= x1_6); // @[Annotator.scala 86:58]
  wire  odd_6_left_right = (_GEN_147 == x0_6 | _GEN_147 == x1_6) & (_GEN_137 >= y0_6 & _GEN_137 <= y1_6); // @[Annotator.scala 87:58]
  wire  odd_6 = odd_6_top_bottom | odd_6_left_right; // @[Annotator.scala 89:16]
  wire [15:0] y0_7 = coord_reg_7[47:32]; // @[Annotator.scala 170:36]
  wire [15:0] y1_7 = coord_reg_7[15:0]; // @[Annotator.scala 168:36]
  wire [15:0] x0_7 = coord_reg_7[63:48]; // @[Annotator.scala 171:36]
  wire [15:0] x1_7 = coord_reg_7[31:16]; // @[Annotator.scala 169:36]
  wire  odd_7_top_bottom = (_GEN_137 == y0_7 | _GEN_137 == y1_7) & (_GEN_147 >= x0_7 & _GEN_147 <= x1_7); // @[Annotator.scala 86:58]
  wire  odd_7_left_right = (_GEN_147 == x0_7 | _GEN_147 == x1_7) & (_GEN_137 >= y0_7 & _GEN_137 <= y1_7); // @[Annotator.scala 87:58]
  wire  odd_7 = odd_7_top_bottom | odd_7_left_right; // @[Annotator.scala 89:16]
  wire [15:0] y0_8 = coord_reg_8[47:32]; // @[Annotator.scala 170:36]
  wire [15:0] y1_8 = coord_reg_8[15:0]; // @[Annotator.scala 168:36]
  wire [15:0] x0_8 = coord_reg_8[63:48]; // @[Annotator.scala 171:36]
  wire [15:0] x1_8 = coord_reg_8[31:16]; // @[Annotator.scala 169:36]
  wire  odd_8_top_bottom = (_GEN_137 == y0_8 | _GEN_137 == y1_8) & (_GEN_147 >= x0_8 & _GEN_147 <= x1_8); // @[Annotator.scala 86:58]
  wire  odd_8_left_right = (_GEN_147 == x0_8 | _GEN_147 == x1_8) & (_GEN_137 >= y0_8 & _GEN_137 <= y1_8); // @[Annotator.scala 87:58]
  wire  odd_8 = odd_8_top_bottom | odd_8_left_right; // @[Annotator.scala 89:16]
  wire [15:0] y0_9 = coord_reg_9[47:32]; // @[Annotator.scala 170:36]
  wire [15:0] y1_9 = coord_reg_9[15:0]; // @[Annotator.scala 168:36]
  wire [15:0] x0_9 = coord_reg_9[63:48]; // @[Annotator.scala 171:36]
  wire [15:0] x1_9 = coord_reg_9[31:16]; // @[Annotator.scala 169:36]
  wire  odd_9_top_bottom = (_GEN_137 == y0_9 | _GEN_137 == y1_9) & (_GEN_147 >= x0_9 & _GEN_147 <= x1_9); // @[Annotator.scala 86:58]
  wire  odd_9_left_right = (_GEN_147 == x0_9 | _GEN_147 == x1_9) & (_GEN_137 >= y0_9 & _GEN_137 <= y1_9); // @[Annotator.scala 87:58]
  wire  odd_9 = odd_9_top_bottom | odd_9_left_right; // @[Annotator.scala 89:16]
  wire [15:0] y0_10 = coord_reg_10[47:32]; // @[Annotator.scala 170:36]
  wire [15:0] y1_10 = coord_reg_10[15:0]; // @[Annotator.scala 168:36]
  wire [15:0] x0_10 = coord_reg_10[63:48]; // @[Annotator.scala 171:36]
  wire [15:0] x1_10 = coord_reg_10[31:16]; // @[Annotator.scala 169:36]
  wire  odd_10_top_bottom = (_GEN_137 == y0_10 | _GEN_137 == y1_10) & (_GEN_147 >= x0_10 & _GEN_147 <= x1_10); // @[Annotator.scala 86:58]
  wire  odd_10_left_right = (_GEN_147 == x0_10 | _GEN_147 == x1_10) & (_GEN_137 >= y0_10 & _GEN_137 <= y1_10); // @[Annotator.scala 87:58]
  wire  odd_10 = odd_10_top_bottom | odd_10_left_right; // @[Annotator.scala 89:16]
  wire [15:0] y0_11 = coord_reg_11[47:32]; // @[Annotator.scala 170:36]
  wire [15:0] y1_11 = coord_reg_11[15:0]; // @[Annotator.scala 168:36]
  wire [15:0] x0_11 = coord_reg_11[63:48]; // @[Annotator.scala 171:36]
  wire [15:0] x1_11 = coord_reg_11[31:16]; // @[Annotator.scala 169:36]
  wire  odd_11_top_bottom = (_GEN_137 == y0_11 | _GEN_137 == y1_11) & (_GEN_147 >= x0_11 & _GEN_147 <= x1_11); // @[Annotator.scala 86:58]
  wire  odd_11_left_right = (_GEN_147 == x0_11 | _GEN_147 == x1_11) & (_GEN_137 >= y0_11 & _GEN_137 <= y1_11); // @[Annotator.scala 87:58]
  wire  odd_11 = odd_11_top_bottom | odd_11_left_right; // @[Annotator.scala 89:16]
  wire [15:0] y0_12 = coord_reg_12[47:32]; // @[Annotator.scala 170:36]
  wire [15:0] y1_12 = coord_reg_12[15:0]; // @[Annotator.scala 168:36]
  wire [15:0] x0_12 = coord_reg_12[63:48]; // @[Annotator.scala 171:36]
  wire [15:0] x1_12 = coord_reg_12[31:16]; // @[Annotator.scala 169:36]
  wire  odd_12_top_bottom = (_GEN_137 == y0_12 | _GEN_137 == y1_12) & (_GEN_147 >= x0_12 & _GEN_147 <= x1_12); // @[Annotator.scala 86:58]
  wire  odd_12_left_right = (_GEN_147 == x0_12 | _GEN_147 == x1_12) & (_GEN_137 >= y0_12 & _GEN_137 <= y1_12); // @[Annotator.scala 87:58]
  wire  odd_12 = odd_12_top_bottom | odd_12_left_right; // @[Annotator.scala 89:16]
  wire [15:0] y0_13 = coord_reg_13[47:32]; // @[Annotator.scala 170:36]
  wire [15:0] y1_13 = coord_reg_13[15:0]; // @[Annotator.scala 168:36]
  wire [15:0] x0_13 = coord_reg_13[63:48]; // @[Annotator.scala 171:36]
  wire [15:0] x1_13 = coord_reg_13[31:16]; // @[Annotator.scala 169:36]
  wire  odd_13_top_bottom = (_GEN_137 == y0_13 | _GEN_137 == y1_13) & (_GEN_147 >= x0_13 & _GEN_147 <= x1_13); // @[Annotator.scala 86:58]
  wire  odd_13_left_right = (_GEN_147 == x0_13 | _GEN_147 == x1_13) & (_GEN_137 >= y0_13 & _GEN_137 <= y1_13); // @[Annotator.scala 87:58]
  wire  odd_13 = odd_13_top_bottom | odd_13_left_right; // @[Annotator.scala 89:16]
  wire [15:0] y0_14 = coord_reg_14[47:32]; // @[Annotator.scala 170:36]
  wire [15:0] y1_14 = coord_reg_14[15:0]; // @[Annotator.scala 168:36]
  wire [15:0] x0_14 = coord_reg_14[63:48]; // @[Annotator.scala 171:36]
  wire [15:0] x1_14 = coord_reg_14[31:16]; // @[Annotator.scala 169:36]
  wire  odd_14_top_bottom = (_GEN_137 == y0_14 | _GEN_137 == y1_14) & (_GEN_147 >= x0_14 & _GEN_147 <= x1_14); // @[Annotator.scala 86:58]
  wire  odd_14_left_right = (_GEN_147 == x0_14 | _GEN_147 == x1_14) & (_GEN_137 >= y0_14 & _GEN_137 <= y1_14); // @[Annotator.scala 87:58]
  wire  odd_14 = odd_14_top_bottom | odd_14_left_right; // @[Annotator.scala 89:16]
  wire [15:0] y0_15 = coord_reg_15[47:32]; // @[Annotator.scala 170:36]
  wire [15:0] y1_15 = coord_reg_15[15:0]; // @[Annotator.scala 168:36]
  wire [15:0] x0_15 = coord_reg_15[63:48]; // @[Annotator.scala 171:36]
  wire [15:0] x1_15 = coord_reg_15[31:16]; // @[Annotator.scala 169:36]
  wire  odd_15_top_bottom = (_GEN_137 == y0_15 | _GEN_137 == y1_15) & (_GEN_147 >= x0_15 & _GEN_147 <= x1_15); // @[Annotator.scala 86:58]
  wire  odd_15_left_right = (_GEN_147 == x0_15 | _GEN_147 == x1_15) & (_GEN_137 >= y0_15 & _GEN_137 <= y1_15); // @[Annotator.scala 87:58]
  wire  odd_15 = odd_15_top_bottom | odd_15_left_right; // @[Annotator.scala 89:16]
  wire  _odd_comb_0_T_14 = odd_0 | odd_1 | odd_2 | odd_3 | odd_4 | odd_5 | odd_6 | odd_7 | odd_8 | odd_9 | odd_10 |
    odd_11 | odd_12 | odd_13 | odd_14 | odd_15; // @[Annotator.scala 177:120]
  wire  even_1_top_bottom = (_GEN_137 == y0_1 | _GEN_137 == y1_1) & (_GEN_139 >= x0_1 & _GEN_139 <= x1_1); // @[Annotator.scala 86:58]
  wire  even_1_left_right = (_GEN_139 == x0_1 | _GEN_139 == x1_1) & (_GEN_137 >= y0_1 & _GEN_137 <= y1_1); // @[Annotator.scala 87:58]
  wire  even_1 = even_1_top_bottom | even_1_left_right; // @[Annotator.scala 89:16]
  wire  even_2_top_bottom = (_GEN_137 == y0_2 | _GEN_137 == y1_2) & (_GEN_139 >= x0_2 & _GEN_139 <= x1_2); // @[Annotator.scala 86:58]
  wire  even_2_left_right = (_GEN_139 == x0_2 | _GEN_139 == x1_2) & (_GEN_137 >= y0_2 & _GEN_137 <= y1_2); // @[Annotator.scala 87:58]
  wire  even_2 = even_2_top_bottom | even_2_left_right; // @[Annotator.scala 89:16]
  wire  even_3_top_bottom = (_GEN_137 == y0_3 | _GEN_137 == y1_3) & (_GEN_139 >= x0_3 & _GEN_139 <= x1_3); // @[Annotator.scala 86:58]
  wire  even_3_left_right = (_GEN_139 == x0_3 | _GEN_139 == x1_3) & (_GEN_137 >= y0_3 & _GEN_137 <= y1_3); // @[Annotator.scala 87:58]
  wire  even_3 = even_3_top_bottom | even_3_left_right; // @[Annotator.scala 89:16]
  wire  even_4_top_bottom = (_GEN_137 == y0_4 | _GEN_137 == y1_4) & (_GEN_139 >= x0_4 & _GEN_139 <= x1_4); // @[Annotator.scala 86:58]
  wire  even_4_left_right = (_GEN_139 == x0_4 | _GEN_139 == x1_4) & (_GEN_137 >= y0_4 & _GEN_137 <= y1_4); // @[Annotator.scala 87:58]
  wire  even_4 = even_4_top_bottom | even_4_left_right; // @[Annotator.scala 89:16]
  wire  even_5_top_bottom = (_GEN_137 == y0_5 | _GEN_137 == y1_5) & (_GEN_139 >= x0_5 & _GEN_139 <= x1_5); // @[Annotator.scala 86:58]
  wire  even_5_left_right = (_GEN_139 == x0_5 | _GEN_139 == x1_5) & (_GEN_137 >= y0_5 & _GEN_137 <= y1_5); // @[Annotator.scala 87:58]
  wire  even_5 = even_5_top_bottom | even_5_left_right; // @[Annotator.scala 89:16]
  wire  even_6_top_bottom = (_GEN_137 == y0_6 | _GEN_137 == y1_6) & (_GEN_139 >= x0_6 & _GEN_139 <= x1_6); // @[Annotator.scala 86:58]
  wire  even_6_left_right = (_GEN_139 == x0_6 | _GEN_139 == x1_6) & (_GEN_137 >= y0_6 & _GEN_137 <= y1_6); // @[Annotator.scala 87:58]
  wire  even_6 = even_6_top_bottom | even_6_left_right; // @[Annotator.scala 89:16]
  wire  even_7_top_bottom = (_GEN_137 == y0_7 | _GEN_137 == y1_7) & (_GEN_139 >= x0_7 & _GEN_139 <= x1_7); // @[Annotator.scala 86:58]
  wire  even_7_left_right = (_GEN_139 == x0_7 | _GEN_139 == x1_7) & (_GEN_137 >= y0_7 & _GEN_137 <= y1_7); // @[Annotator.scala 87:58]
  wire  even_7 = even_7_top_bottom | even_7_left_right; // @[Annotator.scala 89:16]
  wire  even_8_top_bottom = (_GEN_137 == y0_8 | _GEN_137 == y1_8) & (_GEN_139 >= x0_8 & _GEN_139 <= x1_8); // @[Annotator.scala 86:58]
  wire  even_8_left_right = (_GEN_139 == x0_8 | _GEN_139 == x1_8) & (_GEN_137 >= y0_8 & _GEN_137 <= y1_8); // @[Annotator.scala 87:58]
  wire  even_8 = even_8_top_bottom | even_8_left_right; // @[Annotator.scala 89:16]
  wire  even_9_top_bottom = (_GEN_137 == y0_9 | _GEN_137 == y1_9) & (_GEN_139 >= x0_9 & _GEN_139 <= x1_9); // @[Annotator.scala 86:58]
  wire  even_9_left_right = (_GEN_139 == x0_9 | _GEN_139 == x1_9) & (_GEN_137 >= y0_9 & _GEN_137 <= y1_9); // @[Annotator.scala 87:58]
  wire  even_9 = even_9_top_bottom | even_9_left_right; // @[Annotator.scala 89:16]
  wire  even_10_top_bottom = (_GEN_137 == y0_10 | _GEN_137 == y1_10) & (_GEN_139 >= x0_10 & _GEN_139 <= x1_10); // @[Annotator.scala 86:58]
  wire  even_10_left_right = (_GEN_139 == x0_10 | _GEN_139 == x1_10) & (_GEN_137 >= y0_10 & _GEN_137 <= y1_10); // @[Annotator.scala 87:58]
  wire  even_10 = even_10_top_bottom | even_10_left_right; // @[Annotator.scala 89:16]
  wire  even_11_top_bottom = (_GEN_137 == y0_11 | _GEN_137 == y1_11) & (_GEN_139 >= x0_11 & _GEN_139 <= x1_11); // @[Annotator.scala 86:58]
  wire  even_11_left_right = (_GEN_139 == x0_11 | _GEN_139 == x1_11) & (_GEN_137 >= y0_11 & _GEN_137 <= y1_11); // @[Annotator.scala 87:58]
  wire  even_11 = even_11_top_bottom | even_11_left_right; // @[Annotator.scala 89:16]
  wire  even_12_top_bottom = (_GEN_137 == y0_12 | _GEN_137 == y1_12) & (_GEN_139 >= x0_12 & _GEN_139 <= x1_12); // @[Annotator.scala 86:58]
  wire  even_12_left_right = (_GEN_139 == x0_12 | _GEN_139 == x1_12) & (_GEN_137 >= y0_12 & _GEN_137 <= y1_12); // @[Annotator.scala 87:58]
  wire  even_12 = even_12_top_bottom | even_12_left_right; // @[Annotator.scala 89:16]
  wire  even_13_top_bottom = (_GEN_137 == y0_13 | _GEN_137 == y1_13) & (_GEN_139 >= x0_13 & _GEN_139 <= x1_13); // @[Annotator.scala 86:58]
  wire  even_13_left_right = (_GEN_139 == x0_13 | _GEN_139 == x1_13) & (_GEN_137 >= y0_13 & _GEN_137 <= y1_13); // @[Annotator.scala 87:58]
  wire  even_13 = even_13_top_bottom | even_13_left_right; // @[Annotator.scala 89:16]
  wire  even_14_top_bottom = (_GEN_137 == y0_14 | _GEN_137 == y1_14) & (_GEN_139 >= x0_14 & _GEN_139 <= x1_14); // @[Annotator.scala 86:58]
  wire  even_14_left_right = (_GEN_139 == x0_14 | _GEN_139 == x1_14) & (_GEN_137 >= y0_14 & _GEN_137 <= y1_14); // @[Annotator.scala 87:58]
  wire  even_14 = even_14_top_bottom | even_14_left_right; // @[Annotator.scala 89:16]
  wire  even_15_top_bottom = (_GEN_137 == y0_15 | _GEN_137 == y1_15) & (_GEN_139 >= x0_15 & _GEN_139 <= x1_15); // @[Annotator.scala 86:58]
  wire  even_15_left_right = (_GEN_139 == x0_15 | _GEN_139 == x1_15) & (_GEN_137 >= y0_15 & _GEN_137 <= y1_15); // @[Annotator.scala 87:58]
  wire  even_15 = even_15_top_bottom | even_15_left_right; // @[Annotator.scala 89:16]
  wire  _even_comb_0_T_14 = even_0 | even_1 | even_2 | even_3 | even_4 | even_5 | even_6 | even_7 | even_8 | even_9 |
    even_10 | even_11 | even_12 | even_13 | even_14 | even_15; // @[Annotator.scala 178:122]
  wire [15:0] y1_16 = coord_reg_16[15:0]; // @[Annotator.scala 168:36]
  wire [15:0] x1_16 = coord_reg_16[31:16]; // @[Annotator.scala 169:36]
  wire [15:0] y0_16 = coord_reg_16[47:32]; // @[Annotator.scala 170:36]
  wire [15:0] x0_16 = coord_reg_16[63:48]; // @[Annotator.scala 171:36]
  wire  even_16_top_bottom = (_GEN_137 == y0_16 | _GEN_137 == y1_16) & (_GEN_139 >= x0_16 & _GEN_139 <= x1_16); // @[Annotator.scala 86:58]
  wire  even_16_left_right = (_GEN_139 == x0_16 | _GEN_139 == x1_16) & (_GEN_137 >= y0_16 & _GEN_137 <= y1_16); // @[Annotator.scala 87:58]
  wire  even_16 = even_16_top_bottom | even_16_left_right; // @[Annotator.scala 89:16]
  wire  odd_16_top_bottom = (_GEN_137 == y0_16 | _GEN_137 == y1_16) & (_GEN_147 >= x0_16 & _GEN_147 <= x1_16); // @[Annotator.scala 86:58]
  wire  odd_16_left_right = (_GEN_147 == x0_16 | _GEN_147 == x1_16) & (_GEN_137 >= y0_16 & _GEN_137 <= y1_16); // @[Annotator.scala 87:58]
  wire  odd_16 = odd_16_top_bottom | odd_16_left_right; // @[Annotator.scala 89:16]
  wire [15:0] y0_17 = coord_reg_17[47:32]; // @[Annotator.scala 170:36]
  wire [15:0] y1_17 = coord_reg_17[15:0]; // @[Annotator.scala 168:36]
  wire [15:0] x0_17 = coord_reg_17[63:48]; // @[Annotator.scala 171:36]
  wire [15:0] x1_17 = coord_reg_17[31:16]; // @[Annotator.scala 169:36]
  wire  odd_17_top_bottom = (_GEN_137 == y0_17 | _GEN_137 == y1_17) & (_GEN_147 >= x0_17 & _GEN_147 <= x1_17); // @[Annotator.scala 86:58]
  wire  odd_17_left_right = (_GEN_147 == x0_17 | _GEN_147 == x1_17) & (_GEN_137 >= y0_17 & _GEN_137 <= y1_17); // @[Annotator.scala 87:58]
  wire  odd_17 = odd_17_top_bottom | odd_17_left_right; // @[Annotator.scala 89:16]
  wire [15:0] y0_18 = coord_reg_18[47:32]; // @[Annotator.scala 170:36]
  wire [15:0] y1_18 = coord_reg_18[15:0]; // @[Annotator.scala 168:36]
  wire [15:0] x0_18 = coord_reg_18[63:48]; // @[Annotator.scala 171:36]
  wire [15:0] x1_18 = coord_reg_18[31:16]; // @[Annotator.scala 169:36]
  wire  odd_18_top_bottom = (_GEN_137 == y0_18 | _GEN_137 == y1_18) & (_GEN_147 >= x0_18 & _GEN_147 <= x1_18); // @[Annotator.scala 86:58]
  wire  odd_18_left_right = (_GEN_147 == x0_18 | _GEN_147 == x1_18) & (_GEN_137 >= y0_18 & _GEN_137 <= y1_18); // @[Annotator.scala 87:58]
  wire  odd_18 = odd_18_top_bottom | odd_18_left_right; // @[Annotator.scala 89:16]
  wire [15:0] y0_19 = coord_reg_19[47:32]; // @[Annotator.scala 170:36]
  wire [15:0] y1_19 = coord_reg_19[15:0]; // @[Annotator.scala 168:36]
  wire [15:0] x0_19 = coord_reg_19[63:48]; // @[Annotator.scala 171:36]
  wire [15:0] x1_19 = coord_reg_19[31:16]; // @[Annotator.scala 169:36]
  wire  odd_19_top_bottom = (_GEN_137 == y0_19 | _GEN_137 == y1_19) & (_GEN_147 >= x0_19 & _GEN_147 <= x1_19); // @[Annotator.scala 86:58]
  wire  odd_19_left_right = (_GEN_147 == x0_19 | _GEN_147 == x1_19) & (_GEN_137 >= y0_19 & _GEN_137 <= y1_19); // @[Annotator.scala 87:58]
  wire  odd_19 = odd_19_top_bottom | odd_19_left_right; // @[Annotator.scala 89:16]
  wire [15:0] y0_20 = coord_reg_20[47:32]; // @[Annotator.scala 170:36]
  wire [15:0] y1_20 = coord_reg_20[15:0]; // @[Annotator.scala 168:36]
  wire [15:0] x0_20 = coord_reg_20[63:48]; // @[Annotator.scala 171:36]
  wire [15:0] x1_20 = coord_reg_20[31:16]; // @[Annotator.scala 169:36]
  wire  odd_20_top_bottom = (_GEN_137 == y0_20 | _GEN_137 == y1_20) & (_GEN_147 >= x0_20 & _GEN_147 <= x1_20); // @[Annotator.scala 86:58]
  wire  odd_20_left_right = (_GEN_147 == x0_20 | _GEN_147 == x1_20) & (_GEN_137 >= y0_20 & _GEN_137 <= y1_20); // @[Annotator.scala 87:58]
  wire  odd_20 = odd_20_top_bottom | odd_20_left_right; // @[Annotator.scala 89:16]
  wire [15:0] y0_21 = coord_reg_21[47:32]; // @[Annotator.scala 170:36]
  wire [15:0] y1_21 = coord_reg_21[15:0]; // @[Annotator.scala 168:36]
  wire [15:0] x0_21 = coord_reg_21[63:48]; // @[Annotator.scala 171:36]
  wire [15:0] x1_21 = coord_reg_21[31:16]; // @[Annotator.scala 169:36]
  wire  odd_21_top_bottom = (_GEN_137 == y0_21 | _GEN_137 == y1_21) & (_GEN_147 >= x0_21 & _GEN_147 <= x1_21); // @[Annotator.scala 86:58]
  wire  odd_21_left_right = (_GEN_147 == x0_21 | _GEN_147 == x1_21) & (_GEN_137 >= y0_21 & _GEN_137 <= y1_21); // @[Annotator.scala 87:58]
  wire  odd_21 = odd_21_top_bottom | odd_21_left_right; // @[Annotator.scala 89:16]
  wire [15:0] y0_22 = coord_reg_22[47:32]; // @[Annotator.scala 170:36]
  wire [15:0] y1_22 = coord_reg_22[15:0]; // @[Annotator.scala 168:36]
  wire [15:0] x0_22 = coord_reg_22[63:48]; // @[Annotator.scala 171:36]
  wire [15:0] x1_22 = coord_reg_22[31:16]; // @[Annotator.scala 169:36]
  wire  odd_22_top_bottom = (_GEN_137 == y0_22 | _GEN_137 == y1_22) & (_GEN_147 >= x0_22 & _GEN_147 <= x1_22); // @[Annotator.scala 86:58]
  wire  odd_22_left_right = (_GEN_147 == x0_22 | _GEN_147 == x1_22) & (_GEN_137 >= y0_22 & _GEN_137 <= y1_22); // @[Annotator.scala 87:58]
  wire  odd_22 = odd_22_top_bottom | odd_22_left_right; // @[Annotator.scala 89:16]
  wire [15:0] y0_23 = coord_reg_23[47:32]; // @[Annotator.scala 170:36]
  wire [15:0] y1_23 = coord_reg_23[15:0]; // @[Annotator.scala 168:36]
  wire [15:0] x0_23 = coord_reg_23[63:48]; // @[Annotator.scala 171:36]
  wire [15:0] x1_23 = coord_reg_23[31:16]; // @[Annotator.scala 169:36]
  wire  odd_23_top_bottom = (_GEN_137 == y0_23 | _GEN_137 == y1_23) & (_GEN_147 >= x0_23 & _GEN_147 <= x1_23); // @[Annotator.scala 86:58]
  wire  odd_23_left_right = (_GEN_147 == x0_23 | _GEN_147 == x1_23) & (_GEN_137 >= y0_23 & _GEN_137 <= y1_23); // @[Annotator.scala 87:58]
  wire  odd_23 = odd_23_top_bottom | odd_23_left_right; // @[Annotator.scala 89:16]
  wire [15:0] y0_24 = coord_reg_24[47:32]; // @[Annotator.scala 170:36]
  wire [15:0] y1_24 = coord_reg_24[15:0]; // @[Annotator.scala 168:36]
  wire [15:0] x0_24 = coord_reg_24[63:48]; // @[Annotator.scala 171:36]
  wire [15:0] x1_24 = coord_reg_24[31:16]; // @[Annotator.scala 169:36]
  wire  odd_24_top_bottom = (_GEN_137 == y0_24 | _GEN_137 == y1_24) & (_GEN_147 >= x0_24 & _GEN_147 <= x1_24); // @[Annotator.scala 86:58]
  wire  odd_24_left_right = (_GEN_147 == x0_24 | _GEN_147 == x1_24) & (_GEN_137 >= y0_24 & _GEN_137 <= y1_24); // @[Annotator.scala 87:58]
  wire  odd_24 = odd_24_top_bottom | odd_24_left_right; // @[Annotator.scala 89:16]
  wire [15:0] y0_25 = coord_reg_25[47:32]; // @[Annotator.scala 170:36]
  wire [15:0] y1_25 = coord_reg_25[15:0]; // @[Annotator.scala 168:36]
  wire [15:0] x0_25 = coord_reg_25[63:48]; // @[Annotator.scala 171:36]
  wire [15:0] x1_25 = coord_reg_25[31:16]; // @[Annotator.scala 169:36]
  wire  odd_25_top_bottom = (_GEN_137 == y0_25 | _GEN_137 == y1_25) & (_GEN_147 >= x0_25 & _GEN_147 <= x1_25); // @[Annotator.scala 86:58]
  wire  odd_25_left_right = (_GEN_147 == x0_25 | _GEN_147 == x1_25) & (_GEN_137 >= y0_25 & _GEN_137 <= y1_25); // @[Annotator.scala 87:58]
  wire  odd_25 = odd_25_top_bottom | odd_25_left_right; // @[Annotator.scala 89:16]
  wire [15:0] y0_26 = coord_reg_26[47:32]; // @[Annotator.scala 170:36]
  wire [15:0] y1_26 = coord_reg_26[15:0]; // @[Annotator.scala 168:36]
  wire [15:0] x0_26 = coord_reg_26[63:48]; // @[Annotator.scala 171:36]
  wire [15:0] x1_26 = coord_reg_26[31:16]; // @[Annotator.scala 169:36]
  wire  odd_26_top_bottom = (_GEN_137 == y0_26 | _GEN_137 == y1_26) & (_GEN_147 >= x0_26 & _GEN_147 <= x1_26); // @[Annotator.scala 86:58]
  wire  odd_26_left_right = (_GEN_147 == x0_26 | _GEN_147 == x1_26) & (_GEN_137 >= y0_26 & _GEN_137 <= y1_26); // @[Annotator.scala 87:58]
  wire  odd_26 = odd_26_top_bottom | odd_26_left_right; // @[Annotator.scala 89:16]
  wire [15:0] y0_27 = coord_reg_27[47:32]; // @[Annotator.scala 170:36]
  wire [15:0] y1_27 = coord_reg_27[15:0]; // @[Annotator.scala 168:36]
  wire [15:0] x0_27 = coord_reg_27[63:48]; // @[Annotator.scala 171:36]
  wire [15:0] x1_27 = coord_reg_27[31:16]; // @[Annotator.scala 169:36]
  wire  odd_27_top_bottom = (_GEN_137 == y0_27 | _GEN_137 == y1_27) & (_GEN_147 >= x0_27 & _GEN_147 <= x1_27); // @[Annotator.scala 86:58]
  wire  odd_27_left_right = (_GEN_147 == x0_27 | _GEN_147 == x1_27) & (_GEN_137 >= y0_27 & _GEN_137 <= y1_27); // @[Annotator.scala 87:58]
  wire  odd_27 = odd_27_top_bottom | odd_27_left_right; // @[Annotator.scala 89:16]
  wire [15:0] y0_28 = coord_reg_28[47:32]; // @[Annotator.scala 170:36]
  wire [15:0] y1_28 = coord_reg_28[15:0]; // @[Annotator.scala 168:36]
  wire [15:0] x0_28 = coord_reg_28[63:48]; // @[Annotator.scala 171:36]
  wire [15:0] x1_28 = coord_reg_28[31:16]; // @[Annotator.scala 169:36]
  wire  odd_28_top_bottom = (_GEN_137 == y0_28 | _GEN_137 == y1_28) & (_GEN_147 >= x0_28 & _GEN_147 <= x1_28); // @[Annotator.scala 86:58]
  wire  odd_28_left_right = (_GEN_147 == x0_28 | _GEN_147 == x1_28) & (_GEN_137 >= y0_28 & _GEN_137 <= y1_28); // @[Annotator.scala 87:58]
  wire  odd_28 = odd_28_top_bottom | odd_28_left_right; // @[Annotator.scala 89:16]
  wire [15:0] y0_29 = coord_reg_29[47:32]; // @[Annotator.scala 170:36]
  wire [15:0] y1_29 = coord_reg_29[15:0]; // @[Annotator.scala 168:36]
  wire [15:0] x0_29 = coord_reg_29[63:48]; // @[Annotator.scala 171:36]
  wire [15:0] x1_29 = coord_reg_29[31:16]; // @[Annotator.scala 169:36]
  wire  odd_29_top_bottom = (_GEN_137 == y0_29 | _GEN_137 == y1_29) & (_GEN_147 >= x0_29 & _GEN_147 <= x1_29); // @[Annotator.scala 86:58]
  wire  odd_29_left_right = (_GEN_147 == x0_29 | _GEN_147 == x1_29) & (_GEN_137 >= y0_29 & _GEN_137 <= y1_29); // @[Annotator.scala 87:58]
  wire  odd_29 = odd_29_top_bottom | odd_29_left_right; // @[Annotator.scala 89:16]
  wire [15:0] y0_30 = coord_reg_30[47:32]; // @[Annotator.scala 170:36]
  wire [15:0] y1_30 = coord_reg_30[15:0]; // @[Annotator.scala 168:36]
  wire [15:0] x0_30 = coord_reg_30[63:48]; // @[Annotator.scala 171:36]
  wire [15:0] x1_30 = coord_reg_30[31:16]; // @[Annotator.scala 169:36]
  wire  odd_30_top_bottom = (_GEN_137 == y0_30 | _GEN_137 == y1_30) & (_GEN_147 >= x0_30 & _GEN_147 <= x1_30); // @[Annotator.scala 86:58]
  wire  odd_30_left_right = (_GEN_147 == x0_30 | _GEN_147 == x1_30) & (_GEN_137 >= y0_30 & _GEN_137 <= y1_30); // @[Annotator.scala 87:58]
  wire  odd_30 = odd_30_top_bottom | odd_30_left_right; // @[Annotator.scala 89:16]
  wire [15:0] y0_31 = coord_reg_31[47:32]; // @[Annotator.scala 170:36]
  wire [15:0] y1_31 = coord_reg_31[15:0]; // @[Annotator.scala 168:36]
  wire [15:0] x0_31 = coord_reg_31[63:48]; // @[Annotator.scala 171:36]
  wire [15:0] x1_31 = coord_reg_31[31:16]; // @[Annotator.scala 169:36]
  wire  odd_31_top_bottom = (_GEN_137 == y0_31 | _GEN_137 == y1_31) & (_GEN_147 >= x0_31 & _GEN_147 <= x1_31); // @[Annotator.scala 86:58]
  wire  odd_31_left_right = (_GEN_147 == x0_31 | _GEN_147 == x1_31) & (_GEN_137 >= y0_31 & _GEN_137 <= y1_31); // @[Annotator.scala 87:58]
  wire  odd_31 = odd_31_top_bottom | odd_31_left_right; // @[Annotator.scala 89:16]
  wire  _odd_comb_1_T_14 = odd_16 | odd_17 | odd_18 | odd_19 | odd_20 | odd_21 | odd_22 | odd_23 | odd_24 | odd_25 |
    odd_26 | odd_27 | odd_28 | odd_29 | odd_30 | odd_31; // @[Annotator.scala 177:120]
  wire  even_17_top_bottom = (_GEN_137 == y0_17 | _GEN_137 == y1_17) & (_GEN_139 >= x0_17 & _GEN_139 <= x1_17); // @[Annotator.scala 86:58]
  wire  even_17_left_right = (_GEN_139 == x0_17 | _GEN_139 == x1_17) & (_GEN_137 >= y0_17 & _GEN_137 <= y1_17); // @[Annotator.scala 87:58]
  wire  even_17 = even_17_top_bottom | even_17_left_right; // @[Annotator.scala 89:16]
  wire  even_18_top_bottom = (_GEN_137 == y0_18 | _GEN_137 == y1_18) & (_GEN_139 >= x0_18 & _GEN_139 <= x1_18); // @[Annotator.scala 86:58]
  wire  even_18_left_right = (_GEN_139 == x0_18 | _GEN_139 == x1_18) & (_GEN_137 >= y0_18 & _GEN_137 <= y1_18); // @[Annotator.scala 87:58]
  wire  even_18 = even_18_top_bottom | even_18_left_right; // @[Annotator.scala 89:16]
  wire  even_19_top_bottom = (_GEN_137 == y0_19 | _GEN_137 == y1_19) & (_GEN_139 >= x0_19 & _GEN_139 <= x1_19); // @[Annotator.scala 86:58]
  wire  even_19_left_right = (_GEN_139 == x0_19 | _GEN_139 == x1_19) & (_GEN_137 >= y0_19 & _GEN_137 <= y1_19); // @[Annotator.scala 87:58]
  wire  even_19 = even_19_top_bottom | even_19_left_right; // @[Annotator.scala 89:16]
  wire  even_20_top_bottom = (_GEN_137 == y0_20 | _GEN_137 == y1_20) & (_GEN_139 >= x0_20 & _GEN_139 <= x1_20); // @[Annotator.scala 86:58]
  wire  even_20_left_right = (_GEN_139 == x0_20 | _GEN_139 == x1_20) & (_GEN_137 >= y0_20 & _GEN_137 <= y1_20); // @[Annotator.scala 87:58]
  wire  even_20 = even_20_top_bottom | even_20_left_right; // @[Annotator.scala 89:16]
  wire  even_21_top_bottom = (_GEN_137 == y0_21 | _GEN_137 == y1_21) & (_GEN_139 >= x0_21 & _GEN_139 <= x1_21); // @[Annotator.scala 86:58]
  wire  even_21_left_right = (_GEN_139 == x0_21 | _GEN_139 == x1_21) & (_GEN_137 >= y0_21 & _GEN_137 <= y1_21); // @[Annotator.scala 87:58]
  wire  even_21 = even_21_top_bottom | even_21_left_right; // @[Annotator.scala 89:16]
  wire  even_22_top_bottom = (_GEN_137 == y0_22 | _GEN_137 == y1_22) & (_GEN_139 >= x0_22 & _GEN_139 <= x1_22); // @[Annotator.scala 86:58]
  wire  even_22_left_right = (_GEN_139 == x0_22 | _GEN_139 == x1_22) & (_GEN_137 >= y0_22 & _GEN_137 <= y1_22); // @[Annotator.scala 87:58]
  wire  even_22 = even_22_top_bottom | even_22_left_right; // @[Annotator.scala 89:16]
  wire  even_23_top_bottom = (_GEN_137 == y0_23 | _GEN_137 == y1_23) & (_GEN_139 >= x0_23 & _GEN_139 <= x1_23); // @[Annotator.scala 86:58]
  wire  even_23_left_right = (_GEN_139 == x0_23 | _GEN_139 == x1_23) & (_GEN_137 >= y0_23 & _GEN_137 <= y1_23); // @[Annotator.scala 87:58]
  wire  even_23 = even_23_top_bottom | even_23_left_right; // @[Annotator.scala 89:16]
  wire  even_24_top_bottom = (_GEN_137 == y0_24 | _GEN_137 == y1_24) & (_GEN_139 >= x0_24 & _GEN_139 <= x1_24); // @[Annotator.scala 86:58]
  wire  even_24_left_right = (_GEN_139 == x0_24 | _GEN_139 == x1_24) & (_GEN_137 >= y0_24 & _GEN_137 <= y1_24); // @[Annotator.scala 87:58]
  wire  even_24 = even_24_top_bottom | even_24_left_right; // @[Annotator.scala 89:16]
  wire  even_25_top_bottom = (_GEN_137 == y0_25 | _GEN_137 == y1_25) & (_GEN_139 >= x0_25 & _GEN_139 <= x1_25); // @[Annotator.scala 86:58]
  wire  even_25_left_right = (_GEN_139 == x0_25 | _GEN_139 == x1_25) & (_GEN_137 >= y0_25 & _GEN_137 <= y1_25); // @[Annotator.scala 87:58]
  wire  even_25 = even_25_top_bottom | even_25_left_right; // @[Annotator.scala 89:16]
  wire  even_26_top_bottom = (_GEN_137 == y0_26 | _GEN_137 == y1_26) & (_GEN_139 >= x0_26 & _GEN_139 <= x1_26); // @[Annotator.scala 86:58]
  wire  even_26_left_right = (_GEN_139 == x0_26 | _GEN_139 == x1_26) & (_GEN_137 >= y0_26 & _GEN_137 <= y1_26); // @[Annotator.scala 87:58]
  wire  even_26 = even_26_top_bottom | even_26_left_right; // @[Annotator.scala 89:16]
  wire  even_27_top_bottom = (_GEN_137 == y0_27 | _GEN_137 == y1_27) & (_GEN_139 >= x0_27 & _GEN_139 <= x1_27); // @[Annotator.scala 86:58]
  wire  even_27_left_right = (_GEN_139 == x0_27 | _GEN_139 == x1_27) & (_GEN_137 >= y0_27 & _GEN_137 <= y1_27); // @[Annotator.scala 87:58]
  wire  even_27 = even_27_top_bottom | even_27_left_right; // @[Annotator.scala 89:16]
  wire  even_28_top_bottom = (_GEN_137 == y0_28 | _GEN_137 == y1_28) & (_GEN_139 >= x0_28 & _GEN_139 <= x1_28); // @[Annotator.scala 86:58]
  wire  even_28_left_right = (_GEN_139 == x0_28 | _GEN_139 == x1_28) & (_GEN_137 >= y0_28 & _GEN_137 <= y1_28); // @[Annotator.scala 87:58]
  wire  even_28 = even_28_top_bottom | even_28_left_right; // @[Annotator.scala 89:16]
  wire  even_29_top_bottom = (_GEN_137 == y0_29 | _GEN_137 == y1_29) & (_GEN_139 >= x0_29 & _GEN_139 <= x1_29); // @[Annotator.scala 86:58]
  wire  even_29_left_right = (_GEN_139 == x0_29 | _GEN_139 == x1_29) & (_GEN_137 >= y0_29 & _GEN_137 <= y1_29); // @[Annotator.scala 87:58]
  wire  even_29 = even_29_top_bottom | even_29_left_right; // @[Annotator.scala 89:16]
  wire  even_30_top_bottom = (_GEN_137 == y0_30 | _GEN_137 == y1_30) & (_GEN_139 >= x0_30 & _GEN_139 <= x1_30); // @[Annotator.scala 86:58]
  wire  even_30_left_right = (_GEN_139 == x0_30 | _GEN_139 == x1_30) & (_GEN_137 >= y0_30 & _GEN_137 <= y1_30); // @[Annotator.scala 87:58]
  wire  even_30 = even_30_top_bottom | even_30_left_right; // @[Annotator.scala 89:16]
  wire  even_31_top_bottom = (_GEN_137 == y0_31 | _GEN_137 == y1_31) & (_GEN_139 >= x0_31 & _GEN_139 <= x1_31); // @[Annotator.scala 86:58]
  wire  even_31_left_right = (_GEN_139 == x0_31 | _GEN_139 == x1_31) & (_GEN_137 >= y0_31 & _GEN_137 <= y1_31); // @[Annotator.scala 87:58]
  wire  even_31 = even_31_top_bottom | even_31_left_right; // @[Annotator.scala 89:16]
  wire  _even_comb_1_T_14 = even_16 | even_17 | even_18 | even_19 | even_20 | even_21 | even_22 | even_23 | even_24 |
    even_25 | even_26 | even_27 | even_28 | even_29 | even_30 | even_31; // @[Annotator.scala 178:122]
  reg  io_out_pixel_valid_r; // @[Reg.scala 15:16]
  reg  io_out_pixel_valid_r_1; // @[Reg.scala 15:16]
  reg  io_out_pixel_valid_r_2; // @[Reg.scala 15:16]
  reg  io_out_pixel_last_r; // @[Reg.scala 15:16]
  reg  io_out_pixel_last_r_1; // @[Reg.scala 15:16]
  reg  io_out_pixel_last_r_2; // @[Reg.scala 15:16]
  reg [63:0] output_pixel_r; // @[Reg.scala 15:16]
  reg [63:0] output_pixel_r_1; // @[Reg.scala 15:16]
  wire [63:0] _output_pixel_T = {overlay_value1,overlay_value0}; // @[Cat.scala 30:58]
  wire [63:0] output_pixel = output_pixel_r_1 | _output_pixel_T; // @[Annotator.scala 186:57]
  reg [63:0] pixel; // @[Annotator.scala 199:22]
  reg [63:0] io_out_pixel_data_REG; // @[Annotator.scala 200:31]
  assign io_framebuf_addr = _io_framebuf_addr_T[10:0]; // @[Annotator.scala 150:20]
  assign io_fontbuf_addr = _io_fontbuf_addr_T[7:0]; // @[Annotator.scala 156:19]
  assign io_out_pixel_valid = io_out_pixel_valid_r_2; // @[Annotator.scala 182:22]
  assign io_out_pixel_last = io_out_pixel_last_r_2; // @[Annotator.scala 183:21]
  assign io_out_pixel_data = io_out_pixel_data_REG; // @[Annotator.scala 200:21]
  always @(posedge clock) begin
    if (reset) begin // @[Annotator.scala 118:26]
      coord_reg_0 <= 64'hffffffffffffffff; // @[Annotator.scala 118:26]
    end else if (io_in_box_valid) begin // @[Annotator.scala 135:25]
      if (5'h0 == io_in_box_counter) begin // @[Annotator.scala 136:34]
        coord_reg_0 <= io_in_box_data; // @[Annotator.scala 136:34]
      end
    end
    if (reset) begin // @[Annotator.scala 118:26]
      coord_reg_1 <= 64'hffffffffffffffff; // @[Annotator.scala 118:26]
    end else if (io_in_box_valid) begin // @[Annotator.scala 135:25]
      if (5'h1 == io_in_box_counter) begin // @[Annotator.scala 136:34]
        coord_reg_1 <= io_in_box_data; // @[Annotator.scala 136:34]
      end
    end
    if (reset) begin // @[Annotator.scala 118:26]
      coord_reg_2 <= 64'hffffffffffffffff; // @[Annotator.scala 118:26]
    end else if (io_in_box_valid) begin // @[Annotator.scala 135:25]
      if (5'h2 == io_in_box_counter) begin // @[Annotator.scala 136:34]
        coord_reg_2 <= io_in_box_data; // @[Annotator.scala 136:34]
      end
    end
    if (reset) begin // @[Annotator.scala 118:26]
      coord_reg_3 <= 64'hffffffffffffffff; // @[Annotator.scala 118:26]
    end else if (io_in_box_valid) begin // @[Annotator.scala 135:25]
      if (5'h3 == io_in_box_counter) begin // @[Annotator.scala 136:34]
        coord_reg_3 <= io_in_box_data; // @[Annotator.scala 136:34]
      end
    end
    if (reset) begin // @[Annotator.scala 118:26]
      coord_reg_4 <= 64'hffffffffffffffff; // @[Annotator.scala 118:26]
    end else if (io_in_box_valid) begin // @[Annotator.scala 135:25]
      if (5'h4 == io_in_box_counter) begin // @[Annotator.scala 136:34]
        coord_reg_4 <= io_in_box_data; // @[Annotator.scala 136:34]
      end
    end
    if (reset) begin // @[Annotator.scala 118:26]
      coord_reg_5 <= 64'hffffffffffffffff; // @[Annotator.scala 118:26]
    end else if (io_in_box_valid) begin // @[Annotator.scala 135:25]
      if (5'h5 == io_in_box_counter) begin // @[Annotator.scala 136:34]
        coord_reg_5 <= io_in_box_data; // @[Annotator.scala 136:34]
      end
    end
    if (reset) begin // @[Annotator.scala 118:26]
      coord_reg_6 <= 64'hffffffffffffffff; // @[Annotator.scala 118:26]
    end else if (io_in_box_valid) begin // @[Annotator.scala 135:25]
      if (5'h6 == io_in_box_counter) begin // @[Annotator.scala 136:34]
        coord_reg_6 <= io_in_box_data; // @[Annotator.scala 136:34]
      end
    end
    if (reset) begin // @[Annotator.scala 118:26]
      coord_reg_7 <= 64'hffffffffffffffff; // @[Annotator.scala 118:26]
    end else if (io_in_box_valid) begin // @[Annotator.scala 135:25]
      if (5'h7 == io_in_box_counter) begin // @[Annotator.scala 136:34]
        coord_reg_7 <= io_in_box_data; // @[Annotator.scala 136:34]
      end
    end
    if (reset) begin // @[Annotator.scala 118:26]
      coord_reg_8 <= 64'hffffffffffffffff; // @[Annotator.scala 118:26]
    end else if (io_in_box_valid) begin // @[Annotator.scala 135:25]
      if (5'h8 == io_in_box_counter) begin // @[Annotator.scala 136:34]
        coord_reg_8 <= io_in_box_data; // @[Annotator.scala 136:34]
      end
    end
    if (reset) begin // @[Annotator.scala 118:26]
      coord_reg_9 <= 64'hffffffffffffffff; // @[Annotator.scala 118:26]
    end else if (io_in_box_valid) begin // @[Annotator.scala 135:25]
      if (5'h9 == io_in_box_counter) begin // @[Annotator.scala 136:34]
        coord_reg_9 <= io_in_box_data; // @[Annotator.scala 136:34]
      end
    end
    if (reset) begin // @[Annotator.scala 118:26]
      coord_reg_10 <= 64'hffffffffffffffff; // @[Annotator.scala 118:26]
    end else if (io_in_box_valid) begin // @[Annotator.scala 135:25]
      if (5'ha == io_in_box_counter) begin // @[Annotator.scala 136:34]
        coord_reg_10 <= io_in_box_data; // @[Annotator.scala 136:34]
      end
    end
    if (reset) begin // @[Annotator.scala 118:26]
      coord_reg_11 <= 64'hffffffffffffffff; // @[Annotator.scala 118:26]
    end else if (io_in_box_valid) begin // @[Annotator.scala 135:25]
      if (5'hb == io_in_box_counter) begin // @[Annotator.scala 136:34]
        coord_reg_11 <= io_in_box_data; // @[Annotator.scala 136:34]
      end
    end
    if (reset) begin // @[Annotator.scala 118:26]
      coord_reg_12 <= 64'hffffffffffffffff; // @[Annotator.scala 118:26]
    end else if (io_in_box_valid) begin // @[Annotator.scala 135:25]
      if (5'hc == io_in_box_counter) begin // @[Annotator.scala 136:34]
        coord_reg_12 <= io_in_box_data; // @[Annotator.scala 136:34]
      end
    end
    if (reset) begin // @[Annotator.scala 118:26]
      coord_reg_13 <= 64'hffffffffffffffff; // @[Annotator.scala 118:26]
    end else if (io_in_box_valid) begin // @[Annotator.scala 135:25]
      if (5'hd == io_in_box_counter) begin // @[Annotator.scala 136:34]
        coord_reg_13 <= io_in_box_data; // @[Annotator.scala 136:34]
      end
    end
    if (reset) begin // @[Annotator.scala 118:26]
      coord_reg_14 <= 64'hffffffffffffffff; // @[Annotator.scala 118:26]
    end else if (io_in_box_valid) begin // @[Annotator.scala 135:25]
      if (5'he == io_in_box_counter) begin // @[Annotator.scala 136:34]
        coord_reg_14 <= io_in_box_data; // @[Annotator.scala 136:34]
      end
    end
    if (reset) begin // @[Annotator.scala 118:26]
      coord_reg_15 <= 64'hffffffffffffffff; // @[Annotator.scala 118:26]
    end else if (io_in_box_valid) begin // @[Annotator.scala 135:25]
      if (5'hf == io_in_box_counter) begin // @[Annotator.scala 136:34]
        coord_reg_15 <= io_in_box_data; // @[Annotator.scala 136:34]
      end
    end
    if (reset) begin // @[Annotator.scala 118:26]
      coord_reg_16 <= 64'hffffffffffffffff; // @[Annotator.scala 118:26]
    end else if (io_in_box_valid) begin // @[Annotator.scala 135:25]
      if (5'h10 == io_in_box_counter) begin // @[Annotator.scala 136:34]
        coord_reg_16 <= io_in_box_data; // @[Annotator.scala 136:34]
      end
    end
    if (reset) begin // @[Annotator.scala 118:26]
      coord_reg_17 <= 64'hffffffffffffffff; // @[Annotator.scala 118:26]
    end else if (io_in_box_valid) begin // @[Annotator.scala 135:25]
      if (5'h11 == io_in_box_counter) begin // @[Annotator.scala 136:34]
        coord_reg_17 <= io_in_box_data; // @[Annotator.scala 136:34]
      end
    end
    if (reset) begin // @[Annotator.scala 118:26]
      coord_reg_18 <= 64'hffffffffffffffff; // @[Annotator.scala 118:26]
    end else if (io_in_box_valid) begin // @[Annotator.scala 135:25]
      if (5'h12 == io_in_box_counter) begin // @[Annotator.scala 136:34]
        coord_reg_18 <= io_in_box_data; // @[Annotator.scala 136:34]
      end
    end
    if (reset) begin // @[Annotator.scala 118:26]
      coord_reg_19 <= 64'hffffffffffffffff; // @[Annotator.scala 118:26]
    end else if (io_in_box_valid) begin // @[Annotator.scala 135:25]
      if (5'h13 == io_in_box_counter) begin // @[Annotator.scala 136:34]
        coord_reg_19 <= io_in_box_data; // @[Annotator.scala 136:34]
      end
    end
    if (reset) begin // @[Annotator.scala 118:26]
      coord_reg_20 <= 64'hffffffffffffffff; // @[Annotator.scala 118:26]
    end else if (io_in_box_valid) begin // @[Annotator.scala 135:25]
      if (5'h14 == io_in_box_counter) begin // @[Annotator.scala 136:34]
        coord_reg_20 <= io_in_box_data; // @[Annotator.scala 136:34]
      end
    end
    if (reset) begin // @[Annotator.scala 118:26]
      coord_reg_21 <= 64'hffffffffffffffff; // @[Annotator.scala 118:26]
    end else if (io_in_box_valid) begin // @[Annotator.scala 135:25]
      if (5'h15 == io_in_box_counter) begin // @[Annotator.scala 136:34]
        coord_reg_21 <= io_in_box_data; // @[Annotator.scala 136:34]
      end
    end
    if (reset) begin // @[Annotator.scala 118:26]
      coord_reg_22 <= 64'hffffffffffffffff; // @[Annotator.scala 118:26]
    end else if (io_in_box_valid) begin // @[Annotator.scala 135:25]
      if (5'h16 == io_in_box_counter) begin // @[Annotator.scala 136:34]
        coord_reg_22 <= io_in_box_data; // @[Annotator.scala 136:34]
      end
    end
    if (reset) begin // @[Annotator.scala 118:26]
      coord_reg_23 <= 64'hffffffffffffffff; // @[Annotator.scala 118:26]
    end else if (io_in_box_valid) begin // @[Annotator.scala 135:25]
      if (5'h17 == io_in_box_counter) begin // @[Annotator.scala 136:34]
        coord_reg_23 <= io_in_box_data; // @[Annotator.scala 136:34]
      end
    end
    if (reset) begin // @[Annotator.scala 118:26]
      coord_reg_24 <= 64'hffffffffffffffff; // @[Annotator.scala 118:26]
    end else if (io_in_box_valid) begin // @[Annotator.scala 135:25]
      if (5'h18 == io_in_box_counter) begin // @[Annotator.scala 136:34]
        coord_reg_24 <= io_in_box_data; // @[Annotator.scala 136:34]
      end
    end
    if (reset) begin // @[Annotator.scala 118:26]
      coord_reg_25 <= 64'hffffffffffffffff; // @[Annotator.scala 118:26]
    end else if (io_in_box_valid) begin // @[Annotator.scala 135:25]
      if (5'h19 == io_in_box_counter) begin // @[Annotator.scala 136:34]
        coord_reg_25 <= io_in_box_data; // @[Annotator.scala 136:34]
      end
    end
    if (reset) begin // @[Annotator.scala 118:26]
      coord_reg_26 <= 64'hffffffffffffffff; // @[Annotator.scala 118:26]
    end else if (io_in_box_valid) begin // @[Annotator.scala 135:25]
      if (5'h1a == io_in_box_counter) begin // @[Annotator.scala 136:34]
        coord_reg_26 <= io_in_box_data; // @[Annotator.scala 136:34]
      end
    end
    if (reset) begin // @[Annotator.scala 118:26]
      coord_reg_27 <= 64'hffffffffffffffff; // @[Annotator.scala 118:26]
    end else if (io_in_box_valid) begin // @[Annotator.scala 135:25]
      if (5'h1b == io_in_box_counter) begin // @[Annotator.scala 136:34]
        coord_reg_27 <= io_in_box_data; // @[Annotator.scala 136:34]
      end
    end
    if (reset) begin // @[Annotator.scala 118:26]
      coord_reg_28 <= 64'hffffffffffffffff; // @[Annotator.scala 118:26]
    end else if (io_in_box_valid) begin // @[Annotator.scala 135:25]
      if (5'h1c == io_in_box_counter) begin // @[Annotator.scala 136:34]
        coord_reg_28 <= io_in_box_data; // @[Annotator.scala 136:34]
      end
    end
    if (reset) begin // @[Annotator.scala 118:26]
      coord_reg_29 <= 64'hffffffffffffffff; // @[Annotator.scala 118:26]
    end else if (io_in_box_valid) begin // @[Annotator.scala 135:25]
      if (5'h1d == io_in_box_counter) begin // @[Annotator.scala 136:34]
        coord_reg_29 <= io_in_box_data; // @[Annotator.scala 136:34]
      end
    end
    if (reset) begin // @[Annotator.scala 118:26]
      coord_reg_30 <= 64'hffffffffffffffff; // @[Annotator.scala 118:26]
    end else if (io_in_box_valid) begin // @[Annotator.scala 135:25]
      if (5'h1e == io_in_box_counter) begin // @[Annotator.scala 136:34]
        coord_reg_30 <= io_in_box_data; // @[Annotator.scala 136:34]
      end
    end
    if (reset) begin // @[Annotator.scala 118:26]
      coord_reg_31 <= 64'hffffffffffffffff; // @[Annotator.scala 118:26]
    end else if (io_in_box_valid) begin // @[Annotator.scala 135:25]
      if (5'h1f == io_in_box_counter) begin // @[Annotator.scala 136:34]
        coord_reg_31 <= io_in_box_data; // @[Annotator.scala 136:34]
      end
    end
    if (_even_comb_1_T_14 | _odd_comb_1_T_14) begin // @[Annotator.scala 188:36]
      box_pixel_overlay_0 <= 32'hffff00; // @[Annotator.scala 189:26]
    end else if (_even_comb_0_T_14 | _odd_comb_0_T_14) begin // @[Annotator.scala 191:42]
      box_pixel_overlay_0 <= 32'hff00; // @[Annotator.scala 192:26]
    end else begin
      box_pixel_overlay_0 <= io_in_pixel_data[31:0]; // @[Annotator.scala 195:26]
    end
    if (_even_comb_1_T_14 | _odd_comb_1_T_14) begin // @[Annotator.scala 188:36]
      box_pixel_overlay_1 <= 32'hffff00; // @[Annotator.scala 190:26]
    end else if (_even_comb_0_T_14 | _odd_comb_0_T_14) begin // @[Annotator.scala 191:42]
      box_pixel_overlay_1 <= 32'hff00; // @[Annotator.scala 193:26]
    end else begin
      box_pixel_overlay_1 <= io_in_pixel_data[63:32]; // @[Annotator.scala 196:26]
    end
    if (reset) begin // @[Counter.scala 60:40]
      image_x <= 11'h0; // @[Counter.scala 60:40]
    end else if (io_in_pixel_start) begin // @[Counter.scala 135:17]
      image_x <= 11'h0; // @[Counter.scala 97:11]
    end else if (io_in_pixel_valid) begin // @[Counter.scala 137:24]
      if (wrap_wrap) begin // @[Counter.scala 86:20]
        image_x <= 11'h0; // @[Counter.scala 86:28]
      end else begin
        image_x <= _wrap_value_T_1; // @[Counter.scala 76:15]
      end
    end
    if (reset) begin // @[Counter.scala 60:40]
      image_y <= 11'h0; // @[Counter.scala 60:40]
    end else if (io_in_pixel_start) begin // @[Counter.scala 135:17]
      image_y <= 11'h0; // @[Counter.scala 97:11]
    end else if (next_line_start) begin // @[Counter.scala 137:24]
      if (wrap_wrap_1) begin // @[Counter.scala 86:20]
        image_y <= 11'h0; // @[Counter.scala 86:28]
      end else begin
        image_y <= _wrap_value_T_3; // @[Counter.scala 76:15]
      end
    end
    if (reset) begin // @[Counter.scala 60:40]
      char_x <= 3'h0; // @[Counter.scala 60:40]
    end else if (io_in_pixel_start) begin // @[Counter.scala 135:17]
      char_x <= 3'h0; // @[Counter.scala 97:11]
    end else if (io_in_pixel_valid) begin // @[Counter.scala 137:24]
      char_x <= _wrap_value_T_5; // @[Counter.scala 76:15]
    end
    if (reset) begin // @[Counter.scala 60:40]
      char_y <= 4'h0; // @[Counter.scala 60:40]
    end else if (io_in_pixel_start) begin // @[Counter.scala 135:17]
      char_y <= 4'h0; // @[Counter.scala 97:11]
    end else if (next_line_start) begin // @[Counter.scala 137:24]
      char_y <= _wrap_value_T_7; // @[Counter.scala 76:15]
    end
    if (reset) begin // @[Counter.scala 60:40]
      image_col <= 8'h0; // @[Counter.scala 60:40]
    end else if (io_in_pixel_start) begin // @[Counter.scala 135:17]
      image_col <= 8'h0; // @[Counter.scala 97:11]
    end else if (next_char_start) begin // @[Counter.scala 137:24]
      if (image_col_wrap_wrap) begin // @[Counter.scala 86:20]
        image_col <= 8'h0; // @[Counter.scala 86:28]
      end else begin
        image_col <= _image_col_wrap_value_T_1; // @[Counter.scala 76:15]
      end
    end
    if (reset) begin // @[Counter.scala 60:40]
      image_row <= 7'h0; // @[Counter.scala 60:40]
    end else if (io_in_pixel_start) begin // @[Counter.scala 135:17]
      image_row <= 7'h0; // @[Counter.scala 97:11]
    end else if (next_row_start) begin // @[Counter.scala 137:24]
      if (image_row_wrap_wrap) begin // @[Counter.scala 86:20]
        image_row <= 7'h0; // @[Counter.scala 86:28]
      end else begin
        image_row <= _image_row_wrap_value_T_1; // @[Counter.scala 76:15]
      end
    end
    framebuf_index <= framebuf_sel[2:0]; // @[Annotator.scala 152:44]
    fontbuf_sel_REG <= char_y; // @[Annotator.scala 155:74]
    fontbuf_sel_REG_1 <= char_x; // @[Annotator.scala 155:112]
    fontbuf_index <= fontbuf_sel[5:0]; // @[Annotator.scala 158:43]
    io_out_pixel_valid_r <= io_in_pixel_valid; // @[Reg.scala 16:19 Reg.scala 16:23 Reg.scala 15:16]
    io_out_pixel_valid_r_1 <= io_out_pixel_valid_r; // @[Reg.scala 16:19 Reg.scala 16:23 Reg.scala 15:16]
    io_out_pixel_valid_r_2 <= io_out_pixel_valid_r_1; // @[Reg.scala 16:19 Reg.scala 16:23 Reg.scala 15:16]
    io_out_pixel_last_r <= io_in_pixel_last; // @[Reg.scala 16:19 Reg.scala 16:23 Reg.scala 15:16]
    io_out_pixel_last_r_1 <= io_out_pixel_last_r; // @[Reg.scala 16:19 Reg.scala 16:23 Reg.scala 15:16]
    io_out_pixel_last_r_2 <= io_out_pixel_last_r_1; // @[Reg.scala 16:19 Reg.scala 16:23 Reg.scala 15:16]
    output_pixel_r <= io_in_pixel_data; // @[Reg.scala 16:19 Reg.scala 16:23 Reg.scala 15:16]
    output_pixel_r_1 <= output_pixel_r; // @[Reg.scala 16:19 Reg.scala 16:23 Reg.scala 15:16]
    pixel <= {box_pixel_overlay_1,box_pixel_overlay_0}; // @[Cat.scala 30:58]
    io_out_pixel_data_REG <= pixel | output_pixel; // @[Annotator.scala 200:38]
  end
// Register and memory initialization
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE_MEM_INIT
  integer initvar;
`endif
`ifndef SYNTHESIS
`ifdef FIRRTL_BEFORE_INITIAL
`FIRRTL_BEFORE_INITIAL
`endif
initial begin
  `ifdef RANDOMIZE
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      `ifdef RANDOMIZE_DELAY
        #`RANDOMIZE_DELAY begin end
      `else
        #0.002 begin end
      `endif
    `endif
`ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {2{`RANDOM}};
  coord_reg_0 = _RAND_0[63:0];
  _RAND_1 = {2{`RANDOM}};
  coord_reg_1 = _RAND_1[63:0];
  _RAND_2 = {2{`RANDOM}};
  coord_reg_2 = _RAND_2[63:0];
  _RAND_3 = {2{`RANDOM}};
  coord_reg_3 = _RAND_3[63:0];
  _RAND_4 = {2{`RANDOM}};
  coord_reg_4 = _RAND_4[63:0];
  _RAND_5 = {2{`RANDOM}};
  coord_reg_5 = _RAND_5[63:0];
  _RAND_6 = {2{`RANDOM}};
  coord_reg_6 = _RAND_6[63:0];
  _RAND_7 = {2{`RANDOM}};
  coord_reg_7 = _RAND_7[63:0];
  _RAND_8 = {2{`RANDOM}};
  coord_reg_8 = _RAND_8[63:0];
  _RAND_9 = {2{`RANDOM}};
  coord_reg_9 = _RAND_9[63:0];
  _RAND_10 = {2{`RANDOM}};
  coord_reg_10 = _RAND_10[63:0];
  _RAND_11 = {2{`RANDOM}};
  coord_reg_11 = _RAND_11[63:0];
  _RAND_12 = {2{`RANDOM}};
  coord_reg_12 = _RAND_12[63:0];
  _RAND_13 = {2{`RANDOM}};
  coord_reg_13 = _RAND_13[63:0];
  _RAND_14 = {2{`RANDOM}};
  coord_reg_14 = _RAND_14[63:0];
  _RAND_15 = {2{`RANDOM}};
  coord_reg_15 = _RAND_15[63:0];
  _RAND_16 = {2{`RANDOM}};
  coord_reg_16 = _RAND_16[63:0];
  _RAND_17 = {2{`RANDOM}};
  coord_reg_17 = _RAND_17[63:0];
  _RAND_18 = {2{`RANDOM}};
  coord_reg_18 = _RAND_18[63:0];
  _RAND_19 = {2{`RANDOM}};
  coord_reg_19 = _RAND_19[63:0];
  _RAND_20 = {2{`RANDOM}};
  coord_reg_20 = _RAND_20[63:0];
  _RAND_21 = {2{`RANDOM}};
  coord_reg_21 = _RAND_21[63:0];
  _RAND_22 = {2{`RANDOM}};
  coord_reg_22 = _RAND_22[63:0];
  _RAND_23 = {2{`RANDOM}};
  coord_reg_23 = _RAND_23[63:0];
  _RAND_24 = {2{`RANDOM}};
  coord_reg_24 = _RAND_24[63:0];
  _RAND_25 = {2{`RANDOM}};
  coord_reg_25 = _RAND_25[63:0];
  _RAND_26 = {2{`RANDOM}};
  coord_reg_26 = _RAND_26[63:0];
  _RAND_27 = {2{`RANDOM}};
  coord_reg_27 = _RAND_27[63:0];
  _RAND_28 = {2{`RANDOM}};
  coord_reg_28 = _RAND_28[63:0];
  _RAND_29 = {2{`RANDOM}};
  coord_reg_29 = _RAND_29[63:0];
  _RAND_30 = {2{`RANDOM}};
  coord_reg_30 = _RAND_30[63:0];
  _RAND_31 = {2{`RANDOM}};
  coord_reg_31 = _RAND_31[63:0];
  _RAND_32 = {1{`RANDOM}};
  box_pixel_overlay_0 = _RAND_32[31:0];
  _RAND_33 = {1{`RANDOM}};
  box_pixel_overlay_1 = _RAND_33[31:0];
  _RAND_34 = {1{`RANDOM}};
  image_x = _RAND_34[10:0];
  _RAND_35 = {1{`RANDOM}};
  image_y = _RAND_35[10:0];
  _RAND_36 = {1{`RANDOM}};
  char_x = _RAND_36[2:0];
  _RAND_37 = {1{`RANDOM}};
  char_y = _RAND_37[3:0];
  _RAND_38 = {1{`RANDOM}};
  image_col = _RAND_38[7:0];
  _RAND_39 = {1{`RANDOM}};
  image_row = _RAND_39[6:0];
  _RAND_40 = {1{`RANDOM}};
  framebuf_index = _RAND_40[2:0];
  _RAND_41 = {1{`RANDOM}};
  fontbuf_sel_REG = _RAND_41[3:0];
  _RAND_42 = {1{`RANDOM}};
  fontbuf_sel_REG_1 = _RAND_42[2:0];
  _RAND_43 = {1{`RANDOM}};
  fontbuf_index = _RAND_43[5:0];
  _RAND_44 = {1{`RANDOM}};
  io_out_pixel_valid_r = _RAND_44[0:0];
  _RAND_45 = {1{`RANDOM}};
  io_out_pixel_valid_r_1 = _RAND_45[0:0];
  _RAND_46 = {1{`RANDOM}};
  io_out_pixel_valid_r_2 = _RAND_46[0:0];
  _RAND_47 = {1{`RANDOM}};
  io_out_pixel_last_r = _RAND_47[0:0];
  _RAND_48 = {1{`RANDOM}};
  io_out_pixel_last_r_1 = _RAND_48[0:0];
  _RAND_49 = {1{`RANDOM}};
  io_out_pixel_last_r_2 = _RAND_49[0:0];
  _RAND_50 = {2{`RANDOM}};
  output_pixel_r = _RAND_50[63:0];
  _RAND_51 = {2{`RANDOM}};
  output_pixel_r_1 = _RAND_51[63:0];
  _RAND_52 = {2{`RANDOM}};
  pixel = _RAND_52[63:0];
  _RAND_53 = {2{`RANDOM}};
  io_out_pixel_data_REG = _RAND_53[63:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
module BlockRAMModule_2(
  input         clock,
  input  [3:0]  io_addrr,
  output [64:0] io_data_out,
  input         io_enw,
  input  [3:0]  io_addrw,
  input  [64:0] io_data_in
);
`ifdef RANDOMIZE_MEM_INIT
  reg [95:0] _RAND_0;
`endif // RANDOMIZE_MEM_INIT
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_1;
  reg [31:0] _RAND_2;
  reg [95:0] _RAND_3;
`endif // RANDOMIZE_REG_INIT
  reg [64:0] ram [0:15]; // @[BlockRAM.scala 20:24]
  wire [64:0] ram_io_data_out_MPORT_data; // @[BlockRAM.scala 20:24]
  wire [3:0] ram_io_data_out_MPORT_addr; // @[BlockRAM.scala 20:24]
  wire [64:0] ram_MPORT_data; // @[BlockRAM.scala 20:24]
  wire [3:0] ram_MPORT_addr; // @[BlockRAM.scala 20:24]
  wire  ram_MPORT_mask; // @[BlockRAM.scala 20:24]
  wire  ram_MPORT_en; // @[BlockRAM.scala 20:24]
  reg [3:0] ram_io_data_out_MPORT_addr_pipe_0;
  reg  forward; // @[BlockRAM.scala 25:26]
  reg [64:0] data_in_prev; // @[BlockRAM.scala 26:31]
  assign ram_io_data_out_MPORT_addr = ram_io_data_out_MPORT_addr_pipe_0;
  assign ram_io_data_out_MPORT_data = ram[ram_io_data_out_MPORT_addr]; // @[BlockRAM.scala 20:24]
  assign ram_MPORT_data = io_data_in;
  assign ram_MPORT_addr = io_addrw;
  assign ram_MPORT_mask = 1'h1;
  assign ram_MPORT_en = io_enw;
  assign io_data_out = forward ? data_in_prev : ram_io_data_out_MPORT_data; // @[BlockRAM.scala 27:21 BlockRAM.scala 28:19 BlockRAM.scala 22:15]
  always @(posedge clock) begin
    if(ram_MPORT_en & ram_MPORT_mask) begin
      ram[ram_MPORT_addr] <= ram_MPORT_data; // @[BlockRAM.scala 20:24]
    end
    ram_io_data_out_MPORT_addr_pipe_0 <= io_addrr;
    forward <= io_enw & io_addrr == io_addrw; // @[BlockRAM.scala 25:45]
    data_in_prev <= io_data_in; // @[BlockRAM.scala 26:31]
  end
// Register and memory initialization
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE_MEM_INIT
  integer initvar;
`endif
`ifndef SYNTHESIS
`ifdef FIRRTL_BEFORE_INITIAL
`FIRRTL_BEFORE_INITIAL
`endif
initial begin
  `ifdef RANDOMIZE
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      `ifdef RANDOMIZE_DELAY
        #`RANDOMIZE_DELAY begin end
      `else
        #0.002 begin end
      `endif
    `endif
`ifdef RANDOMIZE_MEM_INIT
  _RAND_0 = {3{`RANDOM}};
  for (initvar = 0; initvar < 16; initvar = initvar+1)
    ram[initvar] = _RAND_0[64:0];
`endif // RANDOMIZE_MEM_INIT
`ifdef RANDOMIZE_REG_INIT
  _RAND_1 = {1{`RANDOM}};
  ram_io_data_out_MPORT_addr_pipe_0 = _RAND_1[3:0];
  _RAND_2 = {1{`RANDOM}};
  forward = _RAND_2[0:0];
  _RAND_3 = {3{`RANDOM}};
  data_in_prev = _RAND_3[64:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
module AXI4StreamFIFO_2(
  input         clock,
  input         reset,
  input         s_axis_in_tvalid,
  output        s_axis_in_tready,
  input  [63:0] s_axis_in_tdata,
  input         s_axis_in_tlast,
  output        m_axis_out_tvalid,
  input         m_axis_out_tready,
  output [63:0] m_axis_out_tdata,
  output        m_axis_out_tlast,
  output [4:0]  capacity
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
  reg [31:0] _RAND_1;
`endif // RANDOMIZE_REG_INIT
  wire  ram_clock; // @[BlockRAM.scala 38:19]
  wire [3:0] ram_io_addrr; // @[BlockRAM.scala 38:19]
  wire [64:0] ram_io_data_out; // @[BlockRAM.scala 38:19]
  wire  ram_io_enw; // @[BlockRAM.scala 38:19]
  wire [3:0] ram_io_addrw; // @[BlockRAM.scala 38:19]
  wire [64:0] ram_io_data_in; // @[BlockRAM.scala 38:19]
  reg [4:0] head; // @[AXI4StreamFIFO.scala 10:21]
  reg [4:0] tail; // @[AXI4StreamFIFO.scala 11:21]
  wire [4:0] size = head - tail; // @[AXI4StreamFIFO.scala 13:19]
  wire  empty = head == tail; // @[AXI4StreamFIFO.scala 18:20]
  wire  full_hi = ~tail[4]; // @[AXI4StreamFIFO.scala 19:27]
  wire [3:0] full_lo = tail[3:0]; // @[AXI4StreamFIFO.scala 19:50]
  wire [4:0] _full_T_1 = {full_hi,full_lo}; // @[Cat.scala 30:58]
  wire  full = head == _full_T_1; // @[AXI4StreamFIFO.scala 19:19]
  wire  _T = ~full; // @[AXI4StreamFIFO.scala 24:9]
  wire  _T_1 = s_axis_in_tready & s_axis_in_tvalid; // @[AXI4Stream.scala 24:36]
  wire [4:0] _head_T_1 = head + 5'h1; // @[AXI4StreamFIFO.scala 30:20]
  wire  _T_3 = ~empty; // @[AXI4StreamFIFO.scala 34:9]
  wire  _T_6 = m_axis_out_tready & m_axis_out_tvalid; // @[AXI4Stream.scala 24:36]
  wire [4:0] _read_addr_T_1 = tail + 5'h1; // @[AXI4StreamFIFO.scala 39:25]
  wire [4:0] _GEN_9 = _T_6 ? _read_addr_T_1 : tail; // @[AXI4StreamFIFO.scala 38:5 AXI4StreamFIFO.scala 39:17]
  wire [4:0] read_addr = _T_3 ? _GEN_9 : tail; // @[AXI4StreamFIFO.scala 35:3]
  BlockRAMModule_2 ram ( // @[BlockRAM.scala 38:19]
    .clock(ram_clock),
    .io_addrr(ram_io_addrr),
    .io_data_out(ram_io_data_out),
    .io_enw(ram_io_enw),
    .io_addrw(ram_io_addrw),
    .io_data_in(ram_io_data_in)
  );
  assign s_axis_in_tready = ~full; // @[AXI4StreamFIFO.scala 24:9]
  assign m_axis_out_tvalid = ~empty; // @[AXI4StreamFIFO.scala 34:9]
  assign m_axis_out_tdata = ram_io_data_out[63:0]; // @[AXI4StreamFIFO.scala 36:29]
  assign m_axis_out_tlast = ram_io_data_out[64]; // @[AXI4StreamFIFO.scala 36:57]
  assign capacity = 5'h10 - size; // @[AXI4StreamFIFO.scala 16:36]
  assign ram_clock = clock;
  assign ram_io_addrr = read_addr[3:0]; // @[BlockRAM.scala 50:18]
  assign ram_io_enw = _T & _T_1; // @[AXI4StreamFIFO.scala 25:3 BlockRAM.scala 41:14]
  assign ram_io_addrw = head[3:0];
  assign ram_io_data_in = {s_axis_in_tlast,s_axis_in_tdata}; // @[Cat.scala 30:58]
  always @(posedge clock) begin
    if (reset) begin // @[AXI4StreamFIFO.scala 10:21]
      head <= 5'h0; // @[AXI4StreamFIFO.scala 10:21]
    end else if (_T) begin // @[AXI4StreamFIFO.scala 25:3]
      if (_T_1) begin // @[AXI4StreamFIFO.scala 28:5]
        head <= _head_T_1; // @[AXI4StreamFIFO.scala 30:12]
      end
    end
    if (reset) begin // @[AXI4StreamFIFO.scala 11:21]
      tail <= 5'h0; // @[AXI4StreamFIFO.scala 11:21]
    end else if (_T_3) begin // @[AXI4StreamFIFO.scala 35:3]
      if (_T_6) begin // @[AXI4StreamFIFO.scala 38:5]
        if (_T_3) begin // @[AXI4StreamFIFO.scala 35:3]
          tail <= _GEN_9;
        end
      end
    end
  end
// Register and memory initialization
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE_MEM_INIT
  integer initvar;
`endif
`ifndef SYNTHESIS
`ifdef FIRRTL_BEFORE_INITIAL
`FIRRTL_BEFORE_INITIAL
`endif
initial begin
  `ifdef RANDOMIZE
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      `ifdef RANDOMIZE_DELAY
        #`RANDOMIZE_DELAY begin end
      `else
        #0.002 begin end
      `endif
    `endif
`ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {1{`RANDOM}};
  head = _RAND_0[4:0];
  _RAND_1 = {1{`RANDOM}};
  tail = _RAND_1[4:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
module Annotator(
  input         clock,
  input         reset,
  input         s_axis_in_tvalid,
  output        s_axis_in_tready,
  input  [63:0] s_axis_in_tdata,
  input         s_axis_in_tlast,
  output        m_axis_out_tvalid,
  input         m_axis_out_tready,
  output [63:0] m_axis_out_tdata,
  output        m_axis_out_tlast
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
  reg [31:0] _RAND_1;
`endif // RANDOMIZE_REG_INIT
  wire  ram_clock; // @[BlockRAM.scala 38:19]
  wire [7:0] ram_io_addrr; // @[BlockRAM.scala 38:19]
  wire [63:0] ram_io_data_out; // @[BlockRAM.scala 38:19]
  wire  ram_io_enw; // @[BlockRAM.scala 38:19]
  wire [7:0] ram_io_addrw; // @[BlockRAM.scala 38:19]
  wire [63:0] ram_io_data_in; // @[BlockRAM.scala 38:19]
  wire  ram_1_clock; // @[BlockRAM.scala 38:19]
  wire [10:0] ram_1_io_addrr; // @[BlockRAM.scala 38:19]
  wire [63:0] ram_1_io_data_out; // @[BlockRAM.scala 38:19]
  wire  ram_1_io_enw; // @[BlockRAM.scala 38:19]
  wire [10:0] ram_1_io_addrw; // @[BlockRAM.scala 38:19]
  wire [63:0] ram_1_io_data_in; // @[BlockRAM.scala 38:19]
  wire  ctl_clock; // @[Annotator.scala 238:19]
  wire  ctl_reset; // @[Annotator.scala 238:19]
  wire  ctl_io_in_pixel_start; // @[Annotator.scala 238:19]
  wire  ctl_io_in_pixel_valid; // @[Annotator.scala 238:19]
  wire  ctl_io_in_pixel_last; // @[Annotator.scala 238:19]
  wire [63:0] ctl_io_in_pixel_data; // @[Annotator.scala 238:19]
  wire [10:0] ctl_io_framebuf_addr; // @[Annotator.scala 238:19]
  wire [63:0] ctl_io_framebuf_data; // @[Annotator.scala 238:19]
  wire [7:0] ctl_io_fontbuf_addr; // @[Annotator.scala 238:19]
  wire [63:0] ctl_io_fontbuf_data; // @[Annotator.scala 238:19]
  wire [63:0] ctl_io_in_box_data; // @[Annotator.scala 238:19]
  wire [4:0] ctl_io_in_box_counter; // @[Annotator.scala 238:19]
  wire  ctl_io_in_box_valid; // @[Annotator.scala 238:19]
  wire  ctl_io_out_pixel_valid; // @[Annotator.scala 238:19]
  wire  ctl_io_out_pixel_last; // @[Annotator.scala 238:19]
  wire [63:0] ctl_io_out_pixel_data; // @[Annotator.scala 238:19]
  wire  fifo_clock; // @[Annotator.scala 240:20]
  wire  fifo_reset; // @[Annotator.scala 240:20]
  wire  fifo_s_axis_in_tvalid; // @[Annotator.scala 240:20]
  wire  fifo_s_axis_in_tready; // @[Annotator.scala 240:20]
  wire [63:0] fifo_s_axis_in_tdata; // @[Annotator.scala 240:20]
  wire  fifo_s_axis_in_tlast; // @[Annotator.scala 240:20]
  wire  fifo_m_axis_out_tvalid; // @[Annotator.scala 240:20]
  wire  fifo_m_axis_out_tready; // @[Annotator.scala 240:20]
  wire [63:0] fifo_m_axis_out_tdata; // @[Annotator.scala 240:20]
  wire  fifo_m_axis_out_tlast; // @[Annotator.scala 240:20]
  wire [4:0] fifo_capacity; // @[Annotator.scala 240:20]
  reg [2:0] state; // @[Annotator.scala 232:22]
  reg [10:0] tcounter; // @[Annotator.scala 233:25]
  wire  _T = 3'h0 == state; // @[Conditional.scala 37:30]
  wire  _T_1 = s_axis_in_tready & s_axis_in_tvalid; // @[AXI4Stream.scala 24:36]
  wire  _T_5 = _T_1 & s_axis_in_tdata >= 64'h1 & s_axis_in_tdata < 64'h6; // @[Annotator.scala 261:44]
  wire [63:0] _GEN_0 = _T_1 & s_axis_in_tdata >= 64'h1 & s_axis_in_tdata < 64'h6 ? s_axis_in_tdata : {{61'd0}, state}; // @[Annotator.scala 261:70 Annotator.scala 262:15 Annotator.scala 232:22]
  wire  _T_6 = 3'h1 == state; // @[Conditional.scala 37:30]
  wire [10:0] _tcounter_T_1 = tcounter + 11'h1; // @[Annotator.scala 272:30]
  wire [2:0] _GEN_3 = s_axis_in_tlast | tcounter == 11'hff ? 3'h0 : state; // @[Annotator.scala 273:74 Annotator.scala 274:17 Annotator.scala 232:22]
  wire [10:0] _GEN_7 = _T_1 ? _tcounter_T_1 : tcounter; // @[Annotator.scala 270:32 Annotator.scala 272:18 Annotator.scala 233:25]
  wire [2:0] _GEN_8 = _T_1 ? _GEN_3 : state; // @[Annotator.scala 270:32 Annotator.scala 232:22]
  wire  _T_10 = 3'h2 == state; // @[Conditional.scala 37:30]
  wire [2:0] _GEN_9 = s_axis_in_tlast | tcounter == 11'h47b ? 3'h0 : state; // @[Annotator.scala 284:75 Annotator.scala 285:17 Annotator.scala 232:22]
  wire [2:0] _GEN_14 = _T_1 ? _GEN_9 : state; // @[Annotator.scala 281:32 Annotator.scala 232:22]
  wire  _T_14 = 3'h3 == state; // @[Conditional.scala 37:30]
  wire  _T_15 = fifo_capacity > 5'h4; // @[Annotator.scala 291:27]
  wire [19:0] _GEN_103 = {{9'd0}, tcounter}; // @[Annotator.scala 298:45]
  wire [2:0] _GEN_15 = s_axis_in_tlast | _GEN_103 == 20'h8e61f ? 3'h0 : state; // @[Annotator.scala 298:75 Annotator.scala 299:19 Annotator.scala 232:22]
  wire [2:0] _GEN_20 = _T_1 ? _GEN_15 : state; // @[Annotator.scala 293:34 Annotator.scala 232:22]
  wire  _GEN_22 = fifo_capacity > 5'h4 & _T_1; // @[Annotator.scala 291:35 Annotator.scala 248:25]
  wire [10:0] _GEN_25 = fifo_capacity > 5'h4 ? _GEN_7 : tcounter; // @[Annotator.scala 291:35 Annotator.scala 233:25]
  wire [2:0] _GEN_26 = fifo_capacity > 5'h4 ? _GEN_20 : state; // @[Annotator.scala 291:35 Annotator.scala 232:22]
  wire  _T_19 = 3'h4 == state; // @[Conditional.scala 37:30]
  wire [2:0] _GEN_27 = s_axis_in_tlast | tcounter == 11'hf ? 3'h0 : state; // @[Annotator.scala 313:82 Annotator.scala 314:17 Annotator.scala 232:22]
  wire [2:0] _GEN_32 = _T_1 ? _GEN_27 : state; // @[Annotator.scala 307:32 Annotator.scala 232:22]
  wire  _T_23 = 3'h5 == state; // @[Conditional.scala 37:30]
  wire [10:0] _ctl_io_in_box_counter_T_1 = tcounter + 11'h10; // @[Annotator.scala 323:43]
  wire  _GEN_40 = _T_23 & _T_1; // @[Conditional.scala 39:67 Annotator.scala 253:23]
  wire [10:0] _GEN_43 = _T_23 ? _GEN_7 : tcounter; // @[Conditional.scala 39:67 Annotator.scala 233:25]
  wire [2:0] _GEN_44 = _T_23 ? _GEN_32 : state; // @[Conditional.scala 39:67 Annotator.scala 232:22]
  wire  _GEN_45 = _T_19 | _T_23; // @[Conditional.scala 39:67 AXI4Stream.scala 47:19]
  wire  _GEN_46 = _T_19 ? _T_1 : _GEN_40; // @[Conditional.scala 39:67]
  wire [10:0] _GEN_47 = _T_19 ? tcounter : _ctl_io_in_box_counter_T_1; // @[Conditional.scala 39:67]
  wire [10:0] _GEN_49 = _T_19 ? _GEN_7 : _GEN_43; // @[Conditional.scala 39:67]
  wire [2:0] _GEN_50 = _T_19 ? _GEN_32 : _GEN_44; // @[Conditional.scala 39:67]
  wire  _GEN_51 = _T_14 ? _T_15 : _GEN_45; // @[Conditional.scala 39:67]
  wire [10:0] _GEN_55 = _T_14 ? _GEN_25 : _GEN_49; // @[Conditional.scala 39:67]
  wire [2:0] _GEN_56 = _T_14 ? _GEN_26 : _GEN_50; // @[Conditional.scala 39:67]
  wire  _GEN_57 = _T_14 ? 1'h0 : _GEN_46; // @[Conditional.scala 39:67 Annotator.scala 253:23]
  wire [2:0] _GEN_65 = _T_10 ? _GEN_14 : _GEN_56; // @[Conditional.scala 39:67]
  wire  _GEN_66 = _T_10 ? 1'h0 : _T_14 & _GEN_22; // @[Conditional.scala 39:67 Annotator.scala 248:25]
  wire  _GEN_69 = _T_10 ? 1'h0 : _GEN_57; // @[Conditional.scala 39:67 Annotator.scala 253:23]
  wire  _GEN_72 = _T_6 | (_T_10 | _GEN_51); // @[Conditional.scala 39:67 AXI4Stream.scala 47:19]
  wire  _GEN_73 = _T_6 & _T_1; // @[Conditional.scala 39:67 BlockRAM.scala 41:14]
  wire [2:0] _GEN_77 = _T_6 ? _GEN_8 : _GEN_65; // @[Conditional.scala 39:67]
  wire  _GEN_78 = _T_6 ? 1'h0 : _T_10 & _T_1; // @[Conditional.scala 39:67 BlockRAM.scala 41:14]
  wire  _GEN_81 = _T_6 ? 1'h0 : _GEN_66; // @[Conditional.scala 39:67 Annotator.scala 248:25]
  wire  _GEN_84 = _T_6 ? 1'h0 : _GEN_69; // @[Conditional.scala 39:67 Annotator.scala 253:23]
  wire [63:0] _GEN_88 = _T ? _GEN_0 : {{61'd0}, _GEN_77}; // @[Conditional.scala 40:58]
  BlockRAMModule ram ( // @[BlockRAM.scala 38:19]
    .clock(ram_clock),
    .io_addrr(ram_io_addrr),
    .io_data_out(ram_io_data_out),
    .io_enw(ram_io_enw),
    .io_addrw(ram_io_addrw),
    .io_data_in(ram_io_data_in)
  );
  BlockRAMModule_1 ram_1 ( // @[BlockRAM.scala 38:19]
    .clock(ram_1_clock),
    .io_addrr(ram_1_io_addrr),
    .io_data_out(ram_1_io_data_out),
    .io_enw(ram_1_io_enw),
    .io_addrw(ram_1_io_addrw),
    .io_data_in(ram_1_io_data_in)
  );
  AnnotatorController ctl ( // @[Annotator.scala 238:19]
    .clock(ctl_clock),
    .reset(ctl_reset),
    .io_in_pixel_start(ctl_io_in_pixel_start),
    .io_in_pixel_valid(ctl_io_in_pixel_valid),
    .io_in_pixel_last(ctl_io_in_pixel_last),
    .io_in_pixel_data(ctl_io_in_pixel_data),
    .io_framebuf_addr(ctl_io_framebuf_addr),
    .io_framebuf_data(ctl_io_framebuf_data),
    .io_fontbuf_addr(ctl_io_fontbuf_addr),
    .io_fontbuf_data(ctl_io_fontbuf_data),
    .io_in_box_data(ctl_io_in_box_data),
    .io_in_box_counter(ctl_io_in_box_counter),
    .io_in_box_valid(ctl_io_in_box_valid),
    .io_out_pixel_valid(ctl_io_out_pixel_valid),
    .io_out_pixel_last(ctl_io_out_pixel_last),
    .io_out_pixel_data(ctl_io_out_pixel_data)
  );
  AXI4StreamFIFO_2 fifo ( // @[Annotator.scala 240:20]
    .clock(fifo_clock),
    .reset(fifo_reset),
    .s_axis_in_tvalid(fifo_s_axis_in_tvalid),
    .s_axis_in_tready(fifo_s_axis_in_tready),
    .s_axis_in_tdata(fifo_s_axis_in_tdata),
    .s_axis_in_tlast(fifo_s_axis_in_tlast),
    .m_axis_out_tvalid(fifo_m_axis_out_tvalid),
    .m_axis_out_tready(fifo_m_axis_out_tready),
    .m_axis_out_tdata(fifo_m_axis_out_tdata),
    .m_axis_out_tlast(fifo_m_axis_out_tlast),
    .capacity(fifo_capacity)
  );
  assign s_axis_in_tready = _T | _GEN_72; // @[Conditional.scala 40:58 AXI4Stream.scala 47:19]
  assign m_axis_out_tvalid = fifo_m_axis_out_tvalid; // @[Annotator.scala 241:19]
  assign m_axis_out_tdata = fifo_m_axis_out_tdata; // @[Annotator.scala 241:19]
  assign m_axis_out_tlast = fifo_m_axis_out_tlast; // @[Annotator.scala 241:19]
  assign ram_clock = clock;
  assign ram_io_addrr = ctl_io_fontbuf_addr; // @[BlockRAM.scala 50:18]
  assign ram_io_enw = _T ? 1'h0 : _GEN_73; // @[Conditional.scala 40:58 BlockRAM.scala 41:14]
  assign ram_io_addrw = tcounter[7:0];
  assign ram_io_data_in = s_axis_in_tdata; // @[Annotator.scala 270:32 BlockRAM.scala 57:20]
  assign ram_1_clock = clock;
  assign ram_1_io_addrr = ctl_io_framebuf_addr; // @[BlockRAM.scala 50:18]
  assign ram_1_io_enw = _T ? 1'h0 : _GEN_78; // @[Conditional.scala 40:58 BlockRAM.scala 41:14]
  assign ram_1_io_addrw = tcounter; // @[Annotator.scala 281:32 BlockRAM.scala 56:18]
  assign ram_1_io_data_in = s_axis_in_tdata; // @[Annotator.scala 281:32 BlockRAM.scala 57:20]
  assign ctl_clock = clock;
  assign ctl_reset = reset;
  assign ctl_io_in_pixel_start = _T & _T_5; // @[Conditional.scala 40:58 Annotator.scala 247:25]
  assign ctl_io_in_pixel_valid = _T ? 1'h0 : _GEN_81; // @[Conditional.scala 40:58 Annotator.scala 248:25]
  assign ctl_io_in_pixel_last = s_axis_in_tlast; // @[Annotator.scala 293:34 Annotator.scala 295:32]
  assign ctl_io_in_pixel_data = s_axis_in_tdata; // @[Annotator.scala 293:34 Annotator.scala 296:32]
  assign ctl_io_framebuf_data = ram_1_io_data_out; // @[Annotator.scala 252:24]
  assign ctl_io_fontbuf_data = ram_io_data_out; // @[Annotator.scala 251:23]
  assign ctl_io_in_box_data = s_axis_in_tdata; // @[Conditional.scala 39:67]
  assign ctl_io_in_box_counter = _GEN_47[4:0];
  assign ctl_io_in_box_valid = _T ? 1'h0 : _GEN_84; // @[Conditional.scala 40:58 Annotator.scala 253:23]
  assign fifo_clock = clock;
  assign fifo_reset = reset;
  assign fifo_s_axis_in_tvalid = ctl_io_out_pixel_valid; // @[Annotator.scala 243:25]
  assign fifo_s_axis_in_tdata = ctl_io_out_pixel_data; // @[Annotator.scala 245:24]
  assign fifo_s_axis_in_tlast = ctl_io_out_pixel_last; // @[Annotator.scala 244:24]
  assign fifo_m_axis_out_tready = m_axis_out_tready; // @[Annotator.scala 241:19]
  always @(posedge clock) begin
    if (reset) begin // @[Annotator.scala 232:22]
      state <= 3'h0; // @[Annotator.scala 232:22]
    end else begin
      state <= _GEN_88[2:0];
    end
    if (reset) begin // @[Annotator.scala 233:25]
      tcounter <= 11'h0; // @[Annotator.scala 233:25]
    end else if (_T) begin // @[Conditional.scala 40:58]
      if (_T_1 & s_axis_in_tdata >= 64'h1 & s_axis_in_tdata < 64'h6) begin // @[Annotator.scala 261:70]
        tcounter <= 11'h0; // @[Annotator.scala 263:18]
      end
    end else if (_T_6) begin // @[Conditional.scala 39:67]
      tcounter <= _GEN_7;
    end else if (_T_10) begin // @[Conditional.scala 39:67]
      tcounter <= _GEN_7;
    end else begin
      tcounter <= _GEN_55;
    end
  end
// Register and memory initialization
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE_MEM_INIT
  integer initvar;
`endif
`ifndef SYNTHESIS
`ifdef FIRRTL_BEFORE_INITIAL
`FIRRTL_BEFORE_INITIAL
`endif
initial begin
  `ifdef RANDOMIZE
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      `ifdef RANDOMIZE_DELAY
        #`RANDOMIZE_DELAY begin end
      `else
        #0.002 begin end
      `endif
    `endif
`ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {1{`RANDOM}};
  state = _RAND_0[2:0];
  _RAND_1 = {1{`RANDOM}};
  tcounter = _RAND_1[10:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
