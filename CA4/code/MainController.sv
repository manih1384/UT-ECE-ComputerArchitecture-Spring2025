module MainController(op, func3, regWriteD, ALUOp,
                      resultSrcD, memWriteD, jumpD,
                      branchD, ALUSrcD, immSrcD, luiD);

    input [6:0] op;
    input [2:0] func3;
    output reg memWriteD, regWriteD, ALUSrcD, luiD;
    output reg [1:0] resultSrcD, jumpD, ALUOp;
    output reg [2:0] branchD, immSrcD;

    always @(op, func3) begin
        // Clear all outputs initially
        {ALUOp, regWriteD, immSrcD, ALUSrcD, memWriteD, 
             resultSrcD, jumpD, ALUOp, branchD, immSrcD, luiD} <= 16'b0;

        case (op)
            7'b0110011: begin // R-type (`R_T`)
                ALUOp      <= 2'b10;
                regWriteD  <= 1'b1;
            end
        
            7'b0010011: begin // I-type (`I_T`)
                ALUOp      <= 2'b11;
                regWriteD  <= 1'b1;
                immSrcD    <= 3'b000;
                ALUSrcD    <= 1'b1;
                resultSrcD <= 2'b00;
            end
        
            7'b0100011: begin // S-type (`S_T`)
                ALUOp      <= 2'b00;
                memWriteD  <= 1'b1;
                immSrcD    <= 3'b001;
                ALUSrcD    <= 1'b1;
            end
        
            7'b1100011: begin // B-type (`B_T`)
                ALUOp      <= 2'b01;
                immSrcD    <= 3'b010;
                case(func3)
                    3'b000   : branchD <= 3'b001; // BEQ
                    3'b001   : branchD <= 3'b010; // BNE
                    3'b010   : branchD <= 3'b011; // BLT
                    3'b011   : branchD <= 3'b100; // BGE
                    default  : branchD <= 3'b000;
                endcase
            end
        
            7'b0110111: begin // U-type (`U_T`)
                resultSrcD <= 2'b11;
                immSrcD    <= 3'b100;
                regWriteD  <= 1'b1;
                luiD       <= 1'b1;
            end
        
            7'b1101111: begin // J-type (`J_T`)
                resultSrcD <= 2'b10;
                immSrcD    <= 3'b011;
                jumpD      <= 2'b01;
                regWriteD  <= 1'b1;
            end
        
            7'b0000011: begin // LW (`LW_T`)
                ALUOp      <= 2'b00;
                regWriteD  <= 1'b1;
                immSrcD    <= 3'b000;
                ALUSrcD    <= 1'b1;
                resultSrcD <= 2'b01;
            end
        
            7'b1100111: begin // JALR (`JALR_T`)
                ALUOp      <= 2'b00;
                regWriteD  <= 1'b1;
                immSrcD    <= 3'b000;
                ALUSrcD    <= 1'b1;
                jumpD      <= 2'b10;
                resultSrcD <= 2'b10;
            end
        
            default: begin // Default (invalid opcode)
                regWriteD <= 1'b0;
                ALUSrcD   <= 2'b00;
                ALUOp     <= 3'b000;
            end

        endcase
    end

endmodule
