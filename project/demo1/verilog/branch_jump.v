module branch_jump(opcode, RsVal, incr_PC, JumpReg, Jump, Branch, ALUResult, immediate, next_PC);

input [15:0] incr_PC;
input JumpReg, Jump, Branch;
input [15:0] ALUResult; 
input [15:0] immediate;
input [4:0] opcode;
input [15:0] RsVal;
output [15:0] next_PC;

wire [15:0] immedWire;
wire [15:0] addOutput;
wire [15:0] mux2Output;
wire BranchAND;
wire zero;
   wire C_out;

//A, B, C_in, S, C_out
cla_16b ADD(.A(incr_PC), .B(immedWire), .C_in(1'b0), .S(addOutput), .C_out(C_out));
//InA, InB, InC, InD, S, Out
//mux4_1 MUX4_1(.InD(incr_PC), .InC(addOutput), .InB(mux2Output), .InA(), .S({Jump, BranchAND}), .Out(next_PC));
// if(jump) 
// {
// 	if(branchAND) 
//		{
//			next_PC = x;
//		}
//		else
//		{
//			next_PC = mux2Output;
//		}
// }
// else
// {
// 	if(branchAND) 
//		{
//			next_PC = addOutput;
//		}
//		else next_PC = incr_PC
// }
assign next_PC = Jump ? mux2Output : (BranchAND ? addOutput : incr_PC); 

assign mux2Output = JumpReg ? ALUResult : addOutput;

branch_ALU ALU(.opcode(opcode), .zero(zero), .RsVal(RsVal));

assign BranchAND = zero & Branch; 
assign immedWire = immediate;

endmodule
	
