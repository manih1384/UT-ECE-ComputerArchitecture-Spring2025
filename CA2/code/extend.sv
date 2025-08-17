module Extend (inst, ImmSrc, ImmExt);
    input [31:0] inst;
    input [2:0] ImmSrc;
    output reg [31:0] ImmExt;
    always @(instruction, ImmSrc) begin
        case (ImmSrc)
            3'd000: ImmExt={{20{inst[31]}},inst[31:20]}; //I type
            3'd001: ImmExt={{20{inst[31]}},inst[31:25],inst[11:7]}; //S type
            3'd010: ImmExt={{19{inst[31]}},inst[31],inst[7],inst[30:25],inst[11:8],1'b0}; //B type
       	    3'd011: ImmExt={{11{inst[31]}},inst[31],inst[19:12],inst[20],inst[30:21],1'b0}; //J type
	        3'd100: ImmExt={inst[31:12],12'd0}; //U type
        endcase
    end
    
endmodule
