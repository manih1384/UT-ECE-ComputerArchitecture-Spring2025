module Datapath(
    input clk,rst,addrSrc,mem_read,mem_write,load_a,load_b,alu_control,push,pop,pc_rite,ir_write,stack_src,mdr_en,jump
    output [2:0]opcode,
    output [7:0] tos
);
wire [4:0] pcIn,pc,pcPlus4Out,memoryIn,instructionAddress;
wire [7:0] memOut,irOut,mdrOut,stackIn,stackOut,Aout,Bout;
assign instructionAddress = irOut[4:0];
assign opcode = irOut[7:5];
Register #(5) PCReg(.clk(clk),.rst(rst),.wr(pc_write),.din(pcIn),.dout(pc));
Plus1 pcPlus1 (.pc(pc),.out(pcPlus4Out));
mux2to1 #(5) pcMux (.a(pcPlus4Out),.b(instructionAddress),.sel(jump),.out(pcIn))
mux2to1 #(5) memoryMux(.a(pc),.b(instructionAddress),.sel(addrSrc),.out(memoryIn)) ;
Mem memory (.addr(memoryIn),.din(stackOut),.data(memOut),.write_enable(mem_write));
Register #(8) ir(.clk(clk),.rst(rst),.wr(ir_write),.din(memOut),.dout(irOut));
Register #(8) mdr (.clk(clk),.rst(rst),.wr(mdr_en),.din(memOut),.dout(mdrOut));

mux2to1 #(8) stackMux(.a(aluOut),.b(mdrOut),.sel(stack_src),.out(stackIn));
Stack stack(.clk(clk),.rst(rst),.d_in(stackIn),.push(push),.pop(pop),.d_out(stackOut),.tos(tos));

Register #(8) A (.clk(clk),.rst(rst),.wr(load_a),.din(stackOut),.dout(AOut));
Register #(8) B (.clk(clk),.rst(rst),.wr(load_b),.din(stackOut),.dout(Bout));
ALU alu (.A(Aout),.B(Bout),.opcode(alu_control),.Y(aluOut));

endmodule