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
                            instruction
                            );

    wire [1:0] num_reg_reads;
    input [15:0] instruction;
    input [2:0] writeRegSel_DX, writeRegSel_XM, writeRegSel_MWB, readRegSel1, readRegSel2;
    input regWrite_DX, regWrite_XM, regWrite_MWB;
    output stall;
    reg r1, r2;
    
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

    assign stall = (( r1 & (readRegSel1 == writeRegSel_DX) & (regWrite_DX)) 
                    | (r1 & (readRegSel1 == writeRegSel_XM) & (regWrite_XM))
                //    | (r1 & (readRegSel1 == writeRegSel_MWB) & (regWrite_MWB))
                   | (r2 & (readRegSel2 == writeRegSel_DX) & (regWrite_DX))
                   | (r2 & (readRegSel2 == writeRegSel_XM) & (regWrite_XM))
                //    | (r2 & (readRegSel2 == writeRegSel_MWB) & (regWrite_MWB))
                   ) 
                   ? 1 : 0;
endmodule