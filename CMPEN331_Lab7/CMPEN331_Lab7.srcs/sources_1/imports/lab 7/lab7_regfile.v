module regfile (rna, rnb, d, wn, we, clk, clrn, qa, qb);	// 32x32 regfile
	input [31:0] d;		// data of write port
	input [4:0] rna;	// reg # of read port A
	input [4:0] rnb;	// reg # of read port B
	input [4:0] wn;		// reg # of write port
	input we;			// write enable
	input clk, clrn;	// clock and reset
	output [31:0] qa, qb;	//read ports A and B
	reg [31:0] register [1:31];	// 31 32-bit registers
	assign qa = (rna == 0)? 0 : register[rna];	// read port A
	assign qb = (rnb == 0)? 0 : register[rnb];	// read port B
	integer i, j;

	initial begin
	   for(j = 0; j < 32; j = j+1) 
		register[j] <= 32'b0;
	end

	always @(posedge clk or negedge clrn) begin
		if (!clrn)
			for(i = 1; i < 32; i = i+1)
				register[i] <= 0;				// assign 0 to each of the 31 32-bit registers
		else begin
			if ((wn != 0) && we)
				register[wn] <= d;			// if write enable, write data into register
		end
	end
endmodule