// $Id: $
// File name:   nonceCounter.sv
// Created:     11/30/2014
// Author:      Sheik Dawood
// Lab Section: 337-03
// Version:     1.0  Initial Design Entry
// Description: nonce Counter

module nonceCounter
  #(
    parameter N_CORE = 1
    )
   (
    input wire 	       clk,
    input wire 	       n_rst,
    input wire 	       cycle,
    output wire [31:0] nonce
    );

   reg 		       enable;
   reg 		       clear;

   enable = (cycle == ) ? 1'b1 : 0;
   clear = () ? 1'b1 : 0;
   
   counter #(32) cnt(.clk(clk),.n_rst(n_rst),.clear(clear),.enable(enable),.rollover_val(32'd4294967295),.count_out(nonce));
   
   
endmodule // nonceCounter

  
