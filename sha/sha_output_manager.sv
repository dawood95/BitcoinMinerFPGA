// $Id: $
// File name:   sha256_output_manager
// Created:     11/30/2014
// Author:      Shubham Agrawal
// Lab Section: 337-03
// Version:     1.0  Initial Design Entry
// Description: SHA256 Output Manager (Common for all SHA256 cores)

module sha_output_manager
  #(
    parameter NUM_CORES = 1
    )
   (
    input wire 			    clk, enable,
    input wire [33*NUM_CORES - 1:0] data_in,
    output wire [NUM_CORES - 1:0]   flag,
    output reg [31:0] 		    golden_nonce
    );
   
   genvar 			    i;
   integer 			    j[31:0];
   reg [33*NUM_CORES - 1:0] 	    rf;
   
   always_ff @ (posedge clk) begin
      if (enable) rf <= data_in;
      else rf <= rf;
   end
   
   generate
    for (i = 0; i < NUM_CORES; i++) begin
       assign flag[i] = rf[33*(i + 1) - 1];
    end
   endgenerate
   
   generate
    for (i = 0; i < 32; i++) begin
       always_comb begin
          golden_nonce[i] = 1'b0;
          for (j[i] = 0; j[i] < NUM_CORES; j[i]++) begin
          if (flag[j[i]] == 1)
            golden_nonce[i] = rf[33*j[i] + i];
          end
       end
    end
   endgenerate
   
endmodule  
