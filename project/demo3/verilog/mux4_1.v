/*
    CS/ECE 552 Spring '20
    Homework #1, Problem 1

    4-1 mux template
*/
module mux4_1(InA, InB, InC, InD, S, Out);
    input        InA, InB, InC, InD;
    input [1:0]  S;
    output 	Out;
    wire 	AB, CD;	

    mux2_1 MUX1(InA, InB, S[0], AB);
    mux2_1 MUX2(InC, InD, S[0], CD);
    mux2_1 MUX3(AB, CD, S[1], Out);

endmodule
