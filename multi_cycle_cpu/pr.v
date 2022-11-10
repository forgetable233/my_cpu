//流水线寄存器
module pr #(parameter width_a = 32, parameter width_b = 32)(clock, reset, in_data, in_ctrl, out_data, out_ctrl);
    input clock;
    input reset;                                //复位信号
    input [width_a - 1 : 0] in_data;            //数据信号
    input [width_b - 1 : 0] in_ctrl;            //控制信号
    output reg [width_a - 1 : 0] out_data;
    output reg [width_b - 1 : 0] out_ctrl;

    always@(posedge clock,negedge reset) begin
        if (reset == 1'b0) begin            //同pc，低电平异步复位
            out_data <= 0;                     //reset为0时，所有复位信号被复位为0
            out_ctrl <= 0;
        end
        else begin
            out_data <= in_data;
            out_ctrl <= in_ctrl;    
        end
    end
endmodule
