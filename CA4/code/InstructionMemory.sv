module InstructionMemory(pc, instruction);

    input [31:0] pc;
    output [31:0] instruction;
    reg [7:0] instructionMem [0:$pow(2, 16)-1]; 
    wire [31:0] adr;
    initial $readmemb("instructions.mem", instructionMem);
    assign adr = {pc[31:2], 2'b00}; 
    assign instruction = {instructionMem[adr], 
                          instructionMem[adr + 1], 
                            instructionMem[adr + 2],
                             instructionMem[adr + 3]};

endmodule
