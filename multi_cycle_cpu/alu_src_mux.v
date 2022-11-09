module alu_src_mux(b, imm_32, bus_b, alu_src);

input alu_src;
input [31:0] b;
input [31:0] imm_32;

output [31:0] bus_b;

assign bus_b = (alu_src == 0) ? b : imm_32;

endmodule
