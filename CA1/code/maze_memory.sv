module maze_memory (
    input wire [3:0] X,    
    input wire [3:0] Y,    
    input wire D_in,       
    input wire RD, WR, clk, 
    output reg D_out        
);

    
    reg [15:0] memory [0:15]; 

    initial begin
        $readmemb("maze_map.txt", memory); 
    end


    always @(*) begin
        if (RD) begin
           
            D_out = memory[Y][15 - X]; 
        end else begin
            D_out = 1'b0; 
        end
        memory[0][15]<=1;
    end

    always @(posedge clk) begin
        if (WR) begin
            memory[Y][15 - X] <= D_in;
        end
    end

endmodule
