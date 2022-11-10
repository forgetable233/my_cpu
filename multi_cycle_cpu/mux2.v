module mux2(out1, in1, in2, in3, in4, op);

input [1:0] op;
input [31:0] in1;
input [31:0] in2;
input [31:0] in3;
input [31:0] in4;

output reg [31:0] out1;

always@(*)
begin
	case(op)
		2'b00: out1 <= in1;
		2'b01: out1 <= in2;
		2'b10: out1 <= in3;
		2'b11: out1 <= in4;
	endcase
end
endmodule