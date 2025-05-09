

module CU (
    input [6:0] opcode,
    input [2:0] func3,
    input [6:0] func7,
    input zero,
    output reg MemWrite, RegWrite, ALUSrc2,
    output reg [1:0] PCSrc, ResultSrc,
    output reg [2:0] ALUControl, ImmSrc
);

    wire [9:0] function_choose = {func7, func3};
    
    always @(*) begin
        {MemWrite,RegWrite,ALUSrc2,PCSrc,ResultSrc,ALUControl,ImmSrc}=0
        
        case (opcode)



            // R-Type instructions
            7'd51: begin
                RegWrite = 1'b1;
                ALUSrc2 = 1'b0;
                ResultSrc = 2'b00;
                
                case (function_choose)
                    10'b0000000000: ALUControl = 3'b000;  // add
                    10'b0100000000: ALUControl = 3'b001;  // sub
                    10'b0000000111: ALUControl = 3'b010;  // and
                    10'b0000000110: ALUControl = 3'b011;  // or
                    10'b0000000010: ALUControl = 3'b101;  // slt
                    default: ALUControl = 3'b000; 
                endcase
            end



            
            // I-Type instructions (only needed for lw)
            7'd3: begin  
                ImmSrc = 3'b000;
                ResultSrc = 2'b01;
                ALUSrc2 = 1'b1;
                RegWrite = 1'b1;
                ALUControl = 3'b000;  
            end



			
            // I-type arithmetic(for addi, ori, slti)
            7'd19: begin  
                ResultSrc = 2'b00;
                ImmSrc = 3'b000;
                RegWrite = 1'b1;
                ALUSrc2 = 1'b1;
                
                case (func3)
                    3'b000: ALUControl = 3'b000;  // addi
                    3'b110: ALUControl = 3'b011;  // ori
                    3'b010: ALUControl = 3'b101;  // slti
                    default: ALUControl = 3'b000;  
                endcase
            end



            // jalr
            7'd103: begin  
                ImmSrc = 3'b000;
                ALUControl = 3'b000;
                PCSrc = 2'b10;
                ResultSrc = 2'b10;
                RegWrite = 1'b1;
                ALUSrc2 = 1'b1;
            end
            



            // S-Type instruction(sw)
            7'd35: begin  
                MemWrite = 1'b1;
                ImmSrc = 3'b001;
                ALUSrc2 = 1'b1;
                ALUControl = 3'b000;
            end


            
            // B-Type instructions
            7'd99: begin  
                ALUSrc2 = 1'b0;
                ImmSrc = 3'b010;
                
                case (func3)
                    3'b000: begin  // beq
                        ALUControl = 3'b001;  
                        PCSrc = (zero == 1'b1) ? 2'b01 : 2'b00;
                    end
                    3'b001: begin  // bne
                        ALUControl = 3'b001;  
                        PCSrc = (zero == 1'b0) ? 2'b01 : 2'b00;
                    end
                    default: PCSrc = 2'b00;
                endcase
            end
            
            // J-Type instruction(jal)
            7'd111: begin  
                PCSrc = 2'b01;
                ResultSrc = 2'b10;
                ImmSrc = 3'b011;
                RegWrite = 1'b1;
            end
            
            // U-Type instruction(lui)
            7'd55: begin  
                ResultSrc = 2'b11;
                ImmSrc = 3'b100;
                RegWrite = 1'b1;
            end
            
            default: begin
            end
        endcase
    end
endmodule