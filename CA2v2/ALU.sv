module ALU (
    input [31:0] SrcA, SrcB,
    input [2:0] ALUControl,
    output reg [31:0] ALUResult,
    output zero
);
    always @(SrcA,SrcB,ALUControl) begin
        case (ALUControl)
            3'd0: ALUResult = SrcA + SrcB;      
            3'd1: ALUResult = SrcA - SrcB;      
            3'd2: ALUResult = SrcA & SrcB;      
            3'd3: ALUResult = SrcA | SrcB;      
            3'd4: ALUResult = SrcA ^ SrcB;     
            3'd5: ALUResult = (SrcA < SrcB) ? 32'd1 : 32'd0;  
            default: ALUResult = 32'd0;
        endcase
    end
    
    assign zero = (ALUResult == 32'd0);
endmodule