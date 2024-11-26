module part1(KEY, LEDR);
   
	input [1:0] KEY;
	output [9:0] LEDR; 
	
	wire Clock, Reset_n, rollover;
	wire [4:0] Q;   // k = 20 ==> need 5 bits 
	
	
	
	assign Clock = KEY[1];
	assign Reset_n = KEY[0];
	
	assign LEDR[4:0] = Q; 
	assign LEDR[9] = rollover; 
	
	
	counter my_counter (Clock, Reset_n, Q, rollover);
	defparam my_counter.n = 5; 
	defparam my_counter.k = 20;
	
	
endmodule

module counter (Clock, Reset_n, Q, rollover);
	parameter n = 4;
	parameter k = 8;
		
	input Clock, Reset_n;
	output [n-1:0] Q; 
	reg [n-1:0] Q;
	output rollover; 
	
	
	always @(posedge Clock or negedge Reset_n)
	if (!Reset_n)
			Q <= 'd0;
		else
			if ( Q == k-1)
				Q <= 'd0;
			else	
				Q <= Q + 1'b1;
				
	assign rollover = (Q == k-1) ? 1'b1 : 1'b0;			
	 
endmodule