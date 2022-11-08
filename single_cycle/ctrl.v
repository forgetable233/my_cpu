`define add_f	6'b100000
`define addu_f  6'b100001
`define subu_f  6'b100011
`define and_f   6'b100100
`define or_f    6'b100101
`define slt_f   6'b101010
`define jr_f    6'b001000

`define add_op  5'b00000
`define addu_op 5'b00001
`define subu_op 5'b00010
`define and_op  5'b00011
`define or_op   5'b00100
`define slt_op  5'b00101
`define lui_op  5'b00110
`define none    5'b11111


module ctrl(reg_write, 
            aluop, 
            op, 
            funct,
            if_extend,
            alu_src,
            reg_dst,
            mem_write,
            memtoreg, 
            s_npc);

output reg [1:0]memtoreg;
output reg [1:0]reg_dst;
output reg [1:0] s_npc;
output reg [4:0] aluop;
output reg reg_write;
output reg if_extend;
output reg alu_src;
output reg mem_write;

input [5:0] op;
input [5:0] funct;

always @(*) begin
    if(op == 6'b000000)begin
        case(funct)
            `add_f:  {memtoreg, mem_write, reg_write, if_extend, alu_src, reg_dst, s_npc, aluop} = {2'b01, 1'b0, 1'b1, 1'b0, 1'b0, 2'b01, 2'b11,  `add_op};
            `addu_f: {memtoreg, mem_write, reg_write, if_extend, alu_src, reg_dst, s_npc, aluop} = {2'b01, 1'b0, 1'b1, 1'b0, 1'b0, 2'b01, 2'b11,  `addu_op};
            `subu_f: {memtoreg, mem_write, reg_write, if_extend, alu_src, reg_dst, s_npc, aluop} = {2'b01, 1'b0, 1'b1, 1'b0, 1'b0, 2'b01, 2'b11,  `subu_op};
            `and_f:  {memtoreg, mem_write, reg_write, if_extend, alu_src, reg_dst, s_npc, aluop} = {2'b01, 1'b0, 1'b1, 1'b0, 1'b0, 2'b01, 2'b11,  `and_op};
            `or_f:   {memtoreg, mem_write, reg_write, if_extend, alu_src, reg_dst, s_npc, aluop} = {2'b01, 1'b0, 1'b1, 1'b0, 1'b0, 2'b01, 2'b11,  `or_op};
            `slt_f:  {memtoreg, mem_write, reg_write, if_extend, alu_src, reg_dst, s_npc, aluop} = {2'b01, 1'b0, 1'b1, 1'b0, 1'b0, 2'b01, 2'b11,  `slt_op};    
            `jr_f:   {memtoreg, mem_write, reg_write, if_extend, alu_src, reg_dst, s_npc, aluop} = {2'b00, 1'b0, 1'b1, 1'b0, 1'b0, 2'b00, 2'b10,  `none};
        endcase
    end
    else begin
        case(op)
            6'b001000: {memtoreg, mem_write, reg_write, if_extend, alu_src, reg_dst, s_npc, aluop} = {2'b01, 1'b0, 1'b1, 1'b1, 1'b1, 2'b00, 2'b11 , `add_op};    // addi
            6'b001001: {memtoreg, mem_write, reg_write, if_extend, alu_src, reg_dst, s_npc, aluop} = {2'b01, 1'b0, 1'b1, 1'b1, 1'b1, 2'b00, 2'b11 , `addu_op};   // addiu
            6'b001100: {memtoreg, mem_write, reg_write, if_extend, alu_src, reg_dst, s_npc, aluop} = {2'b01, 1'b0, 1'b1, 1'b0, 1'b1, 2'b00, 2'b11 , `and_op};    // andi
            6'b001101: {memtoreg, mem_write, reg_write, if_extend, alu_src, reg_dst, s_npc, aluop} = {2'b01, 1'b0, 1'b1, 1'b0, 1'b1, 2'b00, 2'b11 , `or_op};     // ori
            6'b001111: {memtoreg, mem_write, reg_write, if_extend, alu_src, reg_dst, s_npc, aluop} = {2'b01, 1'b0, 1'b1, 1'b1, 1'b1, 2'b00, 2'b11 , `lui_op};    // lui
            6'b101011: {memtoreg, mem_write, reg_write, if_extend, alu_src, reg_dst, s_npc, aluop} = {2'b01, 1'b1, 1'b0, 1'b1, 1'b1, 2'b00, 2'b11 , `add_op};    // sw
            6'b100011: {memtoreg, mem_write, reg_write, if_extend, alu_src, reg_dst, s_npc, aluop} = {2'b10, 1'b0, 1'b1, 1'b1, 1'b1, 2'b00, 2'b11 , `add_op};    // lw
            6'b000100: {memtoreg, mem_write, reg_write, if_extend, alu_src, reg_dst, s_npc, aluop} = {2'b00, 1'b0, 1'b0, 1'b1, 1'b0, 2'b00, 2'b00 , `subu_op};   // beq
            6'b000010: {memtoreg, mem_write, reg_write, if_extend, alu_src, reg_dst, s_npc, aluop} = {2'b01, 1'b0, 1'b0, 1'b0, 1'b0, 2'b00, 2'b01 , `none};      // j
            6'b000011: {memtoreg, mem_write, reg_write, if_extend, alu_src, reg_dst, s_npc, aluop} = {2'b01, 1'b0, 1'b1, 1'b0, 1'b0, 2'b10, 2'b01 , `none};      // jal
        endcase
    end
end
endmodule