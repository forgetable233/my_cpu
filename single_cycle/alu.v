module alu(c, a, b);

output reg [31:0] c;

input [31:0] a;
input [31:0] b;

always @(*) begin
    c = a + b;
end

endmodule
