// $Id: $
// File name:   sha256.sv
// Created:     12/2/2014
// Author:      Sheik Dawood
// Lab Section: 337-03
// Version:     1.0  Initial Design Entry
// Description: SHA-256 Block

// Expect the correct has everytime cycle rollsover to 0

module sha256(
	      input wire 	  clk,
	      input wire [255:0]  H,
	      input wire [511:0]  W,
	      input wire [5:0] 	  cycle,
	      output wire [255:0] hash
	      );

   reg [255:0] 			 currentData;
   reg [255:0] 			 nextData;

   reg [511:0] 			 currentWord;
   reg [511:0] 			 nextWord;

   reg [31:0] 			 h0;
   reg [31:0] 			 h1;
   reg [31:0] 			 h2;
   reg [31:0] 			 h3;
   reg [31:0] 			 h4;
   reg [31:0] 			 h5;
   reg [31:0] 			 h6;
   reg [31:0] 			 h7;


   always_ff @(posedge clk)
     begin: h0FF
	if(cycle == 0)
	  begin
	     h0 <= H[31:0];
	     h1 <= H[63:32];
	     h2 <= H[95:64];
	     h3 <= H[127:96];
	     h4 <= H[159:128];
	     h5 <= H[191:160];
	     h6 <= H[223:192];
	     h7 <= H[255:224];
	  end
	else if(cycle == 6'd32)
	  begin
	     h0 <= 32'h6a09e667;
	     h1 <= 32'hbb67ae85;
	     h2 <= 32'h3c6ef372;
	     h3 <= 32'ha54ff53a;
	     h4 <= 32'h510e527f;
	     h5 <= 32'h9b05688c;
	     h6 <= 32'h1f83d9ab;
	     h7 <= 32'h5be0cd19;
	  end
	else
	  begin
	     h0 <= h0;
	     h1 <= h1;
	     h2 <= h2;
	     h3 <= h3;
	     h4 <= h4;
	     h5 <= h5;
	     h6 <= h6;
	     h7 <= h7;
	  end // else: !if(cycle == 6'32)
     end
   
   adder adder1(.a(nextData[31:0]),.b(h0),.c(hash[31:0]));
   adder adder2(.a(nextData[63:32]),.b(h1),.c(hash[63:32]));
   adder adder3(.a(nextData[95:64]),.b(h2),.c(hash[95:64]));
   adder adder4(.a(nextData[127:96]),.b(h3),.c(hash[127:96]));
   adder adder5(.a(nextData[159:128]),.b(h4),.c(hash[159:128]));
   adder adder6(.a(nextData[191:160]),.b(h5),.c(hash[191:160]));
   adder adder7(.a(nextData[223:192]),.b(h6),.c(hash[223:192]));
   adder adder8(.a(nextData[255:224]),.b(h7),.c(hash[255:224]));

   always_ff @(posedge clk)
     begin: sha256FilpFlop
	if(cycle == 0)
	  currentData <= H;
	else if(cycle == 6'd32)
	  currentData <= 256'h5BE0CD191F83D9AB9B05688C510E527FA54FF53A3C6EF372BB67AE856A09E667;
     	else
	  currentData <= nextData;
     end
   
   sha_math math(
		 .math_input(currentData),
		 .W(currentWord[63:0]),
		 .cycle(cycle),
		 .math_output(nextData)
		 );


   always_ff @(posedge clk)
     begin: sha256wordFF
	if(cycle == 0)
	  currentWord <= W;
	else if(cycle == 6'd32)
	  begin
	     currentWord[31:0] <= hash[31:0];
	     currentWord[63:32] <= hash[63:32];
	     currentWord[95:64] <= hash[95:64];
	     currentWord[127:96] <= hash[127:96];
	     currentWord[159:128] <= hash[159:128];
	     currentWord[191:160] <= hash[191:160];
	     currentWord[223:192] <= hash[223:192];
	     currentWord[255:224] <= hash[255:224];
	     currentWord[287:256] <= 32'h80000000;
	     currentWord[319:288] <= 32'h00000000;
	     currentWord[351:320] <= 32'h00000000;
	     currentWord[383:352] <= 32'h00000000;
	     currentWord[415:384] <= 32'h00000000;
	     currentWord[447:416] <= 32'h00000000;
	     currentWord[479:448] <= 32'h00000000;
	     currentWord[511:480] <= 32'h00000100;
	  end
	else
	  currentWord <= nextWord;
     end
   
   sha_datashift ds(
		    .dataInput(currentWord),
		    .dataOutput(nextWord)
		    );
   
endmodule // sha256

	      
//256bits =h0h1h2..h8
