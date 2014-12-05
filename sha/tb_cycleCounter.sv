// $Id: $
// File name:   tb_cycleCounter.sv
// Created:     12/4/2014
// Author:      Sheik Dawood
// Lab Section: 337-03
// Version:     1.0  Initial Design Entry
// Description: Cycle counter test bench

`timescale 1ns/100ps


module tb_nonceCounter();

   
   reg clk;
   always
     begin
	clk = 1'b1;
	#(10);
	clk = 1'b0;
	#(10);
     end

   reg clc;
   reg en;
   reg [5:0] cycle;
   reg [32:0] nonce;
   
   cycleCounter DUT(
		    .clk(clk),
		    .clearCounter(clc),
		    .solveEn(en),
		    .cycle(cycle)
		    );

   nonceCounter DUT1(
		     .clk(clk),
		     .clearCounter(clc),
		     .cycle(cycle),
		     .nonce(nonce)
		     );

   always @(negedge clk)
     begin
	if(clc == 1'b1 && cycle == 32'd1)
	  $display("Value = %d",nonce);
     end
   
   initial
     begin
	clc = 1'b1;
	clc = 1'b0;
	@(negedge clk);
	clc = 1'b1;
	en = 1'b1;
     end
	  
   
endmodule // tb_cycleCounter

     
