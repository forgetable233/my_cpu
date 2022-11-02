module imm_extend(imm_16, imm_32, if_extend);

input if_extend;
input [15:0] imm_16;

output [31:0] imm_32;

assign imm_32=(if_extend)? {{16{imm_16[15]}},imm_16}: {16'h0000,imm_16};

endmodule
