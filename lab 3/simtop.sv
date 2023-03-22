/* Copyright 2020 Jason Bakos, Philip Conrad, Charles Daniels */

/* Top-level module for CSCE611 RISC-V CPU, for running under simulation.  In
 * this case, the I/Os and clock are driven by the simulator. */

module simtop;

	logic clk, rst_n;
	// hex signals
	logic [6:0] HEX0,HEX1,HEX2,HEX3,HEX4,HEX5,HEX6,HEX7;
	logic [55:0] hexout;
	assign hexout = {HEX7,HEX6,HEX5,HEX4,HEX3,HEX2,HEX1,HEX0};
	//assign hexout = {HEX0,HEX1,HEX2,HEX3,HEX4,HEX5,HEX6,HEX7};
	
	// signals for instruction and switch and test vector
	logic [17:0] SW = 18'b0;
	logic [3:0] key;
	logic [108:0] testvector[63:0];
	logic [63:0] vect_index = 64'b0;
	logic [31:0] instruction_EX, instruction_EX_B, GPIO_out;
	logic [31:0] GPIO_in = 32'd0;
	logic [6:0] opcode_EX_A, opcode_EX_B;
	logic [4:0] rd_EX_A, rd_EX_B, rs1_EX_A, rs1_EX_B, rs2_EX_A, rs2_EX_B;
	logic [2:0] funct3_EX_A, funct3_EX_B;
	logic [6:0] funct7_EX_A, funct7_EX_B;
	logic [11:0] imm12_EX_A, imm12_EX_B, csr_EX_A, csr_EX_B;
	logic [19:0] imm20_EX_A, imm20_EX_B;
	logic [6:0] opcode_EX, opcode_EX_C;
	logic [11:0] csr_EX, csr_EX_C;
	logic [6:0] funct7_EX, funct7_EX_C;
	logic [2:0] funct3_EX, funct3_EX_C;
	logic [0:0] alusrc_EX, alusrc_EX_C, regwrite_EX, regwrite_EX_C;
   logic [1:0] regsel_EX, regsel_EX_C;
   logic [3:0] aluop_EX, aluop_EX_C;
   logic [0:0] GPIO_we, GPIO_we_EX,GPIO_we_EX_C;
	// cpu memory
	logic [31:0] inst_ram [4095:0];
   logic [11:0] PC_FETCH;

    // logic signals for cpu
    logic [4:0] rd_EX;
    logic [4:0] rs1_EX;
    logic [4:0] rs2_EX;
    logic [11:0] imm12_EX;
    logic [19:0] imm20_EX;
    logic [31:0] readdata1;
    logic [31:0] readdata2;
    logic [31:0] writedata_WB;
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

		 
	// CSCE 611 - Ethan Hang 
	
	top top_dut
	(
		//////////// CLOCK //////////
		.CLOCK_50(clk),
		.CLOCK2_50(),
	   .CLOCK3_50(),

		//////////// LED //////////
		.LEDG(),
		.LEDR(),

		//////////// KEY //////////
		.KEY(key[0]),

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
	
	instr_decoder id_dut(
        .instruction_EX(instruction_EX),
        .opcode_EX(opcode_EX_A),
        .rd_EX(rd_EX_A),
        .funct3_EX(funct3_EX_A),
        .rs1_EX(rs1_EX_A),
        .rs2_EX(rs2_EX_A),
        .funct7_EX(funct7_EX_A),
        .imm12_EX(imm12_EX_A),
        .imm20_EX(imm20_EX_A),
        .csr_EX(csr_EX_A)
    );
	
	 cpu cpu_dut(
		 .clk(clk),
		 .rst_n(~key[0]),
		 .GPIO_in(GPIO_in),
		 .GPIO_out(GPIO_out)
	);
	
	control_unit cntrl_dut(
        .opcode_EX(opcode_EX_C),
        .funct3_EX(funct3_EX_C),
        .funct7_EX(funct7_EX_C),
        .csr_EX(csr_EX_C),
        .alusrc(alusrc_EX_C),
        .regwrite(regwrite_EX_C),
        .regsel(regsel_EX_C),
        .aluop(aluop_EX_C),
        .gpio_we(GPIO_we_EX_C)
    );
	
	// Generate clock with no sensitivity list
	always
		begin
			clk = 1'b1;
			#5;
			clk = 1'b0;
			#5;
		end
		
	// Initially, read test vector file to test 
	initial
		begin	
			// reset key
			key[0] = 1'b0;		// 1 will show GPIO_out
			#27;
			//key[0] = 1'b1;		// 1 will show hex output
			// hex output test
			// cpu test
			
			// assign control signals
			//assign opcode_EX_C = 7'b0110011;		// R
			assign opcode_EX_C = 7'b0010011;	// I
			//assign opcode_EX_C = 7'b0110111;	// U
			//assign opcode_EX_C = 7'b1110011;	// csr
			assign funct3_EX_C = 3'b000;
			assign funct7_EX_C = 7'b0000000;
			assign csr_EX_C = 12'b111100000010;
			//assign {alusrc_EX, regwrite_EX, regsel_EX, aluop_EX, GPIO_we_EX} = 9'b0_1_10_0011_0; // R
			assign {alusrc_EX, regwrite_EX, regsel_EX, aluop_EX, GPIO_we_EX} = 9'b1_1_10_0011_0; // I
			//assign {alusrc_EX, regwrite_EX, regsel_EX, aluop_EX, GPIO_we_EX} = 9'bx_1_01_xxxx_0; // U
			//assign {alusrc_EX, regwrite_EX, regsel_EX, aluop_EX, GPIO_we_EX} = 9'bx_0_xx_xxxx_1; // csr
			
			// to check instruction decoder, read test vector file of bits
			$readmemb("testinstructions.mem", testvector);
			key[0] = 1'b1;
		end
		
	
	always @(posedge clk)
		begin
			// assign corresponding registers to test vector bits
			{instruction_EX, opcode_EX_B, rd_EX_B, funct3_EX_B, rs1_EX_B, rs2_EX_B, funct7_EX_B, imm12_EX_B, imm20_EX_B, csr_EX_B} = testvector[vect_index];
			SW <= SW + 18'd1;
			//GPIO_in <= GPIO_in + 1'b1;
			//vect_index <= vect_index + 1'b1;
		end

	// Check results on falling edge
		always @(negedge clk)
			begin
				$display("Switch value = %h", SW);
				//$display("GPIO_in value = %h", GPIO_in);
				//$display("HEX = %h", hexout[31:0]);
				$display("=========");
				vect_index <= vect_index + 1'b1;
				// Testing hex decoder
				// Check decoder #1 at input F
				if(GPIO_out[31:28] == 4'hF) begin
					if ( ~7'h71 !== HEX0 ) begin
						$display("Error: HEX0 value %h does not match the Switch value, %h", HEX0, GPIO_out[31:28]);
					end
				end
				// #1 at input E
				if(GPIO_out[31:28] == 4'hE) begin
					if ( ~7'h79 !== HEX0 ) begin
						$display("Error: HEX0 value %h does not match the Switch value, %h", HEX0, GPIO_out[3:0]);
					end
				end
				// Check decoder #2 at input D
				if(GPIO_out[27:24] == 4'hD) begin
					if ( ~7'h5E !== HEX1 ) begin
						$display("Error: HEX1 value %h does not match the Switch value, %h", HEX1, GPIO_out[27:24]);
					end
				end
				// #2 at input C
				if(GPIO_out[27:24] == 4'hC) begin
					if ( ~7'h39 !== HEX1 ) begin
						$display("Error: HEX1 value %h does not match the Switch value, %h", HEX1, GPIO_out[27:24]);
					end
				end
				// Check decoder #3 at input B
				if(GPIO_out[23:20] == 4'hB) begin
					if ( ~7'h7C !== HEX2 ) begin
						$display("Error: HEX2 value %h does not match the Switch value, %h", HEX2, GPIO_out[23:20]);
					end
				end
				// #3 at input A
				if(GPIO_out[23:20] == 4'hA) begin
					if ( ~7'h5F !== HEX2 ) begin
						$display("Error: HEX2 value %h does not match the Switch value, %h", HEX2, GPIO_out[23:20]);
					end
				end
				// Check decoder #4 at input 9
				if(GPIO_out[19:16] == 4'h9) begin
					if ( ~7'h67 !== HEX3 ) begin
						$display("Error: HEX3 value %h does not match the Switch value, %h", HEX3, GPIO_out[19:16]);
					end
				end
				// #4 at input 8
				if(GPIO_out[19:16] == 4'h8) begin
					if ( ~7'h7F !== HEX3 ) begin
						$display("Error: HEX3 value %h does not match the Switch value, %h", HEX3, GPIO_out[19:16]);
					end
				end
				// Check decoder #5 at input 7
				if(GPIO_out[15:12] == 4'h7) begin
					if ( ~7'h07 !== HEX4 ) begin
						$display("Error: HEX4 value %h does not match the Switch value, %h", HEX4, GPIO_out[15:12]);
					end
				end
				// #5 at input 6
				if(GPIO_out[15:12] == 4'h6) begin
					if ( ~7'h7D !== HEX4 ) begin
						$display("Error: HEX4 value %h does not match the Switch value, %h", HEX4, GPIO_out[15:12]);
					end
				end
				
				// check instructions in test vector file
				if (opcode_EX_A !== opcode_EX_B) begin
					// %b will represent binary format
					$display("opcode %b does not match %b", opcode_EX_A, opcode_EX_B);
				end
				if (rd_EX_A !== rd_EX_B) begin
					$display("rd %b does not match %b", rd_EX_A, rd_EX_B);
				end

				if (funct3_EX_A !== funct3_EX_B) begin
					$display("fun3 %b does not match %b", funct3_EX_A, funct3_EX_B);
				end

				if (rs1_EX_A !== rs1_EX_B) begin
					$display("rs1 %b does not match %b", rs1_EX_A, rs1_EX_B);
				end

				if (rs2_EX_A !== rs2_EX_B) begin
					$display("rs2 %b does not match %b", rs2_EX_A, rs2_EX_B);
				end

				if (funct7_EX_A !== funct7_EX_B) begin
					$display("fun7 %b does not match %b", funct7_EX_A, funct7_EX_B);
				end

				if (imm12_EX_A !== imm12_EX_B) begin
					$display("imm12 %b does not match %b", imm12_EX_A, imm12_EX_B);
				end

				if (imm20_EX_A !== imm20_EX_B) begin
					$display("imm20 %b does not match %b", imm20_EX_A, imm20_EX_B);
				end
				if (csr_EX_A !== csr_EX_B) begin
					$display("csr %b does not match %b", csr_EX_A, csr_EX_B);
				end
				
				// check control unit
				// R
				if (opcode_EX_C == 7'b0110011 && funct3_EX_C == 3'b000 && funct7_EX_C == 7'b0000000) begin
					//assign {alusrc_EX, regwrite_EX, regsel_EX, aluop_EX, GPIO_we_EX} = 9'b0_1_10_0011_0;
					if ({alusrc_EX, regwrite_EX, regsel_EX, aluop_EX, GPIO_we_EX} !== {alusrc_EX_C, regwrite_EX_C, regsel_EX_C, aluop_EX_C, GPIO_we_EX_C}) begin
						$display("r control signals %b does not match %b", {alusrc_EX, regwrite_EX, regsel_EX, aluop_EX, GPIO_we_EX}, {alusrc_EX_C, regwrite_EX_C, regsel_EX_C, aluop_EX_C, GPIO_we_EX_C});
					end
				end
				// I
				if (opcode_EX_C == 7'b0010011 && funct3_EX_C == 3'b000) begin
					//assign {alusrc_EX, regwrite_EX, regsel_EX, aluop_EX, GPIO_we_EX} = 9'b1_1_10_0011_0;
					if ({alusrc_EX, regwrite_EX, regsel_EX, aluop_EX, GPIO_we_EX} !== {alusrc_EX_C, regwrite_EX_C, regsel_EX_C, aluop_EX_C, GPIO_we_EX_C}) begin
						$display("i control signals %b does not match %b", {alusrc_EX, regwrite_EX, regsel_EX, aluop_EX, GPIO_we_EX}, {alusrc_EX_C, regwrite_EX_C, regsel_EX_C, aluop_EX_C, GPIO_we_EX_C});
					end
				end
				// U
				if (opcode_EX_C == 7'b0110111) begin
					//assign {alusrc_EX, regwrite_EX, regsel_EX, aluop_EX, GPIO_we_EX} = 9'bx_1_01_xxxx_0;
					if ({alusrc_EX, regwrite_EX, regsel_EX, aluop_EX, GPIO_we_EX} !== {alusrc_EX_C, regwrite_EX_C, regsel_EX_C, aluop_EX_C, GPIO_we_EX_C}) begin
						$display("u control signals %b does not match %b", {alusrc_EX, regwrite_EX, regsel_EX, aluop_EX, GPIO_we_EX}, {alusrc_EX_C, regwrite_EX_C, regsel_EX_C, aluop_EX_C, GPIO_we_EX_C});
					end
				end
				// csr
				if (opcode_EX_C == 7'b1110011 && csr_EX_C == 12'b111100000010) begin
					//assign {alusrc_EX, regwrite_EX, regsel_EX, aluop_EX, GPIO_we_EX} = 9'bx_0_xx_xxxx_1;
					if ({alusrc_EX, regwrite_EX, regsel_EX, aluop_EX, GPIO_we_EX} !== {alusrc_EX_C, regwrite_EX_C, regsel_EX_C, aluop_EX_C, GPIO_we_EX_C}) begin
						$display("csr control signals %b does not match %b", {alusrc_EX, regwrite_EX, regsel_EX, aluop_EX, GPIO_we_EX}, {alusrc_EX_C, regwrite_EX_C, regsel_EX_C, aluop_EX_C, GPIO_we_EX_C});
					end
				end
				// next index		
			end
endmodule
