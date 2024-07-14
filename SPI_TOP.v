module SPI_TOP(
    input clk,
	input rst,
	input ss_n,
	input MOSI, 
	output MISO
);

	wire [9:0] SLAVE_RAM;
	wire [7:0] RAM_SLAVE;
	wire tx_valid, rx_valid;

//**instantiate modules**//

	SPI_Slave SPI_SLAVE 
	(
		.MOSI(MOSI),
		.MISO(MISO),
		.ss_n(ss_n),
		.clk(clk),
		.rst(rst),
		.rx_data(SLAVE_RAM),
		.rx_valid(rx_valid),
		.tx_data(RAM_SLAVE),
		.tx_valid(tx_valid)
	);
	// instantiate RAM module
	Single_Port_Asyn_RAM RAM
	(
		.clk(clk),
		.rst(rst),
		.din(SLAVE_RAM),
		.rx_valid(rx_valid),
		.dout(RAM_SLAVE),
		.tx_valid(tx_valid)
	);
	

endmodule