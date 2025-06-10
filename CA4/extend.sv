module Extend(immSrc, data, out);

    input [2:0] immSrc;
    input [24:0] data;

    output reg [31:0] out;

    always @(immSrc, data) begin
        case(immSrc)
            3'b000 : out <= {{20{data[24]}}, data[24:13]};
            3'b001 : out <= {{20{data[24]}}, data[24:18], data[4:0]};
            3'b011 : out <= {{12{data[24]}}, data[12:5], data[13], data[23:14], 1'b0};
            3'b010 : out <= {{20{data[24]}}, data[0], data[23:18], data[4:1], 1'b0};
            3'b100 : out <= {data[31:12], {12{1'b0}}};
            default: out <= 32'b0;
        endcase
    end

endmodule
