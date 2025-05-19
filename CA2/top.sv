module RISC_V(clk ,rst);
    input clk,rst;

    wire RegWrite, MemWrite, ALUSrc2;
    wire[1:0] ResultSrc, PCSrc;
    wire[2:0] ALUControl, ImmSrc;
    wire [6:0] opcode;
    wire bge, zero;
    wire[2:0] func3;
    wire[6:0] func7;

    CU cntr(.opcode(opcode), .func3(func3), .func7(func7), .zero(zero), .bge(bge),.PCSrc(PCSrc), .ResultSrc(ResultSrc), .MemWrite(MemWrite), .ALUControl(ALUControl), .ALUSrc(ALUSrc), .ImmSrc(ImmSrc), .RegWrite(RegWrite));
    datapath dp(.clk(clk), .rst(rst), .RegWrite(RegWrite), .MemWrite(MemWrite), .ResultSrc(ResultSrc), .PCSrc(PCSrc), .ALUSrc2(ALUSrc2), .ALUControl(ALUControl),.ImmSrc(ImmSrc),.bge(bge), .zero(zero), .opcode(opcode), .func3(func3), .func7(func7));
    


endmodule
