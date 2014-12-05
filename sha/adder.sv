module adder(
	     input wire [31:0] 	a,
	     input wire [31:0] 	b,
	     output wire [31:0] c 	      
	     );
   
   assign c = a+b;
endmodule // adder_basic
