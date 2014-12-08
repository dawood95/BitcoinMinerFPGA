// $Id: $
// File name:   S1.v
// Created:     11/6/2014
// Author:      Sheik Dawood
// Lab Section: 337-03
// Version:     1.0  Initial Design Entry
// Description: S1


module S1(
	 input wire [31:0] i,
	 output wire [31:0] o
	 );
   assign o = {i[5:0],i[31:6]}^{i[10:0],i[31:11]}^{i[24:0],i[31:25]};

endmodule // m
