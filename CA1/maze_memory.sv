module maze_memory (
    input wire [3:0] X,     // Column index (0-15)
    input wire [3:0] Y,     // Row index (0-15)
    input wire D_in,        // Data input for writes
    input wire RD, WR, clk, // Read/Write and clock controls
    output reg D_out        // Data output
);

    // Define a 16x16 memory array
    reg [15:0] memory [0:15]; // 16 rows, each with 16 bits

    // Initialize the memory from a file
    initial begin
        $readmemb("maze_map.txt", memory); // Load the maze map
    end

    // Combinational read logic
    always @(*) begin
        if (RD) begin
            // Reverse column indexing for top-left to bottom-right corner mapping
            D_out = memory[Y][15 - X]; // Flip column for correct coordinate access
        end else begin
            D_out = 1'b0; // Default output if RD is not set
        end
    end

    // Synchronous write logic
    always @(posedge clk) begin
        if (WR) begin
            // Write data to the correct column index using reversed logic
            memory[Y][15 - X] <= D_in;
        end
    end

endmodule
