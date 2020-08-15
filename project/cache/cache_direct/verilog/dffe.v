module dffe (en, q, d, clk, rst);
input en, d, clk, rst;
output q;
wire data;

assign data = en ? d : q;

dff DFF(.d(data), .q(q), .clk(clk), .rst(rst));

endmodule