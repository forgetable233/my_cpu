module pipeline_cpu(clock, reset);
input   clock;
input   reset;

wire zero_exe;
wire reg_write;
wire alu_src;
wire if_extend;
wire mem_write;
wire [1:0] reg_dst;
wire [1:0] memtoreg;
wire [1:0] s_npc;
wire [4:0] aluop;

wire zero_mem;
wire reg_write_exe;
wire reg_write_wb;
wire alu_src_exe;
wire mem_write_exe;
wire [1:0] reg_dst_exe;
wire [1:0] memtoreg_exe;
wire [1:0] s_npc_exe;
wire [4:0] aluop_exe;

wire [1:0] memtoreg_mem;
wire [1:0] memtoreg_wb;
wire reg_write_mem;
wire mem_write_mem;

wire [4:0] rs;
wire [4:0] rt;
wire [4:0] rd;
wire [4:0] rw_id;
wire [4:0] rw_exe;
wire [4:0] rw_mem;
wire [4:0] rw_wb;
wire [4:0] num_write;
wire [4:0] shamt;
wire [5:0] op;
wire [5:0] funct;
wire [15:0] imm_16;
wire [25:0] instr_index;
wire [31:0] pc;
wire [31:0] npc;
wire [31:0] npc_t;
wire [31:0] npc_t_if;
wire [31:0] npc_t_id;
wire [31:0] npc_t_exe;
wire [31:0] npc_t_mem;
wire [31:0] npc_t_wb;
wire [31:0] bus_a_id;
wire [31:0] bus_a_exe;
wire [31:0] bus_b_id;
wire [31:0] bus_b_exe;
wire [31:0] bus_b_mem;
wire [31:0] b;
wire [31:0] c_exe;
wire [31:0] c_mem;
wire [31:0] c_wb;
wire [31:0] reg_wirte_data;
wire [31:0] instruction_if;
wire [31:0] instruction_id;
wire [31:0] imm_32_id;
wire [31:0] imm_32_if;
wire [31:0] imm_32_exe;
wire [31:0] mem_load_data;
wire [31:0] mem_loda_data_wb;

// **************************************************************************************//
// ***************************************IF*********************************************//
// **************************************************************************************//
// PC获得下一条指令
pc PC(  .pc(pc), 
        .clock(clock), 
        .reset(reset), 
        .npc(npc));

// 暂时存储下一条指令的地址
assign npc_t_if = pc + 4;

// 根据PC得到对应的指令内容，保存在IF_ID寄存器中
im IM(  .instruction(instruction_if), 
        .pc(pc));

// IF_ID段流水线寄存器
pr #(32, 32) IF_ID(     .clock(clock),
                        .reset(reset),
                        .in_data(npc_t_if),
                        .in_ctrl(instruction_if),
                        .out_data(npc_t_id),
                        .out_ctrl(instruction_id));

// **************************************************************************************//
// ***************************************ID*********************************************//
// **************************************************************************************//

// 根据得到的指令进行对应的解码操作，此时的指令位instruction_if
assign op = instruction_if[31:26];
assign rs = instruction_if[25:21];
assign instr_index_id = instruction_if[25:0];
assign rt = instruction_if[20:16];
assign rd = instruction_if[15:11];
assign shamt = instruction_if[10:5];
assign funct  = instruction_if[5:0];
assign imm_16 = instruction_if[15:0];

// 对立即数进行拓展操作
imm_extend imm_extend(  .imm_16(imm_16),
                        .imm_32(imm_32_id),
                        .if_extend(if_extend));

// 选择写入的目标寄存器
mux2 MUX2_INS(  .out1(rw_id),
                .in1(rt),
                .in2(rd),
                .in3(5'b11111),
                .in4(5'b11111),
                .op(reg_dst));

// 根据指令进行译码操作，得到对应的控制信号。
ctrl CTRL(      .op(op), 
                .funct(funct),   
                .reg_write(reg_write), 
                .aluop(aluop), 
                .if_extend(if_extend), 
                .alu_src(alu_src), 
                .reg_dst(reg_dst),
                .mem_write(mem_write),
                .memtoreg(memtoreg),
                .s_npc(s_npc));

// ID_EXE端流水线寄存器
// 保存的数据：写入目标寄存器，PC + 4 数据，bus_a读出数据，bus_b读出数据，立即数拓展数据。共5 + 32 * 4 = 133位
// 保存的指令：为ctrl产生的所有指令,共5个，10位
pr #(133, 15) ID_EXE(   .clock(clock),
                        .reset(reset),
                        .in_data({npc_t_id, rw_id, bus_a_id, bus_b_id, imm_32_id}),
                        .in_ctrl({memtoreg, mem_write, reg_write, alu_src, aluop}),
                        .out_data({npc_t_exe, rw_exe, bus_a_exe, bus_b_exe, imm_32_exe}),
                        .out_ctrl({memtoreg_exe, mem_write_exe, reg_write_exe, alu_src_exe, aluop_exe}));

// **************************************************************************************//
// ***************************************EXE********************************************//
// **************************************************************************************//
// 选择alu输入的计算数b
alu_src_mux alu_src_mux(.b(bus_b_exe), 
                        .imm_32(imm_32_exe),
                        .bus_b(b),
                        .alu_src(alu_src_exe));

// alu进行运算操作
alu ALU(    .c(c_exe), 
            .a(bus_a_exe), 
            .b(b), 
            .aluop(aluop_exe),
            .zero(zero_exe));

// EXE_MEM阶段寄存器
// 保存的数据：bus_b，PC + 4，c，rw 共101位
// 保存的控制信号：
pr #(101, 4) EXE_MEM(   .clock(clock),
                        .reset(reset),
                        .in_data({npc_t_exe, bus_b_exe, c_exe, rw_exe}),
                        .in_ctrl({memtoreg_exe, reg_write_exe, mem_write_exe}),
                        .out_data({npc_t_mem, bus_b_mem, c_mem, rw_mem}),
                        .out_ctrl({memtoreg_mem, reg_write_mem, mem_write_mem}));

// **************************************************************************************//
// ***************************************MEM********************************************//
// **************************************************************************************//
// 访问内存堆获得对应的数据 
dm DM(  .data_out(mem_load_data),
        .clock(clock),
        .mem_write(mem_write_mem),
        .address(c_mem),
        .data_in(bus_b_mem));

pr #(101, 3) MEM_WB(    .clock(clock),
                        .reset(reset),
                        .in_data({npc_t_mem, mem_load_data, c_exe, rw_exe}),
                        .in_ctrl({memtoreg_mem, reg_write_mem}),
                        .out_data({npc_t_wb, mem_loda_data_wb, c_wb, rw_wb}),
                        .out_ctrl({memtoreg_wb, reg_write_wb}));

// **************************************************************************************//
// ****************************************WB********************************************//
// **************************************************************************************//
// 选择写入寄存器的数据
mux2 MUX2_DM(   .out1(reg_wirte_data),
                .in1(npc_t_wb),
                .in2(c_wb),
                .in3(mem_loda_data_wb),
                .in4(5'b11111),
                .op(memtoreg_wb));

gpr GPR(    .a(bus_a_id), 
            .b(bus_b_id), 
            .clock(clock), 
            .reg_write(reg_wirte_wb), 
            .num_write(rw_wb), 
            .rs(rs), 
            .rt(rt), 
            .data_write(reg_write_data));

npc NPC(    .npc(npc),
            .npc_t(npc_t_if),
            .instr_index(instr_index),
            .offset(imm_32),
            .a(bus_a_id),
            .zero(zero),
            .s(s_npc));
endmodule
