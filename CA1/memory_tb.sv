`timescale 1ns / 1ps

module tb_maze_memory;

    // Signals for the testbench
    reg [3:0] X, Y;       // 4-bit input coordinates
    reg RD, WR, clk;      // Read, Write, and Clock signals
    reg D_in;             // Data input for write
    wire D_out;           // Data output for reading

    // Instantiate the Device Under Test (DUT)
    maze_memory dut (
        .X(X),
        .Y(Y),
        .D_in(D_in),
        .RD(RD),
        .WR(WR),
        .clk(clk),
        .D_out(D_out)
    );

    // Generate clock signal (10 ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;  // Toggle clock every 5 ns
    end

    // Test procedure
    initial begin

        // Initialize signals
        $display("Starting Test: Display Row 0 of Memory.");
        RD = 1;  // Only enabling read operations
        WR = 0;  // Disabling write operations
        X = 4'b0000;
        Y = 4'b0000;  // Reading from row 0

        // Wait for DUT to initialize
        #10;

        $display("\nDisplaying the bits of memory[0]:");

        // Iterate through each bit of row 0 and display them
        for (X = 0; X < 16; X = X + 1) begin
            #10;  // Wait for read operation
            $display("memory[0][%0d] = %b", X, D_out);
        end

        // End simulation
        $display("\nTest complete: Row 0 displayed.");
        $finish;
    end

endmodule
