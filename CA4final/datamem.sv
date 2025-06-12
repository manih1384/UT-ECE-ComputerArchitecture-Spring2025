module DataMemory(address, Data, memWrite, clk, readData);
    input [31:0] address, Data;
    input memWrite, clk;

    output [31:0] readData;

    reg [7:0] dataMemory [0:$pow(2, 16)-1]; // 64KB

    wire [31:0] adr;
    assign adr = {address[31:2], 2'b00};

    initial $readmemb("data.mem", dataMemory,1000); 

    always @(posedge clk) begin
        if(memWrite)
            {dataMemory[adr + 3], dataMemory[adr + 2], 
                dataMemory[adr + 1], dataMemory[adr]} <= Data;
    end

    assign readData = {dataMemory[adr + 3], dataMemory[adr + 2], 
                        dataMemory[adr + 1], dataMemory[adr]};

endmodule
