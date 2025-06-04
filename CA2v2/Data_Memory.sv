module Data_memory (clk, A, WD, WE ,read_data);
    input WE , clk;
    input  [31:0] A, WD;
    output reg [31:0] read_data;
    reg [7:0] data_memory [0:$pow(2, 16)-1];

    reg [31:0] adr;
    assign adr = {A[31:2], 2'b00}; 

    initial $readmemb("DataMemory.mem", data_memory);

    always @(posedge clk) begin
        if (WE)
            {data_memory[adr + 3], data_memory[adr + 2], data_memory[adr + 1], data_memory[adr]} = WD;
    end

    always @( clk, A, WD, WE) begin
           read_data = {data_memory[adr + 3], data_memory[adr + 2], data_memory[adr + 1], data_memory[adr]};
    end



endmodule

