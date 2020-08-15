module extension_unit(instruction, immediate);

// There are 5 flavors of extending immediates, which are used by various instructions: 
//			5b zero extension, 
//			5b sign extension, 
//			8b zero extension, 
//			8b sign extension, 
//			and 11b sign extension

input [15:0] instruction;
output reg [15:0] immediate;
wire [4:0] opcode;

assign opcode = instruction[15:11];
always@(*) begin
   case(opcode)
		5'b00100: begin			// J (11b sign)
					immediate = {{5{instruction[10]}}, instruction[10:0]};
				 end
		5'b00110: begin			// JAL (11b sign)
					immediate = {{5{instruction[10]}}, instruction[10:0]};
				 end
		5'b01000: begin			// ADDI (5b sign)
					immediate = {{11{instruction[4]}}, instruction[4:0]};
				 end
		5'b01001: begin			// SUBI (5b sign)
					immediate = {{11{instruction[4]}}, instruction[4:0]};
				 end
		5'b01010: begin			// XORI (5b zero)
					immediate = {11'h0, instruction[4:0]};
				 end
		5'b01011: begin			// ANDNI (5b zero)
					immediate = {11'h0, instruction[4:0]};
				 end
		5'b11000: begin			// LBI (8b sign)
					immediate = {{8{instruction[7]}}, instruction[7:0]};
				 end
		5'b10010: begin			// SLBI (8b zero)
					immediate = {8'h0, instruction[7:0]};
				 end
		5'b00101: begin			// JR (8b sign)
					immediate = {{8{instruction[7]}}, instruction[7:0]};
				 end
		5'b00111: begin			// JALR (8b sign)
					immediate = {{8{instruction[7]}}, instruction[7:0]};
				 end
		5'b01100: begin			// BEQZ (8b sign)
					immediate = {{8{instruction[7]}}, instruction[7:0]};
				 end
		5'b01101: begin			// BNEZ (8b sign)
					immediate = {{8{instruction[7]}}, instruction[7:0]};
				 end
		5'b01110: begin			// BLTZ (8b sign)
					immediate = {{8{instruction[7]}}, instruction[7:0]};
				 end
		5'b01111: begin			// BGEZ (8b sign)
					immediate = {{8{instruction[7]}}, instruction[7:0]};
				 end
		default: immediate = {{11{instruction[4]}}, instruction[4:0]}; // only matters for ROLI, SLLI, RORI, SRLI - they take the bottom 4 bits. Otherwise - imm not used
   endcase
end

endmodule
