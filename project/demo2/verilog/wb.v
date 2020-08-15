/*
   CS/ECE 552 Spring '20
  
   Filename        : wb.v
   Description     : This is the module for the overall Write Back stage of the processor.
*/
module wb 	(
					readData,
					memToReg,
					memRead,
					aluResult,
					nextPC,
					writeR7,
					writeData,
					writeEn,
               		writeRegSel,
               		writeReg		
				);

// Passing REG FILE ???

// Inputs:
//	1. Read Data
//	2. MemtoReg
//	3. ALU Result

input [15:0] readData, aluResult, nextPC;
input memRead, memToReg, writeR7, writeEn;
input [2:0] writeRegSel;

// Outputs:
// 	1. Write Data [15:0]

output [15:0] writeData;
output [2:0] writeReg;

// MUXES
// Read data vs. ALU result
// PC+2 vs. writeREG

/*
		if(writeR7)
		{
			writeData = nextPC;
		}
		else if(memToReg)
		{
			writeData = readData;
		}
		else writeData = alu_result;
*/
assign writeData = writeR7 ? nextPC : (memToReg ? readData : aluResult);
assign writeReg = writeRegSel;
endmodule