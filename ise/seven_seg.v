/******************************************************************************************
*   sev_segdriver.v - An easy-to-use 7-segment display driver
*******************************************************************************************
* 
* Author: David Hong
*
* Handles the required multiplexing and data conversion to properly display 
* a value on the 7-seg display. Four input buses correspond to each of the four
* digits of the display (data_digit0, data_digit1, data_digit2, and data_digit3) 
* Simply pass in a 5-bit value into the appropriate bus for display.
*	- Bit-5 is for the decimal point, and Bit-4 to Bit-1 is for segment data.
*
*  Example: If you want to display '9.' on the leftmost digit, pass 
*			   5'b1_1001 into 'data_digit3'
*  Example: If you want to display '1' on the rightmost digit, pass
*              5'b0_0001 into 'data_digit0'
* 
* This module is only capapble of outputting the following characters on the display
*    0, 1, 2, 3, 4, 5, 6, 7, 8, 9, A, b, C, d, E, F
* Modifying the code to handle other characters shouldn't be too difficult.
*
* NOTES (refer to Basys2 manual for a in-depth description of 7-segment operation)
*	- Each of the four digits should be displayed once every 1_ms ~ 16.667_ms, corresponding
*	  to a refresh rate of 1_kHz ~ 60_Hz (respectively) so the human-eye cannot discern the 
*	  multiplexing, and the display looks continually lit.
*	- "clk" should therefore be anywhere from 4_kHz ~ 250_Hz
*		- 250 Hz should be fine. Using a higher clk frequency is not necessary for 
*		  basic display applications.
******************************************************************************************/

