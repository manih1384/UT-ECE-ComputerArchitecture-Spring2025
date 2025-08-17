module RegisterFile(clk, regWrite,
                    readRegister1, readRegister2,
                    writeRegister, writeData,
                    readData1, readData2);

    input regWrite, clk;
    input [4:0] readRegister1, readRegister2, writeRegister;
    input [31:0] writeData;
    
    output reg [31:0] readData1, readData2;

    reg [31:0] registerFile [0:31];

    initial 
        registerFile[0] = 32'd0;

    always @(negedge clk) begin
        if (regWrite & (|writeRegister))
            registerFile[writeRegister] <= writeData;
    end

    always @(negedge clk) begin
        readData1 <= registerFile[readRegister1];
        readData2 <= registerFile[readRegister2];
    end

endmodule
