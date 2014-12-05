//Dawood's folder
// $Id: $
// File name:   hash_checker.sv
// Created:     11/30/2014
// Author:      Shubham Agrawal
// Lab Section: 337-03
// Version:     1.0  Initial Design Entry
// Description: Hash Checker

module hash_checker (
		     input wire 	clk,
		     input wire [5:0] 	count,
		     input wire [31:0] 	nonce, data_in, //first 32 bits of hash
		     output wire [32:0] flag_plus_nonce
		     );
   
   wire 				flag;
   reg [31:0] 				nonce_stored;
   
   assign flag = (data_in == 32'b0) ? 1'b1 : 1'b0;
   assign flag_plus_nonce = {flag, nonce_stored};
  
   always_ff @ (posedge clk) begin
      if(count == 1'b1) 
	nonce_stored <= nonce;
      else 
	nonce_stored <= nonce_stored;
   end

endmodule
