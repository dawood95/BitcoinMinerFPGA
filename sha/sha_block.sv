// $Id: $
// File name:   sha_block.sv
// Created:     11/30/2014
// Author:      Sheik Dawood
// Lab Section: 337-03
// Version:     1.0  Initial Design Entry
// Description: Top Level Sha Block

module sha_block 
  #(
    parameter NCORE = 2
    )
   (
    input wire 	       clk,
    input wire [255:0] midState,
    input wire [511:0] headData,
    input wire 	       solveEn,
    input wire 	       loadState,
    output wire        flag,
    output wire [31:0] goldenNonce
    );
   
   genvar 	       i;
   
   localparam [31:0] 	       nonceFactor = (32'd4294967295 / NCORE) + 1;
   
   reg [33*NCORE-1:0]  outputManagerIn;
   reg [NCORE-1:0]     outputManagerFlag;
   reg [5:0] 	       cycle;
   reg [31:0] 	       nonce;
   
   wire 	       clearCounter;
   
   assign clearCounter = ~loadState;
   assign flag = (outputManagerFlag == 0) ? 1'b0 : 1'b1;
   
   cycleCounter cycleCounter(
			     .clk(clk),
			     .clearCounter(clearCounter),
			     .solveEn(solveEn),
			     .cycle(cycle)
			     );
   
   nonceCounter #(NCORE) nonceCounter (
				       .clk(clk),
				       .clearCounter(clearCounter),
				       .cycle(cycle),
				       .nonce(nonce)
				       );
   
   sha_output_manager #(NCORE) outputManager (
					      .clk(clk),
					      .enable(solveEn),
					      .data_in(outputManagerIn),
					      .flag(outputManagerFlag),
					      .golden_nonce(goldenNonce)
					      );
   
   generate
      for (i = 0; i < NCORE; i++)
	begin : cre
	   sha_core core(
			 .clk(clk),
			 .midState(midState),
			 .headData(headData),
			 .cycle(cycle),
			 .nonce(nonce),
			 .nonceFactor(i*nonceFactor),
			 .coreOutput(outputManagerIn[33*(i+1)-1:33*i])
			 );
	end // for (i = 0; i < NCORE; i++)
   endgenerate

   
   
endmodule // sha_block




