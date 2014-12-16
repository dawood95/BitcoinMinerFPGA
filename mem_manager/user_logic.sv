module user_logic #(
	parameter ADDRESSWIDTH = 28 ,
	parameter DATAWIDTH = 32,
	parameter BYTEENABLEWIDTH = 4
)
(
	input logic clk,
	input logic reset,
	//input logic write_n,
	//input logic read_n,
	input logic rdwr_cntl,
	input logic n_action,
	output logic indicator,
	input logic add_data_sel,
	input logic [ADDRESSWIDTH-1:0] read_address,
	
	// debuggin
	output logic[DATAWIDTH-1:0] mm_debug_data,
	output logic [1:0] mm_debug_flag,
	
	// Control interface to write master
	input  logic write_control_done,	 		   // Asserted and held when Master is done writing last word.Start next request on the next cycle.	
	output logic write_control_fixed_location,		   // When set Master will not increment address
	output logic [ADDRESSWIDTH-1:0] write_control_write_base, // Address to write data into
	output logic [ADDRESSWIDTH-1:0] write_control_write_length,// Number of bytes to transfer. Must be multiple of DATAWIDTH
	output logic write_control_go,				   // Start write	
	// user logic data interface to write master 
	output logic write_user_write_buffer,  		 	// Write signal
	output logic [DATAWIDTH-1:0] write_user_buffer_data,    // Write Data
	input logic write_user_buffer_full,				// Buffer full signal. Don't write if asserted
	// Control interface to read master
	input logic read_control_done,//Asserted and held when Master is done writing last word.Start next request on the next cycle.	
	output logic read_control_fixed_location,	    	//When set Master will not increment address
	output logic [ADDRESSWIDTH-1:0]read_control_read_base,//Address to read Data from
	output logic [ADDRESSWIDTH-1:0]read_control_read_length,//Number of bytes to read. Must be multiple of DATAWIDTH
	output logic read_control_go,		// Start read
	// user logic data interface to read master 
	output logic read_user_read_buffer,		// Read signal
	input logic [DATAWIDTH-1:0]read_user_buffer_output_data,// Valid data to be read when user_data_available is asserted
	input logic read_user_data_available,		//Read data is available.Assert user_read_buffer only when this is asserted.
	// interface with design core 
	input logic [31:0] core_in,
	input logic sol_claim,
	output logic shift_out_enable,
	output logic sol_response,
	output logic start_out,
	output logic [31:0] core_out,
	input wire debug0,
	input wire debug1,
	input wire debug2,
	input wire debug3,
	input wire debug4,
	input logic [255:0] midState,
	input logic [511:0] headData,
	input logic [31:0] dc_display_data
);


assign write_control_write_length = 4;
assign write_control_fixed_location = 1'b1;
assign read_control_fixed_location = 1'b1;
assign read_control_read_length = 4;

// my variables
logic start_found, next_start_found, display_start_found;
logic [7:0] rd_count; 
logic [7:0] next_rd_count;
logic [31:0] nonce_found;
logic [31:0] next_nonce_found;
logic mine_block = 28'h8000008; 
logic nonce_block = 28'h8000068; // 96 bytes later
logic [1:0] loc_mm_debug;
logic [1:0] loc_mm_debug_next;
logic [3:0] is_solved;
logic [3:0] next_is_solved;

logic [ADDRESSWIDTH-1:0] r_address, r_nextAddress, w_address, w_nextAddress;
logic [DATAWIDTH-1:0] rd_data, wr_data, nextData; 
logic [DATAWIDTH-1:0] nextRead_data, read_data;
typedef enum {IDLE, WRITE, WRITE_WAIT, READ_REQ, READ_WAIT, READ_ACK, READ_DATA, 
	BLOCK_IDLE, BLOCK_READ_REQ, BLOCK_READ_WAIT, BLOCK_READ_ACK, BLOCK_READ_DATA, 
	BLOCK_WRITE, BLOCK_WRITE_WAIT, WATCH_NONCE, NONCE_WRITE, NONCE_WRITE_WAIT, PAUSE} state_t;
state_t state, nextState;

// assign display_data = add_data_sel ? address : ((rdwr_cntl) ? 0 : read_data) ;

/*
always_comb begin
	if (nonce_found) begin 
		display_data = nonce_found;
	end else begin
		
	end
end 
*/

/*
assign display_start_found = start_found;
assign display_data[3:0] = {3'b0,display_start_found};
assign display_data[27:0] = r_address;
*/

// read counter
/*
logic [7:0] total_reads;
logic count_read;
counter #(8) cntr(.clk(clk),.n_rst(!reset),.enable(count_read),.rollover_val(8'd24),.count_out(total_reads));
*/

