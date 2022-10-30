module single_cycle(clock, reset);

input clock;
input reset;

wire [31:0] pc;
wire [31:0] npc;

pc PC(.pc(pc), .clock(clock), .reset(reset), .npc(npc));


endmodule
