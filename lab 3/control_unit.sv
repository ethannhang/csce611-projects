// CSCE 611 - Ethan Hang - Copyright 2022

module control_unit (
    input logic [6:0] opcode_EX,
    input logic [2:0] funct3_EX,
    input logic [6:0] funct7_EX,
    input logic [11:0] csr_EX,
    output logic [0:0] alusrc,
    output logic [0:0] regwrite,
    output logic [1:0] regsel,
    output logic [3:0] aluop,
    output logic [0:0] gpio_we  // write to GPIO register
);

    always_comb
		begin
        case (opcode_EX)
		      // 9-bit control signals are determined by op, fun3, fun7, and csr values for specific instructions
            // R
            7'b0110011: {alusrc, regwrite, regsel, aluop, gpio_we} = (funct3_EX == 3'b000 && funct7_EX == 7'b0000000) ? 9'b0_1_10_0011_0 : 
                        (funct3_EX == 3'b000 && funct7_EX == 7'b0100000) ? 9'b0_1_10_0100_0 : (funct3_EX == 3'b111 && funct7_EX == 7'b0000000) ? 9'b0_1_10_0000_0 :   
                        (funct3_EX == 3'b110 && funct7_EX == 7'b0000000) ? 9'b0_1_10_0001_0 : (funct3_EX == 3'b100 && funct7_EX == 7'b0000000) ? 9'b0_1_10_0010_0 :    
								(funct3_EX == 3'b001 && funct7_EX == 7'b0000000) ? 9'b0_1_10_1000_0 : (funct3_EX == 3'b101 && funct7_EX == 7'b0000000) ? 9'b0_1_10_1001_0 :
								(funct3_EX == 3'b111 && funct7_EX == 7'b0000000) ? 9'b0_1_10_0000_0 : (funct3_EX == 3'b010 && funct7_EX == 7'b0000000) ? 9'b0_1_10_1100_0 :
                        (funct3_EX == 3'b011 && funct7_EX == 7'b0000000) ? 9'b0_1_10_1101_0 : (funct3_EX == 3'b101 && funct7_EX == 7'b0100000) ? 9'b0_1_10_1010_0 :
                        (funct3_EX == 3'b000 && funct7_EX == 7'b0000001) ? 9'b0_1_10_0101_0 : (funct3_EX == 3'b001 && funct7_EX == 7'b0000001) ? 9'b0_1_10_0110_0 :
                        (funct3_EX == 3'b011 && funct7_EX == 7'b0000001) ? 9'b0_1_10_0111_0 : 9'bx_x_xx_xxxx_x;		// x = dont care
				// I
            7'b0010011: {alusrc, regwrite, regsel, aluop, gpio_we} = (funct3_EX == 3'b000) ? 9'b1_1_10_0011_0 : (funct3_EX == 3'b111) ? 9'b1_1_10_0000_0 : 
								(funct3_EX == 3'b110) ? 9'b1_1_10_0001_0 : (funct3_EX == 3'b100) ? 9'b1_1_10_0010_0 : (funct3_EX == 3'b001 && funct7_EX == 7'b0000000) ? 9'b1_1_10_1000_0 : 
                        (funct3_EX == 3'b101 && funct7_EX == 7'b0100000) ? 9'b1_1_10_1010_0 : (funct3_EX == 3'b101 && funct7_EX == 7'b0000000) ? 9'b1_1_10_1001_0 : 9'bx_x_xx_xxxx_x;
            // U
            7'b0110111: {alusrc, regwrite, regsel, aluop, gpio_we} = 9'bx_1_01_xxxx_0;
            // CSR
            7'b1110011: {alusrc, regwrite, regsel, aluop, gpio_we} = (csr_EX == 12'b111100000010) ? 9'bx_0_xx_xxxx_1 : 9'bx_1_00_xxxx_0; 
            default: {alusrc, regwrite, regsel, aluop, gpio_we} = 9'bx_x_xx_xxxx_x;		// default value = dont care
        endcase
    end
endmodule