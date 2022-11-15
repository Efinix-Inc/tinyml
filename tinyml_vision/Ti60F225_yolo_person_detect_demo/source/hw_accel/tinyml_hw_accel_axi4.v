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

module tinyml_hw_accel_axi4 #(
   parameter ADDR_WIDTH = 32,
   parameter DATA_WIDTH = 32
) (
   output                     axi_interrupt,
   input                      axi_aclk,
   input                      axi_resetn,
   //AW
   input [7:0]                axi_awid,
   input [ADDR_WIDTH-1:0]     axi_awaddr,
   input [7:0]                axi_awlen,
   input [2:0]                axi_awsize,
   input [1:0]                axi_awburst,
   input                      axi_awlock,
   input [3:0]                axi_awcache,
   input [2:0]                axi_awprot,
   input [3:0]                axi_awqos,
   input [3:0]                axi_awregion,
   input                      axi_awvalid,
   output                     axi_awready,
   //W
   input [DATA_WIDTH-1:0]     axi_wdata,
   input [(DATA_WIDTH/8)-1:0] axi_wstrb,
   input                      axi_wlast,
   input                      axi_wvalid,
   output                     axi_wready,
   //B
   output [7:0]               axi_bid,
   output [1:0]               axi_bresp,
   output                     axi_bvalid,
   input                      axi_bready,
   //AR
   input [7:0]                axi_arid,
   input [ADDR_WIDTH-1:0]     axi_araddr,
   input [7:0]                axi_arlen,
   input [2:0]                axi_arsize,
   input [1:0]                axi_arburst,
   input                      axi_arlock,
   input [3:0]                axi_arcache,
   input [2:0]                axi_arprot,
   input [3:0]                axi_arqos,
   input [3:0]                axi_arregion,
   input                      axi_arvalid,
   output                     axi_arready,
   //R
   output [7:0]               axi_rid,
   output [DATA_WIDTH-1:0]    axi_rdata,
   output [1:0]               axi_rresp,
   output                     axi_rlast,
   output                     axi_rvalid,
   input                      axi_rready,
   //User Logic
   output                     usr_we,
   output [ADDR_WIDTH-1:0]    usr_waddr,
   output [DATA_WIDTH-1:0]    usr_wdata,
   output                     usr_re,
   output [ADDR_WIDTH-1:0]    usr_raddr,
   input  [DATA_WIDTH-1:0]    usr_rdata,
   input                      usr_rvalid
);

///////////////////////////////////////////////////////////////////////////////
localparam     RAM_SIZE = 2048;
localparam     RAMW   = $clog2(RAM_SIZE);

localparam [2:0]  IDLE     = 3'h0,
                  PRE_WR   = 3'h1,
                  WR       = 3'h2,
                  WR_RESP  = 3'h3,
                  PRE_RD   = 3'h4,
                  RD       = 3'h5;
      
reg [2:0]               busState,
                        busNext;
wire                    busReady,
                        busWrite,
                        busWriteResp,
                        busRead;

reg  [7:0]              awidReg;
reg  [ADDR_WIDTH-1:0]   awaddrReg;
reg  [7:0]              awlenReg;
reg  [2:0]              awsizeReg;
reg  [1:0]              awburstReg,
                        awlockReg;
reg  [3:0]              awcacheReg;
reg  [2:0]              awprotReg;
reg  [3:0]              awqosReg;
reg  [3:0]              awregionReg;

reg  [7:0]              aridReg;
reg  [ADDR_WIDTH-1:0]   araddrReg;
reg  [7:0]              arlenReg;
reg  [2:0]              arsizeReg;
reg  [1:0]              arburstReg,
                        arlockReg;
reg  [3:0]              arcacheReg;
reg  [2:0]              arprotReg;
reg  [3:0]              arqosReg;
reg  [3:0]              arregionReg;

reg  [31:0]             awaddr_base;
wire [31:0]             awWrapSize;
reg  [7:0]              decodeAwsize;

wire [31:0]             araddr_wrap;
reg  [7:0]              decodeArsize;

reg  [31:0]             araddr_base;
wire [31:0]             arWrapSize;
reg  [7:0]              ridReg;
reg  [1:0]              rrespReg;
reg  [1:0]              rlastReg;

wire                    pWr_done;
wire                    pRd_done;
wire                    awaddr_ext;
wire                    araddr_ext;

