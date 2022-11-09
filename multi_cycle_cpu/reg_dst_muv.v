module reg_dst_mux(rt, rd, num_write, reg_dst);

input [5:0] rt;
input [5:0] rd;
input reg_dst;

output [5:0] num_write;

assign num_write = (reg_dst == 0) ? rd : rt;

endmodule
