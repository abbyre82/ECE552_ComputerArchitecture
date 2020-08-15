/* $Author: sinclair $ */
/* $LastChangedDate: 2020-02-09 17:03:45 -0600 (Sun, 09 Feb 2020) $ */
/* $Rev: 46 $ */
module proc (/*AUTOARG*/
   // Outputs
   err, 
   // Inputs
   clk, rst
   );

   input clk;
   input rst;

   output err;

	wire HALT;
	wire NOP;
	wire writeR7;
	wire jumpReg;
	wire jump;
	wire branch;
	wire memToReg; 
	wire memRead;
	wire [3:0] ALUop;
	wire memWrite; 
	wire ALUsrc;
	wire regWrite;

	wire [15:0] readData1, readData2, immediate, currPC, nextPC, pc_plus_2;
	wire [15:0] instruction, writeData, aluResult, readFromMem;

	// PC dff
	register PC_REG(.clk(clk), .rst(rst), .data_in(nextPC), .state(currPC));
   // None of the above lines can be modified

   // OR all the err ouputs for every sub-module and assign it as this
   // err output
   
   // As desribed in the homeworks, use the err signal to trap corner
   // cases that you think are illegal in your statemachines
   
   
   /* your code here -- should include instantiations of fetch, decode, execute, mem and wb modules */

fetch fetch0 (
					.clk(clk),
					.rst(rst),
					.currPC(currPC),
					.nextPC(pc_plus_2),
					.instruction(instruction)
		);

decode decode0(			
					.clk(clk),
					.rst(rst),
					.currPC(currPC),
					.instruction(instruction), 
					.new_addr(pc_plus_2),
					.write_data(writeData), 
					.HALT(HALT),  
					.NOP(NOP),  
					.writeR7(writeR7),  
					.jumpReg(jumpReg),  
					.jump(jump),  
					.branch(branch), 
					.memToReg(memToReg), 
					.memRead(memRead), 
					.ALUop(ALUop), 
					.memWrite(memWrite), 
					.ALUsrc(ALUsrc), 
					.regWrite(regWrite),
					.immediate(immediate),
					.read_data_1(readData1),
					.read_data_2(readData2),
					.nextPC(nextPC)
		);

execute execute0(
					.ALUSrc(ALUsrc), 
					.ALUOp(ALUop), 
					.ReadData1(readData1), 
					.ReadData2(readData2), 
					.extOutput(immediate), 
					.ALUResult(aluResult), 
					.Zero(), 
					.Ofl()
		);

memory memory0 (
					.clk(clk),
					.rst(rst),
					.HALT(HALT),
					.memWrite(memWrite),
					.aluResult(aluResult),
					.writeData(readData2),
					.memRead(memRead),
					.readData(readFromMem)		
		);

wb wb0 (
					.readData(readFromMem),
					.memToReg(memToReg),
					.memRead(memRead),
					.aluResult(aluResult),
					.nextPC(pc_plus_2),
					.writeR7(writeR7),
					.writeData(writeData),
					.writeEn(regWrite)		
		);

   
endmodule // proc
// DUMMY LINE FOR REV CONTROL :0:
