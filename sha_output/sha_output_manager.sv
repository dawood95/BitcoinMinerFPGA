// $Id: $
// File name:   sha256_output_manager
// Created:     11/30/2014
// Author:      Shubham Agrawal
// Lab Section: 337-03
// Version:     1.0  Initial Design Entry
// Description: SHA256 Output Manager (Common for all SHA256 cores)

module sha_output_manager
  #(
    parameter NUM_CORES = 2
    )
   (
    input wire 			    clk, n_rst, enable,
    input wire [33*NUM_CORES - 1:0] data_in,
    output wire [NUM_CORES - 1:0]   flag,
    output reg [31:0] 		    golden_nonce
    );
   
   genvar i, j, m;
   integer k[31:0];
   reg [33*NUM_CORES - 1:0] rf;
   
   
   generate
   for (m = 0; m < NUM_CORES; m++) begin : reset
     always_ff @ (posedge clk, negedge n_rst) begin
       if (n_rst == 0) rf[33*(m+1) - 1:33*m] <= 33'd17179869183;
       else if (enable == 1'b1) rf[33*(m+1) - 1:33*m] <= data_in[33*(m+1) - 1:33*m];
       else rf[33*(m+1) - 1:33*m] <= rf[33*(m+1) - 1:33*m];
     end
   end
   endgenerate
   
   generate
   for (i = 0; i < NUM_CORES; i++) begin: reset2
     assign flag[i] = data_in[33*(i + 1) - 1];
   end
   endgenerate
   
   generate
   for (j = 0; j < 32; j++) begin: reset3
       always_comb begin
          golden_nonce[j] = 1'b0;
          for (k[j] = 0; k[j] < NUM_CORES; k[j]++) begin
          if (flag[k[j]] == 1)
            golden_nonce[j] = rf[33*k[j] + j];
          end
       end
    end
   endgenerate
   
endmodule  
