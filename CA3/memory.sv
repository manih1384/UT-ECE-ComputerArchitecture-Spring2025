module Mem (
    input wire clk,               // Clock for writing
    input wire write_enable,                // Write enable (active high)
    input wire [4:0] addr,        // 5-bit address (0-31)
    input wire [7:0] din,         // 8-bit data input for writing
    output reg [7:0] data         // 8-bit data output
);

reg [7:0] rom_array [0:31];

initial begin
    $readmemh("rom_data.mem", rom_array);
end

always @(posedge clk) begin
    if (write_enable)
        rom_array[addr] <= din;
end

always @(*) begin
    data = rom_array[addr];
end

endmodule
