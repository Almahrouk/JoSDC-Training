`timescale 1ns / 1ns

module rom_tb ();
	reg	[4:0]  address;
	reg	  clock;
	reg	  rden;
	wire	[3:0]  q;
	
	rom_sim	rom_sim_inst (
	.address ( address ),
	.clock ( clock ),
	.rden ( rden ),
	.q ( q )
	);

	
	always begin // clock initialization
     clock =1'b0;
     #10;
	  clock =1'b1;
	  #10;  
     end
	
	initial
		begin
			address = 5'b00000; rden = 0;
			#20 rden = 1;
			//#10 rden = 0;
			#10 address = 5'b00010; rden = 1;
			#10 address = 5'b00011; rden = 1;
			#30 address = 5'b00111; rden = 0;
		end
		
		initial begin #100 $stop;
		end

endmodule