`timescale 1ns/1ns
module datapath(clk, rst, RegWrite, MemWrite, ResultSrc, PCSrc, ALUSrc, ALUControl,ImmSrc, zero, opcode, func3, func7);
    input clk, rst, RegWrite, MemWrite, ALUSrc;
    input[1:0] PCSrc,ResultSrc ;
    input[2:0] ALUControl, ImmSrc;
    output zero;
    output [6:0] opcode;
    output[2:0] func3;
    output[6:0] func7;
    

    wire[31:0] ALUResult, PCPlus4, 
    PCTarget, PCNext, PC, instruction, 
    Result, WD, RD1, RD2, ImmExt;
    wire[31:0] SrcB, ReadData;
    wire [4:0] A1, A2, A3;

    assign A1 = instruction[19:15];
    assign A2 = instruction[24:20];
    assign A3 = instruction[11:7];
    assign WD = Result;
    assign opcode = instruction[6:0];
    assign func3 = instruction[14:12];
    assign func7 = instruction[31:25];

    PC_mux PCMux (
    .PCSrc(PCSrc),
    .PCplus4(PCPlus4),
    .PCImm(PCTarget),
    .ALUres(ALUResult),
    .PCNext(PCNext)
  );
   PC_register PCreg (
    .clk(clk),
    .rst(rst),
    .PCNext(PCNext),
    .PC(PC)
  );    
    instruction_memory inst_mem(
        .pc(PC), 
        .inst(instruction)
    );
    PCPlus4 PC4(
        .PC(PC), 
        .PCPlus4(PCPlus4)
    );
    PC_imm_adder PCI(
        .PC(PC), 
        .offset(ImmExt), 
        .PCTarget(PCTarget)
    );
    Extend EXTU(
        .inst(instruction), 
        .ImmSrc(ImmSrc), 
        .ImmExt(ImmExt)
    );
    register_file RegisterFile (
    .clk(clk),
    .rst(rst),
    .RegWrite(RegWrite),
    .A1(A1),
    .A2(A2),
    .A3(A3),
    .WD(WD),
    .RD1(RD1),
    .RD2(RD2)
  );    SrcB_mux SrcB_data (
    .ALUSrc(ALUSrc),
    .RD2(RD2),
    .ImmExt(ImmExt),
    .SrcB(SrcB)
  );
    ALU alu (
    .A(RD1),
    .B(SrcB),
    .ALUControl(ALUControl),
    .ALUResult(ALUResult),
    .zero(zero)
  );
  Data_memory dataMemory (
    .clk(clk),
    .Address(ALUResult),
    .WriteData(RD2),
    .MemWrite(MemWrite),
    .ReadData(ReadData)
  );    
  Result_mux resMux (
    .ResultSrc(ResultSrc),
    .ALUres(ALUResult),
    .ReadData(ReadData),
    .PCplus4(PCPlus4),
    .ImmExt(ImmExt),
    .Result(Result)
  );


endmodule
