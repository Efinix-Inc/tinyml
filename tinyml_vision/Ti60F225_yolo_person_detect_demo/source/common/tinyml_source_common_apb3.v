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

`timescale 1ns / 1ps

module tinyml_source_common_apb3 #(
   parameter   ADDR_WIDTH  = 12,
   parameter   DATA_WIDTH  = 32,
   parameter   NUM_REG     = 10
) (
//   input    [1:0]          select_demo_mode,
   output                  cam_confdone,
   output   [15:0]         rgb_control,
   output                  trigger_capture_frame,
   output                  continuous_capture_frame,
   output                  rgb_gray,
   output                  cam_dma_init_done,
   output                  set_red_green,
   output                  hw_accel_dma_init_done,
   input   [31:0]          debug_fifo_status,
   input   [31:0]          debug_cam_dma_fifo_rcount,
   input   [31:0]          debug_cam_dma_fifo_wcount,
   input   [31:0]          debug_display_dma_fifo_rcount,
   input   [31:0]          debug_display_dma_fifo_wcount,
   input   [31:0]          debug_dma_hw_accel_in_fifo_wcount,
   input   [31:0]          debug_dma_hw_accel_out_fifo_rcount,
   input   [31:0]          debug_cam_dma_status,
   input   [31:0]          frames_per_second,
   input                   clk,
   input                   resetn,
   input  [ADDR_WIDTH-1:0] PADDR,
   input                   PSEL,
   input                   PENABLE,
   output                  PREADY,
   input                   PWRITE,
   input  [DATA_WIDTH-1:0] PWDATA,
   output [DATA_WIDTH-1:0] PRDATA,
   output                  PSLVERROR
);

///////////////////////////////////////////////////////////////////////////////

localparam [1:0] IDLE   = 2'b00,
                 SETUP  = 2'b01,
                 ACCESS = 2'b10;

reg [1:0]            busState, 
                     busNext;
reg [DATA_WIDTH-1:0] slaveReg [0:NUM_REG-1];
reg [DATA_WIDTH-1:0] slaveRegOut;
reg                  slaveReady;
wire                 actWrite,
                     actRead;
integer              byteIndex;

///////////////////////////////////////////////////////////////////////////////

   always@(posedge clk or negedge resetn)
   begin
      if(!resetn) 
         busState <= IDLE; 
      else
         busState <= busNext; 
   end

   always@(*)
   begin
      busNext = busState;
   
      case(busState)
         IDLE:
         begin
            if(PSEL && !PENABLE)
               busNext = SETUP;
            else
               busNext = IDLE;
         end
         SETUP:
         begin
            if(PSEL && PENABLE)
               busNext = ACCESS;
            else
               busNext = IDLE;
         end
         ACCESS:
         begin
            if(PREADY)
               busNext = IDLE;
            else
               busNext = ACCESS;
         end
         default:
         begin
            busNext = IDLE;
         end
      endcase
   end

   assign actWrite   = PWRITE  & (busState == ACCESS);
   assign actRead    = !PWRITE & (busState == ACCESS);
   assign PSLVERROR  = 1'b0; //FIXME
   assign PRDATA     = slaveRegOut;
   assign PREADY     = slaveReady & & (busState !== IDLE);

   always@ (posedge clk)
   begin
      slaveReady <= actWrite | actRead;
   end

   always@ (posedge clk or negedge resetn)
   begin
      if(!resetn)
         for(byteIndex = 0; byteIndex < NUM_REG; byteIndex = byteIndex + 1)
            slaveReg[byteIndex] <= {{DATA_WIDTH}{1'b0}};
      else begin
         for(byteIndex = 0; byteIndex < NUM_REG; byteIndex = byteIndex + 1)
            if(actWrite && PADDR[ADDR_WIDTH-1:0] == (byteIndex*4))
               slaveReg[byteIndex] <= PWDATA;
            else
               slaveReg[byteIndex] <= slaveReg[byteIndex];
      end
   end

   always@ (posedge clk or negedge resetn)
   begin
      if(!resetn)
         slaveRegOut <= {{DATA_WIDTH}{1'b0}};
      else begin
         if (actRead) begin
            case(PADDR[7:2])
               5'd7  : slaveRegOut <= debug_fifo_status;
               5'd8  : slaveRegOut <= debug_cam_dma_fifo_rcount;
               5'd9  : slaveRegOut <= debug_cam_dma_fifo_wcount;
               5'd10  : slaveRegOut <= debug_display_dma_fifo_rcount;
               5'd11 : slaveRegOut <= debug_display_dma_fifo_wcount;
               5'd12 : slaveRegOut <= debug_cam_dma_status;
               5'd13 : slaveRegOut <= frames_per_second;
               5'd14 : slaveRegOut <= debug_dma_hw_accel_in_fifo_wcount;
               5'd15 : slaveRegOut <= debug_dma_hw_accel_out_fifo_rcount;
               5'd16 : slaveRegOut <= 32'hABCD_5678;   //To verify correct slave read operation
               default: begin slaveRegOut <= slaveRegOut; end
            endcase
         end
         else
            slaveRegOut <= slaveRegOut;
      end
   end

   //custom logic starts here
   assign rgb_control              = slaveReg[0][15:0];
   assign cam_confdone             = slaveReg[1][0];
   assign trigger_capture_frame    = slaveReg[2][0];
   assign continuous_capture_frame = slaveReg[2][1];
   assign rgb_gray                 = slaveReg[3][0];
   assign cam_dma_init_done        = slaveReg[4][0];
   assign set_red_green            = slaveReg[5][0];
   assign hw_accel_dma_init_done   = slaveReg[6][0];
   
endmodule