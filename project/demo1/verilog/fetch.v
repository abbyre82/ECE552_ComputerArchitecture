/*
   CS/ECE 552 Spring '20
  
   Filename        : fetch.v
   Description     : This is the module for the overall fetch stage of the processor.
*/
module fetch 	(
						clk,
						rst,
						currPC,
						nextPC,
						instruction
					);

input clk, rst;
input [15:0] currPC;
output [15:0] nextPC, instruction;

// Get instruction from INSTRUCTION MEMORY
// Perform PC increment logic
// Take care of HALT and NOP
//	Dump data mem for halt
   
// get instr from mem
memory2c INSTR_MEM(
				.data_out(instruction), 
				.data_in(16'h0),  
				.addr(currPC),  
				.enable(1'b1),				// ???? how do we know?
				.wr(1'b0),  
				.createdump(1'b0),  		// ???? HALT
				.clk(clk),  
				.rst(rst)
			);

// Add 2 to curr address to create new addr
cla_16b ADDER(.A(currPC), .B(16'h2), .C_in(1'b0),.S(nextPC), .C_out());

endmodule
