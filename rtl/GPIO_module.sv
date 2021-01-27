`include "defines.h"
module gpio
(
	input	logic	PCLK,
	input	logic	PRESETn,
    input	logic						gpio_wr_en,
    input	logic 						gpio_rd_en,
	input	logic [`ADDR_WIDTH-1 : 0]	gpio_reg_addr,
	input	logic [`DATA_WIDTH-1 : 0]	gpio_wdata,
	input	logic [(`DATA_WIDTH/8)-1 : 0]	gpio_strb,
	
	output	logic [`DATA_WIDTH-1 : 0]	gpio_rdata,
	output  logic 						gpio_error,
	inout 	wire  	GPIO_pins [(`DATA_WIDTH-1):0]
);	

	logic [`DATA_WIDTH-1 : 0]GPIO_oe;
	logic [`DATA_WIDTH-1 : 0]GPIO_o;
	reg [(`DATA_WIDTH-1):0] flop_1,flop_2;
//-----------------------GPIO_Registers-----------------------------------//
	reg [(`DATA_WIDTH-1):0]	dir_reg,
							in_reg,
							out_reg,
							clr_reg,
							set_reg,
							mode_reg;	
//----------------Tri_state_buffer-----------------------------//	
	
	for(genvar g=0; g<(`DATA_WIDTH) ; g++)begin
		assign GPIO_pins[g]=(GPIO_oe[g])?GPIO_o[g]:1'bz;
	end 	
//--------------------Mode_Selection Logic------------------------//		
	always_comb begin
		for(int n=0;n<`DATA_WIDTH;n++) begin
			GPIO_oe[n]=(mode_reg[n])?((~out_reg[n]) & dir_reg[n]):dir_reg[n];
			GPIO_o[n]=(mode_reg[n])? 1'b0 :out_reg[n];
		end
	end
//---------Flopping to synchronise inputs--------------------//
	always@(posedge PCLK)begin
		if (~PRESETn)begin
			flop_1<=1'b0;
			flop_2<=1'b0;
		end 
		else begin
			for(int n=0; n<`DATA_WIDTH ; n++) 
				flop_1[n]<=GPIO_pins[n];
				flop_2	<=flop_1;
				in_reg	<=flop_2;
		end
	end	
//------- ERROR GENERATION LOGIC --------------------------//
assign gpio_error=((gpio_wr_en|gpio_rd_en) && ~(gpio_reg_addr==`dir|gpio_reg_addr==`in|gpio_reg_addr==`out|
                                gpio_reg_addr==`set|gpio_reg_addr==`clr|gpio_reg_addr==`mode))? 1'b1 : 1'b0;
//---------------REGISTERS READ/WRITE--------------------------//		
	always@(posedge PCLK) begin
		if (!PRESETn) begin			
				dir_reg		<={`DATA_WIDTH{1'b0}};
				out_reg		<={`DATA_WIDTH{1'b0}};
				set_reg		<={`DATA_WIDTH{1'b0}};
				clr_reg		<={`DATA_WIDTH{1'b0}};
				mode_reg	<={`DATA_WIDTH{1'b0}};
		end
		else if (gpio_wr_en) begin		
				case(gpio_reg_addr)
					`dir: begin
							for(int n=0; n<(`DATA_WIDTH/8); n++)
							dir_reg[n*8 +: 8] <= gpio_strb[n]? gpio_wdata[n*8 +: 8] : dir_reg[n*8 +: 8];
						end
					`out:   begin
								for(int n=0; n<(`DATA_WIDTH/8); n++)
									out_reg[n*8 +: 8] <= gpio_strb[n]? gpio_wdata[n*8 +: 8] : out_reg[n*8 +: 8];
						    end
						
					`set:	begin
								set_reg <= gpio_wdata;	
								out_reg <= out_reg | gpio_wdata;
							end
							
					`clr:	begin
								clr_reg <= gpio_wdata;					
								out_reg <= out_reg & (~gpio_wdata);
							end	
					`mode:	begin	
							for(int n=0; n<(`DATA_WIDTH/8); n++)
								mode_reg[n*8 +: 8] <= gpio_strb[n]? gpio_wdata[n*8 +: 8] : dir_reg[n*8 +: 8];
							end
					default: begin	//Gives Slave Error in Any Other address's case, that is defined in combinational logic above...
					   clr_reg<=clr_reg;
					end
				endcase
		end
	end	
	
    always_comb begin
            if (gpio_rd_en)  begin //Check for read operation
				case(gpio_reg_addr)
					`dir: begin
						gpio_rdata =dir_reg;
					end
					`out: begin 
						gpio_rdata =out_reg;		
					end
					`in: begin 
						gpio_rdata =in_reg;
					end
					`set: begin
						gpio_rdata =set_reg;				
					end
					`clr:  begin
						gpio_rdata =clr_reg;					
					end
					`mode:  begin
						gpio_rdata =mode_reg;					
					end
					default: begin 	
                        gpio_rdata ={`DATA_WIDTH{1'bx}};
					end		
				endcase
			end
		else
		  gpio_rdata ={`DATA_WIDTH{1'b0}};
	end	
endmodule

