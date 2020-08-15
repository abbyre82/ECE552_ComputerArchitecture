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
						instruction,
						stall_from_fetch,
						stall_mem_data,
						flush,
						err
					);

input clk, rst;
input stall_mem_data;
input [15:0] currPC;
input flush;
output [15:0] nextPC, instruction;
output stall_from_fetch;
output err;
wire [15:0] pc_plus_2, new_instr;
wire done;
wire flush_F;

// Get instruction from INSTRUCTION MEMORY
// Perform PC increment logic
// Take care of HALT and NOP
//	Dump data mem for halt

/* data_mem = 1, inst_mem = 0 *
* needed for cache parameter */
parameter memtype = 0;

mem_system_hier #(memtype) INSTR_MEM(
				.Addr(currPC),
				.DataIn(16'h0),
				.Rd(1'b1),
				.Wr(1'b0),
				.createdump(1'b0),
				.DataOut(new_instr),
				.Done(done), //TO DO
				.Stall(stall_from_fetch), //TO DO
				.CacheHit(), //MIGHT NOT NEED
				.err(err)
);

// Add 2 to curr address to create new addr
cla_16b ADDER(.A(currPC), .B(16'h2), .C_in(1'b0),.S(pc_plus_2), .C_out());
assign nextPC = (rst | stall_mem_data | ~done | flush_F) ? currPC : pc_plus_2;
assign instruction = (rst | ~done | flush_F) ? 16'h0800 : new_instr;

dffe FLUSH(.en(flush | ~stall_from_fetch), .q(flush_F), .d(flush), .clk(clk), .rst(rst));

endmodule
