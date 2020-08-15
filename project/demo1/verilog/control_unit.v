module control_unit(	instruction, 
			instr_type, 
			HALT,  
			NOP,  
			writeR7,  
			jumpReg,  
			jump,  
			branch, 
			memToReg, 
			memRead, 
			ALUop, 
			memWrite, 
			ALUsrc, 
			regWrite	);

input [15:0] instruction;

// 4 instruction types:
// 0 = J
// 1 = I-1
// 2 = I-2
// 3 = R
output [1:0] instr_type;

// Control signals
output wire HALT;
output NOP;
output writeR7;
output jumpReg;
output jump;
output branch;
output memToReg; 
output memRead;
output [3:0] ALUop;
output memWrite; 
output ALUsrc;
output regWrite;

// Intermediate control signals
reg HALT_i;
reg NOP_i;
reg writeR7_i;
reg jumpReg_i;
reg jump_i;
reg branch_i;
reg memToReg_i; 
reg memRead_i;
reg [3:0] ALUop_i;
reg memWrite_i; 
reg ALUsrc_i;
reg regWrite_i;
reg [1:0] instr_type_i;

// Assign outputs:
//assign HALT = HALT_i;
//assign NOP = NOP_i;
assign writeR7 = writeR7_i;
assign jumpReg = jumpReg_i;
assign jump = jump_i;
assign branch = branch_i;
assign memToReg = memToReg_i;
assign memRead = memRead_i;
assign ALUop = ALUop_i;
assign memWrite = memWrite_i;
assign ALUsrc = ALUsrc_i;
assign regWrite = regWrite_i;
assign instr_type = instr_type_i;

// Opcodes and operations
// wire [1:0]alu_op_sel;
wire [4:0] opcode;
reg [3:0] alu_op;
reg [3:0] shift_rot_op;
wire [1:0] func;

assign func = instruction[1:0];
assign opcode = instruction[15:11];
assign HALT = HALT_i;
assign NOP = NOP_i;

// Logic to determine ALU operations
// ADD, SUB, XOR, ANDN
// ROL, SLL, ROR, SRL
always@(*) begin
   case(func)
		2'b00: begin
				alu_op = 4'h0;				// ADD
				shift_rot_op = 4'h2;		// ROL
			 end
		2'b01: begin
				alu_op = 4'h1;				// SUB
				shift_rot_op = 4'h4;		// SLL
			 end
		2'b10: begin
				alu_op = 4'h7;				// XOR
				shift_rot_op = 4'h3;		// ROR
			 end
		2'b11: begin
				alu_op = 4'hD;				// ANDN
				shift_rot_op = 4'h5;		// SRL
			 end
	endcase
end


