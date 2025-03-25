


module rat_fsm(
  input clk, rst, start, D_out, stack_empty, q_empty, run, done,
  output reg RD, load_y, load_x, push, WR, pop, enqueue, dequeue, fail, back_track,reg [1:0] count
);

   
  reg [3:0] pstate, nstate;  
  reg counter_rst, counter_en, co;  

  
  parameter [3:0] 
    INIT = 4'b0000, 
    NEW_MOVE = 4'b0001, 
    MOVE = 4'b0010, 
    FIFO_MAKER = 4'b0011,
    WAIT = 4'b0100, 
    SHOW_TIME = 4'b0101,
    CHECK_BACK = 4'b0111,
    BACK_TRACK_STATE = 4'b1000,
    FAIL_STATE = 4'b1001;


  always @(posedge clk or posedge rst) begin
    if (rst) pstate <= INIT;
    else pstate <= nstate;
  end


  always @(posedge clk or posedge rst) begin
    if (rst)
      count <= 2'b00;  
    else begin
      if (counter_rst)
        count <= 2'b00;  
      else if (counter_en)
        count <= count + 1;  
    end
    co = count[1] & count[0];  
  end


  always @(pstate or start  or co or stack_empty or D_out or q_empty or run or done) begin
    nstate = INIT;
    {RD, load_y, load_x, push, WR, pop, enqueue, dequeue, fail, back_track} = 0;
    counter_rst = 0;
    counter_en = 0;

    case (pstate)
      INIT: begin
        nstate = start ? NEW_MOVE : INIT;
      end

      NEW_MOVE: begin
        nstate = D_out ? (co ? CHECK_BACK : NEW_MOVE) : MOVE;
        counter_en = 1;  
        RD = 1;  
      end

      MOVE: begin
        nstate = done ? FIFO_MAKER : NEW_MOVE;
        load_x = 1;  
        load_y = 1; 
        counter_rst = 1; 
        push = 1;
        WR = 1;  
      end

      FIFO_MAKER: begin
        nstate = stack_empty ? WAIT : FIFO_MAKER;
        pop = 1; 
        enqueue = 1;  
      end

      WAIT: begin
        nstate = run ? SHOW_TIME : WAIT;
      end

      SHOW_TIME: begin
        nstate = q_empty ? INIT : SHOW_TIME;
        dequeue = 1; 
      end

      CHECK_BACK: begin
        nstate = stack_empty ? FAIL_STATE : BACK_TRACK_STATE;
      end

      BACK_TRACK_STATE: begin
        nstate = NEW_MOVE;
        back_track = 1; 
        pop = 1; 
        counter_rst = 1; 
      end

      FAIL_STATE: begin
        nstate = INIT;
        fail = 1;
      end

      default: nstate = INIT;
    endcase
  end

endmodule



module rat_dp (
    input wire clk, rst,
    input wire RD, load_y, load_x, push, WR, pop, enqueue, dequeue, fail, back_track,D_out
    input wire [1:0] count,
    output [1:0]q_out,
    output wire done, stack_empty, q_empty, run
);

    wire [1:0] stack_out;

    stack stack_inst (
        .clk(clk),
        .rst(rst),
        .push(push),
        .pop(pop),
        .data_in(opcode),
        .data_out(stack_out),
        .empty(stack_empty)
    );

    queue q_inst (
        .clk(clk),
        .enqueue(enqueue),
        .dequeue(dequeue),
        .data_in(stack_out),
        .data_out(q_out),
        .empty(q_empty)
    );






    reg [3:0] x_position;
    reg [3:0] y_position;

    wire [3:0] new_x;
    wire [3:0] new_y;

    wire [1:0] opcode = back_track ? ~stack_out : count;/*inja*/

    move_translator mv (
        .x(x_position),
        .y(y_position),
        .opcode(opcode),
        .new_x(new_x),
        .new_y(new_y)
    );

    wire reg_mux = (~back_track) & D_out;
    wire [3:0] x_mux_out = reg_mux ? x_position : new_x;
    wire [3:0] y_mux_out = reg_mux ? y_position : new_y;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            x_position <= 0;
            y_position <= 0;
        end else begin
            if (load_x) x_position <= x_mux_out;
            if (load_y) y_position <= y_mux_out;
        end
    end

    assign done = (x_position == 15) & (y_position == 15);

endmodule












module rat_top (
    input wire clk, rst, start, run,
    output wire fail, done,
    output [1:0] move
);

    // Internal signals
    wire RD, load_y, load_x, push, WR, pop, enqueue, dequeue, back_track;
    wire [1:0] count, q_out;
    wire D_out, stack_empty, q_empty;
    wire [3:0] X, Y;  // Coordinates for memory access

    // FSM instantiation
    rat_fsm fsm_inst (
        .clk(clk),
        .rst(rst),
        .start(start),
        .D_out(D_out),
        .stack_empty(stack_empty),
        .q_empty(q_empty),
        .run(run),
        .done(done),
        .RD(RD),
        .load_y(load_y),
        .load_x(load_x),
        .push(push),
        .WR(WR),
        .pop(pop),
        .enqueue(enqueue),
        .dequeue(dequeue),
        .fail(fail),
        .back_track(back_track),
        .count(count)
    );

    // Datapath instantiation
    rat_dp dp_inst (
        .clk(clk),
        .rst(rst),
        .RD(RD),
        .load_y(load_y),
        .load_x(load_x),
        .push(push),
        .WR(WR),
        .pop(pop),
        .enqueue(enqueue),
        .dequeue(dequeue),
        .fail(fail),
        .back_track(back_track),
        .count(count),
        .q_out(q_out),
        .done(done),
        .D_out(D_out),
        .stack_empty(stack_empty),
        .q_empty(q_empty),
        .run(run)
    );

    maze_memory memory_inst (
        .clk(clk),
        .X(X),
        .Y(Y),
        .D_out(D_out), 
        .WR(WR),    
        .RD(RD),    
        .D_in(1'b1) 
    );
    assign move = q_out;
    // Coordinate assignment (from datapath to memory)
    assign X = dp_inst.x_position;
    assign Y = dp_inst.y_position;

endmodule