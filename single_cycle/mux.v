module mux(in1, in2, out, op);

input [31:0] in1;
input [31:0] in2;
input op;

output [31:0] out;

assign out = (op == 0) ? in1 : in2;

endmodule
