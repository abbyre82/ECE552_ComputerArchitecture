module register_4b(en, clk, rst, data_in, state);

    input clk, rst, en;
    input [3:0] data_in;
    output [3:0] state;

    dffe dff0(.en(en), .clk(clk), .rst(rst), .d(data_in[0]), .q(state[0]));
    dffe dff1(.en(en), .clk(clk), .rst(rst), .d(data_in[1]), .q(state[1]));
    dffe dff2(.en(en), .clk(clk), .rst(rst), .d(data_in[2]), .q(state[2]));
    dffe dff3(.en(en), .clk(clk), .rst(rst), .d(data_in[3]), .q(state[3]));

endmodule