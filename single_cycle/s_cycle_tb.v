`timescale 1ns/1ns
module s_cycle_tb;

reg clock;
reg reset;

initial begin
    clock = 1;
    reset = 1;
    #1000
    reset = 0;
    #1000
    reset = 1;
end

always #40
    assign clock = ~clock;

// single_cycle single_cycle0(.clock(clock), .reset(reset));

endmodule
