module MEM_WB(
            clk,
            rst,
            err_data,
            en,
            HALT,
            readFromMem,
            aluResult,
            pc_plus_2,
            writeR7,
            memToReg,
            regWrite,
            writeRegSel,
            memRead_XM,
            readFromMem_MWB,
            aluResult_MWB,
            pc_plus_2_MWB,
            writeR7_MWB,
            memToReg_MWB,
            regWrite_MWB,
            writeRegSel_MWB,
            HALT_MWB,
            data_en,
            err_data_MWB,
            memRead_MWB
            );

input [15:0] pc_plus_2, aluResult, readFromMem;
input writeR7, memToReg, regWrite, clk, rst, en, HALT, data_en, err_data, memRead_XM;
input [2:0] writeRegSel;

output [15:0] pc_plus_2_MWB, aluResult_MWB, readFromMem_MWB;
output writeR7_MWB, memToReg_MWB, regWrite_MWB, HALT_MWB, err_data_MWB, memRead_MWB;
output [2:0] writeRegSel_MWB;

register_16b pc_plus_2_MWB_reg(.en(en), .clk(clk), .rst(rst), .data_in(pc_plus_2), .state(pc_plus_2_MWB));
register_16b readFromMem_MWB_reg(.en(data_en), .clk(clk), .rst(rst), .data_in(readFromMem), .state(readFromMem_MWB));
register_16b aluResult_MWB_reg(.en(en), .clk(clk), .rst(rst), .data_in(aluResult), .state(aluResult_MWB));

register_1b writeR7_MWB_reg(.en(en), .clk(clk), .rst(rst), .data_in(writeR7), .state(writeR7_MWB));
register_1b memToReg_MWB_reg(.en(en), .clk(clk), .rst(rst), .data_in(memToReg), .state(memToReg_MWB));
register_1b regWrite_MWB_reg(.en(en), .clk(clk), .rst(rst), .data_in(regWrite), .state(regWrite_MWB));
register_1b halt_MWB_reg(.en(en), .clk(clk), .rst(rst), .data_in(HALT), .state(HALT_MWB));
register_1b err_data_MWB_reg(.en(en), .clk(clk), .rst(rst), .data_in(err_data), .state(err_data_MWB));
register_1b memRead_MWB_reg(.en(en), .clk(clk), .rst(rst), .data_in(memRead_XM), .state(memRead_MWB));

register_3b writeRegSel_MWB_reg(.en(en), .clk(clk), .rst(rst), .data_in(writeRegSel), .state(writeRegSel_MWB));

endmodule