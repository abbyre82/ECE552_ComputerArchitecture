module fwd_unit(
            r1_hdu_DX,
            r2_hdu_DX,
            readRegSel1_DX,
            readRegSel2_DX,
            alu_result_XM,
            alu_result_MWB,
            read_data_MWB,
            memRead_XM,
            memRead_MWB,
            writeR7_XM,
            writeR7_MWB,
            pc_plus_2_XM,
            pc_plus_2_MWB,
            writeRegSel_XM,
            writeRegSel_MWB,
            regWrite_XM,
            regWrite_MWB,
            ex_ex_fwd_r1,
            ex_ex_fwd_r2,
            mem_ex_fwd_r1,
            mem_ex_fwd_r2,
            ex_ex_result_r1,
            ex_ex_result_r2,
            mem_ex_result_r1,
            mem_ex_result_r2
);

input memRead_XM, memRead_MWB, writeR7_XM, writeR7_MWB, r1_hdu_DX, r2_hdu_DX;
input [2:0] readRegSel1_DX, readRegSel2_DX, writeRegSel_XM, writeRegSel_MWB;
input [15:0] alu_result_XM, alu_result_MWB, pc_plus_2_XM, pc_plus_2_MWB;
input regWrite_MWB, regWrite_XM;
input [15:0] read_data_MWB;
output [15:0] ex_ex_result_r1, ex_ex_result_r2, mem_ex_result_r1, mem_ex_result_r2;
output ex_ex_fwd_r1, ex_ex_fwd_r2, mem_ex_fwd_r1, mem_ex_fwd_r2;

assign mem_ex_fwd_r1 =    ( r1_hdu_DX & (readRegSel1_DX == writeRegSel_MWB) & regWrite_MWB )
                        | ( r1_hdu_DX & readRegSel1_DX == 3'h7 & writeR7_MWB & regWrite_MWB & ~memRead_MWB );
assign mem_ex_fwd_r2 =    ( r2_hdu_DX & (readRegSel2_DX == writeRegSel_MWB) & regWrite_MWB )
                        | ( r2_hdu_DX & readRegSel2_DX == 3'h7 & writeR7_MWB & regWrite_MWB & ~memRead_MWB );
assign ex_ex_fwd_r1 =     ( r1_hdu_DX & (readRegSel1_DX == writeRegSel_XM) & regWrite_XM )
                        | ( r1_hdu_DX & readRegSel1_DX == 3'h7 & writeR7_XM & regWrite_XM & ~memRead_XM );
assign ex_ex_fwd_r2 =     ( r2_hdu_DX & (readRegSel2_DX == writeRegSel_XM) & regWrite_XM )
                        | ( r2_hdu_DX & readRegSel2_DX == 3'h7 & writeR7_XM & regWrite_XM & ~memRead_XM );

assign mem_ex_result_r1 = writeR7_MWB ? pc_plus_2_MWB : (memRead_MWB ? read_data_MWB : alu_result_MWB);
assign mem_ex_result_r2 = writeR7_MWB ? pc_plus_2_MWB : (memRead_MWB ? read_data_MWB : alu_result_MWB);
assign ex_ex_result_r1 = writeR7_XM ? pc_plus_2_XM : alu_result_XM;
assign ex_ex_result_r2 = writeR7_XM ? pc_plus_2_XM : alu_result_XM;

endmodule