`timescale 100ns / 100ps
module z80_test;

  reg clk = 0;
  reg reset = 0;
  reg [7:0] di = 0;

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
    $dumpfile("z80_top.vcd");
    $dumpvars();
    $from_myhdl(clk, reset);
    $to_myhdl(dbus_out,address, dbus_in);
  end

  // initial begin
  //     $dumpfile("z80_top.vcd");
  //     $dumpvars();
  // end

endmodule
