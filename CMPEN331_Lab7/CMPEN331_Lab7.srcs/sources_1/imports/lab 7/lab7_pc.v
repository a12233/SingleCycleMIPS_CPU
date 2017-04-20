module program_counter (
	input [31:0] pc_addr,
 	input clk,
 	input rst,
 	output reg [31:0] pc
); 
	
	always @(posedge clk or posedge rst) begin
		if (rst)
			pc <= 0; 
		else
			pc <= pc_addr; 
	end

endmodule