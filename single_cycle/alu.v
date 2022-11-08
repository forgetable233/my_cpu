`define add_op 	5'b00000
`define addu_op 5'b00001
`define subu_op 5'b00010
`define and_op 	5'b00011
`define or_op 	5'b00100
`define slt_op 	5'b00101
`define lui_op  5'b00110


module alu(c, a, b, aluop, zero);

output reg [31:0] c;

input [31:0] a;
input [31:0] b;
input [4:0] aluop;
input zero;

assign zero = (c == 0) ? 1 : 0;

always @(*) begin
    case(aluop)
        `add_op:	c = $signed(a) + $signed(b);
		`addu_op:	c = a + b;
		`subu_op:	c = a - b;
		`and_op:	c = a & b;
		`or_op:		c = a | b;
		`slt_op:	c = ($signed(a) < $signed(b)) ? 1 : 0;
		`lui_op:	c = b << 16;
    endcase 
end

endmodule