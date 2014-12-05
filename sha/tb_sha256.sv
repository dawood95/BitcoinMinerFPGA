// $Id: $
// File name:   tb_sha256.sv
// Created:     12/2/2014
// Author:      Sheik Dawood
// Lab Section: 337-03
// Version:     1.0  Initial Design Entry
// Description: SHA 256 Test Bench

`timescale 1ns/100ps

module tb_sha256();

   reg clk;
   always
     begin
        clk = 1'b0;
        #(10);
        clk = 1'b1;
        #(10);
     end

   reg [255:0] data;
   reg [511:0] word;
   reg         clc;
   reg 	       en;
   reg [5:0]   cycle;
   reg [255:0] out;
   
   sha256 DUT(
              .clk(clk),
              .H(data),
              .W(word),
              .cycle(cycle),
              .hash(out)
              );

   cycleCounter cyc(
                    .clk(clk),
                    .clearCounter(clc),
                    .solveEn(en),
                    .cycle(cycle)
                    );
   
   always @(negedge clk)
     begin
	if(en != 1'b0)
	  begin
	     if(cycle == 6'd63)
	       en = 1'b0;
	     $display("Current output %d : %h %h %h %h %h %h %h %h",cycle,out[255:224],out[223:192],out[191:160],out[159:128],out[127:96],out[95:64],out[63:32],out[31:0]);
	  end
     end
   
   initial
     begin
        en = 1'b0;
        clc = 1'b1;
	clc = 1'b0;
	@(negedge clk);
	clc = 1'b1;
        data = 256'h5BE0CD191F83D9AB9B05688C510E527FA54FF53A3C6EF372BB67AE856A09E667;
	word[31:0] = 32'h02000000;
	word[63:32] = 32'h40e929c1;
	word[95:64] = 32'hbfe701e3;
	word[127:96] =  32'h0024aba7;
	word[159:128] = 32'h23f880ca;
	word[191:160] = 32'hc8a59c59;
	word[223:192] = 32'hcc1df51a;
	word[255:224] = 32'h00000000;
	word[287:256] = 32'h00000000;
	word[319:288] = 32'hc16eeafe;
	word[351:320] = 32'ha4c57f77;
	word[383:352] = 32'h4bfe5013;
	word[415:384] = 32'h275dcf07;
	word[447:416] = 32'hf8a3825f;
	word[479:448] = 32'h947582cc;
	word[511:480] = 32'h4b270b5b;
	#(20);
	@(negedge clk);
	$display("Input : %h %h %h %h %h %h %h %h",data[255:224],data[223:192],data[191:160],data[159:128],data[127:96],data[95:64],data[63:32],data[31:0]);
	en = 1'b1;
	@(negedge en);
	clc = 1'b1;
	clc = 1'b0;
	@(negedge clk);
	clc = 1'b1;
        data = 256'h283048996015d72e781f50c06df10eb3bda2b4ea48f552d85a018aef1e397ddc;
	word[31:0] = 32'h7dab00c4;
	word[63:32] = 32'h76167e54;
	word[95:64] = 32'h61481b18;
	word[127:96] =  32'h8d958418;
	word[159:128] = 32'h80000000;
	word[191:160] = 32'h00000000;
	word[223:192] = 32'h00000000;
	word[255:224] = 32'h00000000;
	word[287:256] = 32'h00000000;
	word[319:288] = 32'h00000000;
	word[351:320] = 32'h00000000;
	word[383:352] = 32'h00000000;
	word[415:384] = 32'h00000000;
	word[447:416] = 32'h00000000;
	word[479:448] = 32'h00000000;
	word[511:480] = 32'h00000280;
	#(20);
	@(negedge clk);
	$display("Input : %h %h %h %h %h %h %h %h",data[255:224],data[223:192],data[191:160],data[159:128],data[127:96],data[95:64],data[63:32],data[31:0]);
	en = 1'b1;
	@(negedge en);
	clc = 1'b1;
	clc = 1'b0;
	@(negedge clk);
	clc = 1'b1;
	data = 256'h5BE0CD191F83D9AB9B05688C510E527FA54FF53A3C6EF372BB67AE856A09E667;
	word[31:0] = 32'h81e276d1;
	word[63:32] = 32'ha165793c;
	word[95:64] = 32'h5c3068a2;
	word[127:96] =  32'h78099500;
	word[159:128] = 32'h4bb6f8e0;
	word[191:160] = 32'hd969cf6d;
	word[223:192] = 32'he9f3a65f;
	word[255:224] = 32'h3a357c0f;
	word[287:256] = 32'h80000000;
	word[319:288] = 32'h00000000;
	word[351:320] = 32'h00000000;
	word[383:352] = 32'h00000000;
	word[415:384] = 32'h00000000;
	word[447:416] = 32'h00000000;
	word[479:448] = 32'h00000000;
	word[511:480] = 32'h00000100;
	//00000100000000000000000000000000000000000000000000000000800000003a357c0fe9f3a65fd969cf6d4bb6f8e0780995005c3068a2a165793c81e276d1
	//00000100000000000000000000000000000000000000000000000000800000003a357c0fe9f3a65fd969cf6d4bb6f8e0780995005c3068a2a165793c81e276d1
	#(20);
	@(negedge clk);
	$display("Input : %h %h %h %h %h %h %h %h",data[255:224],data[223:192],data[191:160],data[159:128],data[127:96],data[95:64],data[63:32],data[31:0]);
	en = 1'b1;
     end
   
	      
endmodule // tb_sha256

