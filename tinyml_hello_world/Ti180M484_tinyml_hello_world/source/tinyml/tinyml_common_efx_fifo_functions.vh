/////////////////////////////////////////////////////////////////////////////
//           _____       
//          / _______    Copyright (C) 2013-2020 Efinix Inc. All rights reserved.
//         / /       \   
//        / /  ..    /   tinyml_common_efx_fifo_functions.vh
//       / / .'     /    
//    __/ /.'      /     Description:
//   __   \       /      Include file for generic fifo required functions
//  /_/ /\ \_____/ /     
// ____/  \_______/      
//
// *******************************
// Revisions:
// 1.0 Initial rev
//
// *******************************

function integer depth2width;
input [31:0] depth;
// Description:
//   Converts a depth value into a Width.  For instance a depth of
//        a=depth2width(64);
//   sets "a" to 6. 
//
//   One way to use this is to convert a depth to a width value on a
//   register.  For instance:
//        reg [depth2width(MEM_WIDTH)-1:0] a;
//
begin : fnDepth2Width
  if (depth > 1) begin
     depth = depth - 1;
     for (depth2width=0; depth>0; depth2width = depth2width + 1)
       depth = depth>>1;
  end
  else
    depth2width = 1;
end
endfunction 


//--------------------------------------------------------------------
function integer width2depth;
input [31:0] width;
// Description:
//   Converts a width value into a depth.  For instance a width of
//        a=width2depth(6);
//   sets "a" to 64. 
//
//   One way to use this is to convert a width to a depth value on a
//   register.  For instance:
//        reg [WORD_WIDTH-1:0] a [width2depth(ADR_WIDTH)-1];
//
begin : fnWidth2Depth
  width2depth = width**2;
end
endfunction 

//--------------------------------------------------------------------
function integer divCeil;
input [31:0] dividend;
input [31:0] divisor;
// Description:
//   Divides dividend by divisor.  In dividing the values the max value 
//   is obtained.
//        a=divCeil(6,4);
//   sets "a" to 2. 
//
begin : fnDivCeil
  divCeil = (dividend-(dividend%divisor)) / divisor;
  divCeil = (dividend%divisor) > 0 ? divCeil + 1 : divCeil;
end
endfunction 

//--------------------------------------------------------------------
function integer divFloor;
input [31:0] dividend;
input [31:0] divisor;
// Description:
//   Divides dividend by divisor.  In dividing the values the max value 
//   is obtained.
//        a=divFloor(6,4);
//   sets "a" to 1. 
//
begin : fnDivFloor
  divFloor = (dividend-(dividend%divisor)) / divisor;
end
endfunction 

////////////////////////////////////////////////////////////////////////////////
// Copyright (C) 2013-2020 Efinix Inc. All rights reserved.              
//
// This   document  contains  proprietary information  which   is        
// protected by  copyright. All rights  are reserved.  This notice       
// refers to original work by Efinix, Inc. which may be derivitive       
// of other work distributed under license of the authors.  In the       
// case of derivative work, nothing in this notice overrides the         
// original author's license agreement.  Where applicable, the           
// original license agreement is included in it's original               
// unmodified form immediately below this header.                        
//
// WARRANTY DISCLAIMER.                                                  
//     THE  DESIGN, CODE, OR INFORMATION ARE PROVIDED “AS IS” AND        
//     EFINIX MAKES NO WARRANTIES, EXPRESS OR IMPLIED WITH               
//     RESPECT THERETO, AND EXPRESSLY DISCLAIMS ANY IMPLIED WARRANTIES,  
//     INCLUDING, WITHOUT LIMITATION, THE IMPLIED WARRANTIES OF          
//     MERCHANTABILITY, NON-INFRINGEMENT AND FITNESS FOR A PARTICULAR    
//     PURPOSE.  SOME STATES DO NOT ALLOW EXCLUSIONS OF AN IMPLIED       
//     WARRANTY, SO THIS DISCLAIMER MAY NOT APPLY TO LICENSEE.           
//
// LIMITATION OF LIABILITY.                                              
//     NOTWITHSTANDING ANYTHING TO THE CONTRARY, EXCEPT FOR BODILY       
//     INJURY, EFINIX SHALL NOT BE LIABLE WITH RESPECT TO ANY SUBJECT    
//     MATTER OF THIS AGREEMENT UNDER TORT, CONTRACT, STRICT LIABILITY   
//     OR ANY OTHER LEGAL OR EQUITABLE THEORY (I) FOR ANY INDIRECT,      
//     SPECIAL, INCIDENTAL, EXEMPLARY OR CONSEQUENTIAL DAMAGES OF ANY    
//     CHARACTER INCLUDING, WITHOUT LIMITATION, DAMAGES FOR LOSS OF      
//     GOODWILL, DATA OR PROFIT, WORK STOPPAGE, OR COMPUTER FAILURE OR   
//     MALFUNCTION, OR IN ANY EVENT (II) FOR ANY AMOUNT IN EXCESS, IN    
//     THE AGGREGATE, OF THE FEE PAID BY LICENSEE TO EFINIX HEREUNDER    
//     (OR, IF THE FEE HAS BEEN WAIVED, $100), EVEN IF EFINIX SHALL HAVE 
//     BEEN INFORMED OF THE POSSIBILITY OF SUCH DAMAGES.  SOME STATES DO 
//     NOT ALLOW THE EXCLUSION OR LIMITATION OF INCIDENTAL OR            
//     CONSEQUENTIAL DAMAGES, SO THIS LIMITATION AND EXCLUSION MAY NOT   
//     APPLY TO LICENSEE.
//
////////////////////////////////////////////////////////////////////////////////