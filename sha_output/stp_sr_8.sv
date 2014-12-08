// $Id: $
// File name:   stp_sr_8.sv
// Created:     12/7/2014
// Author:      Shubham Agrawal
// Lab Section: 337-03
// Version:     1.0  Initial Design Entry
// Description: 8-word Serial-to-Parallel Shift Register

module stp_sr_8 (
  input wire clk, n_rst, shift_enable,
  input wire [31:0] serial_in,
  output wire [255:0] parallel_out
);
  
  wire [31:0] p_out [7:0];
  
  assign parallel_out [31:0] = p_out[0];
  assign parallel_out [63:32] = p_out[1];
  assign parallel_out [95:64] = p_out[2];
  assign parallel_out [127:96] = p_out[3];
  assign parallel_out [159:128] = p_out[4];
  assign parallel_out [191:160] = p_out[5];
  assign parallel_out [223:192] = p_out[6];
  assign parallel_out [255:224] = p_out[7];
  
  stp_sr #(8) SR (
    .clk(clk),
    .n_rst(n_rst),
    .shift_enable(shift_enable),
    .serial_in(serial_in),
    .parallel_out(p_out)
  );
endmodule
