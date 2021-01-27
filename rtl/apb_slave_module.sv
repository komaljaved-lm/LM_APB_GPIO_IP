`include "defines.h"
module apb_slave(
input logic PCLK,
	 input logic PRESETn,
	 input logic PSELx,
	 input logic PENABLE,
	 input logic PWRITE,
	 input logic [(`DATA_WIDTH/8)-1 : 0]PSTRB,
	 input logic [`DATA_WIDTH-1 : 0]PWDATA,
	 input logic [`ADDR_WIDTH-1 : 0]PADDR,
//-----GPIO SIGNALS ---------
	input		logic [`DATA_WIDTH-1 : 0]		gpio_rdata,
	input		logic 							gpio_error,
//-----------------------------------------------------------------------------
	output	logic 								gpio_wr_en,
	output	logic 								gpio_rd_en,
	output	logic [`ADDR_WIDTH-1 : 0]			gpio_reg_addr,
	output	logic [`DATA_WIDTH-1 : 0]			gpio_wdata,
	output	logic [(`DATA_WIDTH/8)-1 : 0]		gpio_strb, 
	 output logic [`DATA_WIDTH-1 : 0]			PRDATA,
	 output logic 								PREADY,
	 output logic 								PSLVERR
);


	assign gpio_reg_addr   = PADDR;
	assign gpio_wdata	   = PWDATA;
	assign gpio_strb	   = PSTRB;	
	
	always_comb begin
		if (!PRESETn) begin
				gpio_rd_en	=1'b0;
				gpio_wr_en	=1'b0;
				PREADY		=1'bz;
				PSLVERR		=1'bz;
				PRDATA		={`DATA_WIDTH{1'b0}};	
		end
		else if (PSELx && PENABLE) begin
			if(PWRITE) begin // Check for write operation
				gpio_rd_en		=1'b0;
				gpio_wr_en		=1'b1;
				PREADY 			=1'b1;
				PSLVERR 		=gpio_error;
				PRDATA			=gpio_rdata;	
			end
			else if(~PWRITE) begin //Check for read operation
				gpio_rd_en		=1'b1;
				gpio_wr_en		=1'b0;
				PREADY			=1'b1;
				PSLVERR			=gpio_error;
				PRDATA			=gpio_rdata;
			end
			else begin				// we are in the loop when MASTER is in ACESS state and either wait
									//is asserted by us or their is unknown value in PWRITE 
				gpio_rd_en	=~PWRITE;
				gpio_wr_en	=PWRITE;
				PREADY		=1'b0;	
				PSLVERR		=1'b0;
				PRDATA		=gpio_rdata;// to be reviewed once specs will be cleared...			
			end						//we can place a counter to get out of this loop...
		end
		else begin
		gpio_rd_en	= 1'b0;
		gpio_wr_en	= 1'b0;
		PREADY		= 1'bz;
		PSLVERR		= 1'bz;
		PRDATA		= {`DATA_WIDTH{1'b0}};
		end
	end
endmodule
