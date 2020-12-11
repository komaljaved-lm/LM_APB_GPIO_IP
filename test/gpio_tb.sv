//------------------------------------------------------------------------------------------------------------//
//--------------Fully Directed TestBench to check the Specific Functionalities of the DUT --------------------//
//---------It Oncludes all the tests to Verify Following Functionalites as Discribed in each Testcase---------//
//------------------------------------------------------------------------------------------------------------//
`include "top.sv"
module apb_slave_unit_test_1;
  //===================================
  // Design Under Test Signals
  //===================================
  logic PCLK= 0;
  logic PRESETn;
  logic PSELx;
  logic PENABLE;
  logic PWRITE;
  logic [3:0] PSTRB;
  logic	[32-1: 0]	PWDATA;
  logic	[32-1: 0]	PADDR;
  logic	[32-1: 0]	PRDATA;
  logic PREADY;
  logic PSLVERR;
  wire  GPIO_pins [31:0];
  // clk generator
  always begin
      #5 PCLK = ~PCLK;
  end
//DUT Instance
   top_GPIO_APBSlave mod3(.GPIO_pins(GPIO_pins), .*); 
   
//Clocking Block 
 	default clocking cb @(posedge PCLK);
 	default input #0 output #0;
	output PRESETn, PSELx,PENABLE, PWRITE, PSTRB, PWDATA,PADDR; 
 	input PREADY, PRDATA, PSLVERR ;
 endclocking
 
  initial
  //Case_01:: Reset DUT consectively 
	begin
	$display("==========================Starting Test Cases==========================");
	$display("==========================Reseting DUT==========================");
//Reset For  (8) Cycles
    cb.PRESETn <= 1'b0;
    repeat(8)@(posedge PCLK);
//Deasset Reset
	cb.PRESETn <= 1'b1;
	$display("Reset::%d",PRESETn);
	@(posedge PCLK)
	$display("==========================Reset Completed==========================");

//========================== Write to Direction Register ================================//
@(posedge PCLK)
	cb.PSELx<=1'b1;
	cb.PSTRB<=4'b1111;
	cb.PENABLE<=1'b0;
	cb.PWRITE<=1'b1;
	cb.PADDR<=32'd1;
    cb.PWDATA <= 32'hffff_ff00;	
@(posedge PCLK)
	cb.PENABLE<=1'b1;
@(posedge PCLK)
  cb.PSELx <=1'b0;
  cb.PENABLE<=1'b0;
//============================= Write to Out Register====================================//
repeat(3) @(posedge PCLK)
	cb.PSELx<=1'b1;
	cb.PSTRB<=4'b1011;
	cb.PWRITE<=1'b1;
	cb.PADDR<=32'd3;
    cb.PWDATA <= 32'hffff_ffff;
@(posedge PCLK)
	cb.PENABLE<=1'b1;
@(posedge PCLK)
  cb.PSELx <=1'b0;
  cb.PENABLE<=1'b0;
//============================= Reading Back from Out Register=============================//
repeat(3)@(posedge PCLK)
	cb.PSELx<=1'b1;
	cb.PWRITE<=1'b0;
	cb.PADDR<=32'd3;
@(posedge PCLK)
	cb.PENABLE<=1'b1;
@(posedge PCLK)
  cb.PSELx <=1'b0;
  cb.PENABLE<=1'b0;  
//============================= Reading Back from Input Register============================//
repeat(3)@(posedge PCLK)
	cb.PSELx<=1'b1;
	cb.PADDR<=32'd2;
	cb.PWRITE<=1'b0;	
@(posedge PCLK)
	cb.PENABLE<=1'b1;
@(posedge PCLK)
  cb.PSELx <=1'b0;
  cb.PENABLE<=1'b0;

//============================= Write To Clear Register====================================// 
repeat(3)@(posedge PCLK)
	cb.PSELx<=1'b1;
	cb.PSTRB<=4'b1111;
	cb.PWRITE<=1'b1;
	cb.PADDR<=32'd5;
    cb.PWDATA <= 32'hff00_0000;
@(posedge PCLK)
	cb.PENABLE<=1'b1;
@(posedge PCLK)
  cb.PSELx <=1'b0;
  cb.PENABLE<=1'b0;
//============================== Reading Back from Input Register===========================// 
repeat(3)@(posedge PCLK)
	cb.PSELx<=1'b1;
	cb.PADDR<=32'd2;
	cb.PWRITE<=1'b0;	
@(posedge PCLK)
	cb.PENABLE<=1'b1;
@(posedge PCLK)
  cb.PSELx <=1'b0;
  cb.PENABLE<=1'b0;
//===================================== Writting To Set Register===========================//
repeat(3)@(posedge PCLK)
	cb.PSELx<=1'b1;
	cb.PSTRB<=4'b1111;
	cb.PWRITE<=1'b1;
	cb.PADDR<=32'd4;
    cb.PWDATA <= 32'hff00_0000;
@(posedge PCLK)
	cb.PENABLE<=1'b1;
@(posedge PCLK)
  cb.PSELx <=1'b0;
  cb.PENABLE<=1'b0;
//===================================== Reading Back From Input===========================//
repeat(3)@(posedge PCLK)
	cb.PSELx<=1'b1;
	cb.PADDR<=32'd2;
	cb.PWRITE<=1'b0;	
@(posedge PCLK)
	cb.PENABLE<=1'b1;
@(posedge PCLK)
  cb.PSELx <=1'b0;
  cb.PENABLE<=1'b0;
//----------------------------------------------------------------------------------------------------
//========================== Write to Direction Register ================================//
@(posedge PCLK)
	cb.PSELx<=1'b1;
	cb.PSTRB<=4'b1111;
	cb.PENABLE<=1'b0;
	cb.PWRITE<=1'b1;
	cb.PADDR<=32'd1;
    cb.PWDATA <= 32'hffff_ffff;	
@(posedge PCLK)
	cb.PENABLE<=1'b1;
@(posedge PCLK)
  cb.PSELx <=1'b0;
  cb.PENABLE<=1'b0;
//=========================== == Write To Mode Register====================================// 
repeat(3)@(posedge PCLK)
	cb.PSELx<=1'b1;
	cb.PSTRB<=4'b1111;
	cb.PWRITE<=1'b1;
	cb.PADDR<=32'd6;
    cb.PWDATA <= 32'hffff_ffff;
@(posedge PCLK)
	cb.PENABLE<=1'b1;
@(posedge PCLK)
  cb.PSELx <=1'b0;
  cb.PENABLE<=1'b0;
//============================= Write To Out Register====================================// 
repeat(3)@(posedge PCLK)
	cb.PSELx<=1'b1;
	cb.PSTRB<=4'b1111;
	cb.PWRITE<=1'b1;
	cb.PADDR<=32'd3;
    cb.PWDATA <= 32'h5555_5555;
@(posedge PCLK)
	cb.PENABLE<=1'b1;
@(posedge PCLK)
  cb.PSELx <=1'b0;
  cb.PENABLE<=1'b0;
  //============================== Reading Back from Out Register===========================// 
repeat(3)@(posedge PCLK)
	cb.PSELx<=1'b1;
	cb.PADDR<=32'd2;
	cb.PWRITE<=1'b0;	
@(posedge PCLK)
	cb.PENABLE<=1'b1;
@(posedge PCLK)
  cb.PSELx <=1'b0;
  cb.PENABLE<=1'b0;
//===============================Writting at Mode Register(addr=6)======================================// 
repeat(3)@(posedge PCLK)
	cb.PSELx<=1'b1;
	cb.PSTRB<=4'b1111;
	cb.PENABLE<=1'b0;
	cb.PWRITE<=1'b1;
	cb.PADDR<=32'd6;
	cb.PWDATA <= 32'h0000_0000;	
@(posedge PCLK)
	cb.PENABLE<=1'b1;
@(posedge PCLK)
//===============================Writting Input Register(addr=1)======================================// 
	cb.PSELx<=1'b1;
	cb.PSTRB<=4'b1111;
	cb.PENABLE<=1'b0;
	cb.PWRITE<=1'b1;
	cb.PADDR<=32'd1;
    cb.PWDATA <= 32'hff00_ff00;	
@(posedge PCLK)
	cb.PENABLE<=1'b1;
@(posedge PCLK)
//===============================Write To Out Register(addr=3)======================================//

	cb.PENABLE<=1'b0;
	cb.PSTRB<=4'b1111;
	cb.PWRITE<=1'b1;
	cb.PADDR<=32'd3;
    cb.PWDATA <= 32'hffff_ffff;
@(posedge PCLK)
	cb.PENABLE<=1'b1;
@(posedge PCLK)
  cb.PENABLE<=1'b0;
//===============================Reading Back from Out Register(addr=3)======================================//
	cb.PADDR<=32'd3;
	cb.PWRITE<=1'b0;	
@(posedge PCLK)
	cb.PENABLE<=1'b1;
@(posedge PCLK)
  cb.PENABLE<=1'b0;
//===============================Reading Back from Input Register(addr=2)======================================//
	cb.PENABLE<=1'b0;
	cb.PADDR<=32'd2;
	cb.PWRITE<=1'b0;
@(posedge PCLK)
	cb.PENABLE<=1'b1;
@(posedge PCLK)
  cb.PSELx <=1'b0;
  cb.PENABLE<=1'b0;
/*
//------------------------------------------------------------------------------------------------------------//
//--------------------------------------Writting at Intrup Regusters------------------------------------------//
//------------------------------------------------------------------------------------------------------------//
//================  Write to Intrupt Enable Register(addr=7)===============//
	@(posedge PCLK)
	@(posedge PCLK)	
	@(posedge PCLK)
	cb.PSELx<=1'b1;
	cb.PSTRB<=4'b1111;
	cb.PENABLE<=1'b0;
	cb.PWRITE<=1'b1;
	cb.PADDR<=32'd7;
    cb.PWDATA <= 32'hffff_0000;// Writting Int_Enable
@(posedge PCLK)
	cb.PENABLE<=1'b1;
@(posedge PCLK)
//============================Write to Intrupt rs-hi Register(addr=8)================================//
@(posedge PCLK)
	cb.PSELx<=1'b1;
	cb.PSTRB<=4'b1111;
	cb.PENABLE<=1'b0;
	cb.PWRITE<=1'b1;
	cb.PADDR<=32'd8;
    cb.PWDATA <= 32'hf0f0_0000;	// Writting rs_hi	
@(posedge PCLK)
	cb.PENABLE<=1'b1;
@(posedge PCLK)
//============================Write to Intrupt lo-fl Register(addr=9)================================//
@(posedge PCLK)
	cb.PSELx<=1'b1;
	cb.PSTRB<=4'b1111;
	cb.PENABLE<=1'b0;
	cb.PWRITE<=1'b1;
	cb.PADDR<=32'd9;
    cb.PWDATA <= 32'h0f0f_0000;	// Writting fl_lo	
@(posedge PCLK)
	cb.PENABLE<=1'b1;
@(posedge PCLK)
//============================Write to Intrupt rs-hi Register(addr=10)================================//
@(posedge PCLK)
	cb.PSELx<=1'b1;
	cb.PSTRB<=4'b1111;
	cb.PENABLE<=1'b0;
	cb.PWRITE<=1'b1;
	cb.PADDR<=32'd10;
    cb.PWDATA <= 32'h00ff_0000;	// Writting Intrupt_Type Register	
@(posedge PCLK)
	cb.PENABLE<=1'b1;
@(posedge PCLK)
//============================Write to Direction Register (addr=1)================================//
@(posedge PCLK)
	cb.PSELx<=1'b1;
	cb.PSTRB<=4'b1111;
	cb.PENABLE<=1'b0;
	cb.PWRITE<=1'b1;
	cb.PADDR<=32'd1;
    cb.PWDATA <= 32'hffff_ffff;// Writting Direction Register
@(posedge PCLK)
	cb.PENABLE<=1'b1;
@(posedge PCLK)
//============================Write to OutPut Register(addr=3)================================//
@(posedge PCLK)
	cb.PSELx<=1'b1;
	cb.PSTRB<=4'b1111;
	cb.PENABLE<=1'b0;
	cb.PWRITE<=1'b1;
	cb.PADDR<=32'd3;
    cb.PWDATA <= 32'h0000_0000;// Writting OutPut Register
@(posedge PCLK)
	cb.PENABLE<=1'b1;
@(posedge PCLK)
//=============================Reading back from Intrupt Registerts(addr=2)===================//
	cb.PENABLE<=1'b0;
	cb.PADDR<=32'd11;
	cb.PWRITE<=1'b0;
@(posedge PCLK)
	cb.PENABLE<=1'b1;
@(posedge PCLK)
  cb.PSELx <=1'b0;
  cb.PENABLE<=1'b0;
//================================Writting OutPut Register============================//
@(posedge PCLK)
	cb.PSELx<=1'b1;
	cb.PSTRB<=4'b1111;
	cb.PENABLE<=1'b0;
	cb.PWRITE<=1'b1;
	cb.PADDR<=32'd3;
    cb.PWDATA <= 32'hffff_0000;// Writting OutPut Register
@(posedge PCLK)
	cb.PENABLE<=1'b1;
@(posedge PCLK)
//===========================Reading back from Intrupt Registerts============================//
	cb.PENABLE<=1'b0;
	cb.PADDR<=32'd11;
	cb.PWRITE<=1'b0;
@(posedge PCLK)
	cb.PENABLE<=1'b1;
@(posedge PCLK)
  cb.PSELx <=1'b0;
  cb.PENABLE<=1'b0;
//================================Writting OutPut Register============================//
@(posedge PCLK)
	cb.PSELx<=1'b1;
	cb.PSTRB<=4'b1111;
	cb.PENABLE<=1'b0;
	cb.PWRITE<=1'b1;
	cb.PADDR<=32'd3;
    cb.PWDATA <= 32'h0000_0000;// Writting OutPut Register
@(posedge PCLK)
	cb.PENABLE<=1'b1;
@(posedge PCLK)
//================Reading back from Intrupt Status Register===================//
	cb.PENABLE<=1'b0;
	cb.PADDR<=32'd11;
	cb.PWRITE<=1'b0;
@(posedge PCLK)
	cb.PENABLE<=1'b1;
@(posedge PCLK)
  cb.PSELx <=1'b0;
  cb.PENABLE<=1'b0;
*/
//================================Display Logic============================//
	repeat(5)@(posedge PCLK);
	$display("========================All Test Cases Run Successfully========================");
	$finish;
	end
		always @(posedge PCLK) begin
	//	@(posedge PREADY)
		if(PWRITE && PREADY)
			$display("\t\tWrite Data ::%h\tAddress::%4d\t PSRTB::%4b",PWDATA,PADDR,PSTRB);
		else if(~PWRITE && PREADY)
			$display("Read Data ::%b\tAddress::%4d",PRDATA,PADDR);
 		end
endmodule
