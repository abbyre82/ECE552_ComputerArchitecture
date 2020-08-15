/*
    CS/ECE 552 Spring '20
    Homework #1, Problem 2
    
    a 1-bit full adder
*/
module fullAdder_1b(A, B, C_in, S, C_out);
    input  A, B;
    input  C_in;
    output S;
    output C_out;

    wire nand1_out, nand2_out, nand3_out;

    nand2 nand1(.in1(A),.in2(B),.out(nand1_out));
    nand2 nand2(.in1(B),.in2(C_in),.out(nand2_out));
    nand2 nand3(.in1(A),.in2(C_in),.out(nand3_out));
    nand3 nand_out(.in1(nand1_out),.in2(nand2_out),.in3(nand3_out),.out(C_out));
   
    xor3 xor1(.in1(A),.in2(B),.in3(C_in),.out(S));

endmodule
