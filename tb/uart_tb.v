module uart_tb;

  reg clk=0;
  reg [7:0]address = 8'b0000000;
  reg read = 0;
  reg write = 0;
  reg [7:0]cpu_dbus_out = 8'b0000000;
  wire tx;

  reg rx;
  wire [7:0]cpu_dbus_in;



  uart_device dut(.clk(clk),
                  .address(address),
                  .dbus_in(cpu_dbus_out),
                  .dbus_out(cpu_dbus_in),
                  .read(read),
                  .write(write),
                  .tx(tx),
                  .rx(rx));

  initial
  begin
    $dumpfile("uart_tb.vcd");
    $dumpvars();

    #35 address = 'h01;
    #40 cpu_dbus_out = 'hBB;
    #60 write = 1;
    #80 write = 0;
    #90 address = 'h02;
    cpu_dbus_out = 'h01;
    #100 write = 1;
    #110 write = 0;


    #600 $finish;
  end


  always #5 clk = !clk;


endmodule
