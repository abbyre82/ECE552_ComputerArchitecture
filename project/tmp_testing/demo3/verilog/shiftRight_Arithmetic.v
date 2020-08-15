module shiftRight_Arithmetic(In, Cnt, Out);

input [15:0] In;
input [3:0] Cnt;
output reg [15:0] Out;

wire [15:0] out;

always@(*) begin
	case(Cnt)
		4'b0000 : assign Out = In;
		4'b0001 : assign Out = {{1{In[15]}}, In[15:1]};
		4'b0010 : assign Out = {{2{In[15]}}, In[15:2]};
		4'b0011 : assign Out = {{3{In[15]}}, In[15:3]};
		4'b0100 : assign Out = {{4{In[15]}}, In[15:4]};
		4'b0101 : assign Out = {{5{In[15]}}, In[15:5]};
		4'b0110 : assign Out = {{6{In[15]}}, In[15:6]};
		4'b0111 : assign Out = {{7{In[15]}}, In[15:7]};
		4'b1000 : assign Out = {{8{In[15]}}, In[15:8]};
		4'b1001 : assign Out = {{9{In[15]}}, In[15:9]};
		4'b1010 : assign Out = {{10{In[15]}}, In[15:10]};
		4'b1011 : assign Out = {{11{In[15]}}, In[15:11]};
		4'b1100 : assign Out = {{12{In[15]}}, In[15:12]};
		4'b1101 : assign Out = {{13{In[15]}}, In[15:13]};
		4'b1110 : assign Out = {{14{In[15]}}, In[15:14]};
		4'b1111 : assign Out = {{15{In[15]}}, In[15]};
	endcase
end



endmodule