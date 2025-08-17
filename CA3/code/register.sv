module Register #(
    parameter WIDTH = 8  
)(
    input wire clk,
    input wire rst,            
    input wire wr,             
    input wire [WIDTH-1:0] din,
    output reg [WIDTH-1:0] dout
);

always @(posedge clk) begin
    if (rst)
        dout <= {WIDTH{1'b0}};  
    else if (wr)
        dout <= din;            
    
end

endmodule
