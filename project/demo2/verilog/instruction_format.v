module instruction_format(input [15:0] instruction, output [1:0] instr_type);

wire [4:0] opcode;
assign opcode = instruction[15:11];
reg [1:0] instr_type_i;
assign instr_type = instr_type_i;

always@(*) begin
   case(opcode)
		5'b00000: begin			/************************************ HALT */
					instr_type_i = 0;
				 end
		5'b00001: begin			/************************************ NOP */
					instr_type_i = 0;
				 end
		5'b00100: begin			/************************************ J */
					instr_type_i = 0;
				 end
		5'b00110: begin			/************************************ JAL */
					instr_type_i = 0;
				 end
		5'b01000: begin			/************************************ ADDI */
					instr_type_i = 1;
				 end
		5'b01001: begin			/************************************ SUBI */
					instr_type_i = 1;
				 end
		5'b01010: begin			/************************************ XORI */
					instr_type_i = 1;
				 end
		5'b01011: begin			/************************************ ANDNI */
					instr_type_i = 1;
				 end
		5'b10100: begin			/************************************ ROLI */
					instr_type_i = 1;
				 end
		5'b10101: begin			/************************************ SLLI */
					instr_type_i = 1;
				 end
		5'b10110: begin			/************************************ RORI */
					instr_type_i = 1;
				 end
		5'b10111: begin			/************************************ SRLI */
					instr_type_i = 1;
				 end
		5'b10000: begin			/************************************ ST */
					instr_type_i = 1;
				 end
		5'b10001: begin			/************************************ LD */
					instr_type_i = 1;
				 end
		5'b10011: begin			/************************************ STU */
					instr_type_i = 1;
				 end
		5'b11000: begin			/************************************ LBI */
					instr_type_i = 2;
				 end
		5'b10010: begin			/************************************ SLBI */
					instr_type_i = 2;
				 end
		5'b00101: begin			/************************************ JR */
					instr_type_i = 2;
				 end
		5'b00111: begin			/************************************ JALR */
					instr_type_i = 2;
				 end
		5'b01100: begin			/************************************ BEQZ */
					instr_type_i = 2;
				 end
		5'b01101: begin			/************************************ BNEZ */
					instr_type_i = 2;
				 end
		5'b01110: begin			/************************************ BLTZ */
					instr_type_i = 2;
				 end
		5'b01111: begin			/************************************ BGEZ */
					instr_type_i = 2;
				 end
		5'b11001: begin			/************************************ BTR */
					instr_type_i = 3;
				 end
		5'b11011: begin			/************************************ ADD, SUB, XOR, ANDN */
					instr_type_i = 3;
				 end
		5'b11010: begin			/************************************ ROL, SLL, ROR, SRL */
					instr_type_i = 3;
				 end
		5'b11100: begin			/************************************ SEQ */
					instr_type_i = 3;
				 end
		5'b11101: begin			/************************************ SLT */
					instr_type_i = 3;
				 end
		5'b11110: begin			/************************************ SLE */
					instr_type_i = 3;
				 end
		5'b11111: begin			/************************************ SCO */
					instr_type_i = 3;
				 end
   		default: begin
					instr_type_i = 0;
				end
	endcase
end

endmodule