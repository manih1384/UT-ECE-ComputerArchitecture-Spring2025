module queue(
  input wire clk,             
  input wire rst,            
  input wire enqueue,             
  input wire dequeue,             
  input wire [1:0] data_in,   
  output reg [1:0] data_out,  
  output reg empty                  
);
  reg [1:0] queue [255:0]; 
  reg [$clog2(256):0] head;             
  reg [$clog2(256):0] tail;           

  always @(posedge clk or posedge rst) begin
    if (rst) begin
      head <= 0;
      tail <= 0;
      data_out <= 0;
    end else begin
      if (enqueue) begin
        queue[tail] <= data_in;          
        tail <= tail + 1;                
      end

      if (dequeue && !empty) begin
        data_out <= queue[tail];          
        tail <= tail - 1;                 
      end
    end
  end

  always @(*) begin
    empty = (head == tail);              
  end
endmodule
