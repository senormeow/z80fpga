`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date:    22:15:04 03/10/2022
// Design Name:
// Module Name:    top
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
`timescale 1ns/1ps
module top(
    input clk_50MHz,
    input rst,
    input rst2,
    //input  [7:0] sw,

    output [6:0] seg,
    output       dp,
    output [3:0] anode,
    output [7:0] Led,
	 output tx,
	 output clkout

  );

  /*
      TEMPORARY
      - Using a counter to generate a slower clock, which
        is not good FPGA design practice but will work in this
        case since it's a low-speed design.
      - Use DCM's for clock manipulation needs (good practice)
      using 'counter[16]' divides the 50_MHz clock by 131,072 (2^17)
      resulting in... 
          frequency = 381.469_Hz
          period    = 2.621_ms
      each refresh period takes 4 clock cycles, so the refresh period is
          refresh_period = 10.485_ms
      which falls in-between a required refresh period of 1_ms ~ 16_ms
  */
  reg [21:0] counter = 22'd0;
  always @(posedge clk_50MHz or posedge rst)
  begin
    if(rst)
    begin
      counter <= 0;
    end
    else
    begin
      counter <= counter + 1'b1;
    end
  end

  wire [4:0] data_digit0;
  wire [4:0] data_digit1;
  wire [4:0] data_digit2;
  wire [4:0] data_digit3;

  wire dispclk = counter[16];

  //turn off decimal always
  assign data_digit0[4] = 1'b1;
  assign data_digit1[4] = 1'b1;
  assign data_digit2[4] = 1'b1;
  assign data_digit3[4] = 1'b1;


  sev_segdriver dut(
                  .clk         (dispclk),
                  .rst         (rst),

                  .seg         (seg),
                  .dp          (dp),
                  .anode       (anode),

                  .data_digit0 (data_digit0),
                  .data_digit1 (data_digit1),
                  .data_digit2 (data_digit2),
                  .data_digit3 (data_digit3)
                );

  wire cpuclk;
  assign clkout = cpuclk;

  clockDiv oneMhzClk (
    .clk(clk_50MHz), 
    .reset(rst), 
    .clk_out(cpuclk)
    );


  wire s_rx;
  wire s_tx;
  assign tx = s_tx;
  wire [7:0] dbus_out;
  wire [15:0] address;
  wire [7:0] dbus_in;
  wire [7:0] charout;
  wire rd_n;
  wire wr_n;
  wire mreq_n;
  wire iorq_n;

  assign Led[7:0] = dbus_in;

	  z80_system system(.clk(cpuclk),
                   .reset(rst2),
                   .s_rx(s_rx),
                   .s_tx(s_tx),
                   .dbus_out(dbus_out),
                   .dbus_in(dbus_in),
						 .charout(charout),
                   .address(address),
                   .rd_n(rd_n),
                   .wr_n(wr_n),
                   .mreq_n(mreq_n),
                   .iorq_n(iorq_n));



  /*
    reg [15:0] counter_for_display = 16'd0;
    always @(posedge counter[20] or posedge rst)
    begin
      if(rst)
      begin
        counter_for_display = 16'd0;
      end
      else
      begin
        counter_for_display = counter_for_display + 1'b1;
      end
    end
  */



  assign data_digit0[3:0] = charout[3:0];
  assign data_digit1[3:0] = charout[7:4];
  assign data_digit2[3:0] = 0;
  assign data_digit3[3:0] = 0;



endmodule
