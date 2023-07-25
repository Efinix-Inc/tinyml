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

module display_hdmi_yuv # (
    parameter   FRAME_WIDTH     = 1920,
    parameter   FRAME_HEIGHT    = 1080,
    
    parameter   VIDEO_MAX_HRES  = 11'd1920,
    parameter   VIDEO_HSP       = 8'd44,
    parameter   VIDEO_HBP       = 8'd148,
    parameter   VIDEO_HFP       = 8'd88,
    
    parameter   VIDEO_MAX_VRES  = 11'd1080,
    parameter   VIDEO_VSP       = 6'd5,
    parameter   VIDEO_VBP       = 6'd36,
    parameter   VIDEO_VFP       = 6'd4
) (
    input logic             iHdmiClk,
    input logic             iRst_n,
    
    // control offset display rgb
    input logic [31:0]      set_offset_display_rgb,
    
    //DMA RGB Input
    input logic [63:0]      ivDisplayDmaRdData,
    input logic             iDisplayDmaRdValid,
    input logic [7:0]       iv7DisplayDmaRdKeep,
    output logic            oDisplayDmaRdReady,
    
    // DMA Fifo status
    input logic             iRstDebugReg,
    output logic            oDebugDisplayDmaFifoUnderflow,
    output logic            oDebugDisplayDmaFifoOverflow ,
    output logic  [31:0]    ov32DebugDisplayDmaFifoRCount, 
    output logic  [31:0]    ov32DebugDisplayDmaFifoWCount,

    //YUV output
    output logic            oHdmiYuvVs ,
    output logic            oHdmiYuvHs ,
    output logic            oHdmiYuvDe ,
    output logic    [15:0]  ov16HdmiYuvData 

);

localparam DISP_FIFO_DEPTH       = 4096;
localparam FIFO_COUNT_BIT        = $clog2(DISP_FIFO_DEPTH);

localparam RGB_COLOR_BIT = 8;

localparam  PPC             = 3'd2;

////////////////////////
// Variable Declaration
///////////////////////

// DMA Fifo
wire [FIFO_COUNT_BIT-1:0] wvDisplayDmaFifoCount;

wire wVgaGenHs;
wire wVgaGenVs;
wire wVgaGenVd;
wire wVgaGenDe;
wire [13:0] wv14VgaGenOutX;
wire [11:0] wv12VgaGenOutY;


///////////
// Vga Gen 
///////////
display_hdmi_vga_gen_v2 #(

    .H_SyncPulse    (VIDEO_HSP),
    .H_BackPorch    (VIDEO_HBP),
    .H_ActivePix    (VIDEO_MAX_HRES),
    .H_FrontPorch   (VIDEO_HFP),

    .V_SyncPulse    (VIDEO_VSP),
    .V_BackPorch    (VIDEO_VBP),
    .V_ActivePix    (VIDEO_MAX_VRES),
    .V_FrontPorch   (VIDEO_VFP),
    
    .P_Cnt          (PPC) //(3'd2) //(3'd1) // (3'd4)
    
) inst_fb_vga_gen_video (
    .in_pclk        (iHdmiClk),
    .in_rstn        (iRst_n),
    .out_hs         (wVgaGenHs),
    .out_vs         (wVgaGenVs),
    .out_de         (wVgaGenDe), // Not used
    .out_valid      (wVgaGenVd),
    .out_x          (wv14VgaGenOutX),
    .out_y          (wv12VgaGenOutY)
);

// parameter to crop from 1920 --> 1080 start and end offset (2PPC)
localparam   HOR_CROP_START  = 210; // (1920-1080)/PPC/2
localparam   HOR_CROP_END    = 750; // 1080/PPC + HOR_CROP_START


wire [(RGB_COLOR_BIT*4*PPC)-1:0]    wvDisplayDmaRdData;
wire                                wDisplayDmaRdValid;
wire                                wDisplayDmaRdReady;

assign wDisplayDmaRdReady = (wvDisplayDmaFifoCount < (DISP_FIFO_DEPTH-300) ) ? 1:0; 

assign wvDisplayDmaRdData = ivDisplayDmaRdData;
assign wDisplayDmaRdValid = iDisplayDmaRdValid && (&iv7DisplayDmaRdKeep) & oDisplayDmaRdReady;
assign oDisplayDmaRdReady = wDisplayDmaRdReady;

