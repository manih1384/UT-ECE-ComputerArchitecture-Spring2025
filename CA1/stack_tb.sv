`timescale 1ns / 1ps

module tb_stack;



  reg clk;
  reg rst;
  reg push;
  reg pop;
  reg [1:0] data_in;
  wire [1:0] data_out;
  wire empty;

  stack uut (  
    .clk(clk),
    .rst(rst),
    .push(push),
    .pop(pop),
    .data_in(data_in),
    .data_out(data_out),
    .empty(empty)
  );

  initial begin
    clk = 0;
    forever #5 clk = ~clk;  
  end

  initial begin
    rst = 0;
    push = 0;
    pop = 0;
    data_in = 0;

    rst = 1;
    #10; 
    rst = 0;
    #10;  
    
    push = 1;
    data_in = 2'b01;
    #10; 
    
    data_in = 2'b10;
    #10;

    data_in = 2'b11;
    #10; 

    push = 0;
    #10;  

    pop = 1;
    #10;  
    $display("Popped value: %b", data_out);
    
    #10;
    $display("Popped value: %b", data_out);

    #10;
    $display("Popped value: %b", data_out);

    pop = 0;
    #10;

    if (empty) $display("Stack is empty.");

    $stop;
  end

endmodule
