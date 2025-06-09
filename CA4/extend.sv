module Extend(immSrc, data, w);

    input [2:0] immSrc;
    input [24:0] data;

    output reg [31:0] w;

    always @(immSrc, data) begin
        case(immSrc)
            3'b000 : w <= {{20{data[24]}}, data[24:13]};
            3'b001 : w <= {{20{data[24]}}, data[24:18], data[4:0]};
            3'b011 : w <= {{12{data[24]}}, data[12:5], data[13], data[23:14], 1'b0};
            3'b010 : w <= {{20{data[24]}}, data[0], data[23:18], data[4:1], 1'b0};
            3'b100 : w <= {data[31:12], {12{1'b0}}};
            default: w <= 32'b0;
        endcase
    end

endmodule
