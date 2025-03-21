`timescale 1ns / 1ps

module tb_stack;  // Testbench module

  // Parameters of the stack that should match the module instantiation
  parameter direction_length = 2;
  parameter size = 256;

  // Testbench signals
  reg clk;
  reg rst;
  reg push;
  reg pop;
  reg [direction_length-1:0] data_in;
  wire [direction_length-1:0] data_out;
  wire empty;

  // Instantiate the stack module
  stack #(
    .direction_length(direction_length),
    .size(size)
  ) uut (  // unit under test
    .clk(clk),
    .rst(rst),
    .push(push),
    .pop(pop),
    .data_in(data_in),
    .data_out(data_out),
    .empty(empty)
  );

  // Clock generation
  initial begin
    clk = 0;
    forever #5 clk = ~clk;  // Toggle clock every 5 time units
  end

  // Test sequence
  initial begin
    // Initialize inputs
    rst = 0;
    push = 0;
    pop = 0;
    data_in = 0;

    // Apply reset
    rst = 1;
    #10;  // Wait for 10 time units
    rst = 0;
    #10;  // Wait for 10 time units
    
    // Test: Stack push operations
    push = 1;
    data_in = 2'b01;
    #10; // Push value "01"
    
    data_in = 2'b10;
    #10; // Push value "10"

    data_in = 2'b11;
    #10; // Push value "11"

    push = 0;
    #10;  // Stop pushing values

    // Test: Pop operations
    pop = 1;
    #10;  // Pop the top value (should get "11")
    $display("Popped value: %b", data_out);
    
    #10;  // Pop the next value (should get "10")
    $display("Popped value: %b", data_out);

    #10;  // Pop the next value (should get "01")
    $display("Popped value: %b", data_out);

    pop = 0;
    #10;

    // Final conditions check
    if (empty) $display("Stack is empty.");

    $stop; // End simulation
  end

endmodule
