module Mux4to1(a, b, c, d,sel, out);

    input [1:0] sel;
    input [31:0] a, b, c, d;
    
    output reg [31:0] out;

    always @(*) begin
        case (sel)
            2'b00  : out <= a;
            2'b01  : out <= b;
            2'b10  : out <= c;
            2'b11  : out <= d;
            default: out <= {32{1'bz}};
        endcase
    end

endmodule