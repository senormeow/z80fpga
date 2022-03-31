///////////////////////////////////////////////////////
// RS-232 RX and TX module
// Modified from fpga4fun.com & KNJN LLC
//`define SIMULATION
//Generate a Uart device that we can wire in
module uart_device(clk, enable, address, dbus_in, dbus_out, write, tx, rx);
  input wire clk;
  input wire enable;
  input wire [7:0]address;
  input wire write;
  input wire [7:0]dbus_in;
  input wire rx;

  output reg [7:0]dbus_out;
  output wire tx;

  wire TxD_busy;
  reg TxD_start = 0;
  reg [7:0]TxD_data = 0;

  always @(posedge enable)
  begin
    if(enable && address == 8'h10 && !write)
      dbus_out <= 8'h00 + TxD_busy;

    if(enable && address == 8'h11 && write)
      TxD_data <= dbus_in;

    if(enable && address == 8'h11 && !write)
      dbus_out <= TxD_data;


  end

  always @(enable, clk)
  begin
    if(enable && address == 8'h12 && dbus_in == 8'h01 && write)
        TxD_start <= 1;

    if(TxD_start == 1 && TxD_busy == 1)
      TxD_start <= 0;
  end

  uart_tx uart_tx_1(.clk(clk),
                    .TxD_start(TxD_start),
                    .TxD_data(TxD_data),
                    .TxD(tx),
                    .TxD_busy(TxD_busy));


endmodule


module uart_tx(
    input clk,
    input TxD_start,
    input [7:0] TxD_data,
    output TxD,
    output TxD_busy
  );

  // Assert TxD_start for (at least) one clock cycle to start transmission of TxD_data
  // TxD_data is latched so that it doesn't have to stay valid while it is being sent

  parameter ClkFrequency = 25000000;	// 25MHz
  parameter Baud = 115200;

  //parameter ClkFrequency = 1_000_000;	// 1MHz
  //parameter Baud = 9600;

  generate
    if(ClkFrequency<Baud*8 && (ClkFrequency % Baud!=0))
      ASSERTION_ERROR PARAMETER_OUT_OF_RANGE("Frequency incompatible with requested Baud rate");
  endgenerate

  ////////////////////////////////
`ifdef SIMULATION

  wire BitTick = 1'b1;  // output one bit per clock cycle
`else
  wire BitTick;
  BaudTickGen #(ClkFrequency, Baud) tickgen(.clk(clk), .enable(TxD_busy), .tick(BitTick));
`endif

  reg [3:0] TxD_state = 0;
  wire TxD_ready = (TxD_state==0);
  assign TxD_busy = ~TxD_ready;

  reg [7:0] TxD_shift = 0;
  always @(posedge clk)
  begin
    if(TxD_ready & TxD_start)
      TxD_shift <= TxD_data;
    else
      if(TxD_state[3] & BitTick)
        TxD_shift <= (TxD_shift >> 1);

    case(TxD_state)
      4'b0000:
        if(TxD_start)
          TxD_state <= 4'b0100;
      4'b0100:
        if(BitTick)
          TxD_state <= 4'b1000;  // start bit
      4'b1000:
        if(BitTick)
          TxD_state <= 4'b1001;  // bit 0
      4'b1001:
        if(BitTick)
          TxD_state <= 4'b1010;  // bit 1
      4'b1010:
        if(BitTick)
          TxD_state <= 4'b1011;  // bit 2
      4'b1011:
        if(BitTick)
          TxD_state <= 4'b1100;  // bit 3
      4'b1100:
        if(BitTick)
          TxD_state <= 4'b1101;  // bit 4
      4'b1101:
        if(BitTick)
          TxD_state <= 4'b1110;  // bit 5
      4'b1110:
        if(BitTick)
          TxD_state <= 4'b1111;  // bit 6
      4'b1111:
        if(BitTick)
          TxD_state <= 4'b0010;  // bit 7
      4'b0010:
        if(BitTick)
          TxD_state <= 4'b0011;  // stop1
      4'b0011:
        if(BitTick)
          TxD_state <= 4'b0000;  // stop2
      default:
        if(BitTick)
          TxD_state <= 4'b0000;
    endcase
  end

  assign TxD = (TxD_state<4) | (TxD_state[3] & TxD_shift[0]);  // put together the start, data and stop bits
endmodule

////////////////////////////////////////////////////////
module BaudTickGen(
    input clk, enable,
    output tick  // generate a tick at the specified baud rate * oversampling
  );
  parameter ClkFrequency = 25000000;
  parameter Baud = 115200;
  parameter Oversampling = 1;

  function integer log2(input integer v);
    begin
      log2=0;
      while(v>>log2)
        log2=log2+1;
    end
  endfunction
  localparam AccWidth = log2(ClkFrequency/Baud)+8;  // +/- 2% max timing error over a byte
  reg [AccWidth:0] Acc = 0;
  localparam ShiftLimiter = log2(Baud*Oversampling >> (31-AccWidth));  // this makes sure Inc calculation doesn't overflow
  localparam Inc = ((Baud*Oversampling << (AccWidth-ShiftLimiter))+(ClkFrequency>>(ShiftLimiter+1)))/(ClkFrequency>>ShiftLimiter);
  always @(posedge clk) if(enable)
      Acc <= Acc[AccWidth-1:0] + Inc[AccWidth:0];
    else
      Acc <= Inc[AccWidth:0];
  assign tick = Acc[AccWidth];
endmodule
