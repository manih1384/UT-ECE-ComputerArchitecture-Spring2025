module rat_tb;

    reg clk;
    reg rst;
    reg start;
    reg run;
    
    wire fail;
    wire done;
    wire [1:0] move;
    rat_top uut (
        .clk(clk),
        .rst(rst),
        .start(start),
        .run(run),
        .fail(fail),
        .done(done),
	.move(move)
    );
    
    always #5 clk = ~clk;
    
    initial begin
        clk = 0;
        rst = 1;
        start = 0;
        run = 0;        
        #20 rst = 0;       
        start = 1;
        #10 start = 0;        
        wait(done || fail);
        #100;        
        if (done) begin
		wait(uut.dp_inst.stack_empty);
		#100;
            run = 1;
            #10 run = 0;
            wait(uut.dp_inst.q_empty);
        end
        #50 $finish;
    end
    always @(posedge done) $display("Path found at time %t", $time);
    always @(posedge fail) $display("No path found at time %t", $time);
    
endmodule