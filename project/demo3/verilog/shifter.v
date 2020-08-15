/*
    CS/ECE 552 Spring '20
    Homework #2, Problem 1
    
    A barrel shifter module.  It is designed to shift a number via rotate
    left, shift left, shift right arithmetic, or shift right logical based
    on the Op() value that is passed in (2 bit number).  It uses these
    shifts to shift the value any number of bits between 0 and 15 bits.
 */
module shifter (In, Cnt, Op, Out);

   // declare constant for size of inputs, outputs (N) and # bits to shift (C)
   parameter   N = 16;
   parameter   C = 4;
   parameter   O = 2;

   input [N-1:0]   In;
   input [C-1:0]   Cnt;
   input [O-1:0]   Op;
   output reg [N-1:0]  Out;

   wire [15:0] shiftLeftResult;
   wire [15:0] shiftRightLogical;
   wire [15:0] shiftRightArithmetic;
   wire [15:0] rotateLeftResult;

   shiftLeft SHFT1(In, Cnt, shiftLeftResult);
   shiftRight_Logical SHFT_RL(In, Cnt, shiftRightLogical);
   shiftRight_Arithmetic SHFT_RA(In, Cnt, shiftRightArithmetic);
   rotateLeft ROTL(In, Cnt, rotateLeftResult);

always@(*) begin
   case(Op)
	2'b00: assign Out = rotateLeftResult;
	2'b01: assign Out = shiftLeftResult;
	2'b10: assign Out = shiftRightArithmetic;
	2'b11: assign Out = shiftRightLogical;
   endcase
end

   //reg [15:0] arr;
   
endmodule
