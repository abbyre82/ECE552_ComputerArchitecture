/*
   CS/ECE 552 Spring '20
  
   Filename        : decode.v
   Description     : This is the module for the overall decode stage of the processor.
*/
module decode (clk,
					rst,
					instruction, 
					currPC,
					new_addr,
					write_data, 
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
					regWrite,
					immediate,
					read_data_1,
					read_data_2,
					nextPC);

// Inputs:
//	1. Instruction [15:0]
//	2. incremented address (PC+2)
//	3. Write Data [15:0]
// clk, rst (for regfile)
   
input clk, rst;
input [15:0] instruction;
input [15:0] new_addr, currPC;
input [15:0] write_data;

output HALT;
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
output [15:0] immediate;
output [15:0] read_data_1, read_data_2;
output [15:0] nextPC;

wire [1:0] instr_type;
wire [2:0] readReg1, readReg2, writeReg;
wire zero;
wire[15:0] next_PC_i, branchAluResult;
wire branch_or_jump, branch_or_jump_n;

nor2 NOR_BR_JMP(branch, jump, branch_or_jump_n);
not1 NOT_BR_JMP(branch_or_jump_n, branch_or_jump);

assign nextPC = HALT ? currPC : (branch_or_jump ? next_PC_i : new_addr);

// Control unit: ALEX
// 	A giant case statement for all the ISA instr
// 	Outputs a bunch of control signals:
//		1. HALT
//		2. NOP
//		3. WriteR7
//		4. JumpReg
//		5. Jump
//		6. Branch
//		7. MemToReg
//		8. MemRead
//		9. ALUOP (figure out how it goes with the added alu)
//		10. MemWrite
//		11. ALUSrc
//		12. RegWrite
control_unit CONTROL(	.instruction(instruction), 
			.instr_type(instr_type), 
			.HALT(HALT),  
			.NOP(NOP),  
			.writeR7(writeR7),  
			.jumpReg(jumpReg),  
			.jump(jump),  
			.branch(branch), 
			.memToReg(memToReg), 
			.memRead(memRead), 
			.ALUop(ALUop), 
			.memWrite(memWrite), 
			.ALUsrc(ALUsrc), 
			.regWrite(regWrite)	);


// Instruction Decode: ABBY
// 	Figure out what rt, rs, rd are
// 	Determine which are used for Read Reg 1, Read Reg 2, and Write Reg
instruction_decode DECODE_REGS(.instr_Type(instr_type),  
								.instruction(instruction),  
								.readReg1(readReg1),  
								.readReg2(readReg2),  
								.writeReg(writeReg),  
								.incr_PC(new_addr));

// Extension unit: ALEX
// 	Determine if SIGN extend or ZERO extend
extension_unit EXTEND_IMM(instruction, immediate);

//	Determine num bits
// Register File:
// 	From the instruction-decode unit - read from 2 regs.
regFile regFile0(
                // Outputs
                .read1Data(read_data_1), .read2Data(read_data_2), .err(),
                // Inputs
                .clk(clk), .rst(rst), .read1RegSel(readReg1), .read2RegSel(readReg2), .writeRegSel(writeReg), .writeData(write_data), .writeEn(regWrite)
                );


// BRANCH AND JUMPS: ABBY
// Additional ALU
//	Has operations for all branches (4)
// Word align (shift 2)
// Adder for curr instr and branch offset
// 2 Muxes (2-1, 4-1)
// AND gate for branch instruction

// branch_ALU BRANCH_ALU(.opcode(instruction[15:11]), .RsVal(read_data_1), .zero(zero));
//A, B, C_in, S, C_out
cla_16b ADD(.A(immediate), .B(read_data_1), .C_in(1'b0), .S(branchAluResult), .C_out());
branch_jump BRANCH_JUMP(.opcode(instruction[15:11]), 
								.RsVal(read_data_1), 
								.incr_PC(new_addr),  
								.JumpReg(jumpReg),  
								.Jump(jump),   
								.Branch(branch),  
								.ALUResult(branchAluResult),  
								.immediate(immediate),  
								.next_PC(next_PC_i));
endmodule