always_comb begin 
	if ((r_address > 28'h00000000) & !rdwr_cntl) 
		indicator = 1;
	else 
		indicator = 0;
end

// alert core of new data
assign start_out = start_found;

logic [4:0] debug;
assign debug = {debug4,debug3,debug2,debug1,debug0};

always_comb
	begin : debugblock
	mm_debug_data = 32'hEEEE1234;
	case(debug)
		5'd0: begin
			mm_debug_data = midState[31:0];
		end
		5'd1: begin
			mm_debug_data = midState[63:32];
		end
		5'd2: begin
			mm_debug_data = midState[95:64];
		end
		5'd3: begin
			mm_debug_data = midState[127:96];
		end
		5'd4: begin
			mm_debug_data = midState[159:128];
		end
		5'd5: begin
			mm_debug_data = midState[191:160];
		end
		5'd6: begin
			mm_debug_data = midState[223:192];
		end
		5'd7: begin
			mm_debug_data = midState[255:224];
		end		
		5'd8: begin
			mm_debug_data = headData[31:0];
		end
		5'd9: begin
			mm_debug_data = headData[63:32];
		end
		5'd10: begin
			mm_debug_data = headData[95:64];
		end
		5'd11: begin
			mm_debug_data = headData[127:96];
		end
		5'd12: begin
			mm_debug_data = headData[159:128];
		end
		5'd13: begin
			mm_debug_data = headData[191:160];
		end
		5'd14: begin
			mm_debug_data = headData[223:192];
		end
		5'd15: begin
			mm_debug_data = headData[255:224];
		end	
		5'd16: begin
			mm_debug_data = headData[287:256];
		end
		5'd17: begin
			mm_debug_data = headData[319:288];
		end
		5'd18: begin
			mm_debug_data = headData[351:320];
		end
		5'd19: begin
			mm_debug_data = headData[383:352];
		end
		5'd20: begin
			mm_debug_data = headData[415:384];
		end
		5'd21: begin
			mm_debug_data = headData[447:416];
		end
		5'd22: begin
			mm_debug_data = headData[479:448];
		end
		5'd23: begin
			mm_debug_data = headData[511:480];
		end
		5'd24: begin
			mm_debug_data = nonce_found;
		end
		5'd25: begin
			mm_debug_data = dc_display_data;
		end
	endcase
end
	
//assign mm_debug_data[31:4] = nonce_found[31:4];
//assign mm_debug_data[3:0] = is_solved;

// debuggin
assign mm_debug_flag = loc_mm_debug;

always_ff @ (posedge clk) begin
	if(!reset) begin
		r_address <= 0;
		w_address <= 0;
		state <= IDLE ;
		wr_data <= 0;
		read_data <= 32'hFEEDFEED; 
		start_found <= 0;
		rd_count <= 0;
		nonce_found <= 0;
		loc_mm_debug <= 2'b01;
		is_solved <= 4'd2;
	end else begin
		state <= nextState;
		r_address <= r_nextAddress;
		w_address <= w_nextAddress;
		wr_data <= nextData;
		read_data <= nextRead_data;
		start_found <= next_start_found;
		rd_count <= next_rd_count;
		nonce_found <= next_nonce_found;
		loc_mm_debug <= loc_mm_debug_next;
		is_solved <= next_is_solved;
	end
end	


// Next State Logic 
always_comb begin
	nextState = state;
	r_nextAddress = r_address;
	w_nextAddress = w_address;
	nextData = wr_data;
	nextRead_data = read_data;
	next_start_found = start_found;
	next_rd_count = rd_count;
	next_nonce_found = nonce_found;
	loc_mm_debug_next = loc_mm_debug;
	next_is_solved = is_solved;
	
	/**
		Default solve response should be 0 for still checking or incorrect solution.
		1 if the solution is correct.
	*/
	
	case(state)
		IDLE: begin //writes take priority
			/*
			if(rdwr_cntl & !n_action) begin
				nextState = WRITE;
				nextAddress = address + BYTEENABLEWIDTH;
				nextData = wr_data + 4 ;
			end else if (!rdwr_cntl & !n_action) begin f
				nextState = READ_REQ;
				nextAddress =  address - BYTEENABLEWIDTH;
			end
			*/
			
			if (read_data == 32'hAAAA0000) begin 
				nextState = BLOCK_IDLE;
				r_nextAddress = 28'h8000004;
				w_nextAddress = 28'h8000090;
				next_start_found = 1'b1;
			end else begin
				nextState = READ_REQ;
				r_nextAddress = 28'h8000000;
				next_start_found = 1'b0;
			end
		end
		WRITE: begin
			nextState = WRITE_WAIT;
		end
		WRITE_WAIT: begin
			/*
			nextAddress = nextAddress + 1; // testing 
			if (write_control_done && start_found == 1'b1) begin
				nextState = BLOCK;
				nextAddress = nextAddress + 4; // testing
			end */
			nextState = IDLE;
		end
		READ_REQ: begin
			nextState = READ_WAIT;
		end
		READ_WAIT: begin
			if ( read_control_done ) begin
				nextState = READ_ACK;
			end
		end
		READ_ACK: begin
			nextState = READ_DATA;
			nextRead_data = read_user_buffer_output_data;
		end
		READ_DATA: begin
			/*
			if (start_found == 1'b1) begin
				nextState = WRITE;
				nextData = read_data;
				nextAddress = nonce_block;
			end
			*/
			nextState = IDLE; 
		end
		BLOCK_IDLE: begin
			// state should be hit 24 times, each before the read
			if (rd_count == 8'd24) begin
				nextState = WATCH_NONCE; // WATCH_NONCE?
			end else begin
				next_rd_count++;
				nextState = BLOCK_READ_REQ;
				r_nextAddress = r_nextAddress + 4;
				w_nextAddress = w_nextAddress + 4;
				next_start_found = 1'b0;
			end
		end
		BLOCK_READ_REQ: begin
			nextState = BLOCK_READ_WAIT;
		end
		BLOCK_READ_WAIT: begin
			if ( read_control_done ) begin
				nextState = BLOCK_READ_ACK;
			end
		end
		BLOCK_READ_ACK: begin
			nextState = BLOCK_READ_DATA;
			nextRead_data = read_user_buffer_output_data;
		end
		BLOCK_READ_DATA: begin
			nextState = BLOCK_WRITE;
			// w_nextAddress = w_nextAddress + 4;
			// write to core here !!
			nextData = read_data;
		end
		BLOCK_WRITE: begin
			nextState = BLOCK_WRITE_WAIT;
		end
		BLOCK_WRITE_WAIT: begin
			nextState = BLOCK_IDLE;
		end
		WATCH_NONCE: begin
			loc_mm_debug_next = 2'b10;
			if (sol_claim) begin
 				next_nonce_found = core_in;
				nextData = core_in;
				nextState = NONCE_WRITE;
				w_nextAddress = 28'h8000004;
				next_is_solved = 4'd8;
			end else begin
				//next_nonce_found = next_nonce_found;
				nextState = WATCH_NONCE;
			end
		end
		NONCE_WRITE: begin
			nextState = NONCE_WRITE_WAIT;
		end
		NONCE_WRITE_WAIT: begin
			nextState = PAUSE;
		end
		PAUSE: begin
			loc_mm_debug_next = 1'b01;
			nextState = WATCH_NONCE;
		end
		default: begin
		end
	endcase	
end

// Output Logic 
always_comb begin
	write_control_go = 1'b0;
	write_user_write_buffer = 1'b0;
	write_control_write_base = w_address;
	write_user_buffer_data = 32'h00000000;
	read_control_go = 1'b0;
	read_control_read_base = r_address;
	read_user_read_buffer = 1'b0;
	rd_data = 32'hbad1bad1;
	core_out = 0;
	shift_out_enable = 0;
	// count_read = 1'b0;
	
	// for debugging
	// mm_debug_data[31:24] = r_address[27:20]; // r_address[27:20];
	// mm_debug_data[23:16] = rd_count;
	// mm_debug_data[15:0] = r_address[15:0];
	
	case(state)
		IDLE: begin
			write_control_go = 1'b0;
			write_user_write_buffer = 1'b0;
		end
		WRITE: begin
			if (!write_user_buffer_full) begin
				write_user_write_buffer = 1'b1;
				write_control_go = 1'b1;		
				write_control_write_base = w_address;
				write_user_buffer_data = wr_data;
			end 
		end
		READ_REQ: begin
			read_control_go = 1'b1;
			read_control_read_base = r_address;
			end
		READ_ACK: begin
			read_user_read_buffer = 1'b1;
		end
		BLOCK_IDLE : begin
			// check for start found and write data to design core
			// count_read = 1'b1;
		end
		BLOCK_READ_REQ: begin
			read_control_go = 1'b1;
			read_control_read_base = r_address;
		end
		BLOCK_READ_ACK: begin 
			read_user_read_buffer = 1'b1;
		end
		BLOCK_READ_DATA: begin
			core_out = read_data;
			shift_out_enable = 1'b1;
		end 
		BLOCK_WRITE: begin
			if (!write_user_buffer_full) begin
				write_user_write_buffer = 1'b1;
				write_control_go = 1'b1;		
				write_control_write_base = w_address;
				write_user_buffer_data = wr_data;
			end 
		end
		NONCE_WRITE: begin
			if (!write_user_buffer_full) begin
				write_user_write_buffer = 1'b1;
				write_control_go = 1'b1;	
				write_control_write_base = w_address;
				write_user_buffer_data = wr_data;
			end 
		end
		PAUSE: begin
			// mm_debug_data = nonce_found;
		end
		default: begin
		end
	endcase
end

endmodule
