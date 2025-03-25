module move_translator #(
\) (
    input [3:0] x, y,           
    input [1:0] opcode,         
    output reg [3:0] new_x,    
    output reg [3:0] new_y
);

    always @(*) begin
        new_x = x;
        new_y = y;

        case (opcode)
            2'b00: begin
                // Move up (decrease y)
                new_x = x;
                new_y = y - 1;
            end
            2'b11: begin
                // Move down (increase y)
                new_x = x;
                new_y = y + 1;
            end
            2'b10: begin
                // Move left (decrease x)
                new_x = x - 1;
                new_y = y;
            end
            2'b01: begin
                // Move right (increase x)
                new_x = x + 1;
                new_y = y;
            end
            default: begin
                new_x = x;
                new_y = y;
            end
        endcase
    end

endmodule
