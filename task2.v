

module task2 (CLOCK_50, 
		 KEY,             
       VGA_R, VGA_G, VGA_B, 
       VGA_HS,             
       VGA_VS,             
       VGA_BLANK,           
       VGA_SYNC,            
       VGA_CLK);
  
input CLOCK_50;
input [3:0] KEY;
output [9:0] VGA_R, VGA_G, VGA_B; 
output VGA_HS;             
output VGA_VS;          
output VGA_BLANK;           
output VGA_SYNC;            
output VGA_CLK;

// Some constants that might be useful for you

parameter SCREEN_WIDTH = 160;
parameter SCREEN_HEIGHT = 120;

parameter BLACK = 3'b000;
parameter BLUE = 3'b001;
parameter GREEN = 3'b010;
parameter YELLOW = 3'b110;
parameter RED = 3'b100;
parameter WHITE = 3'b111;

  // To VGA adapter
  
wire resetn;
wire [7:0] x;
wire [6:0] y;
reg [2:0] colour;
reg plot;
   
// instantiate VGA adapter 
	
vga_adapter #( .RESOLUTION("160x120"))
    vga_u0 (.resetn(KEY[3]),
	         .clock(CLOCK_50),
			   .colour(colour),
			   .x(x),
			   .y(y),
			   .plot(plot),
			   .VGA_R(VGA_R),
			   .VGA_G(VGA_G),
			   .VGA_B(VGA_B),	
			   .VGA_HS(VGA_HS),
			   .VGA_VS(VGA_VS),
			   .VGA_BLANK(VGA_BLANK),
			   .VGA_SYNC(VGA_SYNC),
			   .VGA_CLK(VGA_CLK));


// Your code to fill the screen goes here. 

wire initx, inity, loadx, loady, xdone, ydone; 
wire init_crit, init_offsetx, init_offsety, load_crit, load_offsety, load_offsetx, crit_condition, offset_condition;

wire [7:0] x1, x2;
wire [6:0] y1, y2;
wire [2:0] colour1, colour2;
wire [3:0] pixel;



datapath_clear dp1(.clock(CLOCK_50), 
				   .resetb(KEY[3]), 
				   .initx(initx), 
				   .inity(inity), 
				   .loadx(loadx), 
				   .loady(loady), 
				   .xdone(xdone), 
				   .ydone(ydone), 
				   .x(x1), 
				   .y(y1), 
				   .colour(colour1));
			
datapath_circle dp2(.clock(CLOCK_50),
					.resetb(KEY[3]),
					.pixel(pixel),
					.init_crit(init_crit), 
					.init_offsety(init_offsety), 
					.init_offsetx(init_offsetx), 
					.load_crit(load_crit), 
					.load_offsety(load_offsety), 
					.load_offsetx(load_offsetx), 
					.x(x2), 
					.y(y2), 
					.crit_condition(crit_condition), 
					.offset_condition(offset_condition), 
					.colour(colour2));
					

mux #(8) mux_x(.in1(x1), .in2(x2), .sel(sel), .out(x));	
mux #(7) mux_y(.in1(y1), .in2(y2), .sel(sel), .out(y));	
mux #(3) mux_colour(.in1(colour1), .in2(colour2), .sel(sel), .out(colour));	


state_machine sm(.clock(CLOCK_50), 
				 .resetb(KEY[3]), 
				 .xdone(xdone), 
				 .ydone(ydone),
				 .crit_condition(crit_condition), 
				 .offset_condition(offset_condition),
				 .plot(plot), 
				 .loadx(loadx), 
				 .loady(loady), 
				 .initx(initx), 
				 .inity(inity),
				 .init_crit(init_crit), 
				 .init_offsetx(init_offsetx), 
				 .init_offsety(init_offsety), 
				 .sel(sel),
				 .load_crit(load_crit), 
				 .load_offsety(load_offsety), 
				 .load_offsetx(load_offsetx), 
				 .pixel(pixel));

endmodule


module mux (in1, in2, sel, out);
	parameter k = 8;
	input [k-1:0] in1, in2;
	input sel;
	output [k-1:0] out;
	
	assign out = (sel == 1) ? in2 : in1;
	
endmodule


