module move_translator (
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
                new_y = (y == 0) ? y : y - 1;
            end
            2'b01: begin  
                new_x = (x == 15) ? x : x + 1;  
            end
            2'b10: begin 
                new_x = (x == 0) ? x : x - 1;  
            end
            2'b11: begin 
                new_y = (y == 15) ? y : y + 1;   
            end
        endcase
    end

endmodule