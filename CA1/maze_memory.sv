module maze_memory (
    input wire [3:0] X,      
    input wire [3:0] Y,       
    input wire D_in,          
    input wire RD,            
    input wire WR,            
    input wire clk,           
    output reg D_out         
);

    reg memory [0:15][0:15]; 

    initial begin
        $readmemb("maze_map.txt", memory); 
    end

    always @(*) begin
        if (RD) begin
            D_out <= memory[Y][X]; 
        end
    end

    always @(posedge clk) begin
        if (WR) begin
            memory[Y][X] = D_in;
        end
    end

endmodule
