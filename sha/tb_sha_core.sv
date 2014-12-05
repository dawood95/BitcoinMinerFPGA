// $Id: $
// File name:   tb_sha_core.sv
// Created:     12/1/2014
// Author:      Sheik Dawood
// Lab Section: 337-03
// Version:     1.0  Initial Design Entry
// Description: Test bench for ShA-256

`timescale 1ns/100ps

module tb_sha_core(
		   );
   
   reg tb_clk;
   always
     begin
	tb_clk = 1'b0;
	#(10);
	tb_clk = 1'b1;
	#(10);
     end
   
   reg solveEn;
   reg clearCounter;
   reg [255:0] tb_midState;
   reg [511:0] tb_headData;
   reg [5:0]   tb_cycle;
   reg [31:0]  tb_nonce;
   reg [32:0]  tb_coreOutput;
   reg [255:0] out;

   reg 	       flag1, flag2;
   
   sha_core core(
		 .clk(tb_clk),
		 .midState(tb_midState),
		 .headData(tb_headData),
		 .cycle(tb_cycle),
		 .nonce(tb_nonce),
		 .nonceFactor(32'b0),
		 .shaOutput(out),
		 .coreOutput(tb_coreOutput)
		 );
   
   cycleCounter cycles(
		       .clk(tb_clk),
		       .clearCounter(clearCounter),
		       .solveEn(solveEn),
		       .cycle(tb_cycle)
		       );
   
   always @(negedge tb_clk)
     begin
	if(solveEn != 1'b0)
	  begin
	     if(tb_cycle == 6'd0)
	       if(flag1 == 1'b1) 
		 if(flag2 == 1'b1)
		   solveEn = 1'b0;
		 else
		   flag2 = 1'b1;
	       else
		 flag1 = 1'b1;
	     $display("Current output %d : %h %h %h %h %h %h %h %h",tb_cycle,out[255:224],out[223:192],out[191:160],out[159:128],out[127:96],out[95:64],out[63:32],out[31:0]);
	  end
     end
   
   initial
     begin
	flag1 = 0;
	flag2 = 0;
	clearCounter = 1'b1;
	solveEn = 1'b0;
	clearCounter = 1'b0;
	@(negedge tb_clk);
	clearCounter = 1'b1;
	tb_midState = 256'h283048996015d72e781f50c06df10eb3bda2b4ea48f552d85a018aef1e397ddc;
//6f3d57afcf6d1dfdbd2c3972e2f5d0ae421432c606554ac5c365076a94e4e373;
//99652ab722009cc17eead6af868dac31a51ae10e5acba327591a37a3f4b01abc;
	tb_nonce = 32'd411342221;
	tb_headData[31:0] = 32'h7dab00c4;
	tb_headData[63:32] = 32'h76167e54;
	tb_headData[95:64] = 32'h61481b18;
	tb_headData[127:96] =  32'h8d958418;
	tb_headData[159:128] = 32'h80000000;
	tb_headData[191:160] = 32'h0;
	tb_headData[223:192] = 32'h0;
	tb_headData[255:224] = 32'h00000000;
	tb_headData[287:256] = 32'h00000000;
	tb_headData[319:288] = 32'h0;
	tb_headData[351:320] = 32'h0;
	tb_headData[383:352] = 32'h0;
	tb_headData[415:384] = 32'h0;
	tb_headData[447:416] = 32'h0;
	tb_headData[479:448] = 32'h0;
	tb_headData[511:480] = 32'h00000280;
	
	solveEn = 1'b1;
     end

endmodule // tb_sha_core
