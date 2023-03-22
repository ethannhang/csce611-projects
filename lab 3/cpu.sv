// CSCE 611 - Ethan Hang - Copyright 2022

module cpu (
    input logic clk,
    input logic rst_n,
    input [31:0] GPIO_in,
    output [31:0] GPIO_out
);
	
    logic [31:0] inst_ram [4095:0];
    initial $readmemh("program.dat",inst_ram);

    // program counter
    logic [11:0] PC_FETCH;

    // logic signals for cpu
    logic [31:0] instruction_EX;
    logic [6:0] opcode_EX;
    logic [4:0] rd_EX;
    logic [2:0] funct3_EX;
    logic [4:0] rs1_EX;
    logic [4:0] rs2_EX;
    logic [6:0] funct7_EX;
    logic [11:0] imm12_EX;
    logic [19:0] imm20_EX;
    logic [11:0] csr_EX;
    logic [31:0] readdata1;
    logic [31:0] readdata2;
    logic [31:0] writedata_WB;
    logic alusrc_EX;
    logic regwrite_EX;
    logic [1:0] regsel_EX;
    logic [3:0] aluop_EX;
    logic GPIO_we;
    logic [4:0] rd_WB;
    logic [31:0] R_WB;
    logic regwrite_WB;
    logic [1:0] regsel_WB;
    logic [31:0] GPIO_in_WB;
    logic [31:0] imm20_WB;
    logic [31:0] B_EX;
    logic [31:0] R_EX;
    logic [31:0] se_imm12_EX;
    logic [31:0] imm20_EX_u;
    logic [31:0] cpu_output;
	 logic [31:0] R_GPIO_WB;
    logic zero;


   // 12 bit sign extended to 32 bit
   assign se_imm12_EX = {{20{imm12_EX[11]}}, imm12_EX};
	// lui
	assign imm20_EX_u = {imm20_EX, 12'b0};
   // hex output
   assign GPIO_out = cpu_output;
	// 2 input mux for reg file
	assign B_EX = (alusrc_EX) ? se_imm12_EX : readdata2;
	// 3 input mux for alu
	assign R_GPIO_WB = (regsel_WB[1]) ? R_WB : GPIO_in_WB;
	assign writedata_WB = (regsel_WB[0]) ? imm20_WB : R_GPIO_WB;

    // instance of modules using logic variables

    instr_decoder mydecoder(
        .instruction_EX(instruction_EX),
        .opcode_EX(opcode_EX),
        .rd_EX(rd_EX),
        .funct3_EX(funct3_EX),
        .rs1_EX(rs1_EX),
        .rs2_EX(rs2_EX),
        .funct7_EX(funct7_EX),
        .imm12_EX(imm12_EX),
        .imm20_EX(imm20_EX),
        .csr_EX(csr_EX)
    );

    control_unit mycontrol(
        .opcode_EX(opcode_EX),
        .funct3_EX(funct3_EX),
        .funct7_EX(funct7_EX),
        .csr_EX(csr_EX),
        .alusrc(alusrc_EX),
        .regwrite(regwrite_EX),
        .regsel(regsel_EX),
        .aluop(aluop_EX),
        .gpio_we(GPIO_we)
    );
	 
    alu myalu(
        .A(readdata1),
        .B(B_EX),
        .op(aluop_EX),
        .R(R_EX),
        .zero(zero)
    );

    regfile myregfile(
        .clk(clk),
        .rst(~rst_n),
        .we(regwrite_WB),
        .readaddr1(rs1_EX),
        .readaddr2(rs2_EX),
        .writeaddr(rd_WB),
        .writedata(writedata_WB),
        .readdata1(readdata1),
        .readdata2(readdata2)
    );

    always_ff @(posedge clk) begin
			// check if 0, ACTIVE LOW
        if (rst_n == 0)	
            begin
                PC_FETCH <= 12'd0;        
                instruction_EX <= 32'd0;    
                rd_WB <= 5'd0;              
                regsel_WB <= 2'b00;        
                imm20_WB <= 32'd0;    
                R_WB <= 32'd0;              
                GPIO_in_WB <= 32'd0;
					 //GPIO_in <= 32'b0;
                cpu_output <= 32'b0;
            end else
                begin
                    PC_FETCH <= PC_FETCH + 1'b1;
                    instruction_EX <= inst_ram[PC_FETCH];
                    rd_WB <= rd_EX;
                    regwrite_WB <= regwrite_EX;
                    regsel_WB <= regsel_EX;
                    imm20_WB <= imm20_EX_u;
                    R_WB <= R_EX;
                    GPIO_in_WB <= GPIO_in;
                    if (GPIO_we) cpu_output <= readdata1;
                end
            end
				
    // Check results on falling edge; displaying signal register values
     always @(negedge clk) begin
			$display("Reset = %b", rst_n);
         $display("Register Status: ");
			$display("Instruction = %8h", inst_ram[PC_FETCH]);
			$display("GPIO_in = %h", GPIO_in);
			$display("GPIO_in_WB = %h", GPIO_in_WB);
			//$display("GPIO_we = %b", GPIO_we);
			$display("GPIO_out = %h", GPIO_out);
			// seperate each display block
			$display("========="); 
     end
endmodule