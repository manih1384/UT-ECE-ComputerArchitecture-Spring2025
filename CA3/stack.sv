module Stack(
    input        clk,
    input        rst,
    input  [7:0] d_in,
    input        push,
    input        pop,
    output [7:0] d_out,
    output [7:0] tos
);

    reg [7:0] stack [0:15];
    reg [3:0] sp;

    always @(posedge clk or posedge rst) begin
        if (rst)
            sp <= 0;
        else begin
            if (push) begin
                stack[sp] <= d_in;
                sp <= sp + 1;
            end 
            else if (pop) begin
                sp <= sp - 1;
            end
        end
    end

    assign tos   = (sp == 0) ? 8'bz : stack[sp-1];
    assign d_out = tos;

endmodule
