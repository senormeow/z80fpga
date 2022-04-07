`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date:   16:30:17 03/10/2022
// Design Name:   tv80n
// Module Name:   /home/ise/esalazar/fpga/z80fpga/ise/tv80_tb.v
// Project Name:  z80fpga
// Target Device:
// Tool versions:
// Description:
//
// Verilog Test Fixture created by ISE for module: tv80n
//
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
////////////////////////////////////////////////////////////////////////////////

module tv80_tb;

  reg clk;
  reg reset =0 ;
  wire s_rx;
  wire s_tx;
  wire [7:0] dbus_out;
  wire [15:0] address;
  wire [7:0] dbus_in;

  wire rd_n;
  wire wr_n;
  wire mreq_n;
  wire iorq_n;



  z80_system system(.clk(clk),
                    .reset(reset),
                    .s_rx(s_rx),
                    .s_tx(s_tx),
                    .dbus_out(dbus_out),
                    .dbus_in(dbus_in),
                    .address(address),
                    .rd_n(rd_n),
                    .wr_n(wr_n),
                    .mreq_n(mreq_n),
                    .iorq_n(iorq_n));


  initial
  begin
    // Initialize Inputs
    reset = 1;
    clk = 0;

    //di = 0;

    // Wait 100 ns for global reset to finish
    #10;
    // Add stimulus here
    #11 reset = 0;
	 
  end

  always
  begin
    #2 clk= !clk;
  
	 //if(address == 'hFFFF)
	 //   $finish;
  end
endmodule

