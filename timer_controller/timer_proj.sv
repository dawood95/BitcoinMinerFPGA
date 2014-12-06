module timer_proj
(
  input wire clk,
  //input wire n_rst,
  //input wire start_found,
  input wire [2:0] controller_state,
  output wire midstate_shifts_done,
  output wire remaining_shifts_done
);

  reg [5:0] count_out;
  
  assign midstate_shifts_done = (count_out == 5'b01000) ? 1 : 0;
  assign remaining_shifts_done = (count_out == 5'b11000) ? 1 : 0;
  
  counter #(5) CTR1 (
    .clk(clk),
    .n_rst(1'b1),
    .enable((controller_state == 3'b001) || (controller_state == 3'b010)), 
    .clear(controller_state == 3'b000),
    .rollover_val(5'b11111),
    .count_out(count_out),
  );
    
endmodule
            
        
