module s_cycle_cpu(clock, reset);

input   clock;
input   reset;

wire zero;
wire reg_write;
wire if_extend;
wire alu_src;
wire reg_src;
wire [4:0] aluop;
wire [4:0] rs;
wire [4:0] rt;
wire [4:0] rd;
wire [4:0] num_write;
wire [4:0] shamt;
wire [5:0] op;
wire [5:0] funct;
wire [15:0] imm_16;
wire [31:0] pc;
wire [31:0] npc;
wire [31:0] bus_a;
wire [31:0] bus_b;
wire [31:0] b;
wire [31:0] c;
wire [31:0] r_data_write;
wire [31:0] instruction;
wire [31:0] imm_32;

assign op = instruction[31:26];
assign rs = instruction[25:21];
assign rt = instruction[20:16];
assign rd = instruction[15:11];
assign shamt = instruction[10:5];
assign funct  = instruction[5:0];
assign imm_16 = instruction[15:0];

assign npc = pc + 4;
assign r_data_write = c;

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
            .reg_dst(reg_src));

gpr GPR(    .a(bus_a), 
            .b(b), 
            .clock(clock), 
            .reg_write(reg_write), 
            .num_write(num_write), 
            .rs(rs), 
            .rt(rt), 
            .data_write(r_data_write));

imm_extend imm_extend(  .imm_16(imm_16),
                        .imm_32(imm_32),
                        .if_extend(if_extend));

alu_src_mux alu_src_mux(.b(b), 
                        .imm_32(imm_32),
                        .bus_b(bus_b),
                        .alu_src(alu_src));

reg_dst_mux reg_dst_mux(.rt(rd), 
                        .rd(rt),
                        .num_write(num_write),
                        .reg_dst(reg_dst));

alu ALU(    .c(c), 
            .a(bus_a), 
            .b(bus_b), 
            .aluop(aluop));
endmodule