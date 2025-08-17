module control(
    input clk,
    input reset,
    input [2:0] opcode,          
    input [7:0]tos,
    output reg mem_write,
    output reg load_a,
    output reg load_b,
    output reg [1:0] alu_control,  // Changed to 2-bit for better ALU control
    output reg push,
    output reg pop,
    output reg pc_write,
    output reg jump,
    output reg ir_write,
    output reg addr_src,     // 0=PC, 1=IR address
    output reg stack_src,    // 0=ALU, 1=MDR
    output reg mdr_en        // Memory Data Register enable
);

    parameter FETCH   = 4'b0000,
              LOAD_A = 4'b0001,  // get first operand
              NOT = 4'b0010, // Not doesnt need the second operand
              LOAD_B  = 4'b0011,  // get second operand
              OP2  = 4'b0100, // perform two operand inst
              JUMP =   4'b0101 ,// Jay-Z or normal jump
              POP = 4'b0110,
              LOAD_MDR= 4'b0111,
              PUSH = 4'b1000,
              ID = 4'b1001;
    reg [3:0] state, next_state;

    // State register
    always @(posedge clk or posedge reset) begin
        if (reset) state <= FETCH;
        else state <= next_state;
    end

    // Next state logic,  if op[2]==0,else if op[1]==1 then it is jz and jump
    always @(*) begin
        case(state)
            FETCH : next_state=ID;
            ID: next_state = (opcode[2]) ? 
                               ((opcode[1]) ? JUMP : // jz or normal jump
                                (opcode[0]) ? POP : LOAD_MDR
                               ) : 
                               (LOAD_A);
                               
            LOAD_A: next_state = (opcode[1]==1 & opcode[0]==1) ? NOT: LOAD_B ;  // go nots or go for two operand instruction
            NOT: next_state = FETCH;
            LOAD_B:  next_state = OP2;
            OP2:  next_state = FETCH;
            JUMP: next_state = FETCH;
            POP : next_state = FETCH;
            LOAD_MDR: next_state = PUSH;
            PUSH: next_state = FETCH;
            default: next_state = FETCH;
        endcase
    end


    always @(*) begin
        {stack_src,mem_write, load_a, load_b, push, pop, pc_write, ir_write, addr_src,alu_control,jump,mdr_en} = 0;

        case(state)
            FETCH: begin
                addr_src = 0;// zero for instruction,one for mem access
                ir_write = 1;
                pc_write=1;
            end
            ID: begin
                // addr_src = 0;// zero for instruction,one for mem access
                // ir_write = 1;
                // pc_write=1;
            end
            
            LOAD_A: begin 
                pop = 1;
                load_a = 1;
            end
            
            NOT: begin 
                push = 1;
                stack_src = 1;
            end
            LOAD_B: begin 
                pop = 1;
                load_b = 1;
            end

            OP2: begin // two operand in                                                                                                        st
            push=1;
            alu_control={opcode[1],opcode[0]};
            end
            
            
            JUMP: begin
                jump = opcode[0] ?~(|tos) :1 ;
                pc_write = opcode[0] ? ~(|tos):1 ;
            end

            POP: begin
                mem_write=1;
                pop=1;
                addr_src=1;
            end

            LOAD_MDR: begin
                addr_src=1;
                mdr_en=1;

            end

            PUSH: begin
                stack_src=1;
                push=1;            
            end

        endcase
    end
endmodule