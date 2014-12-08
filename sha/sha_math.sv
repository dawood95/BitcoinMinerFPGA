// $Id: $
// File name:   sha_math.sv
// Created:     11/29/2014
// Author:      Sheik Dawood
// Lab Section: 337-03
// Version:     1.0  Initial Design Entry
// Description: SHA math combinational block

module sha_math(
		input wire [255:0]  math_input,
		input wire [63:0]   W,
		input wire [5:0]   cycle,
		output wire [255:0] math_output
		);
   
   wire [31:0] 			    k[0:63][0:1];
   assign k = '{
		'{32'hbef9a3f7, 32'hc67178f2}, '{32'h428a2f98, 32'h71374491}, '{32'hb5c0fbcf, 32'he9b5dba5}, '{32'h3956c25b, 32'h59f111f1},
		'{32'h923f82a4, 32'hab1c5ed5}, '{32'hd807aa98, 32'h12835b01}, '{32'h243185be, 32'h550c7dc3}, '{32'h72be5d74, 32'h80deb1fe},
		'{32'h9bdc06a7, 32'hc19bf174}, '{32'he49b69c1, 32'hefbe4786}, '{32'h0fc19dc6, 32'h240ca1cc}, '{32'h2de92c6f, 32'h4a7484aa},
		'{32'h5cb0a9dc, 32'h76f988da}, '{32'h983e5152, 32'ha831c66d}, '{32'hb00327c8, 32'hbf597fc7}, '{32'hc6e00bf3, 32'hd5a79147},
		'{32'h06ca6351, 32'h14292967}, '{32'h27b70a85, 32'h2e1b2138}, '{32'h4d2c6dfc, 32'h53380d13}, '{32'h650a7354, 32'h766a0abb},
		'{32'h81c2c92e, 32'h92722c85}, '{32'ha2bfe8a1, 32'ha81a664b}, '{32'hc24b8b70, 32'hc76c51a3}, '{32'hd192e819, 32'hd6990624},
		'{32'hf40e3585, 32'h106aa070}, '{32'h19a4c116, 32'h1e376c08}, '{32'h2748774c, 32'h34b0bcb5}, '{32'h391c0cb3, 32'h4ed8aa4a},
		'{32'h5b9cca4f, 32'h682e6ff3}, '{32'h748f82ee, 32'h78a5636f}, '{32'h84c87814, 32'h8cc70208}, '{32'h90befffa, 32'ha4506ceb},
		'{32'hbef9a3f7, 32'hc67178f2}, '{32'h428a2f98, 32'h71374491}, '{32'hb5c0fbcf, 32'he9b5dba5}, '{32'h3956c25b, 32'h59f111f1},
		'{32'h923f82a4, 32'hab1c5ed5}, '{32'hd807aa98, 32'h12835b01}, '{32'h243185be, 32'h550c7dc3}, '{32'h72be5d74, 32'h80deb1fe},
		'{32'h9bdc06a7, 32'hc19bf174}, '{32'he49b69c1, 32'hefbe4786}, '{32'h0fc19dc6, 32'h240ca1cc}, '{32'h2de92c6f, 32'h4a7484aa},
		'{32'h5cb0a9dc, 32'h76f988da}, '{32'h983e5152, 32'ha831c66d}, '{32'hb00327c8, 32'hbf597fc7}, '{32'hc6e00bf3, 32'hd5a79147},
		'{32'h06ca6351, 32'h14292967}, '{32'h27b70a85, 32'h2e1b2138}, '{32'h4d2c6dfc, 32'h53380d13}, '{32'h650a7354, 32'h766a0abb},
		'{32'h81c2c92e, 32'h92722c85}, '{32'ha2bfe8a1, 32'ha81a664b}, '{32'hc24b8b70, 32'hc76c51a3}, '{32'hd192e819, 32'hd6990624},
		'{32'hf40e3585, 32'h106aa070}, '{32'h19a4c116, 32'h1e376c08}, '{32'h2748774c, 32'h34b0bcb5}, '{32'h391c0cb3, 32'h4ed8aa4a},
		'{32'h5b9cca4f, 32'h682e6ff3}, '{32'h748f82ee, 32'h78a5636f}, '{32'h84c87814, 32'h8cc70208}, '{32'h90befffa, 32'ha4506ceb} 
		};
   // K has been shifter so that the actual K[63] is our K[0].
   logic [31:0] 		    a;
   logic [31:0] 		    b;
   logic [31:0] 		    c;
   logic [31:0] 		    d;
   logic [31:0] 		    e;
   logic [31:0] 		    f;
   logic [31:0] 		    g;
   logic [31:0] 		    h;
   
   reg [31:0] 			    a_s0;
   reg [31:0] 			    e_s1;
   reg [31:0] 			    a_s01;
   reg [31:0] 			    e_s11;
   reg [31:0] 			    maj1;
   reg [31:0] 			    maj2;
   reg [31:0] 			    ch1;
   reg [31:0] 			    ch2;

   reg [31:0] 			    adder_out1;
   reg [31:0] 			    adder_out2;
   reg [31:0] 			    adder_out3;
   reg [31:0] 			    adder_out4;
   reg [31:0] 			    adder_out5;
   reg [31:0] 			    adder_out6;
   reg [31:0] 			    adder_out7;
   reg [31:0] 			    adder_out8;
   reg [31:0] 			    adder_out9;
   reg [31:0] 			    adder_out10;
   reg [31:0] 			    adder_out11;
   reg [31:0] 			    adder_out12;
   reg [31:0] 			    adder_out13;
   reg [31:0] 			    adder_out14;
   
   assign a = math_input[31:0];
   assign b = math_input[63:32];
   assign c = math_input[95:64];
   assign d = math_input[127:96];
   assign e = math_input[159:128];
   assign f = math_input[191:160];
   assign g = math_input[223:192];
   assign h = math_input[255:224];

   assign math_output[31:0] = adder_out10;
   assign math_output[63:32] = adder_out3;
   assign math_output[95:64] = a;
   assign math_output[127:96] = b;
   assign math_output[159:128] = adder_out14;
   assign math_output[191:160] = adder_out7;
   assign math_output[223:192] = e;
   assign math_output[255:224] = f;
   
   ss0 s0_1(.i(a),.o(a_s0));
   ss0 s0_2(.i(adder_out3),.o(a_s01));
   ss1 s1_1(.i(e),.o(e_s1));
   ss1 s1_2(.i(adder_out7),.o(e_s11));
   Maj maj_1(.a(a),.b(b),.c(c),.o(maj1));
   Maj maj_2(.a(adder_out3),.b(a),.c(b),.o(maj2));
   Ch ch_1(.a(e),.b(f),.c(g),.o(ch1));
   Ch ch_2(.a(adder_out7),.b(e),.c(f),.o(ch2));
   
   adder adder1(.a(a_s0),.b(maj1),.c(adder_out1));
   adder adder2(.a(ch1),.b(h),.c(adder_out2));   
   adder adder3(.a(adder_out1),.b(adder_out4),.c(adder_out3));   
   adder adder4(.a(e_s1),.b(adder_out5),.c(adder_out4));   
   adder adder5(.a(adder_out2),.b(adder_out6),.c(adder_out5));
   adder adder6(.a(W[31:0]),.b(k[cycle][0]),.c(adder_out6));
   adder adder7(.a(d),.b(adder_out4),.c(adder_out7));
   adder adder8(.a(a_s01),.b(maj2),.c(adder_out8));
   adder adder9(.a(ch2),.b(g),.c(adder_out9));
   adder adder10(.a(adder_out8),.b(adder_out11),.c(adder_out10));
   adder adder11(.a(e_s11),.b(adder_out12),.c(adder_out11));
   adder adder12(.a(adder_out9),.b(adder_out13),.c(adder_out12));
   adder adder13(.a(W[63:32]),.b(k[cycle][1]),.c(adder_out13));
   adder adder14(.a(c),.b(adder_out11),.c(adder_out14));
endmodule // sha_math
