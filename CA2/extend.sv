module Extend (instruction, ImmSrc, ImmExt);
    input [31:0] instruction;
    input [2:0] ImmSrc;
    output reg [31:0] ImmExt;
    always @(instruction, ImmSrc) begin
        case (ImmSrc)
            3'd000: ImmExt={{20{instruction[31]}},instruction[31:20]}; //I type
            3'd001: ImmExt={{20{instruction[31]}},instruction[31:25],instruction[11:7]}; //S type
            3'd010: ImmExt={{19{instruction[31]}},instruction[31],instruction[7],instruction[30:25],instruction[11:8],1'b0}; //B type
       	    3'd011: ImmExt={{11{instruction[31]}},instruction[31],instruction[19:12],instruction[20],instruction[30:21],1'b0}; //J type
	        3'd100: ImmExt={instruction[31:12],12'd0}; //U type
        endcase
    end
    
endmodule
