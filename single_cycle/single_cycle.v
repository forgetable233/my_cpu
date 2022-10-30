module single_cycle(clock, reset);

input   clock;
input   reset;

wire [31:0] pc;
wire [31:0] npc;

assign pc = 00000000;
assign npc = 00000000;

pc PC0(.pc(pc), .clock(clock), .reset(reset), .npc(npc));

endmodule
