module instruction_memory (pc, inst);
    input [31:0] pc;
    output [31:0] inst;
    

    reg [7:0] memory [0:$pow(2, 16)-1]; 

    wire [31:0] adr;
    assign adr = {pc[31:2], 2'b00}; 

    initial $readmemh("instruction_memory.mem", memory);

    assign inst = {memory[adr + 3], memory[adr + 2], memory[adr + 1], memory[adr]};
    
endmodule
