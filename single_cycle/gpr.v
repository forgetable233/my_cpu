module gpr(a, b, clock, reg_write, num_write, rs, rt, data_write);

// 根据相关信息从寄存器堆中得到/保存相关数据
output [31:0] a;
output [31:0] b;

input clock;
input reg_write;
input [4:0] rs;
input [4:0] rt;
input [4:0] num_write;
input [31:0] data_write;

reg [31:0] gp_registers[31:0];

assign a = rs ? gp_registers[rs] : 0;
assign b = rt ? gp_registers[rt] : 0;

always @(posedge clock) begin
    if (reg_write)
        gp_registers[num_write] <= data_write;
end

endmodule
