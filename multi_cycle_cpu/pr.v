//流水线寄存器
module pr #(parameter width_a = 32, parameter width_b = 32)(clock, reset, in_a, in_b, out_a, out_b);
    input clock;
    input reset;                            //复位信号
    input [width_a - 1 : 0] in_a;           //数据信号
    input [width_b - 1 : 0] in_b;           //控制信号
    output reg [width_a - 1 : 0] out_a;
    output reg [width_b - 1 : 0] out_b;

    always@(posedge clock,negedge reset) begin
        if (reset == 1'b0) begin            //同pc，低电平异步复位
            out_a <= 0;                     //reset为0时，所有复位信号被复位为0
            out_b <= 0;
        end
        else begin
            out_a <= in_a;
            out_b <= in_b;    
        end
    end
endmodule
