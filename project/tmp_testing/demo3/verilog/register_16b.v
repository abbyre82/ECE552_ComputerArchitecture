
module register_16b(en, clk, rst, data_in, state);

input clk, rst, en;
input [15:0] data_in;
output [15:0] state;

dffe dff0(.en(en), .q(state[0]), .d(data_in[0]), .clk(clk), .rst(rst));
dffe dff1(.en(en), .q(state[1]), .d(data_in[1]), .clk(clk), .rst(rst));
dffe dff2(.en(en), .q(state[2]), .d(data_in[2]), .clk(clk), .rst(rst));
dffe dff3(.en(en), .q(state[3]), .d(data_in[3]), .clk(clk), .rst(rst));
dffe dff4(.en(en), .q(state[4]), .d(data_in[4]), .clk(clk), .rst(rst));
dffe dff5(.en(en), .q(state[5]), .d(data_in[5]), .clk(clk), .rst(rst));
dffe dff6(.en(en), .q(state[6]), .d(data_in[6]), .clk(clk), .rst(rst));
dffe dff7(.en(en), .q(state[7]), .d(data_in[7]), .clk(clk), .rst(rst));
dffe dff8(.en(en), .q(state[8]), .d(data_in[8]), .clk(clk), .rst(rst));
dffe dff9(.en(en), .q(state[9]), .d(data_in[9]), .clk(clk), .rst(rst));
dffe dff10(.en(en), .q(state[10]), .d(data_in[10]), .clk(clk), .rst(rst));
dffe dff11(.en(en), .q(state[11]), .d(data_in[11]), .clk(clk), .rst(rst));
dffe dff12(.en(en), .q(state[12]), .d(data_in[12]), .clk(clk), .rst(rst));
dffe dff13(.en(en), .q(state[13]), .d(data_in[13]), .clk(clk), .rst(rst));
dffe dff14(.en(en), .q(state[14]), .d(data_in[14]), .clk(clk), .rst(rst));
dffe dff15(.en(en), .q(state[15]), .d(data_in[15]), .clk(clk), .rst(rst));



endmodule
