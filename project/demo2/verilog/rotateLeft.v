module rotateLeft(In, Cnt, Out);

input [15:0] In;
input [3:0] Cnt;
output reg [15:0] Out;

wire [15:0] out;

always@(*) begin
	case(Cnt)
		4'b0000 : assign Out = In;
		4'b0001 : assign Out = {In[14:0], In[15]};
		4'b0010 : assign Out = {In[13:0], In[15:14]};
		4'b0011 : assign Out = {In[12:0], In[15:13]};
		4'b0100 : assign Out = {In[11:0], In[15:12]};
		4'b0101 : assign Out = {In[10:0], In[15:11]};
		4'b0110 : assign Out = {In[9:0], In[15:10]};
		4'b0111 : assign Out = {In[8:0], In[15:9]};
		4'b1000 : assign Out = {In[7:0], In[15:8]};
		4'b1001 : assign Out = {In[6:0], In[15:7]};
		4'b1010 : assign Out = {In[5:0], In[15:6]};
		4'b1011 : assign Out = {In[4:0], In[15:5]};
		4'b1100 : assign Out = {In[3:0], In[15:4]};
		4'b1101 : assign Out = {In[2:0], In[15:3]};
		4'b1110 : assign Out = {In[1:0], In[15:2]};
		4'b1111 : assign Out = {In[0], In[15:1]};
	endcase
end



endmodule
