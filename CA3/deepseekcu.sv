module control(
    input clk,
    input reset,
    input [2:0] opcode,
    input zero,              // From ALU (zero flag)
    input tos_zero,          // From stack (top-of-stack == 0)
    output reg mem_read,
    output reg mem_write,
    output reg load_a,
    output reg load_b,
    output reg [1:0] alu_control,  // Changed to 2-bit for better ALU control
    output reg push,
    output reg pop,
    output reg pc_write,
    output reg ir_write,
    output reg addr_src,     // 0=PC, 1=IR address
    output reg stack_src,    // 0=ALU, 1=MDR
    output reg mdr_en        // Memory Data Register enable
);

    // State definitions - expanded to 4 bits as per your design
    parameter FETCH    = 4'b0000,
              LOAD_A   = 4'b0001,  // Get first operand
              NOT      = 4'b0010,  // NOT operation
              LOAD_B   = 4'b0011,  // Get second operand
              OP2      = 4'b0100,  // Perform two-operand instruction
              JUMP     = 4'b0101,  // JZ or normal jump
              POP      = 4'b0110,
              LOAD_MDR = 4'b0111,
              PUSH     = 4'b1000;

    reg [3:0] state, next_state;  // Changed to 4-bit to match parameters

    // State register
    always @(posedge clk or posedge reset) begin
        if (reset) state <= FETCH;
        else state <= next_state;
    end

    // Next state logic - fixed syntax and completeness
    always @(*) begin
        case(state)
            FETCH: begin
                next_state = (opcode[2]) ? 
                            ((opcode[1]) ? JUMP :       // 110 or 111 (JMP/JZ)
                             (opcode[0]) ? POP : LOAD_MDR  // 101 or 100 (POP/PUSH)
                            ) : 
                            LOAD_A;  // All ALU ops start with LOAD_A
            end
                               
            LOAD_A: begin
                next_state = (opcode == 3'b011) ? NOT :  // NOT operation
                             (opcode[1:0] != 2'b00) ? LOAD_B : OP2;  // Others go to LOAD_B or OP2
            end
            
            NOT:     next_state = FETCH;
            LOAD_B:  next_state = OP2;
            OP2:     next_state = FETCH;
            JUMP:    next_state = FETCH;
            POP:     next_state = FETCH;
            LOAD_MDR: next_state = PUSH;
            PUSH:    next_state = FETCH;
            default: next_state = FETCH;
        endcase
    end

    // Output logic - fixed syntax and completeness
    always @(*) begin
        // Default all outputs to 0
        {mem_read, mem_write, load_a, load_b, push, pop, pc_write, 
         ir_write, addr_src, stack_src, mdr_en} = 0;
        alu_control = opcode[1:0];  // Using only 2 bits for ALU control

        case(state)
            FETCH: begin
                addr_src = 0;  // 0 for instruction fetch
                ir_write = 1;
                mem_read = 1;  // Need to read instruction
            end
            
            LOAD_A: begin 
                pop = 1;
                load_a = 1;
            end
            
            NOT: begin 
                push = 1;
                stack_src = 1;  // Assuming 1 means ALU result
            end
            
            LOAD_B: begin 
                pop = 1;
                load_b = 1;
            end

            OP2: begin // Two-operand instruction
                push = 1;
                stack_src = 1;  // Push ALU result
            end
            
            JUMP: begin
                // JMP (110) or JZ (111)
                pc_write = (opcode[0]) ? tos_zero : 1'b1;  // JZ checks tos_zero, JMP always jumps
                addr_src = 1;  // Use address from instruction
            end

            POP: begin
                mem_write = 1;
                pop = 1;
                addr_src = 1;  // Use address from instruction
            end

            LOAD_MDR: begin
                addr_src = 1;   // Use address from instruction
                mdr_en = 1;    // Enable MDR
                mem_read = 1;   // Read memory
            end

            PUSH: begin
                stack_src = 0;  // Assuming 0 means push from MDR
                push = 1;            
            end

            default: begin
                // All outputs already 0
            end
        endcase
    end
endmodule