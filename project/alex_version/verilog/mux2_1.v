/*
    CS/ECE 552 Spring '20
    Homework #1, Problem 1

    2-1 mux template
*/
module mux2_1(InA, InB, S, Out);
    input   InA, InB;
    input   S;
    output  Out;

    wire wireA, wireB, invS;
    
    not1 NOT_S(S, invS);
    nand2 NAND_A(InA, invS, wireA);
    nand2 NAND_B(InB, S, wireB);
    nand2 NAND_C(wireA, wireB, Out);

endmodule
