module RISCV(clk ,rst);
    input clk,rst;

    wire RegWrite, MemWrite, ALUSrc;
    wire[1:0] ResultSrc, PCSrc;
    wire[2:0] ALUControl, ImmSrc;
    wire [6:0] opcode;
    wire zero;
    wire[2:0] func3;
    wire[6:0] func7;

    CU cntr(.opcode(opcode), .func3(func3), .func7(func7), .zero(zero),.PCSrc(PCSrc), .ResultSrc(ResultSrc), .MemWrite(MemWrite), .ALUControl(ALUControl), .ALUSrc(ALUSrc), .ImmSrc(ImmSrc), .RegWrite(RegWrite));
    datapath dp(.clk(clk), .rst(rst), .RegWrite(RegWrite), .MemWrite(MemWrite), .ResultSrc(ResultSrc), .PCSrc(PCSrc), .ALUSrc(ALUSrc), .ALUControl(ALUControl),.ImmSrc(ImmSrc), .zero(zero), .opcode(opcode), .func3(func3), .func7(func7));
    


endmodule
