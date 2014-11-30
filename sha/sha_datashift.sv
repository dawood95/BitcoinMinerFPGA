// $Id: $
// File name:   sha_datashift.sv
// Created:     11/29/2014
// Author:      Sheik Dawood
// Lab Section: 337-03
// Version:     1.0  Initial Design Entry
// Description: data shift

module sha_datashift(
		     input wire [511:0]  dataInput,
		     output wire [511:0] dataOutput
		     );

   wire [31:0] 			 d1;
   wire [31:0] 			 d2;
   wire [31:0] 			 d3;
   wire [31:0] 			 d4;
   wire [31:0] 			 d5;
   wire [31:0] 			 d6;
   wire [31:0] 			 d7;
   wire [31:0] 			 d8;
   wire [31:0] 			 d9;
   wire [31:0] 			 d10;
   wire [31:0] 			 d11;
   wire [31:0] 			 d12;
   wire [31:0] 			 d13;
   wire [31:0] 			 d14;
   wire [31:0] 			 d15;
   wire [31:0] 			 d16;

   reg [31:0] 			 adder_out1;
   reg [31:0] 			 adder_out2;
   reg [31:0] 			 adder_out3;

   reg [31:0] 			 sig0;
   reg [31:0] 			 sig1;
   
   assign d1 = dataInput[31:0];
   assign d2 = dataInput[63:32];
   assign d3 = dataInput[95:64];
   assign d4 = dataInput[127:96];
   assign d5 = dataInput[159:128];
   assign d6 = dataInput[191:160];
   assign d7 = dataInput[223:192];
   assign d8 = dataInput[255:224];
   assign d9 = dataInput[287:256];
   assign d10 = dataInput[319:288];
   assign d11 = dataInput[351:320];
   assign d12 = dataInput[383:352];
   assign d13 = dataInput[415:384];
   assign d14 = dataInput[447:416];
   assign d15 = dataInput[479:448];
   assign d16 = dataInput[511:480];

   assign dataInput[31:0] = d2;
   assign dataInput[63:32] = d3;
   assign dataInput[95:64] = d4;
   assign dataInput[127:96] = d5;
   assign dataInput[159:128] = d6;
   assign dataInput[191:160] = d7;
   assign dataInput[223:192] = d8;
   assign dataInput[255:224] = d9;
   assign dataInput[287:256] = d10;
   assign dataInput[319:288] = d11;
   assign dataInput[351:320] = d12;
   assign dataInput[383:352] = d13;
   assign dataInput[415:384] = d14;
   assign dataInput[447:416] = d15;
   assign dataInput[479:448] = d16;
   assign dataInput[511:480] = adder_out3;

   s0 s0_1(.i(d2),.o(sig0));
   s1 s1_1(.i(d15),.o(sig1));
   adder adder1(.a(d1),.b(sig0),.c(adder_out1));
   adder adder2(.a(d10),.b(adder_out1),.c(adder_out2));
   adder adder3(.a(sig1),.b(adder_out2),.c(adder_out3));
   
endmodule // sha_datashift
