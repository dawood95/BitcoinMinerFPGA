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
	input logic [3:0] counter,
	input logic [ADDRESSWIDTH-1:0] read_address,
	output logic[DATAWIDTH-1:0] display_data,
	
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
	input logic [DATAWIDTH-1:0] data_to_write, 	// Would be the possible nonce
	// Control interface to read master
	input logic read_control_done,//Asserted and held when Master is done writing last word.Start next request on the next cycle.	
	output logic read_control_fixed_location,	    	//When set Master will not increment address
	output logic [ADDRESSWIDTH-1:0]read_control_read_base,//Address to read Data from
	output logic [ADDRESSWIDTH-1:0]read_control_read_length,//Number of bytes to read. Must be multiple of DATAWIDTH
	output logic read_control_go,		// Start read
	// user logic data interface to read master 
	output logic read_user_read_buffer,		// Read signal
	input logic [DATAWIDTH-1:0]read_user_buffer_output_data,// Valid data to be read when user_data_available is asserted
	input logic read_user_data_available		//Read data is available.Assert user_read_buffer only when this is asserted.
);


assign write_control_write_length = 4;
assign write_control_fixed_location = 1'b1;
assign read_control_fixed_location = 1'b1; // change this at some point??
assign read_control_read_length = 4;


logic [ADDRESSWIDTH-1:0] address, nextAddress;
logic [DATAWIDTH-1:0] rd_data, wr_data, nextData; 
logic [DATAWIDTH-1:0] nextRead_data, read_data;
typedef enum {IDLE, WRITE, WRITE_WAIT, READ_REQ, READ_WAIT, READ_ACK, READ_DATA} state_t;
state_t state, nextState;

// assign display_data = add_data_sel ? address : ((rdwr_cntl) ? 0 : read_data) ;
assign display_data[31:8] = wr_data;
assign display_data[7:4] = counter;
assign display_data[3:0] = {3'd0,rdwr_cntl};

always_comb begin 
	if ((address > 28'h00000000) & !rdwr_cntl) 
		indicator = 1;
	else 
		indicator = 0;
end

always_ff @ (posedge clk) begin
	if(!reset) begin
		address <= 0;
		state <= IDLE ;
		wr_data <= 0;
		read_data <= 32'hFEEDFEED; 
	end else begin
		state <= nextState;
		address <= nextAddress;
		//address <= 28'h00000004;
		wr_data <= nextData;
		//wr_data <= 32'hf00fbeeb;
		//wr_data <= 32'hdeadbeef;
		read_data <= nextRead_data;
	end
end	

// Next State Logic 
always_comb begin
	nextState = state;
	nextAddress = address;
	nextData = wr_data;
	// nextData = read_data;
	nextRead_data = read_data;
	case(state)
		IDLE: begin //writes take priority
			if(rdwr_cntl & !n_action) begin
				nextState = WRITE;
				nextAddress = address + BYTEENABLEWIDTH;
				nextData = data_to_write; // !! this is where write data goes                                                       
				// nextData = read_data;
				// nextData = wr_data + 4;
			end else if (!rdwr_cntl & !n_action) begin 
				nextState = READ_REQ;
				nextAddress =  address - BYTEENABLEWIDTH;
			end
		end
		WRITE: begin
			nextState = WRITE_WAIT;
		end
		WRITE_WAIT: begin
			if (write_control_done) begin
				nextState = IDLE;
			end
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
			// display_data = read_user_buffer_output_data;
			// nextData = read_user_buffer_output_data;

		end
		READ_DATA: begin
			nextState = IDLE;
		//	nextRead_data = read_user_buffer_output_data;
		end
		default: begin
		end
	endcase	
end

// Output Logic 
always_comb begin
	write_control_go = 1'b0;
	write_user_write_buffer = 1'b0;
	write_control_write_base = address;
	write_user_buffer_data = 32'h00000000;
	read_control_go = 1'b0;
	read_control_read_base = address;
	read_user_read_buffer = 1'b0;
	rd_data = 32'hbad1bad1;
	case(state)
		IDLE: begin
			write_control_go = 1'b0;
			write_user_write_buffer = 1'b0;
		end
		WRITE: begin
			if (!write_user_buffer_full) begin
			write_user_write_buffer = 1'b1;
			write_control_go = 1'b1;		
			write_control_write_base = 28'h8000004;
			write_user_buffer_data = wr_data;
			// display_data = wr_data;
			end 
		end
		READ_REQ: begin
				read_control_go = 1'b1;
				read_control_read_base = 28'h8000000;
				
				end
		READ_ACK: begin
			//if(read_user_data_available) begin
				read_user_read_buffer = 1'b1;
			//end
		end
		READ_DATA: begin
			//rd_data = read_user_buffer_output_data;
		end
		default: begin
		end
	endcase
end

endmodule
