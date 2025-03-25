module maze_memory (
    input wire [3:0] X, Y,       // 4-bit coordinates (0-15)
    input wire D_in,             // Data to write (1 bit)
    input wire RD, WR, clk,      // Control signals
    output reg D_out             // Data read output
);

    // 16x16 memory (each line stores 16 bits)
    reg [15:0] memory [0:15];    // 16 rows, 16 bits each

    // Initialize memory from file
    initial begin
        $readmemb("maze_map.txt", memory);
    end

    // Read operation with boundary checking
    always @(*) begin
        if (RD) begin
            // Check if coordinates are within bounds
            if (X > 15 || Y > 15)
                D_out = 1'b1;    // Outside map = wall
            else
                D_out = memory[Y][X];
        end
        else begin
            D_out = 1'b0;        // Default when not reading
        end
    end

    // Write operation (only allowed within bounds)
    always @(posedge clk) begin
        if (WR && X <= 15 && Y <= 15) begin
            memory[Y][X] <= D_in;
        end
    end

endmodule