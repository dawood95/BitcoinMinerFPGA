module timer_proj
  (
    input wire clk,
    input wire n_rst,
    input wire start_found,
    input wire [2:0] controller_state,
    output reg midstate_shifts_done,
    output reg remaining_shifts_done
    );
    
    reg [3:0] count_out_1;
    reg [4:0] count_out_2;
    flex_counter #(4) CTR1 (.clk(clk), .n_rst(n_rst), .count_enable((controller_state == 3'b001) && (start_found == 1'b1)), 
    .clear(remaining_shifts_done), .rollover_val(4'b1000), .count_out(count_out_1), .rollover_flag(midstate_shifts_done)); //first counter counts uptil 8
    flex_counter #(5) CTR2 (.clk(clk), .n_rst(n_rst), .count_enable((controller_state == 3'b010) && (start_found == 1'b1) && (midstate_shifts_done)), 
    .clear(remaining_shifts_done), .rollover_val(5'b10000), .count_out(count_out_2),.rollover_flag(remaining_shifts_done)); //second counter counts uptil 16
    
  endmodule
            
        