module slt(A, B, Out);

input [15:0] A, B;
output [15:0] Out;

wire compare;

assign compare = (A[15] 
assign Out = (~compare) ? 1 : 0;

endmodule
