module stack #(
  parameter direction_length = 2,      
  parameter size = 256       
) (
  input wire clk,            
  input wire rst,          
  input wire push,           
  input wire pop,           
  input wire [direction_length-1:0] data_in, 
  output reg [direction_length-1:0] data_out, 
  output reg empty           
);

reg [direction_length-1:0] stk [size-1:0];
reg [$clog2(size):0] top_pointer;
always @(posedge clk or posedge rst) 
begin
    if (rst) 
    begin
        top_pointer <= 0;               
        empty <= 1;           
    end 
    else 
    begin
        if (top_pointer==0)
            empty<=1;
        if (push) begin
            stk[top_pointer] <= data_in;  
            top_pointer <= top_pointer + 1;             
    end

    if (pop && !empty) begin
        data_out <= stk[top_pointer-1]; 
        top_pointer <= top_pointer - 1;              
    end

    empty <= (top_pointer == 0);
    end
end

endmodule