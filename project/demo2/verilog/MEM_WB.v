module MEM_WB(
            clk,
            rst,
            en,
            HALT,
            readFromMem,
            aluResult,
            pc_plus_2,
            writeR7,
            memToReg,
            regWrite,
            writeRegSel,
            readFromMem_MWB,
            aluResult_MWB,
            pc_plus_2_MWB,
            writeR7_MWB,
            memToReg_MWB,
            regWrite_MWB,
            writeRegSel_MWB,
            HALT_MWB
            );

input [15:0] pc_plus_2, aluResult, readFromMem;
input writeR7, memToReg, regWrite, clk, rst, en, HALT;
input [2:0] writeRegSel;

output [15:0] pc_plus_2_MWB, aluResult_MWB, readFromMem_MWB;
output writeR7_MWB, memToReg_MWB, regWrite_MWB, HALT_MWB;
output [2:0] writeRegSel_MWB;

register_16b pc_plus_2_MWB_reg(.en(en), .clk(clk), .rst(rst), .data_in(pc_plus_2), .state(pc_plus_2_MWB));
register_16b readFromMem_MWB_reg(.en(en), .clk(clk), .rst(rst), .data_in(readFromMem), .state(readFromMem_MWB));
register_16b aluResult_MWB_reg(.en(en), .clk(clk), .rst(rst), .data_in(aluResult), .state(aluResult_MWB));

register_1b writeR7_MWB_reg(.en(en), .clk(clk), .rst(rst), .data_in(writeR7), .state(writeR7_MWB));
register_1b memToReg_MWB_reg(.en(en), .clk(clk), .rst(rst), .data_in(memToReg), .state(memToReg_MWB));
register_1b regWrite_MWB_reg(.en(en), .clk(clk), .rst(rst), .data_in(regWrite), .state(regWrite_MWB));
register_1b halt_MWB_reg(.en(en), .clk(clk), .rst(rst), .data_in(HALT), .state(HALT_MWB));

register_3b writeRegSel_MWB_reg(.en(en), .clk(clk), .rst(rst), .data_in(writeRegSel), .state(writeRegSel_MWB));

endmodule