`timescale 1ns/1ps

module sev_segdriver(
	input clk,
	input rst, //asynchronous reset

	//bit-4 is for decimal point, bit-3 to bit-0 is for segment data
	input [4:0] data_digit0,
	input [4:0] data_digit1,
	input [4:0] data_digit2,
	input [4:0] data_digit3,

	/*
		Connect these directly to Basys2 output
		- seg[6] => CG
		  ...
		  seg[0] => CA
		- anode[0] => an0
		  ...
		  anode[3] => an3
	*/
	output [6:0] seg,
	output       dp,  //Decimal Point
	output [3:0] anode
	);

	/*
		Conversions: desired value to display converted to appropriate bit-vector
	*/
	localparam BLANK = 7'b1111_111;
	localparam ZERO  = 7'b1000_000; 
	localparam ONE   = 7'b1111_001;
	localparam TWO   = 7'b0100_100;
	localparam THREE = 7'b0110_000;
	localparam FOUR  = 7'b0011_001;
	localparam FIVE  = 7'b0010_010;
	localparam SIX   = 7'b0000_010;
	localparam SEVEN = 7'b1111_000;
	localparam EIGHT = 7'b0000_000;
	localparam NINE  = 7'b0010_000;
	localparam A     = 7'b0001_000;
	localparam B     = 7'b0000_011;
	localparam C     = 7'b1000_110;
	localparam D     = 7'b0100_001;
	localparam E     = 7'b0000_110;
	localparam F     = 7'b0001_110;

	reg [7:0] converted_data_digit0;
	reg [7:0] converted_data_digit1;
	reg [7:0] converted_data_digit2;
	reg [7:0] converted_data_digit3;

	always @(data_digit0[4] or data_digit1[4] or data_digit2[4] or data_digit3[4]) begin
		converted_data_digit0[7] <= data_digit0[4];
		converted_data_digit1[7] <= data_digit1[4];
		converted_data_digit2[7] <= data_digit2[4];
		converted_data_digit3[7] <= data_digit3[4];
	end

	//conversions are combinatorial-logic (not synchronous with clock)
	always @(data_digit0[3:0] or data_digit1[3:0] or data_digit2[3:0] or data_digit3[3:0]) begin
		case(data_digit0[3:0])
			4'h0 : converted_data_digit0[6:0] <= ZERO;      
			4'h1 : converted_data_digit0[6:0] <= ONE;     
			4'h2 : converted_data_digit0[6:0] <= TWO;        
			4'h3 : converted_data_digit0[6:0] <= THREE;   
			4'h4 : converted_data_digit0[6:0] <= FOUR;    
			4'h5 : converted_data_digit0[6:0] <= FIVE;    
			4'h6 : converted_data_digit0[6:0] <= SIX;     
			4'h7 : converted_data_digit0[6:0] <= SEVEN;   
			4'h8 : converted_data_digit0[6:0] <= EIGHT;   
			4'h9 : converted_data_digit0[6:0] <= NINE;    
			4'hA : converted_data_digit0[6:0] <= A;       
			4'hB : converted_data_digit0[6:0] <= B;       
			4'hC : converted_data_digit0[6:0] <= C;       
			4'hD : converted_data_digit0[6:0] <= D;       
			4'hE : converted_data_digit0[6:0] <= E;       
			4'hF : converted_data_digit0[6:0] <= F;         
			default : converted_data_digit0[6:0] <= BLANK;  
		endcase

		case(data_digit1[3:0])
			4'h0 : converted_data_digit1[6:0] <= ZERO;    
			4'h1 : converted_data_digit1[6:0] <= ONE;     
			4'h2 : converted_data_digit1[6:0] <= TWO;     
			4'h3 : converted_data_digit1[6:0] <= THREE;   
			4'h4 : converted_data_digit1[6:0] <= FOUR;    
			4'h5 : converted_data_digit1[6:0] <= FIVE;    
			4'h6 : converted_data_digit1[6:0] <= SIX;     
			4'h7 : converted_data_digit1[6:0] <= SEVEN;   
			4'h8 : converted_data_digit1[6:0] <= EIGHT;   
			4'h9 : converted_data_digit1[6:0] <= NINE;    
			4'hA : converted_data_digit1[6:0] <= A;       
			4'hB : converted_data_digit1[6:0] <= B;       
			4'hC : converted_data_digit1[6:0] <= C;       
			4'hD : converted_data_digit1[6:0] <= D;       
			4'hE : converted_data_digit1[6:0] <= E;       
			4'hF : converted_data_digit1[6:0] <= F;       
			default : converted_data_digit1[6:0] <= BLANK;			
		endcase

		case(data_digit2[3:0])
			4'h0 : converted_data_digit2[6:0] <= ZERO;    
			4'h1 : converted_data_digit2[6:0] <= ONE;     
			4'h2 : converted_data_digit2[6:0] <= TWO;     
			4'h3 : converted_data_digit2[6:0] <= THREE;   
			4'h4 : converted_data_digit2[6:0] <= FOUR;    
			4'h5 : converted_data_digit2[6:0] <= FIVE;    
			4'h6 : converted_data_digit2[6:0] <= SIX;     
			4'h7 : converted_data_digit2[6:0] <= SEVEN;   
			4'h8 : converted_data_digit2[6:0] <= EIGHT;   
			4'h9 : converted_data_digit2[6:0] <= NINE;    
			4'hA : converted_data_digit2[6:0] <= A;       
			4'hB : converted_data_digit2[6:0] <= B;       
			4'hC : converted_data_digit2[6:0] <= C;       
			4'hD : converted_data_digit2[6:0] <= D;       
			4'hE : converted_data_digit2[6:0] <= E;       
			4'hF : converted_data_digit2[6:0] <= F;       
			default : converted_data_digit2[6:0] <= BLANK;
		endcase

		case(data_digit3[3:0])
			4'h0 : converted_data_digit3[6:0] <= ZERO;    
			4'h1 : converted_data_digit3[6:0] <= ONE;     
			4'h2 : converted_data_digit3[6:0] <= TWO;     
			4'h3 : converted_data_digit3[6:0] <= THREE;   
			4'h4 : converted_data_digit3[6:0] <= FOUR;    
			4'h5 : converted_data_digit3[6:0] <= FIVE;    
			4'h6 : converted_data_digit3[6:0] <= SIX;     
			4'h7 : converted_data_digit3[6:0] <= SEVEN;   
			4'h8 : converted_data_digit3[6:0] <= EIGHT;   
			4'h9 : converted_data_digit3[6:0] <= NINE;    
			4'hA : converted_data_digit3[6:0] <= A;       
			4'hB : converted_data_digit3[6:0] <= B;       
			4'hC : converted_data_digit3[6:0] <= C;       
			4'hD : converted_data_digit3[6:0] <= D;       
			4'hE : converted_data_digit3[6:0] <= E;       
			4'hF : converted_data_digit3[6:0] <= F;       
			default : converted_data_digit3[6:0] <= BLANK;
		endcase
	end

	/*
		Store input data into registers. Synch registers with clock
	*/
	reg [7:0] data_digit0_r;
	reg [7:0] data_digit1_r;
	reg [7:0] data_digit2_r;
	reg [7:0] data_digit3_r;
	always @(posedge clk or posedge rst) begin
		if(rst) begin
			data_digit0_r <= 8'd0;
			data_digit1_r <= 8'd0;
			data_digit2_r <= 8'd0;
			data_digit3_r <= 8'd0;
		end
		else begin
			data_digit0_r <= converted_data_digit0;
			data_digit1_r <= converted_data_digit1;
			data_digit2_r <= converted_data_digit2;
			data_digit3_r <= converted_data_digit3;
		end
	end

	/*
		Main statemachine to drive display
		- Uses one-hot encoding (generally good practice)
	*/
	reg [4:0] currentState;
	reg [4:0] nextState;

	localparam IDLE          = 5'b00001;
	localparam DRIVE_DIGIT_0 = 5'b00010;
	localparam DRIVE_DIGIT_1 = 5'b00100;
	localparam DRIVE_DIGIT_2 = 5'b01000;
	localparam DRIVE_DIGIT_3 = 5'b10000;

	// State register run by clock, w/ asynch. reset
	always @(posedge clk or posedge rst) begin
		if(rst) begin
			currentState <= IDLE;
		end
		else begin
			currentState <= nextState;
		end
	end

	//these registers are driven by the statemachine
	//and hook directly to output ports
	reg [6:0] seg_r;
	reg       dp_r;
	reg [3:0] anode_r;

	assign seg   = seg_r;
	assign dp    = dp_r;
	assign anode = anode_r;

	always @(currentState or data_digit0_r or data_digit1_r or data_digit2_r or data_digit3_r) begin
		//default assertions
		seg_r   <= BLANK;
		dp_r    <= 1'b1;
		anode_r <= 4'b1111;

		case(currentState)
			IDLE : begin
				nextState <= DRIVE_DIGIT_0;
			end

			DRIVE_DIGIT_0 : begin
				seg_r     <= data_digit0_r[6:0];
				dp_r      <= data_digit0_r[7];
				anode_r   <= 4'b1110;
				nextState <= DRIVE_DIGIT_1;
			end

			DRIVE_DIGIT_1 : begin
				seg_r     <= data_digit1_r[6:0];
				dp_r      <= data_digit1_r[7];
				anode_r   <= 4'b1101;
				nextState <= DRIVE_DIGIT_2;
			end

			DRIVE_DIGIT_2 : begin
				seg_r     <= data_digit2_r[6:0];
				dp_r      <= data_digit2_r[7];
				anode_r   <= 4'b1011;
				nextState <= DRIVE_DIGIT_3;
			end

			DRIVE_DIGIT_3 : begin
				seg_r     <= data_digit3_r[6:0];
				dp_r      <= data_digit3_r[7];
				anode_r   <= 4'b0111;
				nextState <= DRIVE_DIGIT_0;
			end

			default : begin
				nextState <= IDLE;
			end
		endcase
	end



endmodule