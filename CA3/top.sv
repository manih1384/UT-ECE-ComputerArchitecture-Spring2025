module top(
    input clk,
    input rst
);
    wire [2:0] opcode;
    wire [7:0] tos;

    wire mem_read, mem_write, load_a, load_b, push, pop;
    wire pc_write, ir_write, addr_src, stack_src, mdr_en, jump;
    wire [1:0] alu_control;



    Datapath datapath_inst(
        .clk(clk),
        .rst(rst),
        .addrSrc(addr_src),
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
        .opcode(opcode),
        .tos(tos)
    );

    control control_inst(
        .clk(clk),
        .reset(rst),
        .opcode(opcode),      
        .tos(tos),
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
