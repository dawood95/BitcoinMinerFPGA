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
   reg [31:0] 			 adder_out4;
   reg [31:0] 			 adder_out5;
   reg [31:0] 			 adder_out6;

   reg [31:0] 			 sig0;
   reg [31:0] 			 sig1;
   reg [31:0] 			 sig01;
   reg [31:0] 			 sig11;
   
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

   assign dataOutput[31:0] = d3;
   assign dataOutput[63:32] = d4;
   assign dataOutput[95:64] = d5;
   assign dataOutput[127:96] = d6;
   assign dataOutput[159:128] = d7;
   assign dataOutput[191:160] = d8;
   assign dataOutput[223:192] = d9;
   assign dataOutput[255:224] = d10;
   assign dataOutput[287:256] = d11;
   assign dataOutput[319:288] = d12;
   assign dataOutput[351:320] = d13;
   assign dataOutput[383:352] = d14;
   assign dataOutput[415:384] = d15;
   assign dataOutput[447:416] = d16;
   assign dataOutput[479:448] = adder_out3;
   assign dataOutput[511:480] = adder_out6;

   s0 s0_1(.i(d2),.o(sig0));
   s1 s1_1(.i(d15),.o(sig1));
   s0 s0_11(.i(d3),.o(sig01));
   s1 s1_11(.i(d16),.o(sig11));
   adder adder1(.a(d1),.b(sig0),.c(adder_out1));
   adder adder2(.a(d10),.b(adder_out1),.c(adder_out2));
   adder adder3(.a(sig1),.b(adder_out2),.c(adder_out3));
   adder adder4(.a(d2),.b(sig01),.c(adder_out4));
   adder adder5(.a(d11),.b(adder_out4),.c(adder_out5));
   adder adder6(.a(sig11),.b(adder_out5),.c(adder_out6));
   
endmodule // sha_datashift
