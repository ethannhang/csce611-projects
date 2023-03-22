// CSCE 611 - Ethan Hang - Copyright 2022
module hexdriver (input [3:0] val, output logic [6:0] HEX);
	/* your code here */
	always_comb
		begin
			case(val)
				// Look at DE2-115 Manual for HEX positions
				// Active LOW, implement complement
				4'h0: HEX = ~7'b011_1111;  // switch input = 0000, displays 0
				4'h1: HEX = ~7'b000_0110;  // switch input = 0001, displays 1
				4'h2: HEX = ~7'b101_1011;  // switch input = 0010, displays 2
				4'h3: HEX = ~7'b100_1111;  // switch input = 0011, displays 3
				4'h4: HEX = ~7'b110_0110;  // switch input = 0100, displays 4
				4'h5: HEX = ~7'b110_1101;  // switch input = 0101, displays 5
				4'h6: HEX = ~7'b111_1101;  // switch input = 0110, displays 6
				4'h7: HEX = ~7'b000_0111;  // switch input = 0111, displays 7
				4'h8: HEX = ~7'b111_1111;  // switch input = 1000, displays 8
				4'h9: HEX = ~7'b110_0111;  // switch input = 1001, displays 9
				4'hA: HEX = ~7'b101_1111;  // switch input = 1010, displays a
				4'hB: HEX = ~7'b111_1100;  // switch input = 1011, displays b
				4'hC: HEX = ~7'b011_1001;  // switch input = 1100, displays C
				4'hD: HEX = ~7'b101_1110;  // switch input = 1101, displays d
				4'hE: HEX = ~7'b111_1001;  // switch input = 1110, displays E
				4'hF: HEX = ~7'b111_0001;  // switch input = 1111, displays F
				default : HEX = ~7'b111_1111;  // required, all off
			endcase
		end
endmodule
