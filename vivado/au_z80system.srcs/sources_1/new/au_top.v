module au_top(
    input clk,
    input rst_n,
    output[7:0] led,
    input usb_rx,
    output usb_tx,
    output wire [23:0] io_led,
    output wire [7:0] io_seg,
    output wire [3:0] io_sel,
    input [4:0] io_button
);

    wire rst;
    wire cpuclk;
    wire ledclk;
    wire [6:0] led_seg;
    wire [3:0] led_sel;

    wire s_rx;
    wire s_tx;

    wire rst2;
    assign rst2 = io_button[0];
    
    assign io_led[9] = io_button[0];
    assign io_led[10] = io_button[1];
    assign io_led[11] = io_button[2];
    assign io_led[12] = io_button[3];
    assign io_led[13] = io_button[4];

    assign usb_tx = s_tx;

    wire [7:0] dbus_out;
    wire [15:0] address;
    wire [7:0] dbus_in;
    wire [7:0] charout;
    wire rd_n;
    wire wr_n;
    wire mreq_n;
    wire iorq_n;

    assign io_led[23:15] = dbus_in;

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




    assign io_sel = led_sel;
    assign io_seg = led_seg;

    wire [4:0] data_digit0;
    wire [4:0] data_digit1;
    wire [4:0] data_digit2;
    wire [4:0] data_digit3;

    assign io_led[0] = ledclk;

    reset_conditioner reset_conditioner(.clk(clk), .in(!rst_n), .out(rst));


    clockDiv #(.WIDTH(8), .N(50)) onemhzclk (
        .clk(clk),
        .reset(rst),
        .clk_out(cpuclk));

    clockDiv #(.WIDTH(32), .N(2000)) ledclkdiv (
        .clk(cpuclk),
        .reset(rst),
        .clk_out(ledclk));


    sev_segdriver sevenseg (
        .clk(ledclk),
        .rst(rst),
        .data_digit0(data_digit0),
        .data_digit1(data_digit1),
        .data_digit2(data_digit2),
        .data_digit3(data_digit3),
        .seg(led_seg),
        .anode(led_sel)
    );


    assign data_digit0[3:0] = 0;
    assign data_digit1[3:0] = 0;
    assign data_digit2[3:0] = charout[3:0];
    assign data_digit3[3:0] = charout[7:4];


    assign led = rst ? 8'hAA : 8'h55;
    
endmodule
