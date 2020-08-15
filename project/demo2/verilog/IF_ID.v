module IF_ID(en, clk, rst, pc_plus_2, instruction, currPC, instruction_FD, pc_plus_2_FD, currPC_FD);
    
    input clk, rst, en;
    input [15:0] pc_plus_2, instruction, currPC;
    output [15:0] instruction_FD;
    output [15:0] pc_plus_2_FD;
    output [15:0] currPC_FD;
    wire [15:0] instruction_FD_i;

    register_16b_NOP instruction_REG(.en(en), .clk(clk), .rst(rst), .data_in(instruction), .state(instruction_FD));
    register_16b pc_plus_2_REG(.en(en), .clk(clk), .rst(rst), .data_in(pc_plus_2), .state(pc_plus_2_FD));
    register_16b currPC_REG(.en(en), .clk(clk), .rst(rst), .data_in(currPC), .state(currPC_FD));

endmodule
