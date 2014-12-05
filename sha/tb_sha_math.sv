// $Id: $
// File name:   tb_sha_math.sv
// Created:     12/1/2014
// Author:      Sheik Dawood
// Lab Section: 337-03
// Version:     1.0  Initial Design Entry
// Description: Test Bench for sha math block

`timescale 1ns/100ps

module tb_sha_math(
		   );

   int i;
   reg [255:0] tb_input;
   reg [63:0]  tb_W;
   reg [5:0]   tb_cycle;
   reg [255:0] tb_output;
   
   sha_math math(
		 .math_input(tb_input),
		 .W(tb_W),
		 .cycle(tb_cycle),
		 .math_output(tb_output)
		 );

   initial
     begin
	//Test Case - 1 
	i = 1;
	tb_input = 256'h5BE0CD191F83D9AB9B05688C510E527FA54FF53A3C6EF372BB67AE856A09E667;
	tb_W = 64'h0000000061626380;
	
	tb_cycle = 1;
	#(40)
	$display("Output was %h",tb_output);
     end
   
endmodule // tb_sha_math