///////////////////////////////////////////////////////////////////////////////


   always@ (posedge axi_aclk or negedge axi_resetn)
   begin
      if(!axi_resetn)
         busState <= IDLE;
      else
         busState <= busNext;

   end

   always@ (*)
   begin
      busNext = busState;

      case(busState)
      IDLE:
      begin
         if(axi_awvalid)
            busNext = PRE_WR;
         else if(axi_arvalid)
            busNext = PRE_RD;
         else
            busNext = IDLE;
      end
      PRE_WR:
      begin
         if(pWr_done)
            busNext = WR;
         else
            busNext = PRE_WR;
      end
      WR:
      begin
         if(axi_wlast)
            busNext = WR_RESP;
         else
            busNext = WR;
      end
      WR_RESP:
      begin
         if(axi_bready)
            busNext = IDLE;
         else
            busNext = WR_RESP;
      end
      PRE_RD:
      begin
         if(pRd_done)
            busNext = RD;
         else
            busNext = PRE_RD;
      end
      RD:
      begin
         if(axi_rlast && axi_rready)
            busNext = IDLE;
         else
            busNext = RD;
      end
      default:
         busNext = IDLE;
      endcase
   end

   assign busReady     = (busState == IDLE);
   assign busPreWrite  = (busState == PRE_WR);
   assign busWrite     = (busState == WR);
   assign busWriteResp = (busState == WR_RESP);
   assign busPreRead   = (busState == PRE_RD);
   assign busRead      = (busState == RD);

    //PRE_WRITE
    assign pWr_done = (awburstReg == 2'b10)? awaddr_ext : 1'b1;
    //AW Control

   assign axi_awready   = busReady;

    //Wrap Control
        always@ (posedge axi_aclk or negedge axi_resetn)
        begin
      if (!axi_resetn)
         awaddr_base <= 'h0;
      else begin
         if(busReady)
            awaddr_base <= 'h0;
         else if(busPreWrite && !awaddr_ext)
            awaddr_base <= awaddr_base + awWrapSize;
         else
            awaddr_base <= awaddr_base;
      end
   end

   assign awaddr_ext = busPreWrite ? (awaddr_base[RAMW:0] > awaddrReg[RAMW:0]) : 1'b0;
   assign awWrap     = busWrite    ? (awaddrReg[RAMW:0] == awaddr_base - 4)     : 1'b0;
   assign awWrapSize = (DATA_WIDTH/8) * awlenReg;

    //AW Info 
      always@ (posedge axi_aclk)
   begin
      if(axi_awvalid) begin
         awidReg     <= axi_awid;
         awlenReg    <= axi_awlen + 1'b1;
         awsizeReg   <= axi_awsize;
         awburstReg  <= axi_awburst;
         awlockReg   <= axi_awlock;
         awcacheReg  <= axi_awcache;
         awprotReg   <= axi_awprot;
         awqosReg    <= axi_awqos;
         awregionReg <= axi_awregion;
      end
      else begin
         awidReg     <= awidReg;
         awlenReg    <= awlenReg;
         awsizeReg   <= awsizeReg;
         awburstReg  <= awburstReg;
         awlockReg   <= awlockReg;
         awcacheReg  <= awcacheReg;
         awprotReg   <= awprotReg;
         awqosReg    <= awqosReg;
         awregionReg <= awregionReg;
      end
   end

   always@ (awsizeReg)
   begin
      case(awsizeReg)
      3'h0:decodeAwsize    <= 8'd1;
      3'h1:decodeAwsize    <= 8'd2;
      3'h2:decodeAwsize    <= 8'd4;
      3'h3:decodeAwsize    <= 8'd8;
      3'h4:decodeAwsize    <= 8'd16;
      3'h5:decodeAwsize    <= 8'd32;
      3'h6:decodeAwsize    <= 8'd64;
      3'h7:decodeAwsize    <= 8'd128;
      default:decodeAwsize <= 8'd1;
      endcase
   end

   always@ (posedge axi_aclk)
   begin
      if(axi_awvalid)
         awaddrReg   <= axi_awaddr;
      else if (busWrite) begin
         case(awburstReg)
         2'b00://fixed burst
         awaddrReg <= awaddrReg;
         2'b01://incremental burst
         awaddrReg <= awaddrReg + decodeAwsize;
         2'b10://wrap burst
         begin
            if(awWrap)
               awaddrReg <= awaddrReg - awWrapSize;
            else
               awaddrReg <= awaddrReg + decodeAwsize;
         end
         default:
         awaddrReg <= awaddrReg;
         endcase
      end
   end
    //W operation
      assign axi_wready = busWrite;

    //B Response
   assign axi_bid    = awidReg;
   assign axi_bresp  = 2'b00;
   assign axi_bvalid = busWriteResp;

   //PRE_READ
   assign pRd_done = (arburstReg == 2'b10)? araddr_ext : 1'b1;

   //AR Control
   assign axi_arready = busReady;

   //Wrap Control
        always@ (posedge axi_aclk or negedge axi_resetn)
        begin
      if (!axi_resetn)
         araddr_base <= 'h0;
      else begin
         if(busReady)
            araddr_base <= 'h0;
         else if(busPreRead && !araddr_ext)
            araddr_base <= araddr_base + arWrapSize;
         else
            araddr_base <= araddr_base;
      end
   end

   assign araddr_ext = busPreRead ? (araddr_base[RAMW:0] > araddrReg[RAMW:0]) : 1'b0;
   assign arWrap     = busRead    ? (araddrReg[RAMW:0] == araddr_base - 4)     : 1'b0;
   assign arWrapSize = (DATA_WIDTH/8) * arlenReg;

    //AR Info 
      always@ (posedge axi_aclk)
   begin
      if(axi_arvalid) begin
         aridReg     <= axi_arid;
         arlenReg    <= axi_arlen + 1'b1;
         arsizeReg   <= axi_arsize;
         arburstReg  <= axi_arburst;
         arlockReg   <= axi_arlock;
         arcacheReg  <= axi_arcache;
         arprotReg   <= axi_arprot;
         arqosReg    <= axi_arqos;
         arregionReg <= axi_arregion;
      end
      else begin
         aridReg     <= aridReg;
         arlenReg    <= arlenReg;
         arsizeReg   <= arsizeReg;
         arburstReg  <= arburstReg;
         arlockReg   <= arlockReg;
         arcacheReg  <= arcacheReg;
         arprotReg   <= arprotReg;
         arqosReg    <= arqosReg;
         arregionReg <= arregionReg;
      end
   end

   always@ (arsizeReg)
   begin
      case(arsizeReg)
      3'h0:decodeArsize    <= 8'd1;
      3'h1:decodeArsize    <= 8'd2;
      3'h2:decodeArsize    <= 8'd4;
      3'h3:decodeArsize    <= 8'd8;
      3'h4:decodeArsize    <= 8'd16;
      3'h5:decodeArsize    <= 8'd32;
      3'h6:decodeArsize    <= 8'd64;
      3'h7:decodeArsize    <= 8'd128;
      default:decodeArsize <= 8'd1;
      endcase
   end

   always@ (posedge axi_aclk)
   begin
      if(axi_arvalid)
         araddrReg   <= axi_araddr;
      else if (busRead && axi_rready) begin
         case(arburstReg)
         2'b00://fixed burst
         araddrReg <= araddrReg;
         2'b01://incremental burst
         araddrReg <= araddrReg + decodeArsize;
         2'b10://wrap burst
         begin
            if(arWrap)
               araddrReg <= araddrReg - arWrapSize;
            else
               araddrReg <= araddrReg + decodeArsize;
         end
         default:
         araddrReg <= araddrReg;
         endcase
      end
   end
      
   assign axi_rresp = 2'b00;
   assign axi_rid   = aridReg;

   //Export ports for HW accelerator
   //For non-burst mode, with minor customization.
   
   //For read operation, data is to be hold until rready signal is asserted.
   reg [DATA_WIDTH-1:0] usr_rdata_hold;
   reg                  usr_rvalid_hold;
   
   always@ (posedge axi_aclk or negedge axi_resetn)
   begin
      if (~axi_resetn) begin
         usr_rdata_hold  <= {DATA_WIDTH{1'b0}};
         usr_rvalid_hold <= 1'b0;
      end else if (usr_rvalid) begin
         usr_rdata_hold  <= usr_rdata;
         usr_rvalid_hold <= 1'b1;
      end else if (axi_rready) begin
         usr_rdata_hold  <= {DATA_WIDTH{1'b0}};
         usr_rvalid_hold <= 1'b0;
      end
   end
   
   // R Operation
   assign axi_rdata     = usr_rdata_hold;
 
   // R Response
   assign axi_rvalid    = usr_rvalid_hold;
   assign axi_rlast     = usr_rvalid_hold; //For non-burst mode, rlast equals to rvalid

   assign axi_interrupt = 1'b0;  
   
   assign usr_we        = axi_wready & axi_wvalid & axi_wstrb[0]; //Assume always enable all bytes 
   assign usr_waddr     = awaddrReg;
   assign usr_wdata     = axi_wdata;
   assign usr_re        = busRead;
   assign usr_raddr     = araddrReg;

endmodule
