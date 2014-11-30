// $Id: $
// File name:   tb_sha_output_manager.sv
// Created:     11/30/2014
// Author:      Shubham Agrawal
// Lab Section: 337-03
// Version:     1.0  Initial Design Entry
// Description: Test Bench for SHA256 Output Manager
`timescale 1ns / 10ps

module tb_sha_output_manager();
  //Define Parameters
  parameter CLK_PERIOD = 10;
  localparam CHECK_DELAY = 2.5;
  localparam NUM_CORES = 2;
  
  reg tb_clk, tb_enable;
  reg [33*NUM_CORES - 1:0] tb_data_in;
  reg [NUM_CORES - 1:0] tb_flag;
  reg [31:0] tb_golden_nonce;
  
  integer tb_test_num;
  wire [33*NUM_CORES - 1:0] tb_data_all[3:0];
  
  sha_output_manager DUT (
    .clk(tb_clk),
    .enable(tb_enable),
    .data_in(tb_data_in),
    .flag(tb_flag),
    .golden_nonce(tb_golden_nonce)
  );
  
  always
	begin : CLK_GEN
		tb_clk = 1'b0;
		#(CLK_PERIOD / 2);
		tb_clk = 1'b1;
		#(CLK_PERIOD / 2);
	end
  
  assign tb_data_all[0] = 66'd2730; //0b101010101010
  assign tb_data_all[1] = 66'd4294967297; //0b100..1 (1 followed by 31 zeros and a 1)
  assign tb_data_all[2] = {33'd4294967299, 33'd0}; //0b100..11
  assign tb_data_all[3] = 66'd0;
  
  // Actual test bench process
  initial begin
    //Initialize all inputs
    #(0.1);
    tb_enable = 1;
    tb_data_in = tb_data_all[0];
    tb_test_num = 0;
    
    //Test 1:
    @(negedge tb_clk);
    tb_test_num += 1;
    @(posedge tb_clk);
    #(CHECK_DELAY);
    if (tb_flag == 0 && tb_golden_nonce == 0)
      $info("Test Case %0d:: PASSED", tb_test_num);
    else // Test case failed
      $error("Test Case: %0d:: FAILED", tb_test_num);
    #(CLK_PERIOD * 2.25);
    
    //Test 2:
    @(negedge tb_clk);
    tb_data_in = tb_data_all[1];
    tb_test_num += 1;
    @(posedge tb_clk);
    #(CHECK_DELAY);
    if (tb_flag == 1 && tb_golden_nonce == 1)
      $info("Test Case %0d:: PASSED", tb_test_num);
    else // Test case failed
      $error("Test Case: %0d:: FAILED", tb_test_num);
    #(CLK_PERIOD * 2.25);
    
    //Test 3:
    @(negedge tb_clk);
    tb_data_in = tb_data_all[2];
    tb_test_num += 1;
    @(posedge tb_clk);
    #(CHECK_DELAY);
    if (tb_flag == 2 && tb_golden_nonce == 3)
      $info("Test Case %0d:: PASSED", tb_test_num);
    else // Test case failed
      $error("Test Case: %0d:: FAILED", tb_test_num);
    #(CLK_PERIOD * 2.25);

    //Test 4:
    @(negedge tb_clk);
    tb_data_in = tb_data_all[3];
    tb_test_num += 1;
    @(posedge tb_clk);
    #(CHECK_DELAY);
    if (tb_flag == 0 && tb_golden_nonce == 0)
      $info("Test Case %0d:: PASSED", tb_test_num);
    else // Test case failed
      $error("Test Case: %0d:: FAILED", tb_test_num);
    #(CLK_PERIOD * 2.25);
        
  end
endmodule
