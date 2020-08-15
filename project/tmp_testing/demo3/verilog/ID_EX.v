//Register ID/EX:
//PC + 2
//output HALT;					Used in MEM for memory dump
//output writeR7;					Used in WB for the jumps
//output memToReg; 				Used in WB for loads		
//output memRead;					Used in WB and MEM			
//output [3:0] ALUop;				Used in EX
//output memWrite; 				Used in MEM
//output ALUsrc;					Used in EX			
//output regWrite;				Used in WB		
//output [15:0] immediate;		Used in EX
//readData2 [15:0] 
//writeRegSel [2:0]

module ID_EX(
            clk,
            rst,
            en,
            pc_plus_2,
            HALT,
            writeR7,
            memToReg,
            memRead,
            memWrite,
            ALUsrc,
            regWrite,
            ALUop,
            immediate,
            readData1,
            readData2,
            writeRegSel,
			readRegSel1,
			readRegSel2,
			r1_hdu,
			r2_hdu,
            pc_plus_2_DX,
            HALT_DX,
            writeR7_DX,
            memToReg_DX,
            memRead_DX,
            memWrite_DX,
            ALUsrc_DX,
            regWrite_DX,
            ALUop_DX,
            immediate_DX,
            readData1_DX,
            readData2_DX,
            writeRegSel_DX,
			readRegSel1_DX,
			readRegSel2_DX,
			r1_hdu_DX,
			r2_hdu_DX,
            );

    input [15:0] pc_plus_2;
    input en, clk, rst, HALT, writeR7, memToReg, memRead, memWrite, ALUsrc, regWrite;
    input [3:0] ALUop;
    input [15:0] immediate;
    input [15:0] readData1, readData2;
    input [2:0] writeRegSel;
    input [2:0] readRegSel1, readRegSel2;
    input r1_hdu, r2_hdu;

    output [15:0] pc_plus_2_DX;
    output HALT_DX, writeR7_DX, memToReg_DX, memRead_DX, memWrite_DX, ALUsrc_DX, regWrite_DX;
    output [3:0] ALUop_DX;
    output [15:0] immediate_DX;
    output [15:0] readData1_DX, readData2_DX;
    output [2:0] writeRegSel_DX;
    output [2:0] readRegSel1_DX, readRegSel2_DX;
    output r1_hdu_DX, r2_hdu_DX;

    register_16b pc_plus_2_REG(.en(en), .clk(clk), .rst(rst), .data_in(pc_plus_2), .state(pc_plus_2_DX));
    
    register_16b immediate_REG(.en(en), .clk(clk), .rst(rst), .data_in(immediate), .state(immediate_DX));
    register_16b readData2_REG(.en(en), .clk(clk), .rst(rst), .data_in(readData2), .state(readData2_DX));
    register_16b readData1_REG(.en(en), .clk(clk), .rst(rst), .data_in(readData1), .state(readData1_DX));

    register_1b HALT_REG(.en(en), .clk(clk), .rst(rst), .data_in(HALT), .state(HALT_DX));
    register_1b writeR7_REG(.en(en), .clk(clk), .rst(rst), .data_in(writeR7), .state(writeR7_DX));
    register_1b memToReg_REG(.en(en), .clk(clk), .rst(rst), .data_in(memToReg), .state(memToReg_DX));
    register_1b memRead_REG(.en(en), .clk(clk), .rst(rst), .data_in(memRead), .state(memRead_DX));
    register_1b memWrite_REG(.en(en), .clk(clk), .rst(rst), .data_in(memWrite), .state(memWrite_DX));
    register_1b ALUsrc_REG(.en(en), .clk(clk), .rst(rst), .data_in(ALUsrc), .state(ALUsrc_DX));
    register_1b regWrite_REG(.en(en), .clk(clk), .rst(rst), .data_in(regWrite), .state(regWrite_DX));
    register_1b r1_hdu_REG(.en(en), .clk(clk), .rst(rst), .data_in(r1_hdu), .state(r1_hdu_DX));
    register_1b r2_hdu_REG(.en(en), .clk(clk), .rst(rst), .data_in(r2_hdu), .state(r2_hdu_DX));
    
    register_4b ALUop_REG(.en(en), .clk(clk), .rst(rst), .data_in(ALUop), .state(ALUop_DX));

    register_3b writeRegSel_REG(.en(en), .clk(clk), .rst(rst), .data_in(writeRegSel), .state(writeRegSel_DX));  
    register_3b readRegSel1_REG(.en(en), .clk(clk), .rst(rst), .data_in(readRegSel1), .state(readRegSel1_DX)); 
    register_3b readRegSel2_REG(.en(en), .clk(clk), .rst(rst), .data_in(readRegSel2), .state(readRegSel2_DX));

endmodule