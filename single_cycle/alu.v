`define add_f	6'b100000
`define addu_f 6'b100001
`define subu_f 6'b100011
`define and_f 6'b100100
`define or_f 6'b100101
`define slt_f 6'b101010

`define add_op 5'b00000
`define addu_op 5'b00001
`define subu_op 5'b00010
`define and_op 5'b00011
`define or_op 5'b00100
`define slt_op 5'b00101


module alu(c, a, b, aluop);

output reg [31:0] c;

input [31:0] a;
input [31:0] b;
input [4:0] aluop;

always @(*) begin
    case(aluop)
        `add_op:	c = $signed(a) + $signed(b);
		`addu_op:	c = a + b;
		`subu_op:	c = a - b;
		`and_op:	c = a & b;
		`or_op:		c = a | b;
		`slt_op:	c = ($signed(a) < $signed(b)) ? 1 : 0;
    endcase 
end

endmodule