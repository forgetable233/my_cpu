module mux(in1, in2, out, op);

input [4:0] in1;
input [4:0] in2;
input op;

output [4:0] out;

assign num_write = (op == 0) ? in1 : in2;

endmodule
