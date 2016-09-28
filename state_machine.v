module statemachine(clock, resetb, xdone, ydone, 
					crit_condition, offset_condition,
					plot, loadx, loady, initx, inity,
				    init_crit, init_offsetx, init_offsety, sel,
					load_crit, load_offsety, load_offsetx, pixel);


	input clock, xdone, ydone, resetb;
	input crit_condition, offset_condition;
	
	output reg plot, loadx, loady, initx, inity, sel;
	
	output reg init_crit, init_offsetx, init_offsety, 
			   load_crit, load_offsetx, load_offsety;
			   
	output reg [3:0] pixel;
	
	reg [3:0] state, next_state;
	
	
	`define S_start  4'b0000
	`define S_clear  4'b0001
	`define S_init   4'b0010
	`define S_drawP1 4'b0011
	`define S_drawP2 4'b0100
	`define S_drawP3 4'b0101
	`define S_drawP4 4'b0110
	`define S_drawP5 4'b0111
	`define S_drawP6 4'b1000
	`define S_drawP7 4'b1001
	`define S_drawP8 4'b1010
	`define S_update 4'b1011
	`define S_check  4'b1100
	`define S_finish 4'b1111
	`define OutputsDP1 {loadx, loady, initx, inity}
	`define OutputsDP2 {init_crit, init_offsetx, init_offsety, load_crit, load_offsetx, load_offsety, pixel}
	`define Absent 0
	
	
	
	
	always_comb begin
		case(state) 
			`S_start: begin
					  plot = 0;
					 `OutputsDP1 = 4'b1111;
					 `OutputsDP2 = `Absent;
					  sel = 0;
					  next_state = `S_clear;
					 end
			
			`S_clear: begin
					if(xdone == 1) 
						begin
						plot = 0;
					   `OutputsDP1 = `Absent;
					   `OutputsDP2 = `Absent;
						sel = 0;
						next_state = `S_init;
						end
	
					else if(ydone == 1) 
						begin
						plot = 0;
					   `OutputsDP1 = 4'b1101;
					   `OutputsDP2 = `Absent;
						sel = 0;
						next_state = `S_clear;
						end
					else begin
						plot = 1;
					   `OutputsDP1 = 4'b0100;
					   `OutputsDP2 = `Absent;
					    sel = 0;
						next_state = `S_clear;
						end
					end
					
			`S_init: begin
					 plot = 0;
					`OutputsDP1 = `Absent;
				    `OutputsDP2 = {6'b111111, 4'b0000};
					 sel = 1;
					 next_state = `S_drawP1;
					 end
			
			`S_drawP1: begin
					 plot = 1;
					`OutputsDP1 = `Absent;
					`OutputsDP2 = {6'b000000, 4'b0001};
					 sel = 1;
					 next_state = `S_drawP2;
					 end
			
			`S_drawP2: begin
					 plot = 1;
					`OutputsDP1 = `Absent;
					`OutputsDP2 = {6'b000000, 4'b0010};
					 sel = 1;
					 next_state = `S_drawP3;
					 end
			
			`S_drawP3: begin
					 plot = 1;
					`OutputsDP1 = `Absent;
					`OutputsDP2 = {6'b000000, 4'b0011};
					 sel = 1;
					 next_state = `S_drawP4;
					 end
			
			`S_drawP4: begin
					 plot = 1;
					`OutputsDP1 = `Absent;
					`OutputsDP2 = {6'b000000, 4'b0100};
					 sel = 1;
					 next_state = `S_drawP5;
					 end		 
			
			`S_drawP5: begin
					 plot = 1;
					`OutputsDP1 = `Absent;
					`OutputsDP2 = {6'b000000, 4'b0101};
					 sel = 1;
					 next_state = `S_drawP6;
					 end
			
			`S_drawP6: begin
					 plot = 1;
					`OutputsDP1 = `Absent;
					`OutputsDP2 = {6'b000000, 4'b0110};
					 sel = 1;
					 next_state = `S_drawP7;
					 end
			
			`S_drawP7: begin
					 plot = 1;
					`OutputsDP1 = `Absent;
					`OutputsDP2 = {6'b000000, 4'b0111};
					 sel = 1;
					 next_state = `S_drawP8;
					 end
			
			`S_drawP8: begin
					 plot = 1;
					`OutputsDP1 = `Absent;
					`OutputsDP2 = {6'b000000, 4'b1000};
					 sel = 1;
					 next_state = `S_update;
					 end

			`S_update: begin
					 plot = 0;
					`OutputsDP1 = `Absent;
					if(crit_condition == 1)
						`OutputsDP2 = {6'b000101, 4'b0000};
					else
						`OutputsDP2 = {6'b000111, 4'b0000};
					sel = 1;
					next_state = `S_check;
					end
			
			`S_check: begin
					plot = 0;
					`OutputsDP1 = `Absent;
					`OutputsDP2 = `Absent;
					sel = 1;
					if(offset_condition == 1)
						next_state = `S_drawP1;
					else
						next_state = `S_finish;
					end
					 
			`S_finish: begin
					 plot = 0;
					 `OutputsDP1 = `Absent;
					 `OutputsDP2 = `Absent;
					 sel = 0;
					 next_state = `S_finish;
					 end
			
			default: begin
					 plot = 0;
					 `OutputsDP1 = `Absent;
					 `OutputsDP2 = `Absent;
					 sel = 0;
					 next_state = `S_start;
					 end
		endcase
	end
	
	
	always_ff @(posedge clock, negedge resetb) begin
			
		if(resetb == 0)
			state = `S_start;
		else
			state = next_state;
	end
	
endmodule
	
		



