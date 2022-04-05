module z80_system(clk,
                    reset,
                    s_rx,
                    s_tx,
                    dbus_in,
                    dbus_out,
                    address,
						  charout,
                    rd_n,
                    wr_n,
                    mreq_n,
                    iorq_n);

  input wire clk;
  input wire reset;
  input wire s_rx;

  output reg [7:0]dbus_in;
  output wire s_tx;
  output wire [15:0]address;
  output wire [7:0]dbus_out;
  output reg [7:0] charout = 0;
  output wire rd_n;
  output wire wr_n;
  output wire mreq_n;
  output wire iorq_n;

  wire reset_n;

  reg on = 1;


  tv80n cpu (.clk(clk),
             .reset_n(reset_n),
             .wait_n(on),
             .nmi_n(on),
             .int_n(on),
             .busrq_n(on),
             .di(dbus_in),
             //OUT
             .do(dbus_out),
             .A(address),
             .rd_n(rd_n),
             .wr_n(wr_n),
             .mreq_n(mreq_n),
             .iorq_n(iorq_n)
            );

  assign reset_n = ! reset;

  wire mem_wr = (!wr_n && !mreq_n);
  wire [9:0] memaddr;
  wire [7:0] io_addr;
  wire [7:0] mem_din = dbus_out[7:0];
  wire [7:0] mem_dout;
  wire [7:0] uart_dout;




  //assign dbus_in[7:0] = mem_dout[7:0];
  assign memaddr[9:0] = address[9:0];
  assign io_addr[7:0] = address[7:0];

  wire write;
  wire uart_enable;

  assign uart_enable = !iorq_n;
  assign write = !wr_n;

  memory mymem(
           .clk(clk),
           .we(mem_wr),
           .addr(memaddr),
           .mem_in(mem_din),
           .mem_out(mem_dout)
         );


  uart_device myuart(.clk(clk),
                     .enable(uart_enable),
                     .address(io_addr),
                     .dbus_in(dbus_out),
                     .dbus_out(uart_dout),
                     .write(write),
                     .tx(s_tx),
                     .rx(s_rx));


  always @(clk)
  begin
    if(iorq_n)
      dbus_in <= mem_dout;
    else
      dbus_in <= uart_dout;
  end


  //always @(negedge iorq_n)
    always @(clk)
    if(!iorq_n && !wr_n && address[7:0] == 'hBB)
      charout <= dbus_out;
endmodule

