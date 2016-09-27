module datapath_circle(clock, resetb, pixel, init_crit, init_offsety, 
					   init_offsetx, load_crit, load_offsety, 
					   load_offsetx, center_x, center_y, radius, 
					   x, y, crit_condition, offset_condition);
					   
			
	input clock, resetb;

	input init_crit, init_offsety, init_offsetx, 
		  load_crit, load_offsety, load_offsetx;
		  
	input [7:0] center_x, center_y, radius;
	input [3:0] pixel
	
	output crit_condition, offset_condition;
	output [7:0] x;
	output [6:0] y;
	
	wire [7:0] crit, next_crit;
	wire [7:0] offsetxx, offsety, next_offsetx, next_offsety;
	
	assign crit = init_crit ? (1 - radius) : next_crit;
	assign crit_condition = (crit <= 0) ? 1 : 0;
	assign offset_condition = (offsety <= offsetx);
	
	
	always_comb begin
		case(pixel)
			
			1: begin 
				x = center_x + offsetx;
				y = center_y + offsety;
				end
			2: begin 
				x = center_x + offsety;
				y = center_y + offsetx;
				end
			3: begin
				x = center_x - offsetx;
				y = center_y + offsety;
				end
			4: begin
				x = center_x - offsety;
				y = center_y + offsetx;
				end
			5: begin
				x = center_x - offsetx;
				y = center_y - offsety;
				end
			6: begin
				x = center_x - offsety;
				y = center_y - offsetx;
				end
			7: begin
				x = center_x + offsetx;
				y = center_y - offsety;
				end
			8: begin
				x = center_x + offset_y;
				y = center_y - offsetx;
				end
			
			default: begin
				x = 0;
				y = 0;
		endcase		
	end
	
	
	always_ff @(posedge clock, negedge resetb) begin
	
		
			
		
		
	
	
	
	
	
	
	
	
