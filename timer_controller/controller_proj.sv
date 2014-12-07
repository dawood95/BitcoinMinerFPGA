module controller_proj
(
  input wire clk,
  input wire n_rst,
  input wire start_found,
  input wire midstate_shifts_done,
  input wire remaining_shifts_done,
  input wire sol_claim,
  input wire [1:0] sol_response,
  output wire idleState, midState, headState, solveState,
  output wire [2:0] state
);

  typedef enum logic [2:0] {
    IDLE = 3'b000,
    LOAD_MIDSTATE = 3'b001,
    LOAD_REMAINING_HEADER = 3'b010,
    SOLVE = 3'b011,
    HALT = 3'b100
  } state_type;
  
  state_type cur_state, next_state;
  
  //State Register
  always_ff @ (posedge clk, negedge n_rst) begin
    if (n_rst == 0) cur_state <= idle;
    else cur_state <= next_state;
  end
  
  //Next State Logic
  always_comb begin
    next_state = IDLE;
    case (state)
      IDLE: begin
        if(start_found == 1'b1)
          next_state = LOAD_MIDSTATE;
        else
          next_state = IDLE;
      end
      LOAD_MIDSTATE: begin
        if(start_found == 1'b1 || midstate_shifts_done == 1'b0)
          next_state = LOAD_MIDSTATE;
        else
          next_state = LOAD_REMAINING_HEADER;
      end
      LOAD_REMAINING_HEADER: begin
	if(start_found == 1'b1)
          next_state = LOAD_MIDSTATE;
        else if(remaining_shifts_done == 1'b0)
          next_state = LOAD_REMAINING_HEADER;
        else
          next_state = SOLVE;
      end
      SOLVE: begin
	if(start_found == 1'b1)
          next_state = LOAD_MIDSTATE;
        else if (sol_claim == 1'b1)
          next_state = HALT;
        else 
          next_state = SOLVE;
      end
      HALT: begin
        if(start_found == 1'b1)
          next_state = LOAD_MIDSTATE;
        else if (sol_response == 2'b00)
          next_state = HALT;
        else if (sol_response == 2'b01)
          next_state = SOLVE;
        else
          next_state = IDLE;
      end
    endcase
  end
  
  //Output
  assign state = cur_state;
  assign midState = (state == 3'b001) 	? 1 :  0;
  assign headState = (state == 3'b010) 	? 1 :  0;
  assign idleState = (state == 3'b000) 	? 1 :  0;
  assign solveState = (state == 3'b011) ? 1 :  0;

endmodule
