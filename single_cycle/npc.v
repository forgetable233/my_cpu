module npc(npc,npc_t,instr_index,offset,a,zero,s);

output reg [31:0] npc;

input [31:0] npc_t;  //npc_t = pc+4
input [25:0] instr_index;
input [31:0] offset;  //指令低16位符号扩展
input [31:0] a;  //alu模块a输出
input [1:0] s;  //ctrl模块产生，确定当前指令类型
input zero;   //alu模块zero输出

always @(*)
begin
	case(s)
		2'b00:
		begin
			if(zero == 1)
				npc = npc_t + (offset <<2 );
				else
				npc = npc_t;
		end
		2'b01:npc = {npc_t[31:28], instr_index[25:0], 2'b00};
		2'b10:npc = a;
		2'b11:npc = npc_t;
	endcase
end
endmodule
