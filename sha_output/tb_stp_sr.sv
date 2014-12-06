// $Id: $
// File name:   tb_stp_sr.sv
// Created:     12/5/2014
// Author:      Shubham Agrawal
// Lab Section: 337-03
// Version:     1.0  Initial Design Entry
// Description: Test bench for n-word serial-to-parallel shift register
`timescale 1ns / 10ps

module tb_stp_sr ();
  // Define parameters
  localparam CLK_PERIOD = 2.5;
  localparam CHECK_DELAY = 1;
  
  // Shared Test Variables
  reg tb_clk;
  
  // Default Config Test Variables & constants
  localparam DEFAULT_SIZE = 8;
  localparam DEFAULT_MAX_BIT = (DEFAULT_SIZE - 1);
	
  integer tb_default_test_num;
  integer i, tb_default_i;
  integer tb_default_fail_cnt;
  reg tb_default_n_reset;
  reg [32*DEFAULT_SIZE - 1:0] tb_default_parallel_out;
  reg tb_default_shift_en;
  reg [31:0] tb_default_serial_in;
  reg [32*DEFAULT_SIZE - 1:0] tb_default_test_data;
  reg [32*DEFAULT_SIZE - 1:0] tb_default_expected_out;
  
  // DUT portmaps
  stp_sr DUT
  (
    .clk(tb_clk),
    .n_rst(tb_default_n_reset),
    .serial_in(tb_default_serial_in),
    .shift_enable(tb_default_shift_en),
    .parallel_out(tb_default_parallel_out)
  );
  
  // Clock generation block
  always begin
    tb_clk = 1'b0;
    #(CLK_PERIOD/2.0);
    tb_clk = 1'b1;
    #(CLK_PERIOD/2.0);
  end
  
  // Default Configuration Test bench main process
	initial begin
	  // Initialize all of the test inputs
    tb_default_n_reset		= 1'b1;		// Initialize to be inactive
    tb_default_shift_en		= 1'b0;		// Initialize to be inactive
    tb_default_serial_in	= 32'b0;	// Initialize to be idle
		tb_default_test_num 	= 0;
		for(tb_default_i = 0; tb_default_i < DEFAULT_SIZE; tb_default_i += 1)
		begin
			tb_default_test_data[tb_default_i] = 32'b0;
		end
		for(tb_default_i = 0; tb_default_i < DEFAULT_SIZE; tb_default_i += 1)
		begin
			tb_default_expected_out[tb_default_i] = 32'b0;
		end
		
		// Power-on Reset of the DUT
		#(0.1);
		tb_default_n_reset	= 1'b0; 	// Need to actually toggle this in order for it to actually run dependent always blocks
		#(CLK_PERIOD * 2.25);	// Release the reset away from a clock edge
		tb_default_n_reset	= 1'b1; 	// Deactivate the chip reset
		
		// Wait for a while to see normal operation
		#(CLK_PERIOD);
		
		// Test 1: Check for Proper Reset w/ Idle input
		@(negedge tb_clk); 
		tb_default_test_num = tb_default_test_num + 1;
		tb_default_n_reset = 1'b0;
		tb_default_shift_en = 1'b0;
    tb_default_serial_in = 32'b0;
		for(tb_default_i = 0; tb_default_i < DEFAULT_SIZE*32; tb_default_i += 1)
		begin
			tb_default_test_data[tb_default_i] = 1'b0;
		end
		for(tb_default_i = 0; tb_default_i < DEFAULT_SIZE*32; tb_default_i += 1)
		begin
			tb_default_expected_out[tb_default_i] = 1'b0;
		end
		#(CHECK_DELAY);
		if (tb_default_test_data == tb_default_parallel_out)
			$info("Default Case %0d:: PASSED", tb_default_test_num);
		else // Test case failed
			$error("Default Case %0d:: FAILED", tb_default_test_num);
		
		// Test 2: Check for Proper Reset w/ Active inputs
		@(negedge tb_clk); 
		tb_default_test_num = tb_default_test_num + 1;
		tb_default_n_reset = 1'b0;
		tb_default_shift_en = 1'b1;
    tb_default_serial_in = 32'hFFFFFFFF;
		for(tb_default_i = 0; tb_default_i < DEFAULT_SIZE*32; tb_default_i += 1)
		begin
			tb_default_test_data[tb_default_i] = 1'b0;
		end
		for(tb_default_i = 0; tb_default_i < DEFAULT_SIZE*32; tb_default_i += 1)
		begin
			tb_default_expected_out[tb_default_i] = 1'b0;
		end
		@(posedge tb_clk);
		@(posedge tb_clk);
		#(CHECK_DELAY);
		if (tb_default_test_data == tb_default_parallel_out)
			$info("Default Case %0d:: PASSED", tb_default_test_num);
		else // Test case failed
			$error("Default Case %0d:: FAILED", tb_default_test_num);
		
		// Test 3: Check for Proper Shift Enable Control w/ enable off
		// Power-on Reset of the DUT (Best case conditions)
		@(negedge tb_clk); 
		tb_default_test_num = tb_default_test_num + 1;
		tb_default_serial_in = 32'b0;
		tb_default_shift_en = 1'b0;
		tb_default_n_reset	= 1'b0; 	
		#(CLK_PERIOD * 2);
		@(negedge tb_clk);	// Release the reset away from a clock edge
		tb_default_n_reset	= 1'b1;	// Deactivate the chip reset
		// Perform test
		tb_default_serial_in = 32'hFFFFFFFF;
		tb_default_shift_en = 1'b0;
		for(tb_default_i = 0; tb_default_i < DEFAULT_SIZE*32; tb_default_i += 1)
		begin
			tb_default_test_data[tb_default_i] = 1'b0;
		end
		for(tb_default_i = 0; tb_default_i < DEFAULT_SIZE*32; tb_default_i += 1)
		begin
			tb_default_expected_out[tb_default_i] = 1'b0;
		end
		@(posedge tb_clk);
		#(CHECK_DELAY);
		if (tb_default_test_data == tb_default_parallel_out)
			$info("Default Case %0d:: PASSED", tb_default_test_num);
		else // Test case failed
			$error("Default Case %0d:: FAILED", tb_default_test_num);
		
		// Test 4: Check for Proper Shift Enable Control w/ enable on for one shift
		// Power-on Reset of the DUT (Best case conditions)
		@(negedge tb_clk); 
		tb_default_test_num = tb_default_test_num + 1;
		tb_default_serial_in = 32'b0;
		tb_default_shift_en = 1'b0;
		tb_default_n_reset	= 1'b0; 	
		#(CLK_PERIOD * 2);
		@(negedge tb_clk);	// Release the reset away from a clock edge
		tb_default_n_reset	= 1'b1;	// Deactivate the chip reset
		// Perform test
		tb_default_serial_in = 32'hFFFFFFFF;
		tb_default_shift_en = 1'b1;
		for(tb_default_i = 0; tb_default_i < DEFAULT_SIZE*32; tb_default_i += 1)
		begin
			if(DEFAULT_MAX_BIT == tb_default_i/32) // MSB -> Most significant bit is the fireset one sent
				tb_default_test_data[tb_default_i] = 1'b1;
			else
				tb_default_test_data[tb_default_i] = 1'b0;
		end
		for(tb_default_i = 0; tb_default_i < DEFAULT_SIZE*32; tb_default_i += 1)
		begin
			tb_default_expected_out[tb_default_i] = 1'b0;
		end
		@(posedge tb_clk);
		#(CHECK_DELAY);
		tb_default_expected_out = {tb_default_expected_out[(DEFAULT_MAX_BIT - 1):0], tb_default_serial_in}; // Shift test data
		if (tb_default_expected_out == tb_default_parallel_out)
			$info("Default Case %0d:: PASSED", tb_default_test_num);
		else // Test case failed
			$error("Default Case %0d:: FAILED", tb_default_test_num);
		
		// Test 5: Check for Proper Shift Enable Control w/ enable on for full value shift
		// Power-on Reset of the DUT (Best case conditions)
		@(negedge tb_clk); 
		tb_default_test_num = tb_default_test_num + 1;
		tb_default_serial_in = 32'b0;
		tb_default_shift_en = 1'b0;
		tb_default_n_reset	= 1'b0; 	
		#(CLK_PERIOD * 2);
		@(negedge tb_clk);	// Release the reset away from a clock edge
		tb_default_n_reset	= 1'b1;	// Deactivate the chip reset
		// Prep for shifting
		tb_default_shift_en = 1'b1;
		for(tb_default_i = 0; tb_default_i < DEFAULT_SIZE*32; tb_default_i += 1)
		begin
			tb_default_test_data[tb_default_i] = 1'b1;
		end
		for(tb_default_i = 0; tb_default_i < DEFAULT_SIZE*32; tb_default_i += 1)
		begin
			tb_default_expected_out[tb_default_i] = 1'b0;
		end
		// Shift through the full value and track failure(s)
		tb_default_fail_cnt = 0;
		for(tb_default_i = 0; tb_default_i < DEFAULT_SIZE*32; tb_default_i += 32)
		begin
			// Assign the new serial input value
      for (i = 0; i < 32; i += 1) begin
			  tb_default_serial_in[i] = tb_default_test_data[(DEFAULT_MAX_BIT - tb_default_i/32)*32 + i];
      end
			// Perform shift
			@(posedge tb_clk);
			#(CHECK_DELAY);
			// Updated expected output calculation
			tb_default_expected_out = {tb_default_expected_out[(DEFAULT_MAX_BIT)*32 - 1:0], tb_default_serial_in}; 
			// Compare expected output with actual and track failure(s)
			if (tb_default_expected_out != tb_default_parallel_out)
			begin
				// Current shift failed
				tb_default_fail_cnt = tb_default_fail_cnt + 1;
			end
		end
		// Check for failure(s)
		if(0 < tb_default_fail_cnt)
		begin
			// Test failed
			$error("Default Case %0d:: FAILED", tb_default_test_num);
		end
		else
		begin
			// Test passed
			$info("Default Case %0d:: PASSED", tb_default_test_num);
		end
		
		// Test 6: Check for Proper Shift Enable Control w/ enable on and mixed values
		// Power-on Reset of the DUT (Best case conditions)
		@(negedge tb_clk); 
		tb_default_test_num = tb_default_test_num + 1;
		tb_default_serial_in = 1'b1;
		tb_default_shift_en = 1'b0;
		tb_default_n_reset	= 1'b0; 	
		#(CLK_PERIOD * 2);
		@(negedge tb_clk);	// Release the reset away from a clock edge
		tb_default_n_reset	= 1'b1;	// Deactivate the chip reset
		// Prep for shifting
		tb_default_shift_en = 1'b1;
		for(tb_default_i = 0; tb_default_i < DEFAULT_SIZE; tb_default_i += 32) begin
			if(0 == (tb_default_i/32 % 2)) begin // Even bit
        for (i = 0; i < 32; i += 1) begin
				  tb_default_test_data[tb_default_i*32 + i] = 1'b0;
        end
      end
			else begin // Odd bit
        for (i = 0; i < 32; i += 1) begin
				  tb_default_test_data[tb_default_i*32 + i] = 1'b1;
        end
      end
		end
		for(tb_default_i = 0; tb_default_i < DEFAULT_SIZE*32; tb_default_i += 1)
	  begin
			tb_default_expected_out[tb_default_i] = 1'b0;
		end
		// Shift through the full value and track failure(s)
		tb_default_fail_cnt = 0;
		for(tb_default_i = 0; tb_default_i < DEFAULT_SIZE*32; tb_default_i += 32)
		begin
			// Assign the new serial input value
      for (i = 0; i < 32; i += 1) begin
			  tb_default_serial_in[i] = tb_default_test_data[(DEFAULT_MAX_BIT - tb_default_i/32)*32 + i];
      end
			// Perform shift
			@(posedge tb_clk);
			#(CHECK_DELAY);
			// Updated expected output calculation
			tb_default_expected_out = {tb_default_expected_out[(DEFAULT_MAX_BIT)*32 - 1:0], tb_default_serial_in}; 
			// Compare expected output with actual and track failure(s)
			if (tb_default_expected_out != tb_default_parallel_out)
			begin
				// Current shift failed
				tb_default_fail_cnt = tb_default_fail_cnt + 1;
			end
		end
		// Check for failure(s)
		if(0 < tb_default_fail_cnt)
		begin
			// Test failed
			$error("Default Case %0d:: FAILED", tb_default_test_num);
		end
		else
		begin
			// Test passed
			$info("Default Case %0d:: PASSED", tb_default_test_num);
		end
	end
endmodule
