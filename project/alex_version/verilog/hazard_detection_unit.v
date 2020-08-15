module hazard_detection_unit(
                            writeRegSel_DX, 
                            writeRegSel_XM, 
                            writeRegSel_MWB, 
                            readRegSel1, 
                            readRegSel2, 
                            regWrite_DX,
                            regWrite_XM,
                            regWrite_MWB,
                            stall,
                            instruction,
                            memRead_DX,
                            memRead_XM,
                            writeR7_DX,
                            writeR7_XM,
                            r1_hdu,
                            r2_hdu
                            );

    wire [1:0] num_reg_reads;
    input [15:0] instruction;
    input [2:0] writeRegSel_DX, writeRegSel_XM, writeRegSel_MWB, readRegSel1, readRegSel2;
    input regWrite_DX, writeR7_DX, regWrite_XM, writeR7_XM, regWrite_MWB, memRead_DX, memRead_XM;
    output stall;
    output r1_hdu, r2_hdu;
    reg r1, r2;
    reg branch_jump;
    
    num_regReads NUM_READS(.instruction(instruction),
			.num_reg_reads(num_reg_reads));

    always@(*) begin
        case(num_reg_reads)
                2'b00: begin
                        r1 = 0;
                        r2 = 0;
                    end
                2'b01: begin
                        r1 = 1;
                        r2 = 0;
                    end
                2'b10: begin	
                        r1 = 1;
                        r2 = 1;			
                    end
                default: begin
                        r1 = 0;
                        r2 = 0;
                    end
        endcase
    end

    always@(*) begin
        case(instruction[15:11])
            5'b01100: branch_jump = 1;  // BEQZ
            5'b01101: branch_jump = 1;  // BNEZ
            5'b01110: branch_jump = 1;  // BLTZ
            5'b01111: branch_jump = 1;  // BGEZ
            5'b00101: branch_jump = 1;  // JR
            5'b00111: branch_jump = 1;  // JALR
            default: branch_jump = 0;
        endcase
    end

    assign r1_hdu = r1;
    assign r2_hdu = r2;
    assign stall =      (( r1 & (readRegSel1 == writeRegSel_DX) & (regWrite_DX) & memRead_DX) 
                        | (r2 & (readRegSel2 == writeRegSel_DX) & (regWrite_DX) & memRead_DX)
                        | (r1 & (readRegSel1 == 3'h7 & writeR7_DX) & (regWrite_DX) & ~memRead_DX)
                        | (r2 & (readRegSel2 == 3'h7 & writeR7_DX) & (regWrite_DX) & ~memRead_DX)
                        | (r1 & (readRegSel1 == writeRegSel_XM) & (regWrite_XM) & branch_jump)
                        | (r2 & (readRegSel2 == writeRegSel_XM) & (regWrite_XM) & branch_jump)
                        // | (r1 & (readRegSel1 == 3'h7 & writeR7_XM) & (regWrite_XM) & ~memRead_XM)
                        // | (r2 & (readRegSel2 == 3'h7 & writeR7_XM) & (regWrite_XM) & ~memRead_XM)
                   ) ? 1 : 0;
endmodule