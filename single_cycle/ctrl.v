`define add_f	6'b100000
`define addu_f  6'b100001
`define subu_f  6'b100011
`define and_f   6'b100100
`define or_f    6'b100101
`define slt_f   6'b101010

`define add_op  5'b00000
`define addu_op 5'b00001
`define subu_op 5'b00010
`define and_op  5'b00011
`define or_op   5'b00100
`define slt_op  5'b00101
`define lui_op  5'b00110


module ctrl(reg_write, 
            aluop, 
            op, 
            funct,
            if_extend,
            alu_src,
            reg_dst);
output reg [4:0] aluop;
output reg reg_write;
output reg if_extend;
output reg alu_src;
output reg reg_dst;

input [5:0] op;
input [5:0] funct;

always @(*) begin
    if(op == 6'b000000)begin
        case(funct)
            `add_f:  {reg_write, if_extend, alu_src, reg_dst, aluop} = {1'b1, 1'b0, 1'b0, 1'b0, `add_op};
            `addu_f: {reg_write, if_extend, alu_src, reg_dst, aluop} = {1'b1, 1'b0, 1'b0, 1'b0, `addu_op};
            `subu_f: {reg_write, if_extend, alu_src, reg_dst, aluop} = {1'b1, 1'b0, 1'b0, 1'b0, `subu_op};
            `and_f:  {reg_write, if_extend, alu_src, reg_dst, aluop} = {1'b1, 1'b0, 1'b0, 1'b0, `and_op};
            `or_f:   {reg_write, if_extend, alu_src, reg_dst, aluop} = {1'b1, 1'b0, 1'b0, 1'b0, `or_op};
            `slt_f:  {reg_write, if_extend, alu_src, reg_dst, aluop} = {1'b1, 1'b0, 1'b0, 1'b0, `slt_op};    
        endcase
    end
    else begin
        case(op)
            6'b001000: {reg_write, if_extend, alu_src, reg_dst, aluop} = {1'b1, 1'b1, 1'b1, 1'b1, `add_op};
            6'b001001: {reg_write, if_extend, alu_src, reg_dst, aluop} = {1'b1, 1'b1, 1'b1, 1'b1, `addu_op};
            6'b001100: {reg_write, if_extend, alu_src, reg_dst, aluop} = {1'b1, 1'b0, 1'b1, 1'b1, `and_op};
            6'b001101: {reg_write, if_extend, alu_src, reg_dst, aluop} = {1'b1, 1'b0, 1'b1, 1'b1, `or_op};
            6'b001111: {reg_write, if_extend, alu_src, reg_dst, aluop} = {1'b1, 1'b1, 1'b1, 1'b1, `lui_op};
        endcase
    end
end
endmodule