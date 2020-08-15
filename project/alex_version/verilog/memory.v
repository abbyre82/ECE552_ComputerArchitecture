/*
   CS/ECE 552 Spring '20
  
   Filename        : memory.v
   Description     : This module contains all components in the Memory stage of the 
                     processor.
*/
module memory (
						clk,
						rst,
						HALT,
						memWrite,
						aluResult,
						writeData,
						memRead,
						readData,
						stall_from_mem,
						done_reading,
						err			
					);

input clk, rst;
input memWrite, memRead;			// Control signals: ST / LD
input [15:0] writeData;				// Data written to mem
input [15:0] aluResult;			// Calculated address
input HALT;
wire done;

wire memReadorWrite, mrow_i;
nor2 READ_OR_WRITE(memRead, memWrite, mrow_i);
not1 NOT0(mrow_i, memReadorWrite);

output [15:0] readData;				// Data read from mem
output stall_from_mem;
output done_reading;
output err;
wire stall_i;

/* data_mem = 1, inst_mem = 0 *
* needed for cache parameter */
parameter memtype = 1;

mem_system_hier #(memtype) DATA_MEM(
				.Addr(aluResult),
				.DataIn(writeData),
				.Rd(memRead),
				.Wr(memWrite),
				.createdump(HALT),
				.DataOut(readData),
				.Done(done), //TO DO
				.Stall(stall_from_mem), //TO DO
				.CacheHit(), //MIGHT NOT NEED
				.err(err)
);

assign done_reading = done;

   
endmodule
