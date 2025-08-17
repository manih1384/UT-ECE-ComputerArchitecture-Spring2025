module Mux2to1(a, b,sel, out);
    
    input sel;
    input [31:0] a, b;

    output [31:0] out;
    
    assign out = ~sel ? a : b;

endmodule