`timescale 1ns/1ns

module tb_top;

    reg clk;
    reg rst;

    top dut (
        .clk(clk),
        .rst(rst)
    );

    initial clk = 0;
    always #5 clk = ~clk;

    initial begin
        rst = 1;
        #20;
        rst = 0;
        #500;
        $stop;
    end

endmodule
