module datapath_circle(clock, resetb, pixel, init_vars, 
					   init_circle, load_crit, load_offsety, 
					   load_offsetx, load_circle, x, y, 
					   crit_condition, offset_condition, 
					   colour, circle_num);
					   		
	
	`define BLACK 3'b000
	`define BLUE 3'b001
	`define RED 3'b100
	`define GREEN 3'b010
	`define WHITE 3'b111
	`define YELLOW 3'b110
	
	
	input clock, resetb;

	input init_circle, init_vars, load_circle, load_crit, load_offsety, load_offsetx;
	
	input [3:0] pixel;
	
	output crit_condition, offset_condition;
	output reg [7:0] x;
	output reg [6:0] y;
	output reg [2:0] colour;
	
	output reg [2:0] circle_num;
	
	reg signed[8:0] crit, next_crit;
	
	reg [7:0] offsetx, offsety;
	wire [7:0] next_offsetx, next_offsety;
	reg [7:0] center_x, center_y, radius;
	
	wire [2:0] next_circle;
	
	assign crit_condition = (crit <= 0) ? 1 : 0;
	assign offset_condition = (offsety <= offsetx) ? 1 : 0;
	
	assign next_offsetx = (init_vars == 1) ? radius : offsetx - 1;
	assign next_offsety = (init_vars == 1) ? 0 : offsety + 1;
	assign next_circle = (init_circle == 1) ? 1 : circle_num + 1;
	
	
	always_comb begin
		
		if(init_vars == 1)
			next_crit = (1 - radius);
		else if(crit <= 0) 
			next_crit = (crit + 2 * offsety + 1);
		else 
			next_crit = (crit + 2 * (offsety - offsetx) + 1);
			
		case(circle_num)
			1: begin
			   center_x = 30;
			   center_y = 40;
			   radius = 20;
			   colour = `BLUE;
			   end
			2: begin
			   center_x = 80;
			   center_y = 40;
			   radius = 20;
			   colour = `WHITE;
			   end
			3: begin
			   center_x = 130;
			   center_y = 40;
			   radius = 20;
			   colour = `RED;
			   end
			4: begin
			   center_x = 55;
			   center_y = 80;
			   radius = 20;
			   colour = `YELLOW;
			   end
			5: begin
			   center_x = 105;
			   center_y = 80;
			   radius = 20;
			   colour = `GREEN;
			   end
			default: begin
				center_x = 0;
				center_y = 0;
				radius = 0;
				colour = `BLACK;
				end
		endcase
	
			   
		
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
			circle_num = 1;
		end
		
		else begin 
			if(load_crit == 1)
				crit = next_crit;
			if(load_offsetx == 1)
				offsetx = next_offsetx;
			if(load_offsety == 1)
				offsety = next_offsety;
			if(load_circle == 1)
				circle_num = next_circle;
		end
				
	end

endmodule	
		
		
	
	
	
	
	
	
	
	