/////////////////////////////////////////////////////
// Ensure fifo start read only when DMA partial empty
//////////////////////////////////////////////////////
logic rDmaFifoLatchPartialEmpty;
logic rDmaFifoStartRead;
logic wvDisplayDmaRdEn;
logic rLatchStartFrame; 
logic rLatchStartFrame_d1; 

always @(posedge iHdmiClk) begin 
    if(~iRst_n)	begin
        rDmaFifoLatchPartialEmpty <= 1'b0;
        rLatchStartFrame <= 1'b0;
        rLatchStartFrame_d1 <= 1'b0;
    end else begin
        // Latch partial empty
        if (wvDisplayDmaFifoCount > DISP_FIFO_DEPTH/2) rDmaFifoLatchPartialEmpty <= 1'b1;
        else rDmaFifoLatchPartialEmpty <= rDmaFifoLatchPartialEmpty;
        
        //Latch Valid Start
        if (rDmaFifoLatchPartialEmpty && (~wVgaGenVs)) rLatchStartFrame <= 1'b1;
        else rLatchStartFrame <= rLatchStartFrame;
        // do it twice to remove lagging from rDmaFifoLatchPartialEmpty <--> wVgaGenVs condition
        if (rLatchStartFrame && (~wVgaGenVs)) rLatchStartFrame_d1 <= 1'b1;
        else rLatchStartFrame_d1 <= rLatchStartFrame_d1;
    end
end


// Condition to read DMA Fifo (AND condition)
// 1: VgaGen
// 2: DMAFifo reach partial empty once. (DMA will auto restart once started, should never hit empty again)
// 3 Vsync && partial empty once Detected. (To align the frame)
// 4. (For tinyML) valid within HOR_CROP_START:HOR_CROP_END
assign wvDisplayDmaRdEn = (wv14VgaGenOutX >= HOR_CROP_START) && (wv14VgaGenOutX < HOR_CROP_END) && wVgaGenVd && rLatchStartFrame_d1;

////////////////////
// Display DMA Fifo
///////////////////
wire [(RGB_COLOR_BIT*4*PPC)-1:0] wvDisplayDmaFifoRdata;
wire wDisplayDmaFifoValid;
wire wDmaFifoEmpty;

logic    wDebugDisplayDmaFifoUnderflow;
logic    wDebugDisplayDmaFifoOverflow ;

// Regenerate FIFO bit width == (RGB_COLOR_BIT*4*PPC);
display_dma_fifo u_display_dma_fifo (
    .clk_i          (iHdmiClk),
    .a_rst_i        (~iRst_n),
    
    .almost_full_o  (display_dma_fifo_almost_full),
    .full_o         (),
    .overflow_o     (wDebugDisplayDmaFifoOverflow),
    .wr_ack_o       (),
    .empty_o        (wDmaFifoEmpty),
    .almost_empty_o (),
    .underflow_o    (wDebugDisplayDmaFifoUnderflow),
    
    // Write data
    .wr_en_i        (wDisplayDmaRdValid),
    .wdata          (wvDisplayDmaRdData),
    
    // Read data
    .rd_en_i        (wvDisplayDmaRdEn),
    
    .rd_valid_o     (wDisplayDmaFifoValid),
    .rdata          (wvDisplayDmaFifoRdata),
    
    .datacount_o    (wvDisplayDmaFifoCount)
);

/////////////////////////////////////
/// DIPLAY DMA FIFO DEBUG REGISTER //
/////////////////////////////////////
always @(posedge iHdmiClk) begin 
    if(~iRst_n)	begin
        oDebugDisplayDmaFifoUnderflow <= 1'b0;
        oDebugDisplayDmaFifoOverflow <= 1'b0;
        
        ov32DebugDisplayDmaFifoRCount <= 32'b0;
        ov32DebugDisplayDmaFifoWCount <= 32'b0;
    end else begin
        if (iRstDebugReg) begin
            oDebugDisplayDmaFifoUnderflow <= 1'b0;
            oDebugDisplayDmaFifoOverflow <= 1'b0;
            ov32DebugDisplayDmaFifoRCount <= 32'b0;
            ov32DebugDisplayDmaFifoWCount <= 32'b0;
        end else begin
            if (wDebugDisplayDmaFifoUnderflow) oDebugDisplayDmaFifoUnderflow <= 1'b1;
            else oDebugDisplayDmaFifoUnderflow <= oDebugDisplayDmaFifoUnderflow;
        
            if (wDebugDisplayDmaFifoOverflow) oDebugDisplayDmaFifoOverflow <= 1'b1;
            else oDebugDisplayDmaFifoOverflow <= oDebugDisplayDmaFifoOverflow;
            
            if (wvDisplayDmaRdEn) ov32DebugDisplayDmaFifoRCount <= ov32DebugDisplayDmaFifoRCount + 1'b1;
            else ov32DebugDisplayDmaFifoRCount <= ov32DebugDisplayDmaFifoRCount ;
            
            if (wDisplayDmaRdValid) ov32DebugDisplayDmaFifoWCount <= ov32DebugDisplayDmaFifoWCount + 1'b1;
            else ov32DebugDisplayDmaFifoWCount <= ov32DebugDisplayDmaFifoWCount ;
        end
    end
