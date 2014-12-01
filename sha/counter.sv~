// $Id: $
// File name:   counter.sv
// Created:     11/29/2014
// Author:      Sheik Dawood
// Lab Section: 337-03
// Version:     1.0  Initial Design Entry
// Description: counter


module counter
  #(
    parameter N = 6
    )
   (
    input wire 		clk,
    input wire 		n_rst,
    input wire 		clear,
    input wire 		enable,
    input wire [N-1:0] 	rollover_val,
    output wire [N-1:0] count_out
    );
   
   reg [N-1:0] 		q_cnt;

   assign count_out = q_cnt;

   always_ff @(posedge clk, negedge n_rst)
     begin 
	if(n_rst == 0)
	  q_cnt <= 0;
	else if(clear == 1'b1)
	  q_cnt <= 0;
	else if(enable == 1'b1)
	  q_cnt <= (q_cnt == rollover_val) ? 0 : q_cnt+1;
	else
	  q_cnt <= q_cnt;
     end

endmodule
   
