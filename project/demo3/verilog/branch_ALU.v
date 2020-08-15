//ALU: BEQZ, BNEZ, BLTZ, BGEZ

module branch_ALU(opcode, RsVal, zero);

input [4:0] opcode;
input [15:0] RsVal;
output wire zero;

reg zeroWire;

always @(*) begin
	case(opcode)
		5'b01100: zeroWire = RsVal ? 0 : 1; //BEQZ
		5'b01101: zeroWire = RsVal ? 1 : 0; //BNEZ
		5'b01110: zeroWire = (RsVal[15]) ? 1 : 0; //BLTZ
		5'b01111: zeroWire = (RsVal[15]) ? 0 : 1; //BGEZ
		default: zeroWire = 0;
	endcase
end

assign zero = zeroWire;
			
endmodule	
	
	
