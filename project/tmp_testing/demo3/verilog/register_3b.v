module register_3b(en, clk, rst, state, data_in);
input clk, rst, en;
input [2:0] data_in;
output [2:0] state;

dffe dff0(.en(en), .clk(clk), .rst(rst), .d(data_in[0]), .q(state[0]));
dffe dff1(.en(en), .clk(clk), .rst(rst), .d(data_in[1]), .q(state[1]));
dffe dff2(.en(en), .clk(clk), .rst(rst), .d(data_in[2]), .q(state[2]));

endmodule
