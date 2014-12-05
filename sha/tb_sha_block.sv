// $Id: $
// File name:   tb_sha_block.sv
// Created:     12/4/2014
// Author:      Sheik Dawood
// Lab Section: 337-03
// Version:     1.0  Initial Design Entry
// Description: SHA Block Test Bench

`timescale 1ns/100ps

module tb_sha_block();

   //Clock generation
   reg clk;

   always
     begin
	clk = 1'b0;
	#(10);
	clk = 1'b1;
	#(10);
     end
   
   //DUT
   reg [255:0] midState;
   reg [511:0] headData;
   reg 	       solveEn;
   reg 	       loadEn;
   reg 	       flag;
   reg [31:0]  nonce;
   
   sha_block #(8) DUT(
		      .clk(clk),
		      .midState(midState),
		      .headData(headData),
		      .solveEn(solveEn),
		      .loadState(loadEn),
		      .flag(flag),
		      .goldenNonce(nonce)
		      );

   //Start of test Bench

   initial
     begin
	loadEn = 0;
	solveEn = 0;
	midState = 256'h283048996015d72e781f50c06df10eb3bda2b4ea48f552d85a018aef1e397ddc;
	headData[31:0] = 32'h7dab00c4;
	headData[63:32] = 32'h76167e54;
	headData[95:64] = 32'h61481b18;
	headData[127:96] =  32'h8d958418;
	headData[159:128] = 32'h80000000;
	headData[191:160] = 32'h0;
	headData[223:192] = 32'h0;
	headData[255:224] = 32'h00000000;
	headData[287:256] = 32'h00000000;
	headData[319:288] = 32'h0;
	headData[351:320] = 32'h0;
	headData[383:352] = 32'h0;
	headData[415:384] = 32'h0;
	headData[447:416] = 32'h0;
	headData[479:448] = 32'h0;
	headData[511:480] = 32'h00000280;
	@(posedge clk);
	loadEn = 1'b1;
	@(posedge clk);
	@(posedge clk);
	loadEn = 1'b0;
	solveEn = 1'b1;
	@(posedge clk);
	@(posedge flag);
	@(negedge clk);
	$display("Nonce = %d %h",nonce,nonce);
     end
   
endmodule // tb_sha_block
