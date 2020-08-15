module sco(A, B, Out);

input [15:0] A, B;
output [15:0] Out;
wire C_out;

cla_16b sco_ADD(.A(A), .B(B), .C_in(1'b0), .S(), .C_out(C_out));

assign Out = {{15{1'h0}}, C_out};

endmodule
