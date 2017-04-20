module Extend_Immediate(imm, sext, exImm);
	input [15:0] imm;
	input sext;
	output reg [31:0] exImm;

    always@ (*) begin
        if(sext == 0) begin
            exImm <= {{16'b0}, {imm[15:0]}};
        end
        else if(sext == 1) begin
           exImm <= {{16{imm[15]}}, imm[15:0]};
        end
	end
endmodule