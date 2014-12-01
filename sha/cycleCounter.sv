// $Id: $
// File name:   cycleCounter.sv
// Created:     11/30/2014
// Author:      Sheik Dawood
// Lab Section: 337-03
// Version:     1.0  Initial Design Entry
// Description: Cycles Counter

module cycleCounter (
		     input wire clk,
		     input wire clearCounter,
		     input wire solveEn,
		     output wire [5:0] cycle
		     );

   counter #(6) cntr(.clk(clk),.n_rst(clearCounter),.enable(solveEn),.rollover_val(6'd63),.count_out(cycle));
   
endmodule // cycleCounter
