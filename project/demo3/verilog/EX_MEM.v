module EX_MEM(
            clk,
            rst,
            en, 
            aluResult,
            pc_plus_2,
            HALT,
            writeR7,
            memToReg,
            memRead,
            memWrite,
            regWrite,
            readData2,
            writeRegSel,
            aluResult_XM,
            HALT_XM,
            pc_plus_2_XM,
            writeR7_XM,
            memToReg_XM,
            memRead_XM,
            memWrite_XM,
            regWrite_XM,
            readData2_XM,
            writeRegSel_XM
            );

input [15:0] pc_plus_2, readData2, aluResult;
input HALT, writeR7, memToReg, memRead, memWrite, regWrite, clk, rst, en;
input [2:0] writeRegSel;

output [15:0] pc_plus_2_XM, readData2_XM, aluResult_XM;
output HALT_XM, writeR7_XM, memToReg_XM, memRead_XM, memWrite_XM, regWrite_XM;
output [2:0] writeRegSel_XM;

register_16b pc_plus_2_XM_reg(.en(en), .clk(clk), .rst(rst), .data_in(pc_plus_2), .state(pc_plus_2_XM));
register_16b readData2_XM_reg(.en(en), .clk(clk), .rst(rst), .data_in(readData2), .state(readData2_XM));
register_16b aluResult_reg(.en(en), .clk(clk), .rst(rst), .data_in(aluResult), .state(aluResult_XM));

register_1b HALT_XM_reg(.en(en), .clk(clk), .rst(rst), .data_in(HALT), .state(HALT_XM));
register_1b writeR7_XM_reg(.en(en), .clk(clk), .rst(rst), .data_in(writeR7), .state(writeR7_XM));
register_1b memToReg_XM_reg(.en(en), .clk(clk), .rst(rst), .data_in(memToReg), .state(memToReg_XM));
register_1b memRead_XM_reg(.en(en), .clk(clk), .rst(rst), .data_in(memRead), .state(memRead_XM));
register_1b memWrite_XM_reg(.en(en), .clk(clk), .rst(rst), .data_in(memWrite), .state(memWrite_XM));
register_1b regWrite_XM_reg(.en(en), .clk(clk), .rst(rst), .data_in(regWrite), .state(regWrite_XM));

register_3b writeRegSel_XM_reg(.en(en), .clk(clk), .rst(rst), .data_in(writeRegSel), .state(writeRegSel_XM));

endmodule