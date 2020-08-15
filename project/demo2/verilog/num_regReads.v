module num_regReads(input [15:0] instruction, output [1:0] num_reg_reads);

wire [4:0] opcode;
assign opcode = instruction[15:11];
reg [1:0] num_reg_reads_i;
assign num_reg_reads = num_reg_reads_i;

always@(*) begin
   case(opcode)
		5'b00000: begin			/************************************ HALT */
					num_reg_reads_i = 2'h0;
				 end
		5'b00001: begin			/************************************ NOP */
					num_reg_reads_i = 2'h0;
				 end
		5'b00100: begin			/************************************ J */
					num_reg_reads_i = 2'h0;
				 end
		5'b00110: begin			/************************************ JAL */
					num_reg_reads_i = 2'h0;
				 end
		5'b01000: begin			/************************************ ADDI */
					num_reg_reads_i = 2'h1;
				 end
		5'b01001: begin			/************************************ SUBI */
					num_reg_reads_i = 2'h1;
				 end
		5'b01010: begin			/************************************ XORI */
					num_reg_reads_i = 2'h1;
				 end
		5'b01011: begin			/************************************ ANDNI */
					num_reg_reads_i = 2'h1;
				 end
		5'b10100: begin			/************************************ ROLI */
					num_reg_reads_i = 2'h1;
				 end
		5'b10101: begin			/************************************ SLLI */
					num_reg_reads_i = 2'h1;
				 end
		5'b10110: begin			/************************************ RORI */
					num_reg_reads_i = 2'h1;
				 end
		5'b10111: begin			/************************************ SRLI */
					num_reg_reads_i = 2'h1;
				 end
		5'b10000: begin			/************************************ ST */
					num_reg_reads_i = 2'h2;
				 end
		5'b10001: begin			/************************************ LD */
					num_reg_reads_i = 2'h1;
				 end
		5'b10011: begin			/************************************ STU */
					num_reg_reads_i = 2'h2;
				 end
		5'b11000: begin			/************************************ LBI */
					num_reg_reads_i = 2'h0;
				 end
		5'b10010: begin			/************************************ SLBI */
					num_reg_reads_i = 2'h1;
				 end
		5'b00101: begin			/************************************ JR */
					num_reg_reads_i = 2'h1;
				 end
		5'b00111: begin			/************************************ JALR */
					num_reg_reads_i = 2'h1;
				 end
		5'b01100: begin			/************************************ BEQZ */
					num_reg_reads_i = 2'h1;
				 end
		5'b01101: begin			/************************************ BNEZ */
					num_reg_reads_i = 2'h1;
				 end
		5'b01110: begin			/************************************ BLTZ */
					num_reg_reads_i = 2'h1;
				 end
		5'b01111: begin			/************************************ BGEZ */
					num_reg_reads_i = 2'h1;
				 end
		5'b11001: begin			/************************************ BTR */
					num_reg_reads_i = 2'h1;
				 end
		5'b11011: begin			/************************************ ADD, SUB, XOR, ANDN */
					num_reg_reads_i = 2'h2;
				 end
		5'b11010: begin			/************************************ ROL, SLL, ROR, SRL */
					num_reg_reads_i = 2'h2;
				 end
		5'b11100: begin			/************************************ SEQ */
					num_reg_reads_i = 2'h2;
				 end
		5'b11101: begin			/************************************ SLT */
					num_reg_reads_i = 2'h2;
				 end
		5'b11110: begin			/************************************ SLE */
					num_reg_reads_i = 2'h2;
				 end
		5'b11111: begin			/************************************ SCO */
					num_reg_reads_i = 2'h2;
				 end
   		default: begin
					num_reg_reads_i = 2'h0;
				end
	endcase
end

endmodule