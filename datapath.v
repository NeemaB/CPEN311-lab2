module datapath_clear(clock, resetb, initx, inity, loadx, loady,  xdone, ydone, x, y, colour);

	input clock, initx, inity, loadx, loady, resetb;
	output xdone, ydone;
	output reg [7:0] x;
	output reg [6:0] y;
	output [2:0] colour;
	
	wire [7:0] xnext, xplus1;
	wire [6:0] ynext, yplus1;
	
	`define BLACK 0
	
	assign xnext = (initx == 1) ? 0 : xplus1;
	assign ynext = (inity == 1) ? 0 : yplus1;
	
	assign xdone = (x == 160) ? 1 : 0;
	assign ydone = (y == 120) ? 1 : 0;
	
	assign xplus1 = x + 1;
	assign yplus1 = y + 1;
	
	assign colour = `BLACK;
	//assign colour = x % 8, this is the code for task 2
	
	always_ff @(posedge clock, negedge resetb) begin
		
		if(resetb == 0) begin
			x = 0;
			y = 0;
		end
			
		else begin 
			if(loadx == 1)
				x = xnext;
			if(loady == 1)
				y = ynext;
		end
		
	end	
	
endmodule
			
		
		
	
		
	
