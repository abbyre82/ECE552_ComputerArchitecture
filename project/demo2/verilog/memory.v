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
						readData				
					);

input clk, rst;
input memWrite, memRead;			// Control signals: ST / LD
input [15:0] writeData;				// Data written to mem
input [15:0] aluResult;			// Calculated address
input HALT;

wire memReadorWrite, mrow_i;
nor2 READ_OR_WRITE(memRead, memWrite, mrow_i);
not1 NOT0(mrow_i, memReadorWrite);

output [15:0] readData;				// Data read from mem

// Inputs:
//	1. MemWrite (Is it a store?)
//	2. ALU Result (mem address)
//	3. Write Data
//	4. MemRead (Is it a load?)

// Outputs:
//	1. Read Data

// If (memWrite)
// Write (write_data) to Mem[alu_result]

// if (memRead)
// readData = Mem[alu_result]

memory2c DATA_MEM(
				.data_out(readData), 
				.data_in(writeData),  
				.addr(aluResult),  
				.enable(memReadorWrite),// Is it a load or a stor (mem read / write)
				.wr(memWrite),  
				.createdump(HALT),  		// HALT should dump data mem
				.clk(clk),  
				.rst(rst)
			);

   
endmodule
