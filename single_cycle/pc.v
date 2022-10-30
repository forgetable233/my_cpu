module pc(pc, clock, reset, npc);

    output [31:0] pc;
    input clock;
    input reset;
    input [31:0] npc;

    reg [31:0] temp_pc;
    always @(posedge clock or negedge reset) 
    begin
        if (reset == 0)
            temp_pc <= 32'h00003000;
        else
            temp_pc <= npc;
    end
    assign pc = temp_pc;
endmodule