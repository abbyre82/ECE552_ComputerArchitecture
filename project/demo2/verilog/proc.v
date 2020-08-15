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

	wire stall;
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
	wire [1:0] num_reg_reads;

	wire flush;
	wire [15:0] readData1, readData2, immediate, currPC, nextPC, pc_plus_2;
	wire [15:0] instruction, writeData, aluResult, readFromMem;
	wire [15:0] instruction_FD, pc_plus_2_FD, currPC_FD, flush_instruction;
	
	wire [2:0] writeRegSel, readRegSel1, readRegSel2, writeReg;

	wire [15:0] pc_plus_2_DX, immediate_DX, readData1_DX, readData2_DX;
	wire [2:0] writeRegSel_DX;
	wire [3:0] ALUop_DX;
	wire HALT_DX, writeR7_DX, memToReg_DX, memRead_DX, memWrite_DX, ALUsrc_DX, regWrite_DX;

	wire [15:0] aluResult_XM, pc_plus_2_XM, readData2_XM;
	wire [2:0] writeRegSel_XM;
	wire HALT_XM, writeR7_XM, memToReg_XM, memRead_XM, memWrite_XM, regWrite_XM;

	wire [15:0] readFromMem_MWB, aluResult_MWB, pc_plus_2_MWB;
	wire [2:0] writeRegSel_MWB;
	wire writeR7_MWB, memToReg_MWB, regWrite_MWB, HALT_MWB;

	wire [15:0] testPC;
	wire [15:0] instruction_input;
	// PC dff
	register_16b PC_REG(.en(~stall), .clk(clk), .rst(rst), .data_in(testPC), .state(currPC));
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

// assign flush_instruction = flush ? 16'h0800 : instruction;
assign instruction_input = flush ? 16'h0800 : instruction;
assign testPC = flush ? nextPC: pc_plus_2;

// IF/ID Pipeline Register
IF_ID if_id(//.en(1'b1),
			.en(~stall), 
			.clk(clk), 
			.rst(rst), 
			.currPC(currPC),
			.pc_plus_2(pc_plus_2), 
			.instruction(instruction_input), 
			.instruction_FD(instruction_FD), 
			.pc_plus_2_FD(pc_plus_2_FD),
			.currPC_FD(currPC_FD)
);
// Hazard Detection Unit
hazard_detection_unit HD_unit(
			.instruction(instruction_FD),
			.writeRegSel_DX(writeRegSel_DX), 
			.writeRegSel_XM(writeRegSel_XM), 
			.writeRegSel_MWB(writeRegSel_MWB), 
			.readRegSel1(readRegSel1), 
			.readRegSel2(readRegSel2), 
			.regWrite_DX(regWrite_DX),
			.regWrite_XM(regWrite_XM),
			.regWrite_MWB(regWrite_MWB),
			.stall(stall)
			);

decode decode0(			
			.clk(clk),
			.rst(rst),
			.stall(stall),
			.regWrite_MWB(regWrite_MWB),
			.currPC(currPC_FD),
			.instruction(instruction_FD), 
			.new_addr(pc_plus_2_FD),
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
			.writeRegSel(writeRegSel),
			.writeReg(writeReg),
			.nextPC(nextPC),
			.readReg1(readRegSel1),
			.readReg2(readRegSel2),
			.flush(flush)
		);

// ID/EX Pipeline Register
ID_EX id_ex(
			.clk(clk),
            .rst(rst),
            .en(1'b1),
            .pc_plus_2(pc_plus_2_FD),
            .HALT(HALT),
            .writeR7(writeR7),
            .memToReg(memToReg),
            .memRead(memRead),
            .memWrite(memWrite),
            .ALUsrc(ALUsrc),
            .regWrite(regWrite),
            .ALUop(ALUop),
            .immediate(immediate),
            .readData2(readData2),
            .readData1(readData1),
            .writeRegSel(writeRegSel),
            .pc_plus_2_DX(pc_plus_2_DX),
            .HALT_DX(HALT_DX),
        	.writeR7_DX(writeR7_DX),
            .memToReg_DX(memToReg_DX),
            .memRead_DX(memRead_DX),
            .memWrite_DX(memWrite_DX),
            .ALUsrc_DX(ALUsrc_DX),
            .regWrite_DX(regWrite_DX),
            .ALUop_DX(ALUop_DX),
            .immediate_DX(immediate_DX),
            .readData2_DX(readData2_DX),
            .readData1_DX(readData1_DX),
            .writeRegSel_DX(writeRegSel_DX)
);

execute execute0(
			.ALUSrc(ALUsrc_DX), 
			.ALUOp(ALUop_DX), 
			.ReadData1(readData1_DX), 
			.ReadData2(readData2_DX), 
			.extOutput(immediate_DX), 
			.ALUResult(aluResult), 
			.Zero(), 
			.Ofl()
		);

// EX/MEM Pipeline Register
EX_MEM ex_mem(
            .clk(clk),
            .rst(rst),
            .en(1'b1), 
            .aluResult(aluResult),
            .pc_plus_2(pc_plus_2_DX),
            .HALT(HALT_DX),
            .writeR7(writeR7_DX),
            .memToReg(memToReg_DX),
            .memRead(memRead_DX),
            .memWrite(memWrite_DX),
            .regWrite(regWrite_DX),
            .readData2(readData2_DX),
            .writeRegSel(writeRegSel_DX),
            .aluResult_XM(aluResult_XM),
            .HALT_XM(HALT_XM),
            .pc_plus_2_XM(pc_plus_2_XM),
            .writeR7_XM(writeR7_XM),
            .memToReg_XM(memToReg_XM),
            .memRead_XM(memRead_XM),
            .memWrite_XM(memWrite_XM),
            .regWrite_XM(regWrite_XM),
            .readData2_XM(readData2_XM),
            .writeRegSel_XM(writeRegSel_XM)
            );

memory memory0 (
			.clk(clk),
			.rst(rst),
			.HALT(HALT_MWB),
			.memWrite(memWrite_XM),
			.aluResult(aluResult_XM),
			.writeData(readData2_XM),
			.memRead(memRead_XM),
			.readData(readFromMem)		
		);

MEM_WB mem_wb(
            .clk(clk),
            .rst(rst),
            .en(1'b1),
			.HALT(HALT_XM),
            .readFromMem(readFromMem),
            .aluResult(aluResult_XM),
            .pc_plus_2(pc_plus_2_XM),
            .writeR7(writeR7_XM),
            .memToReg(memToReg_XM),
            .regWrite(regWrite_XM),
            .writeRegSel(writeRegSel_XM),
            .readFromMem_MWB(readFromMem_MWB),
            .aluResult_MWB(aluResult_MWB),
            .pc_plus_2_MWB(pc_plus_2_MWB),
            .writeR7_MWB(writeR7_MWB),
            .memToReg_MWB(memToReg_MWB),
            .regWrite_MWB(regWrite_MWB),
            .writeRegSel_MWB(writeRegSel_MWB),
			.HALT_MWB(HALT_MWB)
			);

wb wb0 (
			.readData(readFromMem_MWB),
			.memToReg(memToReg_MWB),
			.memRead(memRead), //Remove 
			.aluResult(aluResult_MWB),
			.nextPC(pc_plus_2_MWB),
			.writeR7(writeR7_MWB),
			.writeData(writeData),
			.writeEn(regWrite_MWB),
			.writeRegSel(writeRegSel_MWB),
			.writeReg(writeReg)
		);

   
endmodule
