// $Id: $
// File name:   Sig0.sv
// Created:     11/29/2014
// Author:      Sheik Dawood
// Lab Section: 337-03
// Version:     1.0  Initial Design Entry
// Description: Sigma function 0


module s0(
	  input wire [31:0]  i,
	  output wire [31:0] o
	 );
   assign o = {i[6:0],i[31:7]}^{i[17:0],i[31:18]}^{3'b0,i[31:3]};

endmodule // m
