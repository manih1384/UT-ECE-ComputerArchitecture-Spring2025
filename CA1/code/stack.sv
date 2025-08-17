module stack (
  input wire clk,            
  input wire rst,          
  input wire push,           
  input wire pop,           
  input wire [1:0] data_in, 
  output reg [1:0] data_out, 
  output reg empty           
);

reg [1:0] stk [255:0];
reg [$clog2(256):0] top_pointer;
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
        top_pointer <= top_pointer - 1;              
    end
    if (!empty)begin
        data_out <= stk[top_pointer-1];
    end

    empty <= (top_pointer == 0);
    end
end

endmodule