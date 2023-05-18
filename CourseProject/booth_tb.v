`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   20:38:04 05/01/2023
// Design Name:   booth
// Module Name:   C:/Users/user/Desktop/fpga/cousreproj/booth_tb.v
// Project Name:  cousreproj
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: booth
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module booth_tb;

	// Inputs
	reg [3:0] a;
	reg [3:0] b;
   reg clk;
	reg rst;
	// Outputs
	wire [7:0] c;

	// Instantiate the Unit Under Test (UUT)
	booth uut (
		.a(a), 
		.b(b), 
		.c(c),
		.rst(rst),
		.clk(clk)
	);

	initial begin
		// Initialize Inputs
		rst=1;
		clk=0;
		#10;
		a = 6;
		b = -3;
      rst=0;
		#50
		rst=1;
		#5
		a = -4;
		b = -2;
      rst=0;
		#50
		rst=1;
		#5
		a = -6;
		b = 3;
      rst=0;
		#50
		rst=1;
		#5
		a = 4;
		b = 2;
      rst=0;
		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here

	end
      
		always #5 clk=~clk;
endmodule

