//------------------------------
`include "defines.h"
`include "apb_slave_module.sv"
`include "GPIO_module.sv"
//------------------------------

module top_GPIO_APBSlave ( 
//Slave Module Signals
//Input Signals
	 input logic PCLK,
	 input logic PRESETn,
	 input logic PSELx,
	 input logic PENABLE,
	 input logic PWRITE,
	 input logic [(`DATA_WIDTH/8)-1 : 0]PSTRB,
	 input logic [`DATA_WIDTH-1 : 0]PWDATA,
	 input logic [`ADDR_WIDTH-1 : 0]PADDR,
//Output Signals
	 output logic [`DATA_WIDTH-1 : 0]PRDATA,
	 output logic PREADY,
	 output logic PSLVERR,

//Pin LayOut
	inout 	wire  	GPIO_pins [(`DATA_WIDTH-1):0]
);

	logic [`DATA_WIDTH-1 : 0]		gpio_rdata;
	logic 							gpio_ready;
	logic 							gpio_error;
	logic 							gpio_wr_en;
	logic 							gpio_rd_en;
	logic [`ADDR_WIDTH-1 : 0]		gpio_reg_addr;
	logic [`DATA_WIDTH-1 : 0]		gpio_wdata;
	logic [(`DATA_WIDTH/8)-1 : 0]	gpio_strb;

//Slave  and GPIO Instance
	apb_slave	mod_1(.*);
	gpio		mod_2(.*);
	endmodule 
