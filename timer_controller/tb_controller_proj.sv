`timescale 1ns / 10ps
module tb_controller_proj();
  reg tb_clk;
  reg tb_start_found;
  reg tb_midstate_shifts_done;
  reg tb_remaining_shifts_done;
  reg tb_sol_claim;
  reg [1:0] tb_sol_response;
  reg [2:0] tb_state;
  integer tb_test_num;
  localparam CLK_PERIOD = 10; 
  localparam CHECK_DELAY = 2.5;
  controller_proj CONTROLLER
  (
    .clk(tb_clk),
    .start_found(tb_start_found),
    .midstate_shifts_done(tb_midstate_shifts_done),
    .remaining_shifts_done(tb_remaining_shifts_done),
    .sol_claim(tb_sol_claim),
    .sol_response(tb_sol_response),
    .state(tb_state)
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
    tb_start_found = 1'b0;
    tb_midstate_shifts_done = 1'b0;
    tb_remaining_shifts_done = 1'b0;
    tb_sol_claim = 1'b0;
    tb_sol_response = 2'b00;
    
    #(CLK_PERIOD * 2);//wait for a while
    //Test 1: check if the controller is in IDLE state
    @(negedge tb_clk);
	  tb_test_num += 1;
	  @(posedge tb_clk);
	  #(CLK_PERIOD * 0.25);
	  if (tb_state == 3'b000) begin
	    $info("Test Case %0d:: PASSED", tb_test_num);
	    $info("IDLE state.");
	    $info("%0b",tb_state[2]);
	    $info("%0b",tb_state[1]);
	    $info("%0b",tb_state[0]);
	    end
	    else begin
	      $info("Test Case %0d:: FAILED", tb_test_num);
	      $info("%0b",tb_state[2]);
	    $info("%0b",tb_state[1]);
	    $info("%0b",tb_state[0]);
	      end
	   #(CLK_PERIOD * 2); 
	   //Test 2: check if the controller is in IDLE state
    @(negedge tb_clk);
	  tb_test_num += 1;
	  tb_midstate_shifts_done = 1'b1;
	  @(posedge tb_clk);
	  #(CLK_PERIOD * 0.25);
	  if (tb_state == 3'b000) begin
	    $info("Test Case %0d:: PASSED", tb_test_num);
	    $info("%0b",tb_state[2]);
	    $info("%0b",tb_state[1]);
	    $info("%0b",tb_state[0]);
	    end
	    else begin
	      $info("Test Case %0d:: FAILED", tb_test_num);
	      $info("%0b",tb_state[2]);
	    $info("%0b",tb_state[1]);
	    $info("%0b",tb_state[0]);
	      end
	  //Test 3: check if the controller is in IDLE state
    @(negedge tb_clk);
	  tb_test_num += 1;
	  tb_remaining_shifts_done = 1'b1;
	  @(posedge tb_clk);
	  #(CLK_PERIOD * 0.25);
	  if (tb_state == 3'b000) begin
	    $info("Test Case %0d:: PASSED", tb_test_num);
	    $info("IDLE state.");
	    $info("%0b",tb_state[2]);
	    $info("%0b",tb_state[1]);
	    $info("%0b",tb_state[0]);
	    end
	    else begin
	      $info("Test Case %0d:: FAILED", tb_test_num);
	      $info("%0b",tb_state[2]);
	    $info("%0b",tb_state[1]);
	    $info("%0b",tb_state[0]);
	      end  
	  //Test 4: check if the controller is in IDLE state
    @(negedge tb_clk);
	  tb_test_num += 1;
	  tb_sol_claim = 1'b1;
	  @(posedge tb_clk);
	  #(CLK_PERIOD * 0.25);
	  if (tb_state == 3'b000) begin
	    $info("Test Case %0d:: PASSED", tb_test_num);
	    $info("IDLE state.");
	    $info("%0b",tb_state[2]);
	    $info("%0b",tb_state[1]);
	    $info("%0b",tb_state[0]);
	    end
	    else begin
	      $info("Test Case %0d:: FAILED", tb_test_num);
	      $info("%0b",tb_state[2]);
	    $info("%0b",tb_state[1]);
	    $info("%0b",tb_state[0]);
	      end    
	  //Test 5: check if the controller is in IDLE state
    @(negedge tb_clk);
	  tb_test_num += 1;
	  tb_sol_response = 2'b00;
	  @(posedge tb_clk);
	 #(CLK_PERIOD * 0.25);
	  if (tb_state == 3'b000) begin
	    $info("Test Case %0d:: PASSED", tb_test_num);
	    $info("IDLE state.");
	    $info("%0b",tb_state[2]);
	    $info("%0b",tb_state[1]);
	    $info("%0b",tb_state[0]);
	    end
	    else begin
	      $info("Test Case %0d:: FAILED", tb_test_num);
	      $info("%0b",tb_state[2]);
	    $info("%0b",tb_state[1]);
	    $info("%0b",tb_state[0]);
	      end
	  //Test 6: check if the controller is in IDLE state    
	   @(negedge tb_clk);
	  tb_test_num += 1;
	  tb_sol_response = 2'b01;
	  @(posedge tb_clk);
	  #(CLK_PERIOD * 0.25);
	  if (tb_state == 3'b000) begin
	    $info("Test Case %0d:: PASSED", tb_test_num);
	    $info("IDLE state.");
	    $info("%0b",tb_state[2]);
	    $info("%0b",tb_state[1]);
	    $info("%0b",tb_state[0]);
	    end
	    else begin
	      $info("Test Case %0d:: FAILED", tb_test_num);
	      $info("%0b",tb_state[2]);
	    $info("%0b",tb_state[1]);
	    $info("%0b",tb_state[0]);
	      end
	      
	  //Test 7: check if the controller is in IDLE state    
	   @(negedge tb_clk);
	  tb_test_num += 1;
	  tb_sol_response = 2'b10;
	  @(posedge tb_clk);
	  #(CLK_PERIOD * 0.25);
	  if (tb_state == 3'b000) begin
	    $info("Test Case %0d:: PASSED", tb_test_num);
	    $info("IDLE state.");
	    $info("%0b",tb_state[2]);
	    $info("%0b",tb_state[1]);
	    $info("%0b",tb_state[0]);
	    end
	    else begin
	      $info("Test Case %0d:: FAILED", tb_test_num);
	      $info("%0b",tb_state[2]);
	    $info("%0b",tb_state[1]);
	    $info("%0b",tb_state[0]);
	      end
	    
	    //Test 8: check if the controller is in IDLE state    
	   @(negedge tb_clk);
	  tb_test_num += 1;
	  tb_sol_response = 2'b11;
	  @(posedge tb_clk);
	  #(CLK_PERIOD * 0.25);
	  if (tb_state == 3'b000) begin
	    $info("Test Case %0d:: PASSED", tb_test_num);
	    $info("IDLE state.");
	    $info("%0b",tb_state[2]);
	    $info("%0b",tb_state[1]);
	    $info("%0b",tb_state[0]);
	    end
	    else begin
	      $info("Test Case %0d:: FAILED", tb_test_num);
	      $info("%0b",tb_state[2]);
	    $info("%0b",tb_state[1]);
	    $info("%0b",tb_state[0]);
	      end 
	      
	   //Test 9: check if the controller goes to LMS state    
	   @(negedge tb_clk);
	  tb_test_num += 1;
	  tb_start_found = 1'b1;
	  @(posedge tb_clk);
	  #(CLK_PERIOD * 0.25);
	  if (tb_state == 3'b001) begin
	    $info("Test Case %0d:: PASSED", tb_test_num);
	    $info("LMS state.");
	    $info("%0b",tb_state[2]);
	    $info("%0b",tb_state[1]);
	    $info("%0b",tb_state[0]);
	    end
	    else begin
	      $info("Test Case %0d:: FAILED", tb_test_num);
	      $info("%0b",tb_state[2]);
	    $info("%0b",tb_state[1]);
	    $info("%0b",tb_state[0]);
	      end
	  #(CLK_PERIOD / 4);
	  //reinitialize all inputs to 0  
	  tb_start_found = 1'b0;  
	  tb_midstate_shifts_done = 1'b0;
    tb_remaining_shifts_done = 1'b0;
    tb_sol_claim = 1'b0;
    tb_sol_response = 2'b00;  
	      
	   //Test 10: check if the controller is in LMS state
    @(negedge tb_clk);
	  tb_test_num += 1;
	  @(posedge tb_clk);
	  #(CLK_PERIOD * 0.25);
	  if (tb_state == 3'b001) begin
	    $info("Test Case %0d:: PASSED", tb_test_num);
	    $info("LMS state.");
	    $info("%0b",tb_state[2]);
	    $info("%0b",tb_state[1]);
	    $info("%0b",tb_state[0]);
	    end
	    else begin
	      $info("Test Case %0d:: FAILED", tb_test_num);
	      $info("%0b",tb_state[2]);
	    $info("%0b",tb_state[1]);
	    $info("%0b",tb_state[0]);
	      end
	   #(CLK_PERIOD * 2); 
	   //Test 11: check if the controller is in LMS state
    @(negedge tb_clk);
	  tb_test_num += 1;
	  tb_start_found = 1'b1;
	  @(posedge tb_clk);
	  #(CLK_PERIOD * 0.25);
	  if (tb_state == 3'b001) begin
	    $info("Test Case %0d:: PASSED", tb_test_num);
	    $info("LMS state.");
	    $info("%0b",tb_state[2]);
	    $info("%0b",tb_state[1]);
	    $info("%0b",tb_state[0]);
	    end
	    else begin
	      $info("Test Case %0d:: FAILED", tb_test_num);
	      $info("%0b",tb_state[2]);
	    $info("%0b",tb_state[1]);
	    $info("%0b",tb_state[0]);
	      end
	   #(CLK_PERIOD * 2); 
	   
	  //Test 12: check if the controller is in LMS state
    @(negedge tb_clk);
	  tb_test_num += 1;
	  tb_remaining_shifts_done = 1'b1;
	  @(posedge tb_clk);
	  #(CLK_PERIOD * 0.25);
	  if (tb_state == 3'b001) begin
	    $info("Test Case %0d:: PASSED", tb_test_num);
	    $info("LMS state.");
	    $info("%0b",tb_state[2]);
	    $info("%0b",tb_state[1]);
	    $info("%0b",tb_state[0]);
	    end
	    else begin
	      $info("Test Case %0d:: FAILED", tb_test_num);
	      $info("%0b",tb_state[2]);
	    $info("%0b",tb_state[1]);
	    $info("%0b",tb_state[0]);
	      end  
	  //Test 13: check if the controller is in LMS state
    @(negedge tb_clk);
	  tb_test_num += 1;
	  tb_sol_claim = 1'b1;
	  @(posedge tb_clk);
	  #(CLK_PERIOD * 0.25);
	  if (tb_state == 3'b001) begin
	    $info("Test Case %0d:: PASSED", tb_test_num);
	    $info("LMS state.");
	    $info("%0b",tb_state[2]);
	    $info("%0b",tb_state[1]);
	    $info("%0b",tb_state[0]);
	    end
	    else begin
	      $info("Test Case %0d:: FAILED", tb_test_num);
	      $info("%0b",tb_state[2]);
	    $info("%0b",tb_state[1]);
	    $info("%0b",tb_state[0]);
	      end    
	  //Test 14: check if the controller is in LMS state
    @(negedge tb_clk);
	  tb_test_num += 1;
	  tb_sol_response = 2'b00;
	  @(posedge tb_clk);
	  #(CLK_PERIOD * 0.25);
	  if (tb_state == 3'b001) begin
	    $info("Test Case %0d:: PASSED", tb_test_num);
	    $info("LMS state.");
	    $info("%0b",tb_state[2]);
	    $info("%0b",tb_state[1]);
	    $info("%0b",tb_state[0]);
	    end
	    else begin
	      $info("Test Case %0d:: FAILED", tb_test_num);
	      $info("%0b",tb_state[2]);
	    $info("%0b",tb_state[1]);
	    $info("%0b",tb_state[0]);
	      end
	  //Test 15: check if the controller is in LMS state    
	   @(negedge tb_clk);
	  tb_test_num += 1;
	  tb_sol_response = 2'b01;
	  @(posedge tb_clk);
	  #(CLK_PERIOD * 0.25);
	  if (tb_state == 3'b001) begin
	    $info("Test Case %0d:: PASSED", tb_test_num);
	    $info("LMS state.");
	    $info("%0b",tb_state[2]);
	    $info("%0b",tb_state[1]);
	    $info("%0b",tb_state[0]);
	    end
	    else begin
	      $info("Test Case %0d:: FAILED", tb_test_num);
	      $info("%0b",tb_state[2]);
	    $info("%0b",tb_state[1]);
	    $info("%0b",tb_state[0]);
	      end
	      
	  //Test 16: check if the controller is in LMS state    
	   @(negedge tb_clk);
	  tb_test_num += 1;
	  tb_sol_response = 2'b10;
	  @(posedge tb_clk);
	  #(CLK_PERIOD * 0.25);
	  if (tb_state == 3'b001) begin
	    $info("Test Case %0d:: PASSED", tb_test_num);
	    $info("LMS state.");
	    $info("%0b",tb_state[2]);
	    $info("%0b",tb_state[1]);
	    $info("%0b",tb_state[0]);
	    end
	    else begin
	      $info("Test Case %0d:: FAILED", tb_test_num);
	      $info("%0b",tb_state[2]);
	    $info("%0b",tb_state[1]);
	    $info("%0b",tb_state[0]);
	      end
	      
	      
	   //Test 17: check if the controller is in LMS state    
	   @(negedge tb_clk);
	  tb_test_num += 1;
	  tb_sol_response = 2'b11;
	  @(posedge tb_clk);
	  #(CLK_PERIOD * 0.25);
	  if (tb_state == 3'b001) begin
	    $info("Test Case %0d:: PASSED", tb_test_num);
	    $info("LMS state.");
	    $info("%0b",tb_state[2]);
	    $info("%0b",tb_state[1]);
	    $info("%0b",tb_state[0]);
	    end
	    else begin
	      $info("Test Case %0d:: FAILED", tb_test_num);
	      $info("%0b",tb_state[2]);
	    $info("%0b",tb_state[1]);
	    $info("%0b",tb_state[0]);
	      end
	      
	      
	  //Test 18: check if the controller goes to LRH state    
	   @(negedge tb_clk);
	  tb_test_num += 1;
	  tb_midstate_shifts_done = 1'b1;
	  @(posedge tb_clk);
	  #(CLK_PERIOD * 0.25);
	  if (tb_state == 3'b010) begin
	    $info("Test Case %0d:: PASSED", tb_test_num);
	    $info("LRH state.");
	    $info("%0b",tb_state[2]);
	    $info("%0b",tb_state[1]);
	    $info("%0b",tb_state[0]);
	    end
	    else begin
	      $info("Test Case %0d:: FAILED", tb_test_num);
	      $info("%0b",tb_state[2]);
	    $info("%0b",tb_state[1]);
	    $info("%0b",tb_state[0]);
	      end
	  #(CLK_PERIOD / 4);
	  //reinitialize all inputs to 0  
	  tb_start_found = 1'b0;  
	  tb_midstate_shifts_done = 1'b0;
    tb_remaining_shifts_done = 1'b0;
    tb_sol_claim = 1'b0;
    tb_sol_response = 2'b00;  
	      
	   //Test 19: check if the controller is in LRH state
    @(negedge tb_clk);
	  tb_test_num += 1;
	  @(posedge tb_clk);
	  #(CLK_PERIOD * 0.25);
	  if (tb_state == 3'b010) begin
	    $info("Test Case %0d:: PASSED", tb_test_num);
	    $info("LMS state.");
	    $info("%0b",tb_state[2]);
	    $info("%0b",tb_state[1]);
	    $info("%0b",tb_state[0]);
	    end
	    else begin
	      $info("Test Case %0d:: FAILED", tb_test_num);
	      $info("%0b",tb_state[2]);
	    $info("%0b",tb_state[1]);
	    $info("%0b",tb_state[0]);
	      end
	   #(CLK_PERIOD * 2); 
	   //Test 20: check if the controller is in LRH state
    @(negedge tb_clk);
	  tb_test_num += 1;
	  tb_start_found = 1'b1;
	  @(posedge tb_clk);
	  #(CLK_PERIOD * 0.25);
	  if (tb_state == 3'b010) begin
	    $info("Test Case %0d:: PASSED", tb_test_num);
	    $info("LRH state.");
	    $info("%0b",tb_state[2]);
	    $info("%0b",tb_state[1]);
	    $info("%0b",tb_state[0]);
	    end
	    else begin
	      $info("Test Case %0d:: FAILED", tb_test_num);
	      $info("%0b",tb_state[2]);
	    $info("%0b",tb_state[1]);
	    $info("%0b",tb_state[0]);
	      end
	   #(CLK_PERIOD * 2); 
	   
	  //Test 21: check if the controller is in LRH state
    @(negedge tb_clk);
	  tb_test_num += 1;
	  tb_midstate_shifts_done = 1'b1;
	  @(posedge tb_clk);
	  #(CLK_PERIOD * 0.25);
	  if (tb_state == 3'b010) begin
	    $info("Test Case %0d:: PASSED", tb_test_num);
	    $info("LRH state.");
	    $info("%0b",tb_state[2]);
	    $info("%0b",tb_state[1]);
	    $info("%0b",tb_state[0]);
	    end
	    else begin
	      $info("Test Case %0d:: FAILED", tb_test_num);
	      $info("%0b",tb_state[2]);
	    $info("%0b",tb_state[1]);
	    $info("%0b",tb_state[0]);
	      end  
	  //Test 22: check if the controller is in LRH state
    @(negedge tb_clk);
	  tb_test_num += 1;
	  tb_sol_claim = 1'b1;
	  @(posedge tb_clk);
	  #(CLK_PERIOD * 0.25);
	  if (tb_state == 3'b010) begin
	    $info("Test Case %0d:: PASSED", tb_test_num);
	    $info("LRH state.");
	    $info("%0b",tb_state[2]);
	    $info("%0b",tb_state[1]);
	    $info("%0b",tb_state[0]);
	    end
	    else begin
	      $info("Test Case %0d:: FAILED", tb_test_num);
	      $info("%0b",tb_state[2]);
	    $info("%0b",tb_state[1]);
	    $info("%0b",tb_state[0]);
	      end    
	  //Test 23: check if the controller is in LRH state
    @(negedge tb_clk);
	  tb_test_num += 1;
	  tb_sol_response = 2'b00;
	  @(posedge tb_clk);
	  #(CLK_PERIOD * 0.25);
	  if (tb_state == 3'b010) begin
	    $info("Test Case %0d:: PASSED", tb_test_num);
	    $info("LRH state.");
	    $info("%0b",tb_state[2]);
	    $info("%0b",tb_state[1]);
	    $info("%0b",tb_state[0]);
	    end
	    else begin
	      $info("Test Case %0d:: FAILED", tb_test_num);
	      $info("%0b",tb_state[2]);
	    $info("%0b",tb_state[1]);
	    $info("%0b",tb_state[0]);
	      end
	  //Test 24: check if the controller is in LRH state    
	   @(negedge tb_clk);
	  tb_test_num += 1;
	  tb_sol_response = 2'b01;
	  @(posedge tb_clk);
	  #(CLK_PERIOD * 0.25);
	  if (tb_state == 3'b010) begin
	    $info("Test Case %0d:: PASSED", tb_test_num);
	    $info("LRH state.");
	    $info("%0b",tb_state[2]);
	    $info("%0b",tb_state[1]);
	    $info("%0b",tb_state[0]);
	    end
	    else begin
	      $info("Test Case %0d:: FAILED", tb_test_num);
	      $info("%0b",tb_state[2]);
	    $info("%0b",tb_state[1]);
	    $info("%0b",tb_state[0]);
	      end
	      
	  //Test 25: check if the controller is in LRH state    
	   @(negedge tb_clk);
	  tb_test_num += 1;
	  tb_sol_response = 3'b010;
	  @(posedge tb_clk);
	  #(CLK_PERIOD * 0.25);
	  if (tb_state == 3'b010) begin
	    $info("Test Case %0d:: PASSED", tb_test_num);
	    $info("LRH state.");
	    $info("%0b",tb_state[2]);
	    $info("%0b",tb_state[1]);
	    $info("%0b",tb_state[0]);
	    end
	    else begin
	      $info("Test Case %0d:: FAILED", tb_test_num);
	      $info("%0b",tb_state[2]);
	    $info("%0b",tb_state[1]);
	    $info("%0b",tb_state[0]);
	      end
	      
	      
	   //Test 26: check if the controller is in LRH state    
	   @(negedge tb_clk);
	  tb_test_num += 1;
	  tb_sol_response = 2'b11;
	  @(posedge tb_clk);
	  #(CLK_PERIOD * 0.25);
	  if (tb_state == 3'b010) begin
	    $info("Test Case %0d:: PASSED", tb_test_num);
	    $info("LRH state.");
	    $info("%0b",tb_state[2]);
	    $info("%0b",tb_state[1]);
	    $info("%0b",tb_state[0]);
	    end
	    else begin
	      $info("Test Case %0d:: FAILED", tb_test_num);
	      $info("%0b",tb_state[2]);
	    $info("%0b",tb_state[1]);
	    $info("%0b",tb_state[0]);
	      end    
	      
	  
	  //Test 27: check if the controller goes to SOLVE state    
	   @(negedge tb_clk);
	  tb_test_num += 1;
	  tb_remaining_shifts_done = 1'b1;
	  @(posedge tb_clk);
	  #(CLK_PERIOD * 0.25);
	  if (tb_state == 3'b011) begin
	    $info("Test Case %0d:: PASSED", tb_test_num);
	    $info("SOLVE state.");
	    $info("%0b",tb_state[2]);
	    $info("%0b",tb_state[1]);
	    $info("%0b",tb_state[0]);
	    end
	    else begin
	      $info("Test Case %0d:: FAILED", tb_test_num);
	      $info("%0b",tb_state[2]);
	    $info("%0b",tb_state[1]);
	    $info("%0b",tb_state[0]);
	      end
	  #(CLK_PERIOD / 4);
	  //reinitialize all inputs to 0  
	  tb_start_found = 1'b0;  
	  tb_midstate_shifts_done = 1'b0;
    tb_remaining_shifts_done = 1'b0;
    tb_sol_claim = 1'b0;
    tb_sol_response = 2'b00;  
	      
	   //Test 28: check if the controller is in SOLVE state
    @(negedge tb_clk);
	  tb_test_num += 1;
	  @(posedge tb_clk);
	  #(CLK_PERIOD * 0.25);
	  if (tb_state == 3'b011) begin
	    $info("Test Case %0d:: PASSED", tb_test_num);
	    $info("SOLVE state.");
	    $info("%0b",tb_state[2]);
	    $info("%0b",tb_state[1]);
	    $info("%0b",tb_state[0]);
	    end
	    else begin
	      $info("Test Case %0d:: FAILED", tb_test_num);
	      $info("%0b",tb_state[2]);
	    $info("%0b",tb_state[1]);
	    $info("%0b",tb_state[0]);
	      end
	   #(CLK_PERIOD * 2); 
	   //Test 29: check if the controller is in SOLVE state
    @(negedge tb_clk);
	  tb_test_num += 1;
	  tb_start_found = 1'b1;
	  @(posedge tb_clk);
	  #(CLK_PERIOD * 0.25);
	  if (tb_state == 3'b011) begin
	    $info("Test Case %0d:: PASSED", tb_test_num);
	    $info("SOLVE state.");
	    $info("%0b",tb_state[2]);
	    $info("%0b",tb_state[1]);
	    $info("%0b",tb_state[0]);
	    end
	    else begin
	      $info("Test Case %0d:: FAILED", tb_test_num);
	      $info("%0b",tb_state[2]);
	    $info("%0b",tb_state[1]);
	    $info("%0b",tb_state[0]);
	      end
	   #(CLK_PERIOD * 2); 
	   
	  //Test 30: check if the controller is in SOLVE state
    @(negedge tb_clk);
	  tb_test_num += 1;
	  tb_midstate_shifts_done = 1'b1;
	  @(posedge tb_clk);
	  #(CLK_PERIOD * 0.25);
	  if (tb_state == 3'b011) begin
	    $info("Test Case %0d:: PASSED", tb_test_num);
	    $info("SOLVE state.");
	    $info("%0b",tb_state[2]);
	    $info("%0b",tb_state[1]);
	    $info("%0b",tb_state[0]);
	    end
	    else begin
	      $info("Test Case %0d:: FAILED", tb_test_num);
	      $info("%0b",tb_state[2]);
	    $info("%0b",tb_state[1]);
	    $info("%0b",tb_state[0]);
	      end  
	  //Test 31: check if the controller is in SOLVE state
    @(negedge tb_clk);
	  tb_test_num += 1;
	  tb_remaining_shifts_done = 1'b1;
	  @(posedge tb_clk);
	  #(CLK_PERIOD * 0.25);
	  if (tb_state == 3'b011) begin
	    $info("Test Case %0d:: PASSED", tb_test_num);
	    $info("SOLVE state.");
	    $info("%0b",tb_state[2]);
	    $info("%0b",tb_state[1]);
	    $info("%0b",tb_state[0]);
	    end
	    else begin
	      $info("Test Case %0d:: FAILED", tb_test_num);
	      $info("%0b",tb_state[2]);
	    $info("%0b",tb_state[1]);
	    $info("%0b",tb_state[0]);
	      end    
	  //Test 32: check if the controller is in SOLVE state
    @(negedge tb_clk);
	  tb_test_num += 1;
	  tb_sol_response = 2'b00;
	  @(posedge tb_clk);
	  #(CLK_PERIOD * 0.25);
	  if (tb_state == 3'b011) begin
	    $info("Test Case %0d:: PASSED", tb_test_num);
	    $info("SOLVE state.");
	    $info("%0b",tb_state[2]);
	    $info("%0b",tb_state[1]);
	    $info("%0b",tb_state[0]);
	    end
	    else begin
	      $info("Test Case %0d:: FAILED", tb_test_num);
	      $info("%0b",tb_state[2]);
	    $info("%0b",tb_state[1]);
	    $info("%0b",tb_state[0]);
	      end
	  //Test 33: check if the controller is in SOLVE state    
	   @(negedge tb_clk);
	  tb_test_num += 1;
	  tb_sol_response = 2'b01;
	  @(posedge tb_clk);
	  #(CLK_PERIOD * 0.25);
	  if (tb_state == 3'b011) begin
	    $info("Test Case %0d:: PASSED", tb_test_num);
	    $info("SOLVE state.");
	    $info("%0b",tb_state[2]);
	    $info("%0b",tb_state[1]);
	    $info("%0b",tb_state[0]);
	    end
	    else begin
	      $info("Test Case %0d:: FAILED", tb_test_num);
	      $info("%0b",tb_state[2]);
	    $info("%0b",tb_state[1]);
	    $info("%0b",tb_state[0]);
	      end
	      
	  //Test 34: check if the controller is in SOLVE state    
	   @(negedge tb_clk);
	  tb_test_num += 1;
	  tb_sol_response = 3'b011;
	  @(posedge tb_clk);
	  #(CLK_PERIOD * 0.25);
	  if (tb_state == 3'b011) begin
	    $info("Test Case %0d:: PASSED", tb_test_num);
	    $info("SOLVE state.");
	    $info("%0b",tb_state[2]);
	    $info("%0b",tb_state[1]);
	    $info("%0b",tb_state[0]);
	    end
	    else begin
	      $info("Test Case %0d:: FAILED", tb_test_num);
	      $info("%0b",tb_state[2]);
	    $info("%0b",tb_state[1]);
	    $info("%0b",tb_state[0]);
	      end
	      
	      
	   //Test 35: check if the controller is in SOLVE state    
	   @(negedge tb_clk);
	  tb_test_num += 1;
	  tb_sol_response = 2'b11;
	  @(posedge tb_clk);
	  #(CLK_PERIOD * 0.25);
	  if (tb_state == 3'b011) begin
	    $info("Test Case %0d:: PASSED", tb_test_num);
	    $info("SOLVE state.");
	    $info("%0b",tb_state[2]);
	    $info("%0b",tb_state[1]);
	    $info("%0b",tb_state[0]);
	    end
	    else begin
	      $info("Test Case %0d:: FAILED", tb_test_num);
	      $info("%0b",tb_state[2]);
	    $info("%0b",tb_state[1]);
	    $info("%0b",tb_state[0]);
	      end
	
	  
	  //Test 36: check if the controller goes to HALT state    
	   @(negedge tb_clk);
	  tb_test_num += 1;
	  tb_sol_claim = 1'b1;
	  @(posedge tb_clk);
	  #(CLK_PERIOD * 0.25);
	  if (tb_state == 3'b100) begin
	    $info("Test Case %0d:: PASSED", tb_test_num);
	    $info("HALT state.");
	    $info("%0b",tb_state[2]);
	    $info("%0b",tb_state[1]);
	    $info("%0b",tb_state[0]);
	    end
	    else begin
	      $info("Test Case %0d:: FAILED", tb_test_num);
	      $info("%0b",tb_state[2]);
	    $info("%0b",tb_state[1]);
	    $info("%0b",tb_state[0]);
	      end
	  #(CLK_PERIOD / 4);
	  //reinitialize all inputs to 0  
	  
	  tb_start_found = 1'b0;  
	  tb_midstate_shifts_done = 1'b0;
    tb_remaining_shifts_done = 1'b0;
    tb_sol_claim = 1'b0;
    tb_sol_response = 2'b00;  
	      
	  //Test 37: check if the controller remains in HALT state    
	   @(negedge tb_clk);
	  tb_test_num += 1;
	  //tb_sol_claim = 1'b1;
	  @(posedge tb_clk);
	  #(CLK_PERIOD * 0.25);
	  if (tb_state == 3'b100) begin
	    $info("Test Case %0d:: PASSED", tb_test_num);
	    $info("HALT state.");
	    $info("%0b",tb_state[2]);
	    $info("%0b",tb_state[1]);
	    $info("%0b",tb_state[0]);
	    end
	    else begin
	      $info("Test Case %0d:: FAILED", tb_test_num);
	      $info("%0b",tb_state[2]);
	    $info("%0b",tb_state[1]);
	    $info("%0b",tb_state[0]);
	      end
	      
	  //Test 38: check if the controller remains in HALT state    
	   @(negedge tb_clk);
	  tb_test_num += 1;
	  tb_sol_claim = 1'b1;
	  tb_start_found = 1'b1;
	  tb_remaining_shifts_done = 1'b1;
	  tb_midstate_shifts_done = 1'b1;
	  @(posedge tb_clk);
	  #(CLK_PERIOD * 0.25);
	  if (tb_state == 3'b100) begin
	    $info("Test Case %0d:: PASSED", tb_test_num);
	    $info("HALT state.");
	    $info("%0b",tb_state[2]);
	    $info("%0b",tb_state[1]);
	    $info("%0b",tb_state[0]);
	    end
	    else begin
	      $info("Test Case %0d:: FAILED", tb_test_num);
	      $info("%0b",tb_state[2]);
	    $info("%0b",tb_state[1]);
	    $info("%0b",tb_state[0]);
	      end
	  /*
	  //Test 39: check if the controller goes to SOLVE state    
	   @(negedge tb_clk);
	  tb_test_num += 1;
	  tb_sol_response = 2'b01;
	  @(posedge tb_clk);
	  #(CLK_PERIOD * 0.25);
	  if (tb_state == 3'b011) begin
	    $info("Test Case %0d:: PASSED", tb_test_num);
	    $info("SOLVE state.");
	    $info("%0b",tb_state[2]);
	    $info("%0b",tb_state[1]);
	    $info("%0b",tb_state[0]);
	    end
	    else begin
	      $info("Test Case %0d:: FAILED", tb_test_num);
	      $info("%0b",tb_state[2]);
	    $info("%0b",tb_state[1]);
	    $info("%0b",tb_state[0]);
	      end
	  #(CLK_PERIOD / 4);
	  //reinitialize all inputs to 0  
	  
	  tb_start_found = 1'b0;  
	  tb_midstate_shifts_done = 1'b0;
    tb_remaining_shifts_done = 1'b0;
    tb_sol_claim = 1'b0;
    tb_sol_response = 2'b00;  
	      
	  //Test 40: check if the controller remains in SOLVE state    
	   @(negedge tb_clk);
	  tb_test_num += 1;
	  //tb_sol_claim = 1'b1;
	  @(posedge tb_clk);
	  #(CLK_PERIOD * 0.25);
	  if (tb_state == 3'b011) begin
	    $info("Test Case %0d:: PASSED", tb_test_num);
	    $info("SOLVE state.");
	    $info("%0b",tb_state[2]);
	    $info("%0b",tb_state[1]);
	    $info("%0b",tb_state[0]);
	    end
	    else begin
	      $info("Test Case %0d:: FAILED", tb_test_num);
	      $info("%0b",tb_state[2]);
	    $info("%0b",tb_state[1]);
	    $info("%0b",tb_state[0]);
	      end
	      */
	   /*   
	  //Test 41: check if the controller goes to IDLE state    
	   @(negedge tb_clk);
	  tb_test_num += 1;
	  tb_sol_response = 2'b10;
	  @(posedge tb_clk);
	  #(CLK_PERIOD * 0.25);
	  if (tb_state == 3'b000) begin
	    $info("Test Case %0d:: PASSED", tb_test_num);
	    $info("IDLE state.");
	    $info("%0b",tb_state[2]);
	    $info("%0b",tb_state[1]);
	    $info("%0b",tb_state[0]);
	    end
	    else begin
	      $info("Test Case %0d:: FAILED", tb_test_num);
	      $info("%0b",tb_state[2]);
	    $info("%0b",tb_state[1]);
	    $info("%0b",tb_state[0]);
	      end
	  #(CLK_PERIOD / 4);
	  //reinitialize all inputs to 0  
	  
	  tb_start_found = 1'b0;  
	  tb_midstate_shifts_done = 1'b0;
    tb_remaining_shifts_done = 1'b0;
    tb_sol_claim = 1'b0;
    tb_sol_response = 2'b01;  
	      
	  //Test 42: check if the controller remains in IDLE state    
	   @(negedge tb_clk);
	  tb_test_num += 1;
	  //tb_sol_claim = 1'b1;
	  @(posedge tb_clk);
	  #(CLK_PERIOD * 0.25);
	  if (tb_state == 3'b000) begin
	    $info("Test Case %0d:: PASSED", tb_test_num);
	    $info("IDLE state.");
	    $info("%0b",tb_state[2]);
	    $info("%0b",tb_state[1]);
	    $info("%0b",tb_state[0]);
	    end
	    else begin
	      $info("Test Case %0d:: FAILED", tb_test_num);
	      $info("%0b",tb_state[2]);
	    $info("%0b",tb_state[1]);
	    $info("%0b",tb_state[0]);
	      end
	      */
	    
	    
	    //Test 43: check if the controller goes to IDLE state    
	   @(negedge tb_clk);
	  tb_test_num += 1;
	  tb_sol_response = 2'b11;
	  @(posedge tb_clk);
	  #(CLK_PERIOD * 0.25);
	  if (tb_state == 3'b000) begin
	    $info("Test Case %0d:: PASSED", tb_test_num);
	    $info("IDLE state.");
	    $info("%0b",tb_state[2]);
	    $info("%0b",tb_state[1]);
	    $info("%0b",tb_state[0]);
	    end
	    else begin
	      $info("Test Case %0d:: FAILED", tb_test_num);
	      $info("%0b",tb_state[2]);
	    $info("%0b",tb_state[1]);
	    $info("%0b",tb_state[0]);
	      end
	  #(CLK_PERIOD / 4);
	  //reinitialize all inputs to 0  
	  
	  tb_start_found = 1'b0;  
	  tb_midstate_shifts_done = 1'b0;
    tb_remaining_shifts_done = 1'b0;
    tb_sol_claim = 1'b0;
    tb_sol_response = 2'b01;  
	      
	  //Test 44: check if the controller remains in IDLE state    
	   @(negedge tb_clk);
	  tb_test_num += 1;
	  //tb_sol_claim = 1'b1;
	  @(posedge tb_clk);
	  #(CLK_PERIOD * 0.25);
	  if (tb_state == 3'b000) begin
	    $info("Test Case %0d:: PASSED", tb_test_num);
	    $info("IDLE state.");
	    $info("%0b",tb_state[2]);
	    $info("%0b",tb_state[1]);
	    $info("%0b",tb_state[0]);
	    end
	    else begin
	      $info("Test Case %0d:: FAILED", tb_test_num);
	      $info("%0b",tb_state[2]);
	    $info("%0b",tb_state[1]);
	    $info("%0b",tb_state[0]);
	      end
	    
	   
	  
	  
    #(CLK_PERIOD * 2.25); 
  end
endmodule
    