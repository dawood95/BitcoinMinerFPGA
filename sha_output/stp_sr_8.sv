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
  genvar i;
  
  for (i = 0; i < 8; i++) begin
    assign parallel_out [32*(i+1)-1: 32*i] = p_out[i];
  end
  
  stp_sr #(8) SR (
    .clk(clk),
    .n_rst(n_rst),
    .shift_enable(shift_enable),
    .serial_in(serial_in),
    .parallel_out(p_out)
  );
endmodule
