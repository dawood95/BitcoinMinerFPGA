// $Id: $
// File name:   design_core.sv
// Created:     12/6/2014
// Author:      Shubham Agrawal
// Lab Section: 337-03
// Version:     1.0  Initial Design Entry
// Description: Top Level Design Core

module design_core (
  input wire clk, n_rst, start_found,
  input wire sol_response,
  input wire [31:0] in_data,
  input wire shift_in_enable,
  output wire sol_claim,
  output wire [31:0] out_data,
  output logic [31:0] dc_debug_data,
  output logic [255:0] midData1,
  output logic [511:0] headData1
);
  
  // I/O Signals 
  wire midstate_shifts_done, remaining_shifts_done;
  wire [2:0] state;
  wire idleState, midState, headState, solveState;
  wire [255:0] midData;
  wire [511:0] headData;
  logic [31:0] count;
  
  assign midData1 = midData;
  assign headData1 = headData;
  // debug
  // assign out_data = midData[31:0];
  // assign sol_claim = 1'b1;
  // assign dc_debug_data[31:16] = out_data[31:16];
  // assign dc_debug_data[15:0] = in_data[15:0];
  assign dc_debug_data = headData[479:448];
  
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
	 .shift_in_enable(shift_in_enable),
    .controller_state(state),
    .midstate_shifts_done(midstate_shifts_done),
    .remaining_shifts_done(remaining_shifts_done)
  );
  
  stp_sr_8 MID_SR (
    .clk(clk),
    .n_rst(~(idleState || start_found)), //reset when idle
    .shift_enable(midState && shift_in_enable),
    .serial_in(in_data),
    .parallel_out(midData)
  );
  
  stp_sr_16 HEAD_SR (
    .clk(clk),
    .n_rst(~(idleState || start_found)), //reset when idle
    .shift_enable(headState && shift_in_enable),
    .serial_in(in_data),
    .parallel_out(headData)
  );
  
  sha_block SHA (
    .clk(clk),
    .midState(midData),
    .headData(headData),
    .solveEn(solveState),
    .loadState(midState || headState),
    .flag(sol_claim),
    .goldenNonce(out_data),
	 .sha_counter(count)
  );
endmodule
