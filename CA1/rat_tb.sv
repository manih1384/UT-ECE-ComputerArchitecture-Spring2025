module rat_tb;

    // Inputs
    reg clk;
    reg rst;
    reg start;
    reg run;
    
    // Outputs
    wire fail;
    wire done;
    wire [1:0] move;
    // Instantiate the design
    rat_top uut (
        .clk(clk),
        .rst(rst),
        .start(start),
        .run(run),
        .fail(fail),
        .done(done),
	.move(move)
    );
    
    // Clock generation (100MHz)
    always #5 clk = ~clk;
    
    // Main test sequence
    initial begin
        // Initialize
        clk = 0;
        rst = 1;
        start = 0;
        run = 0;
        
        // Reset
        #20 rst = 0;
        
        // Test 1: Find path
        start = 1;
        #10 start = 0;
        
        // Wait for completion
        wait(done || fail);
        #100;
        
        // Test 2: Run found path
        if (done) begin
            run = 1;
            #10 run = 0;
            wait(uut.dp_inst.q_empty);
        end
        
        // End simulation
        #50 $finish;
    end
    
    // Simple monitoring
    always @(posedge done) $display("Path found at time %t", $time);
    always @(posedge fail) $display("No path found at time %t", $time);
    
endmodule