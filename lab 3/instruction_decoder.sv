// Ethan Hang CSCE 611
// RISC V instruction decoding

module instr_decoder (
    input logic [31:0] instruction_EX,
    output logic [6:0] opcode_EX,
    output logic [2:0] funct3_EX,
    output logic [6:0] funct7_EX,
    output logic [11:0] csr_EX,
    output logic [19:0] imm20_EX,
    output logic [11:0] imm12_EX,
    output logic [4:0] rd_EX,
    output logic [4:0] rs1_EX,
    output logic [4:0] rs2_EX
);

    // assign bits accordingly to instruction input
always_comb 
    begin
        opcode_EX = instruction_EX[6:0];
        funct3_EX = instruction_EX[14:12];
        funct7_EX = instruction_EX[31:25];
        csr_EX = instruction_EX[31:20];
        rd_EX = instruction_EX[11:7];
        rs1_EX = instruction_EX[19:15];
        rs2_EX = instruction_EX[24:20];
        imm12_EX = instruction_EX[31:20];
        imm20_EX = instruction_EX[31:12];
    end

endmodule