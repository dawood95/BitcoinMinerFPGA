// $Id: $
// File name:   design_core.sv
// Created:     12/6/2014
// Author:      Shubham Agrawal
// Lab Section: 337-03
// Version:     1.0  Initial Design Entry
// Description: Top Level Design Core

module design_core (
  input wire clk, n_rst, start_found,
  input wire [1:0] sol_response,
  input wire [31:0] in_data,
  output wire sol_claim,
  output wire [31:0] out_data
);
  
  // I/O Signals 
  wire midstate_shifts_done, remaining_shifts_done;
  wire [2:0] state;
  wire idleState, midState, headState, solveState;
  wire [31:0] midData_source [7:0];
  wire [31:0] headData_source [15:0];
  wire [255:0] midData;
  wire [511:0] headData;
  
  controller_proj CTRL (
    .clk(clk),
    .n_rst(n_rst),
    .start_found(start_found),
    .midstate_shifts_done(midstate_shifts_done),
    .remaining_shifts_done(remaining_shifts_done),
    .sol_claim(sol_claim),
    .sol_response(sol_response),
    .state(state),
    .idleState(idleState),
    .midState(midState),
    .headState(headState),
    .solveState(solveState) 
  );
  
  timer_proj TMR (
    .clk(clk),
    .start_found(start_found),
    .controller_state(state),
    .midstate_shifts_done(midstate_shifts_done),
    .remaining_shifts_done(remaining_shifts_done)
  );
  
  stp_sr #(8) MID_SR (
    .clk(clk),
    .n_rst(~(idleState || start_found)), //reset when idle
    .shift_enable(midState),
    .serial_in(in_data),
    .parallel_out(midData)
  );
  
  stp_sr #(16) HEAD_SR (
    .clk(clk),
    .n_rst(~(idleState || start_found)), //reset when idle
    .shift_enable(headState),
    .serial_in(in_data),
    .parallel_out(headData)
  );
  
  sha_block SHA (
    .clk(clk),
    .midState(midData),
    .headData(headData),
    .solveEn(solveState),
    .loadState(midState),
    .flag(sol_claim),
    .goldenNonce(out_data)
  );
endmodule
