module mem_manager (
	input logic clk,
	input logic reset,
	output logic rdwr_cntl, // read write control 
	output logic n_action, // not needed 
	output logic add_data_sel, // not needed 
	output logic [27:0] mm_address, // address to read or write to
	output logic counter, // for testing 
	
	// from master ram controller 
	input logic read_user_data_availble, 
	input logic [31:0] read_user_buffer_output_data,
	input logic write_control_done 
	);
	
	// flags
	logic atom_reg = 28'h8000000; // atom --> reg
	logic hdwr_reg = 28'h8000004; // fpga --> reg 
	
	// data blocks
	logic mine_block = 28'h8000008; 
	logic nonce_block = 28h8000068; // 96 bytes later
	
	// control data reading
	logic rdwr_toggle;
	logic [3:0] clock_counter;
	
	typedef enum {IDLE, READ_REG, READ_BLOCK_SETUP, READ_BLOCK, WRITE_REG} state;
	state q, q_next;
	
	// register
	always_ff @ (posedge clk) begin
		// check for possible solution in here (as in nonce_ready)??
		if (!reset) begin
			q <= IDLE;
			clock_counter = 0;
			rdwr_toggle = 0;
		end else begin
			q <= q_next;
			// clock_counter <= clock_counter + 4'd1;
		end
		
	end
	
	// next state logic 
	always_comb begin
		case(q)
			IDLE: begin
				// check for possible solution flag here
				q_next = READ_REG;
			end
			READ_REG: begin
				if (read_user_data_available) begin
					// hAAAA0000 signals from the atom that new data is ready  
					if (read_user_buffer_output_data == 32'hAAAA0000)
						q_next = WRITE_REG;
					else
						q_next = IDLE; // atom does not have new data 
				end else 
					q_next = READ_REG; // reg read not complete yet
			READ_BLOCK_SETUP: begin
				q_next = READ_BLOCK;
			end
			READ_BLOCK: begin
				// 24 counter goes here 
				// assert shift_enable for shift register 
				// hook up read_user_buffer_output_data directly to sr input
				// read block done and back to idle 
				// use built in multi read of user_logic (read_control_fixed_locaton)??
				q_next = IDLE;
			end
			WRITE_REG: begin
				if (write_control_done) q_next = IDLE;
				else q_next = WRITE_REG;
			end
		endcase
	/*	
	if (clock_counter == 4'd10) begin
			if (rdwr_toggle == 1'b1) rdwr_toggle <= 1'b0;
			else rdwr_toggle <= 1'b1;
			clock_counter <= 4'd0;
		end
	*/
	end 
	
	// output logic 
	always_comb begin
		case(q)
			IDLE: begin
				// prepare reg read 
				address = atom_reg;
				rdwr_cntl = 1'b0;
			end
			READ_REG: begin
				// read reg 
			end
			READ_BLOCK_SETUP: begin
				// prepare block read 
				address = mine_block;
				rdwr_cntl = 1'b0;
			end
			READ_BLOCK: begin
				// read block 
			end
			WRITE_REG: begin
				// prepare write 
				address = hdwr_reg;
				rdwr_cntl = 1'b1;
			end
		endcase
	end 
	
	assign rdwr_cntl = rdwr_toggle;
	assign counter = clock_counter; // for testing
	
	assign add_data_sel = 1'b0; // get data, not address, not needed 
	assign n_action = 1'b0; // switch toggle, not needed
	
endmodule
	