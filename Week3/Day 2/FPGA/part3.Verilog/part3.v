module part3 (CLOCK_50, KEY, SW, HEX5, HEX4, HEX3, HEX2, HEX1, HEX0);
	input CLOCK_50;
	input [1:0] KEY;
	input [7:0] SW;
	output [0:6] HEX5, HEX4, HEX3, HEX2, HEX1, HEX0;

	
	wire Clock, Reset_n, enable, roll_one_Hundredth;
	wire [3:0] H1, H0;	// HH
	wire [3:0] S1, S0;	// SS
	wire [3:0] M1, M0;	// MM
	wire roll_H0, roll_H1, roll_S0, roll_S1, roll_M0, roll_M1;
	wire en_H0, en_H1, en_S0, en_S1, en_M0, en_M1;
	
	
	assign Clock = CLOCK_50;
	assign Reset_n = KEY[1];
	assign enable = KEY[0];
		
	//implementation 
	
	counter slow_clock (Clock, Reset_n, enable, ,roll_one_Hundredth); 
		defparam slow_clock.n = 19;
		defparam slow_clock.k = 500000;
	
	assign en_H0 = roll_one_Hundredth;
	counter H0_count (Clock, Reset_n,en_H0, H0, roll_H0);
		defparam H0_count.n = 4;
		defparam H0_count.k = 10;
		
	assign en_H1 = roll_H0 & en_H0 ;
	counter H1_count (Clock, Reset_n,en_H1, H1, roll_H1);
		defparam H1_count.n = 4;
		defparam H1_count.k = 10;
		
	
	assign en_S0 = roll_H1 & en_H1 ;
	counter S0_count (Clock, Reset_n,en_S0, S0, roll_S0);
		defparam S0_count.n = 4;
		defparam S0_count.k = 10;
		
	
	assign en_S1 = roll_S0 & en_S0 ;
	counter S1_count (Clock, Reset_n,en_S1, S1, roll_S1);
		defparam S1_count.n = 3;
		defparam S1_count.k = 6;	
		
		
	assign en_M0 = roll_S1 & en_S1 ;
	counter_with_load M0_count (Clock, KEY[1], SW[3:0] ,en_M0, M0, roll_M0);
		defparam M0_count.n = 4;
		defparam M0_count.k = 10;
		
	
	assign en_M1 = roll_M0 & en_M0 ;
	counter_with_load M1_count (Clock, KEY[1], SW[7:4] ,en_M1, M1, roll_M1);
		defparam M1_count.n = 3;
		defparam M1_count.k = 6;	
		
	
	// drive the displays
	bcd7seg digit5 (M1, HEX5);
	bcd7seg digit4 (M0, HEX4);
	bcd7seg digit3 (S1, HEX3);
	bcd7seg digit2 (S0, HEX2);
	bcd7seg digit1 (H1, HEX1);
	bcd7seg digit0 (H0, HEX0);
endmodule
			
module counter (Clock, Reset_n, enable, Q, rollover);
	
	parameter n = 4;
	parameter k = 16;
	
	input 		Clock, Reset_n, enable;
	output		rollover;
	output reg	[n-1:0] Q;
	
	always @ (posedge Clock or negedge Reset_n)
		if (~Reset_n)
			Q <= 'd0;
		else if (enable)
		begin
			if (Q == k-1)
				Q <= 'd0;
			else
				Q <= Q + 1'b1;
		end
				
	assign rollover = (Q == k-1);
endmodule


module counter_with_load (Clock, load, data, enable, Q, rollover);
	
	parameter n = 4;
	parameter k = 16;
	
	input 		Clock, load, enable;
	input [n-1:0] data; 
	output		rollover;
	output reg	[n-1:0] Q;
	
	always @ (posedge Clock)
		if (~load)
			Q <= data;
		else if (enable)
		begin
			if (Q == k-1)
				Q <= 'd0;
			else
				Q <= Q + 1'b1;
		end
				
	assign rollover = (Q == k-1);
endmodule



module bcd7seg (bcd, display);
	/******************************************************************/
	/****      PORT DECLARATIONS                                   ****/
	/******************************************************************/
	input [3:0] bcd;
	output reg [0:6] display;
	
	/******************************************************************/
	/****      IMPLEMENTATION                                      ****/
	/******************************************************************/
	/*
	 *       0  
	 *      ---  
	 *     |   |
	 *    5|   |1
	 *     | 6 |
	 *      ---  
	 *     |   |
	 *    4|   |2
	 *     |   |
	 *      ---  
	 *       3  
	 */
	always @ (bcd)
		case (bcd)
			4'h0: display = 7'b0000001;
			4'h1: display = 7'b1001111;
			4'h2: display = 7'b0010010;
			4'h3: display = 7'b0000110;
			4'h4: display = 7'b1001100;
			4'h5: display = 7'b0100100;
			4'h6: display = 7'b0100000;
			4'h7: display = 7'b0001111;
			4'h8: display = 7'b0000000;
			4'h9: display = 7'b0000100;
			default: display = 7'b1111111;
		endcase
endmodule
