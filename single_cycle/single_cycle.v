module s_cycle_cpu(clock, reset);

input   clock;
input   reset;

wire reg_write;
wire zero;
wire [3:0] aluop;
wire [4:0] rs;
wire [4:0] rt;
wire [4:0] rd;
wire [4:0] num_write;
wire [4:0] shamt;
wire [5:0] op;
wire [5:0] funct;
wire [31:0] pc;
wire [31:0] npc;
wire [31:0] bus_a;
wire [31:0] bus_b;
wire [31:0] c;
wire [31:0] r_data_write;
wire [31:0] instruction;

assign op = instruction[31:26];
assign rs = instruction[25:21];
assign rt = instruction[20:16];
assign num_write = instruction[15:11];

assign npc = pc + 4;
// assign num_write = rd;
// assign reg_write = 1;

pc PC(.pc(pc), .clock(clock), .reset(reset), .npc(npc));
im IM(.instruction(instruction), .pc(pc));
ctrl CTRL(.reg_write(reg_write), .aluop(aluop), .op(op), .funct(funct));
gpr GPR(.a(bus_a), .b(bus_b), .clock(clock), .reg_write(reg_write), .num_write(num_write), .rs(rs), .rt(rt), .data_write(r_data_write));
alu ALU(.c(c), .a(bus_a), .b(bus_b), .op(aluop), .zero(zero));
assign r_data_write = c;
endmodule