module mem_manager (
	input logic clk,
	input logic reset,
	output logic rdwr_cntl, // read write control 
	output logic n_action, // not needed 
	output logic add_data_sel, // not needed 
	output logic [27:0] mm_address, // address to read or write to
	// output logic [31:0] counter, // for testing 
	output logic [31:0] data_to_write,
	input logic [31:0] data_to_read,
	input logic data_available,
	
	// from master ram controller 
	input logic read_user_data_available, 
	input logic [31:0] read_user_buffer_output_data,
	input logic write_control_done,
	
	// for design core
	output logic [3:0] start_found,
	output logic [1:0] sol_response,
	output logic [31:0] out_data,
	input logic sol_claim,
	input logic [31:0] in_data
	);
	
	// flags
	logic atom_reg = 28'h8000000; // atom --> reg
	logic hdwr_reg = 28'h8000004; // fpga --> reg 
	
	// data blocks
	logic mine_block = 28'h8000008; 
	logic nonce_block = 28'h8000068; // 96 bytes later
	logic [27:0] address;
	logic [3:0] start;
	
	// control data reading
	logic rdwr_toggle = 1'b0;
	logic [31:0] clock_counter;
	logic [31:0] reg_data, next_reg_data;
	
	typedef enum {IDLE, READ_REG, READ_BLOCK_SETUP, READ_BLOCK, WRITE_REG} state;
	state q, q_next;
	
	// register
	always_ff @ (posedge clk) begin
		// check for possible solution in here (as in nonce_ready)??
		if (!reset) begin
			q <= IDLE;
			reg_data <= 32'h01010101;
			// address <= 28'h2345678;
			// start <= 4'ha;
			// clock_counter <= 0;
			// rdwr_toggle <= 0;
		end else begin
			q <= q_next;
			// start <= 4'hb;
			// address <= 28'haaaaaaa;
			reg_data <= next_reg_data;
			// clock_counter <= clock_counter + 32'd1;
		end
		
	end
	
	// next state logic 
	always_comb begin
		next_reg_data = reg_data;
		case(q)
			IDLE: begin
				// check for possible solution flag here
				q_next = READ_REG;
			end
			READ_REG: begin
				if (data_available) begin
					// hAAAA0000 signals from the atom that new data is ready
					next_reg_data = data_to_read;
					if (data_to_read == 32'hAAAA0000)
						q_next = WRITE_REG;
					else
						q_next = IDLE; // atom does not have new data 
				end else 
					q_next = READ_REG; // reg read not complete yet
			end
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
		mm_address = atom_reg;
		rdwr_toggle = 0;
		// clock_counter = 32'hDDDDDDDD;
		data_to_write = reg_data;
		case(q)
			IDLE: begin
				// prepare reg read 
				mm_address = atom_reg;
				rdwr_toggle = 1'b0;
			end
			READ_REG: begin
				// read reg 
				// clock_counter = read_user_buffer_output_data;
			end
			READ_BLOCK_SETUP: begin
				// prepare block read 
				mm_address = mine_block;
				// mm_address = atom_reg;
				rdwr_toggle = 1'b0;
			end
			READ_BLOCK: begin
				// read block 
			end
			WRITE_REG: begin
				// prepare write 
				mm_address = hdwr_reg;
				// mm_address = atom_reg;
				rdwr_toggle = 1'b1;
				data_to_write = reg_data;
			end
		endcase
	end 
	
	assign rdwr_cntl = rdwr_toggle;
	// assign counter = clock_counter; // for testing
	// assign mm_address = address;
	// assign start_found = start;
	
	assign add_data_sel = 1'b0; // get data, not mm_address, not needed 
	assign n_action = 1'b0; // switch toggle, not needed
	
endmodule
	