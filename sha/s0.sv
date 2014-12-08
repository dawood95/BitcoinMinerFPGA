// $Id: $
// File name:   S0.sv
// Created:     11/6/2014
// Author:      Sheik Dawood
// Lab Section: 337-03
// Version:     1.0  Initial Design Entry
// Description: S0


module S0(
	 input wire [31:0] i,
	 output wire [31:0] o
	 );
   assign o = {i[1:0],i[31:2]}^{i[12:0],i[31:13]}^{i[21:0],i[31:22]};

endmodule // m
