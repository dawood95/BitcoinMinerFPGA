module BitcoinMiner ( 
				CLOCK_50 , 
				SW , 
				KEY, 
				LEDG, 
				LEDR , 
				// DRAM signals
				/*
				DRAM_CLK, 
				DRAM_CKE, 
				DRAM_ADDR ,
				
				DRAM_BA ,
				DRAM_CS_N ,
				DRAM_CAS_N , 
				DRAM_RAS_N , 
				DRAM_WE_N, 
				DRAM_DQ ,
				DRAM_DQM ,
				*/
				// HEX 7 SEG DISPLAY
				HEX0,
				HEX1,
				HEX2,
				HEX3,
				HEX4,
				HEX5,
				HEX6, 
				HEX7,
				// PCIE signals
				PCIE_PERST_N,
            			PCIE_REFCLK_P,
            			PCIE_RX_P,
            			PCIE_TX_P,
            			PCIE_WAKE_N
	);		
	

	input logic  CLOCK_50  ;
	input logic [17:0] SW ; 
	input logic [3:0] KEY ;
	output logic [8:0] LEDG; 
	output logic [17:0]LEDR;
	output logic [6:0] HEX0;
	output logic [6:0] HEX1;
	output logic [6:0] HEX2;
	output logic [6:0] HEX3;
	output logic [6:0] HEX4;
	output logic [6:0] HEX5;
	output logic [6:0] HEX6;
	output logic [6:0] HEX7;
/*
	output logic [11:0]DRAM_ADDR;
	output logic [1:0]DRAM_BA;
	output logic DRAM_CAS_N;
	output logic DRAM_CKE;
	output logic DRAM_CLK;
	output logic DRAM_CS_N;
	inout	logic  [31:0] DRAM_DQ;
	output logic [3:0] DRAM_DQM;
	output logic DRAM_RAS_N;
	output logic DRAM_WE_N;
*/
	input logic PCIE_PERST_N;
	input logic PCIE_REFCLK_P;
	input logic PCIE_RX_P;
	output logic PCIE_TX_P;
	output logic PCIE_WAKE_N;

	//parameter ADDRESSWIDTH = 32 ;
	parameter ADDRESSWIDTH = 28;
	parameter DATAWIDTH = 32;
	
	logic soc_clk;
	logic ctl_wr_fixed_location;
	logic [ADDRESSWIDTH-1:0] ctl_wr_addr_base;
	logic [ADDRESSWIDTH-1:0] ctl_wr_length;

	logic ctl_rd_fixed_location;
	logic [ADDRESSWIDTH-1:0] ctl_rd_addr_base;
	logic [ADDRESSWIDTH-1:0] ctl_rd_length;

	logic ctl_wr_go;
	logic ctl_wr_done;

	logic usr_wr_buffer;
	logic [DATAWIDTH-1:0]usr_wr_buffer_data;
	logic usr_wr_buffer_full;

	logic ctl_rd_go;
	logic ctl_rd_done;

	logic usr_rd_buffer;
	logic [DATAWIDTH-1:0]usr_rd_buffer_data;
	logic usr_rd_buffer_nonempty;
	logic indicator;
	logic [31:0] mm_display_data;
	logic [31:0] dc_display_data;
	logic [31:0] display_data;
	
	// Bitcoin specific variables
	logic rdwr_cntl;
	logic n_action;
	logic [27:0] mm_address;
	logic add_data_sel;
	logic [31:0] counter;
	logic [3:0] start_found;
	logic [1:0] sol_response;
	logic sol_claim;
	logic [31:0] block_data;
	logic [31:0] data_to_write;
	logic [31:0] data_to_read;
	logic data_available;
	logic shift_in_enable;
	logic [1:0] debug;
	logic [255:0] midState;
	logic [511:0] headData;
	logic [31:0] nonce;
