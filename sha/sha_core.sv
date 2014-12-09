// $Id: $
// File name:   sha_core.sv
// Created:     11/30/2014
// Author:      Sheik Dawood
// Lab Section: 337-03
// Version:     1.0  Initial Design Entry
// Description: Sha core

module sha_core(
		input wire 	   clk,
                input wire         loadState,
		input wire [255:0] midState,
		input wire [511:0] headData,
		input wire [5:0]   cycle,
		input wire [31:0]  nonce,
		input wire [31:0]  nonceFactor,
		output wire [32:0] coreOutput	   
		);


   reg [255:0] 			   shaOutput;
   reg [511:0] 			   wordData;
   reg [31:0] 			   nonceVal;
   reg [31:0] 			   nonc;
   reg [31:0] 			   noncF;
   assign nonc = nonce;
   assign noncF = nonceFactor;
   
   adder add(.a(nonce),.b(nonceFactor),.c(nonceVal));
   
   assign wordData = {headData[511:128],nonceVal[7:0],nonceVal[15:8],nonceVal[23:16],nonceVal[31:24],headData[95:0]};
		     
   sha256 sha256Block(
		      .clk(clk),
		      .H(midState),
		      .W(wordData),
		      .cycle(cycle),
		      .hash(shaOutput)
		      );
   
   //SHA Checker

   hash_checker hashchk(
			.clk(clk),
                        .n_rst(~loadState), 
			.count(cycle),
			.nonce(nonceVal),
			.data_in(shaOutput[255:224]),
			.flag_plus_nonce(coreOutput)
			);
   
endmodule // sha_core
