// $Id: $
// File name:   stp_sr.sv
// Created:     12/5/2014
// Author:      Shubham Agrawal
// Lab Section: 337-03
// Version:     1.0  Initial Design Entry
// Description: N-word Serial-to-Parallel Shift Register

module stp_sr
#(
  parameter NUM_WORDS = 8
)
(
  input wire clk, n_rst, shift_enable,
  input wire [31:0] serial_in,
  output reg [31:0] parallel_out [NUM_WORDS - 1:0]
);
  
  genvar i;
  
  always @ (posedge clk, negedge n_rst) begin
    if (n_rst == 0) begin
      parallel_out[0] <= 32'b0;
    end
    else if (shift_enable) begin
      parallel_out[0] <= serial_in;
    end
    else begin
      parallel_out[0] <= parallel_out[0];
    end
  end
  
  generate
    for (i = 1; i < NUM_WORDS; i+= 1) begin : stpsr
      always @ (posedge clk, negedge n_rst) begin
        if (n_rst == 0) begin
          parallel_out[i] <= 32'b0;
        end
        else if (shift_enable) begin
          parallel_out[i] <= parallel_out[i - 1];
        end
        else begin
          parallel_out[i] <= parallel_out[i];
        end
      end
    end
  endgenerate
endmodule
