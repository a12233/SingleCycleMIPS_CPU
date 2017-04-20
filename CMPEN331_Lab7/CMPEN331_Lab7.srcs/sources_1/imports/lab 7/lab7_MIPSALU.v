module MIPSALU (ALUctl, A, B, ALUOut, Zero);
	input [3:0] ALUctl;
	input [31:0] A,B;
	output reg [31:0] ALUOut;
	output Zero;

	assign Zero = !ALUOut; //Zero is true if ALUOut is 0 

	always @(ALUctl, A, B)	
	begin //re-evaluate if these change 
		case (ALUctl)
			4'bx000: ALUOut <= A + B;
			4'bx100: ALUOut <= A - B;
			4'bx001: ALUOut <= A & B;
			4'bx101: ALUOut <= A | B;
			4'bx010: ALUOut <= A ^ B;
			4'bx110: ALUOut <= {{B[15:0]}, {16'h0}};
			4'b0011: ALUOut <= B << A;
			4'b0111: ALUOut <= B >> A;
			4'b1111: ALUOut <= B >>> A;
			default: ALUOut <= 0;
		endcase 
	end
endmodule