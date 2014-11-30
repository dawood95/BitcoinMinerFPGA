// $Id: $
// File name:   tb_hash_checker.sv
// Created:     11/30/2014
// Author:      Shubham Agrawal
// Lab Section: 337-03
// Version:     1.0  Initial Design Entry
// Description: Test Bench for Hash Checker
`timescale 1ns / 10ps

module tb_hash_checker();
  //Define Parameters
  parameter CLK_PERIOD = 10;
  localparam CHECK_DELAY = 2.5;
  
  reg tb_clk;
  reg [5:0] tb_count;
  reg [31:0] tb_nonce, tb_data_in; //first 32 bits of hash
  reg [32:0] tb_flag_plus_nonce;
  
  integer tb_test_num;
  wire [31:0] tb_nonce_one, tb_nonce_two;
  
  hash_checker DUT (
    .clk(tb_clk),
    .count(tb_count),
    .nonce(tb_nonce),
    .data_in(tb_data_in),
    .flag_plus_nonce(tb_flag_plus_nonce)
  );
  
  always
	begin : CLK_GEN
		tb_clk = 1'b0;
		#(CLK_PERIOD / 2);
		tb_clk = 1'b1;
		#(CLK_PERIOD / 2);
	end
  
  assign tb_nonce_one = 32'd2730; //0b101010101010
  assign tb_nonce_two = 32'd4095; //0b111111111111
  
  // Actual test bench process
  initial begin
    //Initialize all inputs
    #(0.1);
    tb_count = 6'b0;
    tb_nonce = tb_nonce_one;
    tb_data_in = 32'd2000;
    tb_test_num = 0;
    
    //Test 1: Check for Proper Flag+Nonce with Count Zero and Hash not Zero
    @(negedge tb_clk);
    tb_test_num += 1;
    @(posedge tb_clk);
    #(CHECK_DELAY);
    if (tb_flag_plus_nonce[31:0] == tb_nonce_one && tb_flag_plus_nonce[32] == (tb_data_in == 0))
      $info("Test Case %0d:: PASSED", tb_test_num);
    else // Test case failed
      $error("Test Case: %0d:: FAILED", tb_test_num);
    #(CLK_PERIOD * 2.25);
    
    //Test 2: Check for Proper Flag+Nonce with Count not Zero and Nonce Changed
    @(negedge tb_clk);
    tb_count = 6'b1;
    tb_nonce = tb_nonce_two;
    tb_test_num += 1;
    @(posedge tb_clk);
    #(CHECK_DELAY);
    if (tb_flag_plus_nonce[31:0] == tb_nonce_one && tb_flag_plus_nonce[32] == (tb_data_in == 0))
      $info("Test Case %0d:: PASSED", tb_test_num);
    else // Test case failed
      $error("Test Case: %0d:: FAILED", tb_test_num);
    
    //Test 3: Check for Proper Flag+Nonce with Count Zero and Nonce unchanged
    @(negedge tb_clk);
    tb_count = 6'b0;
    tb_nonce = tb_nonce_two;
    tb_test_num += 1;
    @(posedge tb_clk);
    #(CHECK_DELAY);
    if (tb_flag_plus_nonce[31:0] == tb_nonce_two && tb_flag_plus_nonce[32] == (tb_data_in == 0))
      $info("Test Case %0d:: PASSED", tb_test_num);
    else // Test case failed
      $error("Test Case: %0d:: FAILED", tb_test_num);
    
    //Test 4: Check for Proper Flag+Nonce with Hash Zero
    @(negedge tb_clk);
    tb_data_in = 32'b0;
    tb_test_num += 1;
    @(posedge tb_clk);
    #(CHECK_DELAY);
    if (tb_flag_plus_nonce[31:0] == tb_nonce_two && tb_flag_plus_nonce[32] == (tb_data_in == 0))
      $info("Test Case %0d:: PASSED", tb_test_num);
    else // Test case failed
      $error("Test Case: %0d:: FAILED", tb_test_num);
  end
endmodule   
    
    
