/*
    CS/ECE 552 Spring '20
    Homework #1, Problem 2
    
    a 16-bit CLA module
*/
module cla_16b(A, B, C_in, S, C_out);

    // declare constant for size of inputs, outputs (N)
    parameter   N = 16;

    input [N-1: 0] A, B;
    input          C_in;
    output [N-1:0] S;
    output         C_out;

    //Carry outs for each bit 
    wire C_out0, C_out1, C_out2, G0, P0, G1, P1, G2, P2, G3, P3, C_in1, C_in2, C_in3;
    
    //Add A[3:0] and B[3:0] and get S[3:0]
    cla_4b cla_4_1(.A(A[3:0]),.B(B[3:0]),.C_in(C_in),.C_out(C_out0),.S(S[3:0]), .G(G0), .P(P0));
    
    //Compute Cin 1
    //Cin = G + P * C_out_prev
    compute_C_in compute1(.P(P0), .G(G0), .C_in_prev(C_out0), .C_in(C_in1));
    
    //Add A[7:4] and B[7:4] and get S[7:4]
    cla_4b cla_4_2(.A(A[7:4]),.B(B[7:4]),.C_in(C_in1),.C_out(C_out1),.S(S[7:4]), .G(G1), .P(P1));

    //Compute Cin 2
    compute_C_in compute2(.P(P1), .G(G1), .C_in_prev(C_out1), .C_in(C_in2));
    
    //Add A[11:8] and B[11:8] and get S[11:8]
    cla_4b cla_4_3(.A(A[11:8]),.B(B[11:8]),.C_in(C_in2),.C_out(C_out2),.S(S[11:8]), .G(G2), .P(P2));

    //Compute Cin 3
    compute_C_in compute3(.P(P2), .G(G2), .C_in_prev(C_out2), .C_in(C_in3));
    
    //Add A[15:12] and B[15:12] and get S[15:12]
    cla_4b cla_4_4(.A(A[15:12]),.B(B[15:12]),.C_in(C_in3),.C_out(C_out),.S(S[15:12]), .G(G3), .P(P3));

endmodule

