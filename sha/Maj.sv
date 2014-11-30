// $Id: $
// File name:   Maj.sv
// Created:     11/6/2014
// Author:      Sheik Dawood
// Lab Section: 337-03
// Version:     1.0  Initial Design Entry
// Description: Maj Block


module Maj(
	 input wire [31:0] a,
	 input wire [31:0] b,
	 input wire [31:0] c,
	 output wire [31:0] o
	 );

   assign o = (a&(b|c)) | (b&c);

endmodule // m

