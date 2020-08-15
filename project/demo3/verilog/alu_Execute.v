`define ADD 0
`define SUB 1
`define ROL 2
`define ROR 3
`define SLL 4
`define SRL 5
`define BTR 6
`define XOR 7
`define SEQ 8
`define SLT 9
`define SLE 10
`define SCO 11
`define SLBI 12
`define ANDN 13
`define LBI 14

module alu_Execute (InA, InB, Cin, Op, invA, invB, sign, Out, Zero, Ofl);
	//1) ADD
	//2) SUB (?)
	//3) ROTL
	//4) ROTR
	//5) SLL
	//6) SRL
	//7) BTR
	//8) XOR
	//9) AND
	//10) OR
	//11) SEQ
	//12) SLT
	//13) SLE
	//14) SCO
	//15) SLBI (?)
	//16) ADDI
	//17) SUBI
	//18) ANDNI
	//19) XORI
	//20) ROLI
	//21) SLLI 
	//22) RORI
	//23) SRLI
	//24) ST
	//25) LD
	//26) STU
	//27) LBI (added by Alex)

   // declare constant for size of inputs, outputs (N),
   // and operations (O)
   parameter    N = 16;
   parameter    O = 4;
   
   input [15:0] InA;
   input [15:0] InB;
   input         Cin;
   input [3:0] Op;
   input         invA;
   input         invB;
   input         sign;
   output wire [15:0] Out;
   output wire   Ofl;
   output        Zero;

   wire [15:0] S;
   wire C_out;

   wire [15:0] A, B;
   assign A = invA ? ~InA : InA;
   assign B = invB ? ~InB : InB;
   wire [15:0] shiftLeft, rotateLeft, shiftRight_A, shiftRight_L, rotateRight, btrOutput;
	wire [15:0] scoOutput, slbiOutput, seqOutput;
	reg OflWire;
   reg [15:0] OutWire;
	wire negative, negative_or_zero, neg_i, noz_i;

	// Calculate negative (for less than), negative OR zero (for less than or equal)
	// NEGATIVE
	//nor2 NOR_NEG(S[15], OflWire, neg_i);
	//not1 NOT_NEG(neg_i, negative);
	assign negative = S[15];
	
	// NEGATIVE OR ZERO
	nor2 NOR_NOZ(negative, Zero, noz_i);
	not1 NOT_NOZ(noz_i, negative_or_zero);
	

	//Instantiation of all ALU submodules
   shifter SHFT1(A, B[3:0], 2'b00, rotateLeft);
   shifter SHFT2(A, B[3:0], 2'b01, shiftLeft);
   shifter SHFT3(A, B[3:0], 2'b10, shiftRight_A);
   shifter SHFT4(A, B[3:0], 2'b11, shiftRight_L);
   rotateRight ROR(.In(A), .Cnt(B[3:0]), .Out(rotateRight));
	btr BTR(.A(A), .rot_A(btrOutput));
	sco SCO(.A(A), .B(B), .Out(scoOutput));
	seq SEQ(.A(A), .B(B), .Out(seqOutput));
	slbi SLBI(.A(A), .B(B), .Out(slbiOutput));

   cla_16b CLA_16(A, B, Cin, S, C_out);

   // If unsigned - overflow is just Cout
   // If signed:
   //	- If Cout = 1 AND MSB is 1 - no overflow
   // 	- If Cout = 1 AND MSB is 0 - OVERFLOW
   // 	- if Cout = 0 - NO OVERFLOW
   //assign ofl = (Op == 3'b100) ? (sign ? ( C_out? ( S[15] ? 0 : 1 ) : 0 ) : C_out): 0;
   
	wire ifLogic, diffSigns, bothPos, bothNeg, negResultFromPos, posResultFromNeg;
	assign diffSigns = A[15] ^ B[15];
	assign bothPos = ~A[15] & ~B[15];
	assign bothNeg = A[15] & B[15];
	assign negResultFromPos = S[15] & bothPos;
	assign posResultFromNeg = ~S[15] & bothNeg & ~Zero;
	assign ifLogic = C_out ? ( S[15] ? 0 : 1 ) : 0;
  	

always@(*) begin
   case(Op) //ADDI or ADD or LD or STU or ST
	`ADD: begin
				OutWire = S;
				OflWire = sign ? ( negResultFromPos | posResultFromNeg ? 1 : diffSigns ? 0 : ifLogic ) : C_out;
	      end
	`SUB: begin //SUBI or SUB
				OutWire = S;
				OflWire = sign ? ( negResultFromPos | posResultFromNeg ? 1 : diffSigns ? 0 : ifLogic ) : C_out;
			end
	`XOR: begin //XOR or XORI
				OutWire = A ^ B;
				OflWire = 0;
			end
	`ANDN: begin //ANDN or ANDNI
				OutWire = A & B;
				OflWire = 0;
			end
	`ROL: begin //ROL or ROLI
				OutWire = rotateLeft;
				OflWire = 0;
			end
	`SLL: begin //SLL or SLLI
				OutWire = shiftLeft;
				OflWire = 0;
			end
	`ROR: begin //ROR or RORI
				OutWire = rotateRight;
				OflWire = 0;
			end
	`SRL: begin //SRLI or SRL
				OutWire = shiftRight_L;
				OflWire = 0;
			end
	`BTR: begin //BTR
		   		OutWire = btrOutput;
				OflWire = 0;
			end
	`SEQ: begin 
		   	OutWire = seqOutput;
				OflWire = 0;
			end
	`SCO: begin
				OutWire = scoOutput;
				OflWire = 0;
			end
	`SLBI: begin
				OutWire = slbiOutput;
				OflWire = 0;
			end
	`SLT: begin	// A < B ? Out = 1: Out = 0
			// -2 - -3 = 1
                                OflWire = sign ? ( negResultFromPos | posResultFromNeg ? 1 : diffSigns ? 0 : ifLogic ) : C_out;
				OutWire = OflWire ? (negative ? 16'h0 : 16'h1) : (negative ? 16'h1 : 16'h0);
			end
	`SLE: begin	// A <= B ? Out = 1: Out = 0
                                OflWire = sign ? ( negResultFromPos | posResultFromNeg ? 1 : diffSigns ? 0 : ifLogic ) : C_out;
				OutWire = OflWire ? (negative ? 16'h0 : 16'h1) : negative_or_zero ? 16'h1 : 16'h0;
			end
	`LBI: begin
				OutWire = B; // Assign the immediate directly
				OflWire = 0;
			end
   endcase
end

   assign Zero = ~|S;
   assign Ofl = OflWire;
   assign Out = OutWire;
       
endmodule

