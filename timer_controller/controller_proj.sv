module controller_proj
  (
    input wire clk,
    input wire sol_verified,
    input wire sol_claim,
    input wire midstate_shifts_done,
    input wire remaining_shifts_done,
    input wire start_found,
    input wire unhalt,
    output reg [2:0] cur_state
    );
    typedef enum logic [2:0] {IDLE = 3'b000, LOAD_MIDSTATE = 3'b001, LOAD_REMAINING_HEADER = 3'b010, SOLVE = 3'b011, HALT = 3'b100} state_type;
    state_type state, nextstate;
    assign state_cur = state;
    always@(posedge clk)
    begin
       state <= nextstate;
    end
    
    always @ (state) 
    begin
    case (state)
      IDLE: begin
      end
      LOAD_MIDSTATE: begin
      end
      LOAD_REMAINING_HEADER: begin
      end
      SOLVE: begin
      end
      HALT: begin
      end
    endcase
  end
  
  always @ (state, sol_verified, sol_claim, midstate_shifts_done, remaining_shifts_done, start_found, unhalt) begin : Next_state
    nextstate = IDLE;
    case (state)
      IDLE: begin
        if(start_found == 1'b1)
          nextstate = LOAD_MIDSTATE;
        else
          nextstate = IDLE;
      end
      LOAD_MIDSTATE: begin
        if(midstate_shifts_done == 1'b0)
          nextstate = LOAD_MIDSTATE;
        else
          nextstate = LOAD_REMAINING_HEADER;
      end
      LOAD_REMAINING_HEADER: begin
        if(remaining_shifts_done == 1'b0)
          nextstate = LOAD_REMAINING_HEADER;
        else
          nextstate = SOLVE;
      end
      SOLVE: begin
        if (sol_claim == 1'b1)
          nextstate = HALT;
        else 
          nextstate = SOLVE;
      end
      HALT: begin
        if (unhalt == 1'b1)
          nextstate = HALT;
        else
          nextstate = SOLVE;
        if (sol_verified == 1'b1)
          nextstate = IDLE;
        else
          nextstate = SOLVE;
      end
    endcase
  end
    
  endmodule