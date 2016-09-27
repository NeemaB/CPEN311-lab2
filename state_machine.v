module statemachine(clock, resetb, xdone, ydone, plot, loadx, loady, initx, inity);


	input clock, xdone, ydone, resetb;
	output plot, loadx, loady, initx, inity;
	
	reg [1:0] state, next_state;
	
	
	`define S_start = 2'b00
	`define S_draw = 2'b01
	`define S_finish = 2'b10
	`define Outputs = {plot, loadx, loady, initx, inity, next_state}
	
	
	
	
	always_comb begin
		
		case(state) 
			
			`S_start: `Outputs = {5'b01111, `S_draw};
			`S_draw: begin
					if(xdone == 1)
						`Outputs = {5'b00000, `S_finish};
					else if(ydone == 1)
						`Outputs = {5'b01101, `S_draw};
					else
						`Outputs = {5'b10100, `S_draw};
					end
			`S_finish: `Outputs = {5'b00000, `S_finish};
			
			default: `Outputs = {5'b00000, `S_start};
		endcase
	end
	
	
	always_ff @(posedge clock, negedge resetb) begin
			
		if(resetb == 0)
			state = `S_start;
		else
			state = next_state;
	end
	
endmodule
	
		









endmodule