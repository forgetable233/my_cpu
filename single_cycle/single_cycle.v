module s_cycle_cpu(clock, reset);

input   clock;
input   reset;

wire zero;
wire reg_write;
wire alu_src;
wire if_extend;
wire mem_write;
wire [1:0] reg_dst;
wire [1:0] memtoreg;
wire [1:0] s_npc;
wire [4:0] aluop;
wire [4:0] rs;
wire [4:0] rt;
wire [4:0] rd;
wire [4:0] num_write;
wire [4:0] shamt;
wire [5:0] op;
wire [5:0] funct;
wire [15:0] imm_16;
wire [25:0] instr_index;
wire [31:0] pc;
wire [31:0] npc;
wire [31:0] npc_t;
wire [31:0] bus_a;
wire [31:0] bus_b;
wire [31:0] b;
wire [31:0] c;
wire [31:0] reg_wirte_data;
wire [31:0] instruction;
wire [31:0] imm_32;
wire [31:0] mem_load_data;

assign op = instruction[31:26];
assign rs = instruction[25:21];
assign instr_index = instruction[25:0];
assign rt = instruction[20:16];
assign rd = instruction[15:11];
assign shamt = instruction[10:5];
assign funct  = instruction[5:0];
assign imm_16 = instruction[15:0];
assign npc_t = pc + 4;

pc PC(  .pc(pc), 
        .clock(clock), 
        .reset(reset), 
        .npc(npc));

im IM(  .instruction(instruction), 
        .pc(pc));

ctrl CTRL(  .reg_write(reg_write), 
            .aluop(aluop), 
            .op(op), 
            .funct(funct), 
            .if_extend(if_extend), 
            .alu_src(alu_src), 
            .reg_dst(reg_dst),
            .mem_write(mem_write),
            .memtoreg(memtoreg),
            .s_npc(s_npc));

gpr GPR(    .a(bus_a), 
            .b(b), 
            .clock(clock), 
            .reg_write(reg_write), 
            .num_write(num_write), 
            .rs(rs), 
            .rt(rt), 
            .data_write(reg_wirte_data));

dm DM(  .data_out(mem_load_data),
        .clock(clock),
        .mem_write(mem_write),
        .address(c),
        .data_in(b));

imm_extend imm_extend(  .imm_16(imm_16),
                        .imm_32(imm_32),
                        .if_extend(if_extend));

mux2 MUX2_INS(  .out1(num_write),
                .in1(rt),
                .in2(rd),
                .in3(5'b111111),
                .op(reg_dst));

mux2 MUX2_DM(   .out1(reg_wirte_data),
                .in1(npc_t),
                .in2(c),
                .in3(mem_load_data),
                .op(memtoreg));

alu_src_mux alu_src_mux(.b(b), 
                        .imm_32(imm_32),
                        .bus_b(bus_b),
                        .alu_src(alu_src));

alu ALU(    .c(c), 
            .a(bus_a), 
            .b(bus_b), 
            .aluop(aluop),
            .zero(zero));

npc NPC(    .npc(npc),
            .npc_t(npc_t),
            .instr_index(instr_index),
            .offset(imm_32),
            .a(bus_a),
            .zero(zero),
            .s(s_npc));
endmodule