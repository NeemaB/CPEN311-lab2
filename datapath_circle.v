module datapath_circle(clock, resetb, pixel, init_crit, init_offsety, 
					   init_offsetx, load_crit, load_offsety, 
					   load_offsetx, center_x, center_y, radius, 
					   x, y, crit_condition, offset_condition);
					   
			
	input clock, resetb;

	input init_crit, init_offsety, init_offsetx, 
		  load_crit, load_offsety, load_offsetx;
		  
	input [7:0] center_x, center_y, radius;
	input [3:0] pixel;
	
	output crit_condition, offset_condition;
	output reg [7:0] x;
	output reg [6:0] y;
	
	reg signed[8:0] crit, next_crit;
	reg [7:0] offsetx, offsety;
	wire [7:0] next_offsetx, next_offsety;
	
	assign crit_condition = (crit <= 0) ? 1 : 0;
	assign offset_condition = (offsety <= offsetx);
	
	assign next_offsetx = (init_offsetx == 1) ? radius : offsetx - 1;
	assign next_offsety = (init_offsety == 1) ? 0 : offsety + 1;
	
	always_comb begin
		
		if(init_crit == 1)
			next_crit = (1 - radius);
		else if(crit <= 0) 
			next_crit = (crit + 2 * offsety + 1);
		else 
			next_crit = (crit + 2 * (offsety - offsetx) + 1);
		
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
				x = center_x + offsety;
				y = center_y - offsetx;
				end
			
			default: begin
				x = 0;
				y = 0;
				end
		endcase		
	end
	
	
	always_ff @(posedge clock, negedge resetb) begin
		
		if(resetb == 0)begin
			crit = 0;
			offsetx = 0;
			offsety = 0;
		end
		
		else begin 
			if(load_crit == 1)
				crit = next_crit;
			if(load_offsetx == 1)
				offsetx = next_offsetx;
			if(load_offsety == 1)
				offsety = next_offsety;
		end
				
	end

endmodule	
		
		
	
	
	
	
	
	
	
	
