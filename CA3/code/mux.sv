module mux2to1 #(
    parameter WIDTH = 8   
)(
    input  wire [WIDTH-1:0] a, 
    input  wire [WIDTH-1:0] b, 
    input  wire sel,
    output wire [WIDTH-1:0] out  
);

assign out = sel ? b : a;

endmodule
