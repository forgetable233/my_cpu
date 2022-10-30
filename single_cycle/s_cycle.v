`timescale 1ps/1ps
module s_cycle_tb;

reg clock;
reg reset;
wire clk;
wire ret;

initial begin
    clock = 1;
    reset = 1;
    #1000
    reset = 0;
    #1000
    reset = 1;
end

always #200
    assign clock = ~clock;

assign clk = clock;
assign ret = reset;
single_cycle(.clock(clk), .reset(ret));

endmodule
