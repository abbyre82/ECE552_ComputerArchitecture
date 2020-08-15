module shiftLeft(In, Cnt, Out);

input [15:0] In;
input [3:0] Cnt;
output reg [15:0] Out;

wire [15:0] out;

always@(*) begin
	case(Cnt)
		4'b0000 : assign Out = In;
		4'b0001 : assign Out = {In, 1'h0};
		4'b0010 : assign Out = {In, 2'h0};
		4'b0011 : assign Out = {In, 3'h0};
		4'b0100 : assign Out = {In, 4'h0};
		4'b0101 : assign Out = {In, 5'h0};
		4'b0110 : assign Out = {In, 6'h0};
		4'b0111 : assign Out = {In, 7'h0};
		4'b1000 : assign Out = {In, 8'h0};
		4'b1001 : assign Out = {In, 9'h0};
		4'b1010 : assign Out = {In, 10'h0};
		4'b1011 : assign Out = {In, 11'h0};
		4'b1100 : assign Out = {In, 12'h0};
		4'b1101 : assign Out = {In, 13'h0};
		4'b1110 : assign Out = {In, 14'h0};
		4'b1111 : assign Out = {In, 15'h0};
	endcase
end



endmodule
