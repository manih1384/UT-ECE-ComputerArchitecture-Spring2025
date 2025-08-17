module ALU_Controller(func3, func7, ALUOp, ALUControl);

    input [2:0] func3;
    input [1:0] ALUOp;
    input func7; // bit 30 instr

    output reg [2:0] ALUControl;
    
    always @(ALUOp or func3 or func7) begin
        case (ALUOp)
            2'b00: // S_T
                ALUControl <= 3'b000; // ADD

            2'b01: // B_T
                ALUControl <= 3'b001; // SUB

            2'b10: begin // R_T
                if (func3 == 3'b000 && ~func7)
                    ALUControl <= 3'b000; // ADD
                else if (func3 == 3'b000 && func7)
                    ALUControl <= 3'b001; // SUB
                else if (func3 == 3'b111)
                    ALUControl <= 3'b010; // AND
                else if (func3 == 3'b110)
                    ALUControl <= 3'b011; // OR
                else if (func3 == 3'b010)
                    ALUControl <= 3'b101; // SLT
                else
                    ALUControl <= 3'bzzz; // Undefined
            end
            
            2'b11: begin // I_T
                if (func3 == 3'b000)
                    ALUControl <= 3'b000; // ADD
                else if (func3 == 3'b100)
                    ALUControl <= 3'b100; // XOR
                else if (func3 == 3'b110)
                    ALUControl <= 3'b011; // OR
                else if (func3 == 3'b010)
                    ALUControl <= 3'b101; // SLT
                else
                    ALUControl <= 3'bzzz; // Undefined
            end

            default:
                ALUControl <= 3'b000; // Default to ADD
        endcase
    end
endmodule
