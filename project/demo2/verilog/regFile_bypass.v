/*
   CS/ECE 552, Spring '20
   Homework #3, Problem #2
  
   This module creates a wrapper around the 8x16b register file, to do
   do the bypassing logic for RF bypassing.
*/
module regFile_bypass (
                       // Outputs
                       read1Data, read2Data, err,
                       // Inputs
                       clk, rst, read1RegSel, read2RegSel, writeRegSel, writeData, writeEn
                       );
   input        clk, rst;
   input [2:0]  read1RegSel;
   input [2:0]  read2RegSel;
   input [2:0]  writeRegSel;
   input [15:0] writeData;
   input        writeEn;

   output [15:0] read1Data;
   output [15:0] read2Data;
   output        err;

   wire [15:0] read1, read2;
   reg [15:0] read1_copy, read2_copy;
   wire comp1, comp2;
   regFile registerFile(.read1Data(read1), .read2Data(read2), .err(err), .clk(clk), .rst(rst), 
	.read1RegSel(read1RegSel), .read2RegSel(read2RegSel), .writeRegSel(writeRegSel), .writeData(writeData), .writeEn(writeEn));

   assign comp1 = |(writeRegSel ^ read1RegSel);
   assign comp2 = |(writeRegSel ^ read2RegSel);

   always @(*) begin
	case(comp1)
		1'b0: read1_copy = writeEn ? writeData : read1;
		1'b1: read1_copy = read1;
	endcase
   end

   always @(*) begin
	case(comp2)
		1'b0: read2_copy =  writeEn ? writeData : read2;
		1'b1: read2_copy = read2;
	endcase
   end

   assign read1Data = read1_copy; 
   assign read2Data = read2_copy;

endmodule

