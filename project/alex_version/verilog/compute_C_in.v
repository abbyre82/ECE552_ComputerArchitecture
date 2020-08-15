module compute_C_in(P, G, C_in, C_in_prev);

input P, G, C_in_prev;

output C_in;

wire G_in, C_out_1;

//Logic to get Carry in
//Ci = Gi + Pi * Ci-1
//Ci = NAND(Ginv , NAND(P, C_in_P))
not1 not1(.in1(G), .out(G_inv));
nand2 nand_C1(.in1(P),.in2(C_in_prev),.out(C_out_1));
nand2 nand_C2(.in1(G_inv),.in2(C_out_1),.out(C_in));

endmodule