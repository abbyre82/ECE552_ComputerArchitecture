module carryLogic(A, B, Cin, C_out, P, G);

	input A, B, Cin;
	output C_out, P, G;
	wire G_inv, P_nor, C_out_1;

	//Logic to get G
	//G = A * B
	nand2 nand_G(.in1(A),.in2(B),.out(G_inv));
	not1 not_1(.in1(G_inv), .out(G)); 

	//Logic to get P
	//P = A + B
	nor2 nor_1(.in1(A),.in2(B),.out(P_nor));
	not1 not_2(.in1(P_nor), .out(P));

	//Logic to get Carry out
	//Ci = Gi + Pi * Ci-1
	//Ci = NAND(Ginv , NAND(P, C_in_P))
	nand2 nand_C1(.in1(P),.in2(Cin),.out(C_out_1));
	nand2 nand_C2(.in1(G_inv),.in2(C_out_1),.out(C_out));

endmodule
	
	
