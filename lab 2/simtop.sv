/* Copyright 2020 Jason Bakos, Philip Conrad, Charles Daniels */

/* Top-level module for CSCE611 RISC-V CPU, for running under simulation.  In
 * this case, the I/Os and clock are driven by the simulator. */

module simtop;

	logic clk;
	logic [6:0] HEX0,HEX1,HEX2,HEX3,HEX4,HEX5,HEX6,HEX7;
	// Implement logic for Switches
	logic [17:0] SW;	

	// 
	top dut
	(
		//////////// CLOCK //////////
		.CLOCK_50(clk),
		.CLOCK2_50(),
	   .CLOCK3_50(),

		//////////// LED //////////
		.LEDG(),
		.LEDR(),

		//////////// KEY //////////
		.KEY(),

		//////////// SW //////////
		.SW(SW),

		//////////// SEG7 //////////
		.HEX0(HEX0),
		.HEX1(HEX1),
		.HEX2(HEX2),
		.HEX3(HEX3),
		.HEX4(HEX4),
		.HEX5(HEX5),
		.HEX6(HEX6),
		.HEX7(HEX7)
	);

	// Initially, the switches are all off
	initial
		begin
			assign SW = 18'b0;
			#10;
		end

	// Generate clock with no sensitivity list
	always
		begin
			clk = 1'b1;
			#5;
			clk = 1'b0;
			#5;
		end

	// Increment switch value on rising edge by 1
	always @(posedge clk)
		begin
			SW <= SW + 1'b1;
			//#5;
		end

	// Check results on falling edge
		always @(negedge clk)
			begin
			//#10;
				// Check decoder #1 at input F
				if(SW[3:0] == 4'hF) begin
					if ( ~7'h71 !== HEX0 ) begin
						$display("Error: HEX0 value %h does not match the Switch value, %h", HEX0, SW[3:0]);
					end
				end
				// #1 at input E
				if(SW[3:0] == 4'hE) begin
					if ( ~7'h79 !== HEX0 ) begin
						$display("Error: HEX0 value %h does not match the Switch value, %h", HEX0, SW[3:0]);
					end
				end
				// Check decoder #2 at input D
				if(SW[7:4] == 4'hD) begin
					if ( ~7'h5E !== HEX1 ) begin
						$display("Error: HEX1 value %h does not match the Switch value, %h", HEX1, SW[7:4]);
					end
				end
				// #2 at input C
				if(SW[7:4] == 4'hC) begin
					if ( ~7'h39 !== HEX1 ) begin
						$display("Error: HEX1 value %h does not match the Switch value, %h", HEX1, SW[7:4]);
					end
				end
				// Check decoder #3 at input B
				if(SW[11:8] == 4'hB) begin
					if ( ~7'h7C !== HEX2 ) begin
						$display("Error: HEX2 value %h does not match the Switch value, %h", HEX2, SW[11:8]);
					end
				end
				// #3 at input A
				if(SW[11:8] == 4'hA) begin
					if ( ~7'h5F !== HEX2 ) begin
						$display("Error: HEX2 value %h does not match the Switch value, %h", HEX2, SW[11:8]);
					end
				end
				// Check decoder #4 at input 9
				if(SW[15:12] == 4'h9) begin
					if ( ~7'h67 !== HEX3 ) begin
						$display("Error: HEX3 value %h does not match the Switch value, %h", HEX3, SW[15:12]);
					end
				end
				// #4 at input 8
				if(SW[15:12] == 4'h8) begin
					if ( ~7'h7F !== HEX3 ) begin
						$display("Error: HEX3 value %h does not match the Switch value, %h", HEX3, SW[15:12]);
					end
				end
				// Check decoder #5 at input 7
				if(SW[17:16] == 4'h7) begin
					if ( ~7'h07 !== HEX4) begin
						$display("Error: HEX4 value %h does not match the Switch value, %h", HEX4, SW[17:16]);
					end
				end
				// #5 at input 6
				if(SW[17:16] == 4'h6) begin
					if ( ~7'h7D !== HEX4) begin
						$display("Error: HEX3 value %h does not match the Switch value, %h", HEX4, SW[17:16]);
					end
				end
			end
			
endmodule
