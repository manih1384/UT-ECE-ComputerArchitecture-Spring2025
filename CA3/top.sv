module top(
    input clk,
    input rst
);
    // Intermediate signals
    wire [2:0] opcode;
    wire [7:0] tos;

    // Control to Datapath signals
    wire mem_read, mem_write, load_a, load_b, push, pop;
    wire pc_write, ir_write, addr_src, stack_src, mdr_en, jump;
    wire [1:0] alu_control;

    // Additional flags
    wire zero = (aluOut == 8'b0);          // Assuming ALU sets aluOut
    wire tos_zero = (tos == 8'b0);         // Top-of-Stack zero flag

    // ALU output, for zero flag
    wire [7:0] aluOut;
    // Aout, Bout (unused here, but for completeness)
    wire [7:0] Aout, Bout;

    // Datapath instantiation
    Datapath datapath_inst(
        .clk(clk),
        .rst(rst),
        .addrSrc(addr_src),
        .mem_read(mem_read),
        .mem_write(mem_write),
        .load_a(load_a),
        .load_b(load_b),
        .alu_control(alu_control),
        .push(push),
        .pop(pop),
        .pc_write(pc_write),
        .ir_write(ir_write),
        .stack_src(stack_src),
        .mdr_en(mdr_en),
        .jump(jump),
        .opcode(opcode),   // OUTPUT [2:0]
        .tos(tos)
        // Internally you may expose aluOut if you want the zero flag.
        // If you make aluOut available at top level, connect .aluOut(aluOut)
    );

    // Control unit instantiation
    control control_inst(
        .clk(clk),
        .reset(rst),
        .opcode(opcode),      // [2:0] from datapath IR
        .zero(zero),
        .tos_zero(tos_zero),
        .mem_read(mem_read),
        .mem_write(mem_write),
        .load_a(load_a),
        .load_b(load_b),
        .alu_control(alu_control),
        .push(push),
        .pop(pop),
        .pc_write(pc_write),
        .ir_write(ir_write),
        .addr_src(addr_src),
        .stack_src(stack_src),
        .mdr_en(mdr_en),
        .jump(jump)
    );

endmodule
