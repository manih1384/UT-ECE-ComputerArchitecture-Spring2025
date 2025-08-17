module ALU (
    input  [7:0] A,
    input  [7:0] B,
    input  [1:0] opcode,
    output reg [7:0] Y
);

    always @(*) begin
        case (opcode)
            2'b00: Y = A + B;
            2'b01: Y = A - B;
            2'b10: Y = A & B;
            2'b11: Y = ~A;
            default: Y = 8'h00;
        endcase
    end

endmodule
