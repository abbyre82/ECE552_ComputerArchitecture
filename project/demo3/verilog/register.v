
module register(clk, rst, data_in, state);

input clk, rst;
input [15:0] data_in;
output [15:0] state;

dff dff0(.q(state[0]), .d(data_in[0]), .clk(clk), .rst(rst));
dff dff1(.q(state[1]), .d(data_in[1]), .clk(clk), .rst(rst));
dff dff2(.q(state[2]), .d(data_in[2]), .clk(clk), .rst(rst));
dff dff3(.q(state[3]), .d(data_in[3]), .clk(clk), .rst(rst));
dff dff4(.q(state[4]), .d(data_in[4]), .clk(clk), .rst(rst));
dff dff5(.q(state[5]), .d(data_in[5]), .clk(clk), .rst(rst));
dff dff6(.q(state[6]), .d(data_in[6]), .clk(clk), .rst(rst));
dff dff7(.q(state[7]), .d(data_in[7]), .clk(clk), .rst(rst));
dff dff8(.q(state[8]), .d(data_in[8]), .clk(clk), .rst(rst));
dff dff9(.q(state[9]), .d(data_in[9]), .clk(clk), .rst(rst));
dff dff10(.q(state[10]), .d(data_in[10]), .clk(clk), .rst(rst));
dff dff11(.q(state[11]), .d(data_in[11]), .clk(clk), .rst(rst));
dff dff12(.q(state[12]), .d(data_in[12]), .clk(clk), .rst(rst));
dff dff13(.q(state[13]), .d(data_in[13]), .clk(clk), .rst(rst));
dff dff14(.q(state[14]), .d(data_in[14]), .clk(clk), .rst(rst));
dff dff15(.q(state[15]), .d(data_in[15]), .clk(clk), .rst(rst));



endmodule
