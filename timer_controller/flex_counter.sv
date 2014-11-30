module flex_counter
#(
  parameter NUM_CNT_BITS = 4
)
(
	input wire clk,
	input wire n_rst,
	input wire count_enable,
	input wire clear,
	input wire [NUM_CNT_BITS-1:0] rollover_val,
	output wire [NUM_CNT_BITS-1:0] count_out,
	output reg rollover_flag
);
//assign serial_in = 1'b1;
reg [NUM_CNT_BITS-1:0] f, NEXT;
reg NEXT_r;
//integer i,k;

always_comb  begin //reset is 1
    NEXT = f;
    NEXT_r = rollover_flag;
    if (clear == 1'b1) begin//count is not enabled then next state will be f
       NEXT=0;
       NEXT_r = 1'b0;
    end
  else begin
    if (count_enable == 1'b1) begin//count is not enabled then next state will be f
     /* NEXT<=f;
    end
    else begin count is enabled then we will add one*/
      NEXT=f+1;
      NEXT_r = 1'b0;
    //end
      if (count_out == (rollover_val-1)) begin//it has reached the limit, then count should be 1
        /*NEXT[NUM_CNT_BITS-1:1]=1'b0;
        NEXT[0] = 1'b1; we are setting the count to 0 by brute force*/
        NEXT_r = 1'b1;
      end
    end
end    
  end//end of combinational block

always_ff @ (posedge clk, negedge n_rst) begin
  if ((n_rst == 1'b0)) begin
    f[NUM_CNT_BITS-1:0] <= 0;//if it is reset then make everything to be the initial states that will be 0
    rollover_flag <= 1'b0;
  end
  else begin
    f <= NEXT;
    rollover_flag <= NEXT_r;
  end
end
/*always_comb begin
  if ((f[0] == 1'b1) && (f[NUM_CNT_BITS-1:1] == '0)) begin //this is the case when the count is one, which is hen rollover_val has been attained
   assign rollover_flag = 1'b1;
  end
  else begin//now the count is not 1
   assign rollover_flag = 1'b0;
  end*/
  assign count_out = f;
endmodule
