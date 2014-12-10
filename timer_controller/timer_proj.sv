module timer_proj
(
  input wire clk,
  //input wire n_rst,
  input wire start_found,
  input wire shift_in_enable,
  input wire [2:0] controller_state,
  output wire midstate_shifts_done,
  output wire remaining_shifts_done
);

  reg [4:0] count_out;
  reg enable;
  
  assign midstate_shifts_done = (count_out == 5'd8) ? 1 : 0;
  assign remaining_shifts_done = (count_out == 5'd24) ? 1 : 0;
  assign enable = ((controller_state == 3'b001 || controller_state == 3'b010) && shift_in_enable);
  
  counter #(5) CTR1 (
    .clk(clk),
    .n_rst(~(controller_state == 3'b000 || start_found)),
    .enable(enable), 
    .rollover_val(5'd24),
    .count_out(count_out)
  );
    
endmodule
            
        