end

//////////////////////////////////////////////////////////////
// select Display Offset color
// This color will be diplayed when
//  1. No DMA Data yet (DMA Not started yet by SW)
//  2. Offset display (Outside of 1080X1080 real camera data)
//  3. set_offset_display_rgb_d[24] is not asserted
/////////////////////////////////////////////////////////////

logic [(RGB_COLOR_BIT*4*PPC)-1:0] rv64OffetDisplay;
logic [31:0] set_offset_display_rgb_d;
always @(posedge iHdmiClk) begin 
    if(~iRst_n)	begin
        rv64OffetDisplay <= 64'h00FFFFFF_00FFFFFF; // white
        set_offset_display_rgb_d <= 32'h0;
    end else begin
         set_offset_display_rgb_d <= set_offset_display_rgb;
         if (set_offset_display_rgb_d[24] == 1'b1) // SW need to set 
             rv64OffetDisplay <= {8'h0,set_offset_display_rgb_d[23:0],8'h0,set_offset_display_rgb_d[23:0]};
         else
             rv64OffetDisplay <= 64'h00FFFFFF_00FFFFFF; // white
    end
end

wire [(RGB_COLOR_BIT*4*PPC)-1:0] wvDisplayDataSel;
assign wvDisplayDataSel = (rLatchStartFrame_d1 & (((wv14VgaGenOutX > HOR_CROP_START) & (wv14VgaGenOutX <= HOR_CROP_END)) == 1) ) ? wvDisplayDmaFifoRdata: rv64OffetDisplay; // pad with white

/////////////////////////////////////////////
/* Unpack X PPC bit data to 1 PPC bit data */
////////////////////////////////////////////
wire [(RGB_COLOR_BIT*PPC)-1:0]    wvDisplayDmaRed;
wire [(RGB_COLOR_BIT*PPC)-1:0]    wvDisplayDmaGreen;
wire [(RGB_COLOR_BIT*PPC)-1:0]    wvDisplayDmaBlue;

wire wUnpackHs;
wire wUnpackVs;
wire wUnpackVd;
wire wUnpackDe;
wire [23:0] wv24UnpackData;

// 2PPC
assign wvDisplayDmaRed   = {wvDisplayDataSel [39:32], wvDisplayDataSel [7:0]}; 
assign wvDisplayDmaGreen = {wvDisplayDataSel [47:40], wvDisplayDataSel [15:8]};
assign wvDisplayDmaBlue  = {wvDisplayDataSel [55:48], wvDisplayDataSel [23:16]};

// Delayed Frame control signal due to fifo read enable --> Fifo valid
reg wVgaGenHs_d1,wVgaGenHs_d2,wVgaGenHs_d3;
reg wVgaGenVs_d1,wVgaGenVs_d2,wVgaGenVs_d3;
reg wVgaGenVd_d1,wVgaGenVd_d2,wVgaGenVd_d3;
reg wVgaGenDe_d1,wVgaGenDe_d2,wVgaGenDe_d3;
reg [13:0] wv14VgaGenOutX_d1,wv14VgaGenOutX_d2,wv14VgaGenOutX_d3;
reg [11:0] wv12VgaGenOutY_d1,wv12VgaGenOutY_d2,wv12VgaGenOutY_d3;

always @(posedge iHdmiClk) begin 
    if(~iRst_n)	begin

        wVgaGenHs_d1 <= 1'b1;
        wVgaGenVs_d1 <= 1'b1;
        wVgaGenVd_d1 <= 1'b0;
        wVgaGenDe_d1 <= 1'b0;
        wv14VgaGenOutX_d1 <= 'h0;
        wv12VgaGenOutY_d1 <= 'h0;
        
        wVgaGenHs_d2 <= 1'b1;
        wVgaGenVs_d2 <= 1'b1;
        wVgaGenVd_d2 <= 1'b0;
        wVgaGenDe_d2 <= 1'b0;
        wv14VgaGenOutX_d2 <= 'h0;
        wv12VgaGenOutY_d2 <= 'h0;
        
        wVgaGenHs_d3 <= 1'b1;
        wVgaGenVs_d3 <= 1'b1;
        wVgaGenVd_d3 <= 1'b0;
        wVgaGenDe_d3 <= 1'b0;
        wv14VgaGenOutX_d3 <= 'h0;
        wv12VgaGenOutY_d3 <= 'h0;
        
    end else begin
    
        wVgaGenHs_d1 <= wVgaGenHs;
        wVgaGenVs_d1 <= wVgaGenVs;
        wVgaGenVd_d1 <= wVgaGenVd;
        wVgaGenDe_d1 <= wVgaGenDe;
        wv14VgaGenOutX_d1 <= wv14VgaGenOutX;
        wv12VgaGenOutY_d1 <= wv12VgaGenOutY;
        
        wVgaGenHs_d2 <= wVgaGenHs_d1;
        wVgaGenVs_d2 <= wVgaGenVs_d1;
        wVgaGenVd_d2 <= wVgaGenVd_d1;
        wVgaGenDe_d2 <= wVgaGenDe_d1;
        wv14VgaGenOutX_d2 <= wv14VgaGenOutX_d1;
        wv12VgaGenOutY_d2 <= wv12VgaGenOutY_d1;
        
        wVgaGenHs_d3 <= wVgaGenHs_d2;
        wVgaGenVs_d3 <= wVgaGenVs_d2;
        wVgaGenVd_d3 <= wVgaGenVd_d2;
        wVgaGenDe_d3 <= wVgaGenDe_d2;
        wv14VgaGenOutX_d3 <= wv14VgaGenOutX_d2;
        wv12VgaGenOutY_d3 <= wv12VgaGenOutY_d2;
        
    end
end
////////////////////////////////////////////


display_hdmi_data_unpack #(
    .PIXEL_BIT  (8'd24),
    .PACK_BIT   (PPC*24),
    .FIFO_WIDTH (4'd11) // To Check
) inst_data_unpack_2to1 (
    .in_pclk    (iHdmiClk),
    .in_rstn    (iRst_n),
    
    .in_x       (wv14VgaGenOutX_d3),
    .in_y       (wv12VgaGenOutY_d3),
    .in_valid   (wVgaGenVd_d3),
    .in_de      (wVgaGenDe_d3),
    .in_hs      (wVgaGenHs_d3),
    .in_vs      (wVgaGenVs_d3),

    // 2 PPC
    .in_data    (   {   { wvDisplayDmaRed[15:8]     , wvDisplayDmaGreen[15:8]   , wvDisplayDmaBlue[15:8]},
                        { wvDisplayDmaRed[7:0]      , wvDisplayDmaGreen[7:0]    , wvDisplayDmaBlue[7:0]}}
                ),  
    
    .out_x      (),
    .out_y      (),
    .out_valid  (wUnpackVd),
    .out_de     (wUnpackDe),
    .out_hs     (wUnpackHs),
    .out_vs     (wUnpackVs),
    .out_data   (wv24UnpackData)
);



///////////////////////////
// Convert RGGB to HDMI YUV
///////////////////////////
display_hdmi_rgb_to_yuv inst_display_hdmi_rgb_to_yuv (
    // Clock and reset input
    .iHdmiClk           (iHdmiClk),
    .iRst_n             (iRst_n),
    
      // With unpack
    // Rgb input
    .iv8Red             (wv24UnpackData[23:16]),
    .iv8Green           (wv24UnpackData[15:8]),
    .iv8Blue            (wv24UnpackData[7:0]),
    .iRgbVd             (wUnpackVd),
    .iRgbVs             (wUnpackVs),
    .iRgbHs             (wUnpackHs),
    
//    // Bypass unpack (1PPC)
//    .iv8Red             (wvDisplayDataSel[7:0]),
//    .iv8Green           (wvDisplayDataSel[15:8]),
//    .iv8Blue            (wvDisplayDataSel[23:16]),
//    .iRgbVd             (wDisplayDmaFifoValid),
//    .iRgbVs             (wVgaGenVs),
//    .iRgbHs             (wVgaGenHs),
    
    // HDMI YUV output
    .oHdmiYuvVs         (oHdmiYuvVs),
    .oHdmiYuvHs         (oHdmiYuvHs),
    .oHdmiYuvDe         (oHdmiYuvDe),
    .ov16HdmiYuvData    (ov16HdmiYuvData)
);

endmodule
