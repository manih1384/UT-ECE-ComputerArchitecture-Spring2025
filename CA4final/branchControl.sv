`define generalJump 3'b000
`define BEQ 3'b001
`define BNE 3'b010
`define JAL  2'b01
`define JALR 2'b10

module BranchController(branchE, jumpE, zero, PCSrcE);

    input zero;
    inout [2:0] branchE;
    input [1:0] jumpE;

    output reg [1:0] PCSrcE;
    
    always @(jumpE, zero, branchE) begin
        case(branchE)
            `generalJump : PCSrcE <= (jumpE == `JAL)  ? 2'b01 :
                             (jumpE == `JALR) ? 2'b10 : 2'b00;

            `BEQ : PCSrcE <= (zero)           ? 2'b01 : 2'b00;
            `BNE : PCSrcE <= (~zero)          ? 2'b01 : 2'b00;
        endcase
    end

endmodule