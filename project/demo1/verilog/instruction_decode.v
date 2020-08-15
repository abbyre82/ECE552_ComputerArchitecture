module instruction_decode(instr_Type, instruction, readReg1, readReg2, writeReg, incr_PC);

input [1:0] instr_Type;
input [15:0] instruction;
input [15:0] incr_PC;
output wire [2:0] readReg1, readReg2, writeReg;

reg [2:0] readReg1Wire, readReg2Wire, writeRegWire;
wire [4:0] opcode;
wire JALROpcode, JALOpcode, SLBIOpcode, LBIOpcode, STOpcode, STUOpcode;
//I format 1
//ADDI
//SUBI
//XORI
//ANDI
//ROLI
//SLLI
//RORI
//SRLI
//ST
//LD
//STU

//I format 2
//LBI
//SLBI
//JR
//JALR
//BEQZ
//BNEZ
//BLTZ
//BGEZ

assign opcode = instruction[15:11];
assign JALROpcode = |(opcode ^ 5'b00111);
assign JALOpcode = |(opcode ^ 5'b00110);
assign SLBIOpcode = |(opcode ^ 5'b10010);
assign LBIOpcode = |(opcode ^ 5'b11000);
assign STOpcode = |(opcode ^ 5'b10000);
assign STUOpcode = |(opcode ^ 5'b10011);
			
always @(*) begin
	case(instr_Type)
		2'b00: begin //J format 5 bits [OpCode], 11 bits [Displacement]
			writeRegWire = (~JALOpcode) ? 7: 0;
			readReg1Wire = 0;
			readReg2Wire = 0;
			end
		2'b01: begin //I format 1 5 bits [OpCode], 3 bits [Rs], 3 bits [Rd], 5 bits [Immediate]
			// Reg1 = Rs, R2 = Rt,
			// If ST - not writing to register.
			writeRegWire = ( ~STUOpcode ) ? instruction[10:8] : instruction[7:5];
			
			// Rs is the same position for all instr
			readReg1Wire = instruction[10:8];

			// If it's STU or ST, Rd is written to mem
			readReg2Wire = ( ~STUOpcode | ~STOpcode ) ?  instruction[7:5] : 3'h0;

			end
		2'b10: begin //I format 2 5 bits [OpCode], 3 bits [Rs], 8 bits [Immediate]
			readReg1Wire = instruction[10:8];
			//If JALR, writeReg = R7. If SLBI or LBI, writeReg = Rs. Else, we don't care what writeReg is.
			writeRegWire = (~JALROpcode) ? 7 : ((~SLBIOpcode | ~LBIOpcode) ? instruction[10:8] : 0);
		   	end
		2'b11: begin //R format 5 bits [OpCode], 3 bits[Rs], 3 bits[Rt], 3 bits[Rd], 2 bits[Op Code Extension]
			readReg1Wire = instruction[10:8];
			readReg2Wire = instruction[7:5];
			writeRegWire = instruction[4:2];
			end
	endcase
end

assign writeReg = writeRegWire;
assign readReg1 = readReg1Wire;
assign readReg2 = readReg2Wire;

endmodule
			
			
