`timescale 1ns / 1ps


module z80system_tb(
);

    reg clk;
    reg reset =0 ;
    wire s_rx;
    wire s_tx;
    wire [7:0] dbus_out;
    wire [15:0] address;
    wire [7:0] dbus_in;
    wire [7:0] charout;

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
        .charout(charout),
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
