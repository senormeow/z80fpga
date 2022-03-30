`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    04:35:33 03/11/2022 
// Design Name: 
// Module Name:    memory 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module memory(mem_out, addr, mem_in, we, clk);
   output[7:0] mem_out;
   input [7:0] mem_in;
   input [9:0] addr;
   input we, clk;
	reg [7:0] mem_out = 254;
   //reg [7:0] mem [1023:0];
   reg [7:0] mem [0:1023];
	
	initial
		begin
	$readmemh("rom.mem", mem);
	end
	
    always @(posedge clk) begin
        if (we) begin
            mem[addr] <= mem_in;
		  end
        mem_out = mem[addr];
   end
endmodule