/* 
pll pll_inst(
	.inclk0( CLOCK_50) ,
	.c1( temp_vga_clk ) ,
	.c0(DRAM_CLK ) ,	
	.c2( soc_clk) );
*/
	
	assign PCIE_WAKE_N = 1'b1;

	assign soc_clk = CLOCK_50;
	

	// assign DRAM_CLK = CLOCK_50;
	
		
	always_ff @(posedge CLOCK_50) begin
		if(!KEY[0]) begin
			LEDG <= 0; 
		end else begin
			if (ctl_rd_go == 1) begin
				LEDG[0] <= 1;
			end
			if (ctl_rd_done == 1) begin
				LEDG[1] <= 1;
			end
			if (usr_rd_buffer_nonempty == 1) begin
				LEDG[2] <= 1;
			end
			if (ctl_wr_go == 1) begin
				LEDG[7] <= 1;
			end
			if (ctl_wr_done == 1) begin
				LEDG[6] <= 1;
			end
			if (usr_wr_buffer_data == 32'hFFFFFFFF) begin
				LEDG[5] <= 1;
			end	
			if ( indicator == 1) begin 
				LEDG[3] <= 1;
			end
		end
	end	

//amm_master_qsys amm_master_inst  ( 
amm_master_qsys_with_pcie amm_master_inst  ( 
	.clk_clk	(soc_clk),  				  // clk.clk
	.reset_reset_n	(KEY[0]),                  	          // reset.reset_n
//       			.altpll_sdram_clk                       (DRAM_CLK),
//						.sdram_addr			(DRAM_ADDR),         			  // new_sdram_controller_0_wire.addr
//                .sdram_ba				(DRAM_BA),           			  // ba
//                .sdram_cas_n			(DRAM_CAS_N),        			  // cas_n
//                .sdram_cke				(DRAM_CKE),          			  // cke
//                .sdram_cs_n			(DRAM_CS_N),         			  // cs_n
//                .sdram_dq				(DRAM_DQ),           			  // dq
//                .sdram_dqm				(DRAM_DQM),          			  // dqm
//                .sdram_ras_n			(DRAM_RAS_N),        			  // ras_n
//                .sdram_we_n			(DRAM_WE_N),         			  // we_n
 
	.write_master_control_fixed_location(ctl_wr_fixed_location),		  // write_master_control.fixed_location
	.write_master_control_write_base(ctl_wr_addr_base),    			  // write_base
	.write_master_control_write_length(ctl_wr_length),   			  // write_length

	.write_master_control_go	(ctl_wr_go),             		  // go
	.write_master_control_done		(ctl_wr_done),           		  // done
	.write_master_user_write_buffer		(usr_wr_buffer),      			  // write_master_user.write_buffer
	.write_master_user_buffer_input_data	(usr_wr_buffer_data), 			  // buffer_input_data
	.write_master_user_buffer_full		(usr_wr_buffer_full),       		  // buffer_full
	 
	.read_master_control_fixed_location	(ctl_rd_fixed_location),		  //read_master_control.fixed_location
	.read_master_control_read_base		(ctl_rd_addr_base),		          //read_base
	.read_master_control_read_length	(ctl_rd_length),			  //read_length

	.read_master_control_go			(ctl_rd_go),				  //go
	.read_master_control_done		(ctl_rd_done),				  //done
	.read_master_user_read_buffer		(usr_rd_buffer),			  //read_master_user.read_buffer
	.read_master_user_buffer_output_data	(usr_rd_buffer_data),			  //buffer_output_data
	.read_master_user_data_available	(usr_rd_buffer_nonempty),		  //data_available

	.pcie_ip_refclk_export           (PCIE_REFCLK_P),                      // pcie_ip_refclk.export
	.pcie_ip_pcie_rstn_export        (PCIE_PERST_N),             	  // pcie_ip_pcie_rstn.export
	.pcie_ip_rx_in_rx_datain_0       (PCIE_RX_P),                          // pcie_ip_rx_in.rx_datain_0
	.pcie_ip_tx_out_tx_dataout_0     (PCIE_TX_P)                           // pcie_ip_tx_out.tx_dataout_0
);
 
 
// TOP LEVEL
design_core design_core_inst (
	.clk(soc_clk), 
	.n_rst(KEY[0]), 
	.start_found(start_found),
	.shift_in_enable(shift_in_enable),
	.sol_response(sol_response),
	.in_data(block_data),
	.sol_claim(sol_claim),
	.out_data(nonce),
	//.dc_debug_flag(debug),
	.dc_debug_data(dc_display_data),
	.midData1(midState),
	.headData1(headData)
);

user_logic user_logic_inst (
	.clk(soc_clk),
	.reset(KEY[0]),
	//.rdwr_cntl(rdwr_cntl),
	.n_action(n_action),
	.add_data_sel(add_data_sel),
	//.mm_address(mm_address),
	.indicator(indicator),
	.mm_debug_data(mm_display_data),
	.mm_debug_flag(debug),
	// .counter(counter),
	// .start_found(start_found),
	.write_control_fixed_location(ctl_wr_fixed_location),
	.write_control_write_base(ctl_wr_addr_base),
	.write_control_write_length(ctl_wr_length),

	.write_control_go(ctl_wr_go),
	.write_control_done(ctl_wr_done),

	.write_user_write_buffer(usr_wr_buffer),
	.write_user_buffer_data(usr_wr_buffer_data),
	.write_user_buffer_full(usr_wr_buffer_full),
	//.data_to_write(data_to_write),

	.read_control_fixed_location(ctl_rd_fixed_location),
	.read_control_read_base(ctl_rd_addr_base),
	.read_control_read_length(ctl_rd_length),

	.read_control_go(ctl_rd_go),
	.read_control_done(ctl_rd_done),

	.read_user_read_buffer(usr_rd_buffer),
	.read_user_buffer_output_data(usr_rd_buffer_data),
	.read_user_data_available(usr_rd_buffer_nonempty),
	.core_in(nonce),
	.sol_claim(sol_claim),
	.shift_out_enable(shift_in_enable),
	.sol_response(sol_response),
	.start_out(start_found),
	.core_out(block_data),
	//.data_to_read(data_to_read),
	//.data_available(data_available)
	.debug0(SW[13]),
	.debug1(SW[14]),
	.debug2(SW[15]),
	.debug3(SW[16]),
	.debug4(SW[17]),
	.midState(midState),
	.headData(headData),
	.dc_display_data(dc_display_data)
);

always_comb begin
	// display debug data from either mem manager or design core
	// if (debug == 2'b01) begin
	display_data = mm_display_data;
	// end else begin
	// display_data = dc_display_data;
	// end
end

SEG_HEX hex0(.iDIG(display_data[31:28]), .oHEX_D(HEX7));  
SEG_HEX hex1(.iDIG(display_data[27:24]), .oHEX_D(HEX6));
SEG_HEX hex2(.iDIG(display_data[23:20]), .oHEX_D(HEX5));
SEG_HEX hex3(.iDIG(display_data[19:16]), .oHEX_D(HEX4));
SEG_HEX hex4(.iDIG(display_data[15:12]), .oHEX_D(HEX3));
SEG_HEX hex5(.iDIG(display_data[11:8]), .oHEX_D(HEX2));
SEG_HEX hex6(.iDIG(display_data[7:4]), .oHEX_D(HEX1));
SEG_HEX hex7(.iDIG(display_data[3:0]), .oHEX_D(HEX0));

endmodule 
