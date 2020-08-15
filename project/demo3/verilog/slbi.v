module slbi(A, B, Out);

input [15:0] A, B;
output wire [15:0] Out;

assign Out = (A << 8) | B;

endmodule