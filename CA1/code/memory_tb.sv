`timescale 1ns / 1ps

module tb_maze_memory;

    reg [3:0] X, Y;      
    reg RD, WR, clk;      
    reg D_in;             
    wire D_out;           

    maze_memory dut (
        .X(X),
        .Y(Y),
        .D_in(D_in),
        .RD(RD),
        .WR(WR),
        .clk(clk),
        .D_out(D_out)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk; 
    end

    initial begin

        RD = 1;  
        WR = 0; 
        X = 4'b0000;
        Y = 4'b0000; 

        #10;
        $finish;
    end

endmodule
