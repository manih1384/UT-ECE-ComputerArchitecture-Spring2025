module Adder(a, b, out);
    parameter N = 32;

    input [N-1:0] a;
    input [N-1:0] b;
    
    output [N-1:0] out;
    
    assign out = a + b;
    
endmodule