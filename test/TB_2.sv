`include "top_GPIO_APBSlave.sv"
module apb_slave_unit_test;
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
  logic	[32-1: 0]	PRDATA_;
  logic PREADY;
  logic PSLVERR;
  logic pass_;
  wire  GPIO_pins [31:0];
// clk generator
  always begin
      #5 PCLK = ~PCLK;
  end
//DUT Instance
   top_GPIO_APBSlave mod3(.PRDATA(PRDATA_),.*); 
   
//Clocking Block 
 	default clocking cb @(posedge PCLK);
 	default input #2 output #2;
	output PRESETn, PSELx,PENABLE, PWRITE, PSTRB, PWDATA,PADDR; 
 	input PREADY, PRDATA_, PSLVERR ;
 endclocking
 
//Tasks

//Write Task-1
		task Write (input [31:0]PADDR ,input [31:0]PWDATA,input [3:0]PSTRB,input PSELx,input PENABLE);
			begin
				//$display("Write-1 Was called");
				cb.PSELx<=PSELx;	//PSELx
				cb.PSTRB<=PSTRB;	//Strob 
				cb.PENABLE<=1'b0;
				cb.PWRITE<=1'b1;
				cb.PADDR<=PADDR;	//Addr
   				cb.PWDATA <=PWDATA;	//wData
			@(posedge PCLK)
				cb.PENABLE<=PENABLE;
			@(posedge PCLK);
			end
		endtask	
//Read Task-1
		task Read(input [31:0]PADDR ,input PSELx,input PENABLE);
			begin
				cb.PSELx<=PSELx;		//PSELx
				cb.PENABLE<=1'b0;
				cb.PWRITE<=1'b0;
				cb.PADDR<=PADDR;		//ADDR
			@(posedge PCLK)
				cb.PENABLE<=PENABLE;	//Enable
			@(posedge PCLK);
			end
		endtask
		
//Initial Block
 		initial
 			begin
 			$display("\n\n\n==========================Starting Test Cases==========================\n\n\n");
 			
 		    	//Case_01:: Reset DUT consectively 
				$display("------Reseting DUT-----");
			//Reset For  (8) Cycles
    			cb.PRESETn <= 1'b0;
    			$display("\t\tWrite Data ::%h\tAddress::%d\t PSRTB::%4b",PWDATA,PADDR,PSTRB);
				repeat(8)@(posedge PCLK);
			//Deasset Reset
				cb.PRESETn <= 1'b1;
				$display("Reset::%d",PRESETn);
			@(posedge PCLK)
				$display("----Reset Completed----\n"); 
				
//---------------------------------Calling Tasks------------------------------------//	
$display("---- Single WRITE/READ after delays ----\n");

//	ADDR	      Wdata	 Strb    	Selx	Enable
//	|	        | 	   |   	  	 |	  |   
Write(32'd1 ,	32'hffff_ffff,	4'b1111,	1'b1,	1'b1);  //Writting Direction  Register
Write(32'd1 ,	32'hffff_ffff,	4'b1111, 	1'b0,	1'b0);	repeat (3)@(posedge PCLK)
//    ADDR	Selx	Enable
//	|	  | 	  |
Read(32'd1 ,	1'b1,	1'b1); 					//Reading Direction  Register
Read(32'd1 ,	1'b0,	1'b0); 					repeat (3)@(posedge PCLK)
			

//Writting Direction  Register (4'b0000)
			Write(32'd1 ,32'h1111_0000,4'b0000,1'b1,1'b1);//Strob=4'b0000
			Write(32'd1 ,32'h1111_0000,4'b0000,1'b0,1'b0);
			repeat (3)@(posedge PCLK)

//Reading Direction  Register 	(4'b0000)
			Read(32'd1 ,1'b1,1'b1);
			Read(32'd1 ,1'b0,1'b0);
			repeat (3)@(posedge PCLK)

//Writting Output Register
			Write(32'd3 ,32'h1111_0000,4'b1111,1'b1,1'b1);//Strob=4'b0000
			Write(32'd3 ,32'h1111_0000,4'b1111,1'b0,1'b0);
			repeat (3)@(posedge PCLK)

//Reading Output Register
			Write(32'd3 ,32'hf00f_f0ff,4'b0001, 1'b1,1'b1);
			Write(32'd3 ,32'hf00f_f0ff,4'b0001, 1'b0,1'b0);
			repeat (3)@(posedge PCLK)
//Reading Input Register			
			Read(32'd2 ,1'b1,1'b1);
			Read(32'd2 ,1'b0,1'b0);
	
//---------------------------------Calling Ended------------------------------------//
			repeat (3)@(posedge PCLK)
			$display("\n\n\n========================All Test Cases Run Successfully=================\n\n\n");
			$finish;
 			end
//---------------------------------Display Logic------------------------------------//
 			always @(posedge PCLK) begin
				@(posedge PREADY)
				//if(PSTRB==4'b0000 && PWRITE==1'b0)
				//$display("Check strob::4'b0");
					if(PWRITE)
						$display("\t\tWrite Data ::%h\tAddress::%d\t PSRTB::%4b",PWDATA,PADDR,PSTRB);
					else
						$display("Read Data ::%b\tAddress::%d",PRDATA_,PADDR);
//------------------------------Self Check Logic------------------------------------//
			if(PSTRB[0]==1)begin
				if(PWDATA[7:0]==PRDATA_[7:0])
					pass_=1;
			end
				else
					pass_=0;
			if(PSTRB[1]==1)begin
				if(PWDATA[15:0]==PRDATA_[15:0])
					pass_=pass_;
			end
				else
					pass_=0;
			if(PSTRB[2]==1)begin
				if(PWDATA[23:16]==PRDATA_[23:16])
					pass_=pass_;
			end
				else
					pass_=0;
			if(PSTRB[3]==1)begin
					if(PWDATA[31:23]==PRDATA_[31:23])
					pass_=pass_;
			end
				else
					pass_=0;
			if(pass_)
				$display("Test Passed");
			else
				$display("Test Failed");
//---------------------------------------------------------------------------------//
			end
 endmodule
