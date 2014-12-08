// $Id: $
// File name:   Sig1.sv
// Created:     11/29/2014
// Author:      Sheik Dawood
// Lab Section: 337-03
// Version:     1.0  Initial Design Entry
// Description: Sigma function 1

module s1(
	  input wire [31:0]  i,
	  output wire [31:0] o
	 );
   assign o = {i[16:0],i[31:17]}^{i[18:0],i[31:19]}^{10'b0,i[31:10]};

endmodule // m
