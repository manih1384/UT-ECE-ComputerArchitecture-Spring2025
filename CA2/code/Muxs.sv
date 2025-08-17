module PC_mux(PCSrc, PCplus4, PCImm, ALUres, PCNext);
    input [1:0] PCSrc;
    input [31:0] PCplus4, PCImm, ALUres;
    output reg [31:0] PCNext;
    always @(PCSrc, PCplus4, PCImm, ALUres) begin
        case (PCSrc)
            2'b00: PCNext = PCplus4;
            2'b01: PCNext = PCImm;
            2'b10: PCNext = ALUres;
            default: PCNext = 32'd0;
        endcase
    end
endmodule

module Result_mux (ResultSrc, ALUres, ReadData, PCplus4, ImmExt, Result);
    input [1:0]ResultSrc;
    input [31:0] ALUres, ReadData, PCplus4, ImmExt;
    output reg [31:0] Result;
    always @(ResultSrc, ALUres, ReadData, PCplus4, ImmExt) begin
        case (ResultSrc)
            2'b00: Result= ALUres;
            2'b01: Result= ReadData;
            2'b10: Result= PCplus4;
            2'b11: Result= ImmExt;
        endcase
    end
endmodule

module SrcB_mux(ALUSrc, RD2, ImmExt, SrcB);
    input ALUSrc;
    input [31:0] RD2, ImmExt;
    output reg [31:0] SrcB;
    always @(ALUSrc, RD2, ImmExt) begin
        case (ALUSrc)
            1'b0: SrcB= RD2;
            1'b1: SrcB= ImmExt;
            default: SrcB=32'd0;
        endcase
    end
endmodule
