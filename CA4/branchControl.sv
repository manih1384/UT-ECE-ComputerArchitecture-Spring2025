module BranchController(branchE, jumpE, zero, PCSrcE);

    input zero;
    inout [2:0] branchE;
    input [1:0] jumpE;

    output reg [1:0] PCSrcE;
    
    always @(jumpE, zero, branchE) begin
        case(branchE)
            3'b000 : begin // generalJump
                if (jumpE == 2'b01) // JAL
                    PCSrcE <= 2'b01;
                else if (jumpE == 2'b10) // JALR
                    PCSrcE <= 2'b10;
                else
                    PCSrcE <= 2'b00;
            end
            3'b001 : // BEQ
                PCSrcE <= (zero)  ? 2'b01 : 2'b00;
            3'b010 : // BNE
                PCSrcE <= (~zero) ? 2'b01 : 2'b00;
        endcase
    end

endmodule
