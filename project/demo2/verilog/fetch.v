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
wire [15:0] pc_plus_2, new_instr;

// Get instruction from INSTRUCTION MEMORY
// Perform PC increment logic
// Take care of HALT and NOP
//	Dump data mem for halt
   
// get instr from mem
memory2c INSTR_MEM(
				.data_out(new_instr), 
				.data_in(16'h0),  
				.addr(currPC),  
				.enable(1'b1),				// ???? how do we know?
				.wr(1'b0),  
				.createdump(1'b0),  		// ???? HALT
				.clk(clk),  
				.rst(rst)
			);

// Add 2 to curr address to create new addr
cla_16b ADDER(.A(currPC), .B(16'h2), .C_in(1'b0),.S(pc_plus_2), .C_out());
assign nextPC = rst ? currPC : pc_plus_2;
assign instruction = rst ? 16'h0800 : new_instr;


endmodule
