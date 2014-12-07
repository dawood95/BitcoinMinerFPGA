`timescale 1ns / 10ps
module tb_timer_proj();
  
  reg tb_clk;
  reg [2:0] tb_controller_state;
  reg tb_midstate_shifts_done;
  reg tb_remaining_shifts_done;
  integer tb_test_num;
  localparam CLK_PERIOD = 10; 
  localparam CHECK_DELAY = 2.5; 
  
  timer_proj TIM
  (
    .clk(tb_clk),
    .controller_state(tb_controller_state),
    .midstate_shifts_done(tb_midstate_shifts_done),
    .remaining_shifts_done(tb_remaining_shifts_done)
  );
  
  // Clock generation block
  always
  begin
		tb_clk = 1'b0   ;
		#(CLK_PERIOD/2.0);
		tb_clk = 1'b1;
		#(CLK_PERIOD/2.0);
  end
	
  initial begin
    // Initilize all inputs
    tb_test_num = 0;
    #(0.1);
    tb_controller_state = 3'b000; 	
	//#(CLK_PERIOD * 2.25);	// Release the reset away from a clock edge
    #(CHECK_DELAY);
	  tb_controller_state = 3'b100; 	
    
    // Wait for a while 
    #(CHECK_DELAY);
      
    // Test 1
	@(negedge tb_clk);
	tb_test_num += 1;
	@(posedge tb_clk);
	#(CLK_PERIOD * 8.25);
	if ((tb_midstate_shifts_done == 0) && (tb_remaining_shifts_done == 0)) begin
      $info("Test Case %0d:: PASSED", tb_test_num);
      $info("Midstate shifts done val: %0b", tb_midstate_shifts_done);
      $info("Remaining shifts done val: %0b", tb_remaining_shifts_done);
      tb_controller_state = 3'b000; //reset the counter
    end
    else begin// Test case failed
      $error("Test Case: %0d:: FAILED", tb_test_num);
      $info("Midstate shifts done val: %0b", tb_midstate_shifts_done);
      $info("Remaining shifts done val: %0b", tb_remaining_shifts_done);
    end
 // #(CLK_PERIOD * 2.25);
  
  
    
    // Test 2
    //#(0.1);
    //tb_controller_state = 3'b000; 	
	//#(CLK_PERIOD * 2.25);	// Release the reset away from a clock edge
	  #(CLK_PERIOD * 2);
	//tb_controller_state = 3'b100;
     
	@(negedge tb_clk);
	tb_test_num += 1;
	@(posedge tb_clk);
	tb_controller_state = 3'b001; //now the counter will be enabled
	#(CLK_PERIOD * 8.25);
	if ((tb_midstate_shifts_done == 1) && (tb_remaining_shifts_done == 0)) begin
      $info("Test Case %0d:: PASSED", tb_test_num);
      $info("Midstate shifts done val: %0b", tb_midstate_shifts_done);
      $info("Remaining shifts done val: %0b", tb_remaining_shifts_done);
      tb_controller_state = 3'b101; //disable the counter
      end
    else begin// Test case failed
      $error("Test Case: %0d:: FAILED", tb_test_num);
      $info("Midstate shifts done val: %0b", tb_midstate_shifts_done);
      $info("Remaining shifts done val: %0b", tb_remaining_shifts_done);
      end
  //#(CLK_PERIOD * 2.25);
  
  // Test 3
  //#(0.1);
    //tb_controller_state = 3'b000; 	
	#(CLK_PERIOD * 3);	// Just a delay
    //#(CHECK_DELAY);
	//tb_controller_state = 3'b100;
    
	@(negedge tb_clk);
	tb_test_num += 1;
	@(posedge tb_clk);
	tb_controller_state = 3'b010;
	#(CLK_PERIOD * 16.25);
	if ((tb_midstate_shifts_done == 0) && (tb_remaining_shifts_done == 1)) begin
      $info("Test Case %0d:: PASSED", tb_test_num);
      $info("Midstate shifts done val: %0b", tb_midstate_shifts_done);
      $info("Remaining shifts done val: %0b", tb_remaining_shifts_done);
      tb_controller_state = 3'b100; //disable the counter again
      end
    else begin// Test case failed
      $error("Test Case: %0d:: FAILED", tb_test_num);
      $info("Midstate shifts done val: %0b", tb_midstate_shifts_done);
      $info("Remaining shifts done val: %0b", tb_remaining_shifts_done);
      end
  #(CLK_PERIOD * 2.25);
  end
endmodule