/*
		ADD, ADDI, LD, STU, ST 			0
		SUBI, SUB				 			1
		ROL, ROLI 							2
		ROR, RORI 							3
		SLL, SLLI 							4
		SRL, SRLI 							5
		BTR 									6
		XOR, XORI 							7
		SEQ 									8
		SLT 									9
		SLE 									10
		SCO									11
		SLBI 									12
		ANDN, ANDNI 						13
*/
always@(*) begin
   case(opcode)
		5'b00000: begin			/************************************ HALT */
					// Only HALT is set to 1, all others 0
					instr_type_i = 0;
					HALT_i = 1;  
					NOP_i = 0;
					writeR7_i = 0;  
					jumpReg_i = 0;
					jump_i = 0;
					branch_i = 0;
					memToReg_i = 0;
					memRead_i = 0;
					ALUop_i = 0;
					memWrite_i = 0;
					ALUsrc_i = 0;
					regWrite_i = 0;
				 end
		5'b00001: begin			/************************************ NOP */
					// Only NOP is set to 1, all others 0
					instr_type_i = 0;
					HALT_i = 0;  
					NOP_i = 1;
					writeR7_i = 0;  
					jumpReg_i = 0;
					jump_i = 0;
					branch_i = 0;
					memToReg_i = 0;
					memRead_i = 0;
					ALUop_i = 0;
					memWrite_i = 0;
					ALUsrc_i = 0;
					regWrite_i = 0;
				 end
		5'b00100: begin			/************************************ J */
					instr_type_i = 0;
					HALT_i = 0;  
					NOP_i = 0;
					writeR7_i = 0;  
					jumpReg_i = 0;
					jump_i = 1;				// JUMP instr
					branch_i = 0;
					memToReg_i = 0;
					memRead_i = 0;
					ALUop_i = 0;
					memWrite_i = 0;
					ALUsrc_i = 0;
					regWrite_i = 0;
				 end
		5'b00110: begin			/************************************ JAL */
					instr_type_i = 0;
					HALT_i = 0;  
					NOP_i = 0;
					writeR7_i = 1;  		// Writing to R7
					jumpReg_i = 0;
					jump_i = 1;
					branch_i = 0;
					memToReg_i = 0;
					memRead_i = 0;
					ALUop_i = 0;
					memWrite_i = 0;
					ALUsrc_i = 0;
					regWrite_i = 1;		// Writing to reg R7
				 end
		5'b01000: begin			/************************************ ADDI */
					instr_type_i = 1;		// Format I-1 instruction
					HALT_i = 0;  
					NOP_i = 0;
					writeR7_i = 0;  
					jumpReg_i = 0;
					jump_i = 0;
					branch_i = 0;
					memToReg_i = 0;
					memRead_i = 0;
					ALUop_i = 4'd0;		// ALU OP 0
					memWrite_i = 0;
					ALUsrc_i = 1;			// Add immediate
					regWrite_i = 1;		// Rd <- Rs + I(zero ext.)
				 end
		5'b01001: begin			/************************************ SUBI */
					instr_type_i = 1;		// Format I-1 instruction
					HALT_i = 0;  
					NOP_i = 0;
					writeR7_i = 0;  
					jumpReg_i = 0;
					jump_i = 0;
					branch_i = 0;
					memToReg_i = 0;
					memRead_i = 0;
					ALUop_i = 4'd1;		// ALU OP 1
					memWrite_i = 0;
					ALUsrc_i = 1;			// Sub immediate
					regWrite_i = 1;		// Rd <- I(sign ext.) - Rs
				 end
		5'b01010: begin			/************************************ XORI */
					instr_type_i = 1;		// Format I-1 instruction
					HALT_i = 0;  
					NOP_i = 0;
					writeR7_i = 0;  
					jumpReg_i = 0;
					jump_i = 0;
					branch_i = 0;
					memToReg_i = 0;
					memRead_i = 0;
					ALUop_i = 4'd7;		// ALU OP 7
					memWrite_i = 0;
					ALUsrc_i = 1;			// xor immediate
					regWrite_i = 1;		// Rd <- Rs XOR I(zero ext.)
				 end
		5'b01011: begin			/************************************ ANDNI */
					instr_type_i = 1;		// Format I-1 instruction
					HALT_i = 0;  
					NOP_i = 0;
					writeR7_i = 0;  
					jumpReg_i = 0;
					jump_i = 0;
					branch_i = 0;
					memToReg_i = 0;
					memRead_i = 0;
					ALUop_i = 4'd13;		// ALU OP 13
					memWrite_i = 0;
					ALUsrc_i = 1;			// AND NOT immediate 
					regWrite_i = 1;		// Rd <- Rs AND ~I(zero ext.)
				 end
		5'b10100: begin			/************************************ ROLI */
					instr_type_i = 1;		// Format I-1 instruction
					HALT_i = 0;  
					NOP_i = 0;
					writeR7_i = 0;  
					jumpReg_i = 0;
					jump_i = 0;
					branch_i = 0;
					memToReg_i = 0;
					memRead_i = 0;
					ALUop_i = 4'd2;		// ALU OP 2
					memWrite_i = 0;
					ALUsrc_i = 1;			// Rotate left by immediate 
					regWrite_i = 1;		// Rd <- Rs << (rotate) I(lowest 4 bits)
				 end
		5'b10101: begin			/************************************ SLLI */
					instr_type_i = 1;		// Format I-1 instruction
					HALT_i = 0;  
					NOP_i = 0;
					writeR7_i = 0;  
					jumpReg_i = 0;
					jump_i = 0;
					branch_i = 0;
					memToReg_i = 0;
					memRead_i = 0;
					ALUop_i = 4'd4;		// ALU OP 4
					memWrite_i = 0;
					ALUsrc_i = 1;			// Shift left by immediate 
					regWrite_i = 1;		// Rd <- Rs << I(lowest 4 bits)
				 end
		5'b10110: begin			/************************************ RORI */
					instr_type_i = 1;		// Format I-1 instruction
					HALT_i = 0;  
					NOP_i = 0;
					writeR7_i = 0;  
					jumpReg_i = 0;
					jump_i = 0;
					branch_i = 0;
					memToReg_i = 0;
					memRead_i = 0;
					ALUop_i = 4'd3;		// ALU OP 3	
					memWrite_i = 0;
					ALUsrc_i = 1;			// Rotate right by immediate 
					regWrite_i = 1;		// Rd <- Rs >> (rotate) I(lowest 4 bits)
				 end
		5'b10111: begin			/************************************ SRLI */
					instr_type_i = 1;		// Format I-1 instruction
					HALT_i <= 0;  
					NOP_i = 0;
					writeR7_i = 0;  
					jumpReg_i = 0;
					jump_i = 0;
					branch_i = 0;
					memToReg_i = 0;
					memRead_i = 0;
					ALUop_i = 4'd5;		// ALU OP 5
					memWrite_i = 0;
					ALUsrc_i =  1;			// Shift right by immediate 
					regWrite_i = 1;		// Rd <- Rs >> I(lowest 4 bits)
				 end
		5'b10000: begin			/************************************ ST */
					instr_type_i = 1;		// Format I-1 instruction
					HALT_i = 0;  
					NOP_i = 0;
					writeR7_i = 0;  
					jumpReg_i = 0;
					jump_i = 0;
					branch_i = 0;
					memToReg_i = 0;
					memRead_i = 0;
					ALUop_i = 4'd0;		// ALU OP 0
					memWrite_i = 1;		// STORE writes to memory
					ALUsrc_i = 1;			// Offset memory by immediate
					regWrite_i = 0;		// NO REG WRITE:	Mem[Rs + I(sign ext.)] <- Rd
				 end
		5'b10001: begin			/************************************ LD */
					instr_type_i = 1;		// Format I-1 instruction
					HALT_i = 0;  
					NOP_i = 0;
					writeR7_i = 0;  
					jumpReg_i = 0;
					jump_i = 0;
					branch_i = 0;
					memToReg_i = 1;		// Reading from memory, writing to REG
					memRead_i = 1;			// LOAD reads from memory
					ALUop_i = 4'd0;		// ALU OP 0
					memWrite_i = 0;
					ALUsrc_i = 1;			// Offset memory by immediate
					regWrite_i = 1;		// Rd <- Mem[Rs + I(sign ext.)]
				 end
		5'b10011: begin			/************************************ STU */
					instr_type_i = 1;		// Format I-1 instruction
					HALT_i = 0;  
					NOP_i = 0;
					writeR7_i = 0;  
					jumpReg_i = 0;
					jump_i = 0;
					branch_i = 0;
					memToReg_i = 0;
					memRead_i = 0;
					ALUop_i = 4'd0;		// ALU OP 0
					memWrite_i = 1;		// STU writes to memory
					ALUsrc_i = 1;			// Offset memory by immediate
					regWrite_i = 1;		// Mem[Rs + I(sign ext.)] <- Rd, Rs <- Rs + I(ssign ext.)
				 end
		5'b11000: begin			/************************************ LBI */
					instr_type_i = 2;		// Format I-2 instruction
					HALT_i = 0;  
					NOP_i = 0;
					writeR7_i = 0;  
					jumpReg_i = 0;
					jump_i = 0;
					branch_i = 0;
					memToReg_i = 0;
					memRead_i = 0;
					ALUop_i = 4'hE;		// ALU OP 14
					memWrite_i = 0;
					ALUsrc_i = 1;			// Immediate is read into reg
					regWrite_i = 1;			// Rs <- I(sign ext.)
				 end
		5'b10010: begin			/************************************ SLBI */
					instr_type_i = 2;		// Format I-2 instruction
					HALT_i = 0;  
					NOP_i = 0;
					writeR7_i = 0;  
					jumpReg_i = 0;
					jump_i = 0;
					branch_i = 0;
					memToReg_i = 0;
					memRead_i = 0;
					ALUop_i = 4'hC;		// ALU OP 12
					memWrite_i = 0;
					ALUsrc_i = 1;			// Immediate user for OR
					regWrite_i = 1;		// Rs <- (Rs << 8) | I(zero ext.)
				 end
		5'b00101: begin			/************************************ JR */
					instr_type_i = 2;		// Format I-2 instruction
					HALT_i = 0;  
					NOP_i = 0;
					writeR7_i = 0;  
					jumpReg_i = 1;			// Reading from Rs
					jump_i = 1;				// JUMP instr
					branch_i = 0;
					memToReg_i = 0;
					memRead_i = 0;
					ALUop_i = 0;
					memWrite_i = 0;
					ALUsrc_i = 0;
					regWrite_i = 0;
				 end
		5'b00111: begin			/************************************ JALR */
					instr_type_i = 2;		// Format I-2 instruction
					HALT_i = 0;  
					NOP_i = 0;
					writeR7_i = 1;  		// Writing to R7
					jumpReg_i = 1;			// Reading from Rs
					jump_i = 1;				// JUMP instr
					branch_i = 0;
					memToReg_i = 0;
					memRead_i = 0;
					ALUop_i = 0;
					memWrite_i = 0;
					ALUsrc_i = 0;
					regWrite_i = 1;		// Writing to reg R7
				 end
		5'b01100: begin			/************************************ BEQZ */
					instr_type_i = 2;		// Format I-2 instruction
					HALT_i = 0;  
					NOP_i = 0;
					writeR7_i = 0;  
					jumpReg_i = 0;
					jump_i = 0;
					branch_i = 1;			// BRANCH INSTR
					memToReg_i = 0;
					memRead_i = 0;
					ALUop_i = 0;
					memWrite_i = 0;
					ALUsrc_i = 0;
					regWrite_i = 0;
				 end
		5'b01101: begin			/************************************ BNEZ */
					instr_type_i = 2;		// Format I-2 instruction
					HALT_i = 0;  
					NOP_i = 0;
					writeR7_i = 0;  
					jumpReg_i = 0;
					jump_i = 0;
					branch_i = 1;			// BRANCH INSTR
					memToReg_i = 0;
					memRead_i = 0;
					ALUop_i = 0;
					memWrite_i = 0;
					ALUsrc_i = 0;
					regWrite_i = 0;
				 end
		5'b01110: begin			/************************************ BLTZ */
					instr_type_i = 2;		// Format I-2 instruction
					HALT_i = 0;  
					NOP_i = 0;
					writeR7_i = 0;  
					jumpReg_i = 0;
					jump_i = 0;
					branch_i = 1;			// BRANCH INSTR
					memToReg_i = 0;
					memRead_i = 0;
					ALUop_i = 0;
					memWrite_i = 0;
					ALUsrc_i = 0;
					regWrite_i = 0;
				 end
		5'b01111: begin			/************************************ BGEZ */
					instr_type_i = 2;		// Format I-2 instruction
					HALT_i = 0;  
					NOP_i = 0;
					writeR7_i = 0;  
					jumpReg_i = 0;
					jump_i = 0;
					branch_i = 1;			// BRANCH INSTR
					memToReg_i = 0;
					memRead_i = 0;
					ALUop_i = 0;
					memWrite_i = 0;
					ALUsrc_i = 0;
					regWrite_i = 0;
				 end
		5'b11001: begin			/************************************ BTR */
					instr_type_i = 3;		// Format R instruction
					HALT_i = 0;  
					NOP_i = 0;
					writeR7_i = 0;  
					jumpReg_i = 0;
					jump_i = 0;
					branch_i = 0;
					memToReg_i = 0;
					memRead_i = 0;
					ALUop_i = 6;			// ALU OP 6
					memWrite_i = 0;
					ALUsrc_i = 0;
					regWrite_i = 1;		// Rd[bit i] <- Rs[bit 15-i] for i = 0..15
				 end
		5'b11011: begin			/************************************ ADD, SUB, XOR, ANDN */
					instr_type_i = 3;		// Format R instruction
					HALT_i = 0;  
					NOP_i = 0;
					writeR7_i = 0;  
					jumpReg_i = 0;
					jump_i = 0;
					branch_i = 0;
					memToReg_i = 0;
					memRead_i = 0;
					ALUop_i = alu_op;		// ALU OP (decided in case statement)
					memWrite_i = 0;
					ALUsrc_i = 0;			// ALU src 0: Reading from 2 regs
					regWrite_i = 1; 		// Rd <- Rs + Rt (for add)
				 end
		5'b11010: begin			/************************************ ROL, SLL, ROR, SRL */
					instr_type_i = 3;		// Format R instruction
					HALT_i = 0;  
					NOP_i = 0;
					writeR7_i = 0;  
					jumpReg_i = 0;
					jump_i = 0;
					branch_i = 0;
					memToReg_i = 0;
					memRead_i = 0;
					ALUop_i = shift_rot_op;	// Shift/ROTATE OP (decided in case statement)
					memWrite_i = 0;
					ALUsrc_i = 0;			// ALU src 0: Reading from 2 regs
					regWrite_i = 1;		// Rd <- Rs << (rotate) Rt (lowest 4 bits)
				 end
		5'b11100: begin			/************************************ SEQ */
					instr_type_i = 3;		// Format R instruction
					HALT_i = 0;  
					NOP_i = 0;
					writeR7_i = 0;  
					jumpReg_i = 0;
					jump_i = 0;
					branch_i = 0;
					memToReg_i = 0;
					memRead_i = 0;
					ALUop_i = 4'd8;		// ALU OP 8
					memWrite_i = 0;
					ALUsrc_i = 0;
					regWrite_i = 1;		// if (Rs == Rt) then Rd <- 1 else Rd <- 0
				 end
		5'b11101: begin			/************************************ SLT */
					instr_type_i = 3;		// Format R instruction
					HALT_i = 0;  
					NOP_i = 0;
					writeR7_i = 0;  
					jumpReg_i = 0;
					jump_i = 0;
					branch_i = 0;
					memToReg_i = 0;
					memRead_i = 0;
					ALUop_i = 4'd9;		// ALU OP 9
					memWrite_i = 0;
					ALUsrc_i = 0;
					regWrite_i = 1;		// if (Rs < Rt) then Rd <- 1 else Rd <- 0
				 end
		5'b11110: begin			/************************************ SLE */
					instr_type_i = 3;		// Format R instruction
					HALT_i = 0;  
					NOP_i = 0;
					writeR7_i = 0;  
					jumpReg_i = 0;
					jump_i = 0;
					branch_i = 0;
					memToReg_i = 0;
					memRead_i = 0;
					ALUop_i = 4'd10;		// ALU OP 10
					memWrite_i = 0;
					ALUsrc_i = 0;
					regWrite_i = 1;		// if (Rs <= Rt) then Rd <- 1 else Rd <- 0
				 end
		5'b11111: begin			/************************************ SCO */
					instr_type_i = 3;		// Format R instruction
					HALT_i = 0;  
					NOP_i = 0;
					writeR7_i = 0;  
					jumpReg_i = 0;
					jump_i = 0;
					branch_i = 0;
					memToReg_i = 0;
					memRead_i = 0;
					ALUop_i = 4'd11;		// ALU OP 11
					memWrite_i = 0;
					ALUsrc_i = 0;
					regWrite_i = 1;		// Writing Rd
				 end
   		default: begin
					instr_type_i = 0;               // Format R instruction
                    HALT_i = 0;
					NOP_i = 0;
					writeR7_i = 0;
					jumpReg_i = 0;
					jump_i = 0;
					branch_i = 0;
					memToReg_i = 0;
					memRead_i = 0;
					ALUop_i = 4'd0;                // ALU OP 11
					memWrite_i = 0;
					ALUsrc_i = 0;
					regWrite_i = 0;         // Writing Rd
				end
	endcase
end

endmodule
