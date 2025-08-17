module ALU(opc, a, b, zero, out);

   input [2:0] opc;
   input [31:0] a, b;
   
   output zero;
   output reg [31:0] out; 
   
   always @(a or b or opc) begin
       case (opc)
           3'b000   :  out = a + b;
           3'b001   :  out = a - b;
           3'b010   :  out = a & b;
           3'b011   :  out = a | b;
           3'b101   :  out = a < b ? 32'd1 : 32'd0;
           3'b100   :  out = a ^ b;
           default:  out = {32{1'bz}};
       endcase
   end

   assign zero = (~|out);

endmodule
