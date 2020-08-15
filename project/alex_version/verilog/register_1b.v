module register_1b(en, clk, rst, state, data_in);
input clk, rst, en;
input data_in;
output state;

dffe dff0(.en(en), .clk(clk), .rst(rst), .d(data_in), .q(state));

endmodule
