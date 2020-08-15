/*
    CS/ECE 552 Spring '20
    Homework #1, Problem 2
    
    a 4-bit CLA module
*/
module cla_4b(A, B, C_in, S, C_out, G, P);

    // declare constant for size of inputs, outputs (N)
    parameter   N = 4;

    input [N-1: 0] A, B;
    input          C_in;
    output [N-1:0] S;
    output         C_out, G, P;

    //Carry outs for each bit 
    wire C_out0, C_out1, C_out2;

    //Get carry out for first bit
    carryLogic carryLogic0(.A(A[0]),.B(B[0]),.Cin(C_in),.C_out(C_out0), .G(), .P());
    
    //Add A[0] and B[0] and get S[0]
    fullAdder_1b fullAdder0(.A(A[0]),.B(B[0]),.C_in(C_in),.C_out(),.S(S[0]));

    //Get carry out for second bit
    carryLogic carryLogic1(.A(A[1]),.B(B[1]),.Cin(C_out0),.C_out(C_out1), .G(), .P());
    
    //Add A[1] and B[1] and get S[1]
    fullAdder_1b fullAdder1(.A(A[1]),.B(B[1]),.C_in(C_out0),.C_out(),.S(S[1]));

    //Get carry out for third bit
    carryLogic carryLogic2(.A(A[2]),.B(B[2]),.Cin(C_out1),.C_out(C_out2), .G(), .P());
    
    //Add A[2] and B[2] and get S[2]
    fullAdder_1b fullAdder2(.A(A[2]),.B(B[2]),.C_in(C_out1),.C_out(),.S(S[2]));

    //Get carry out for third bit
    carryLogic carryLogic3(.A(A[3]),.B(B[3]),.Cin(C_out2),.C_out(C_out), .G(G), .P(P));
    
    //Add A[2] and B[2] and get S[2]
    fullAdder_1b fullAdder3(.A(A[3]),.B(B[3]),.C_in(C_out2),.C_out(),.S(S[3]));

endmodule
