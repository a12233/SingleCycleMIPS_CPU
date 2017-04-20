module Data_Memory(clk, addr, datain, we, dataout);
	input clk;
	input [31:0] addr;
	input [31:0] datain;
	input we;
	output [31:0] dataout;

	reg [31:0] RAM [0:255];
integer i;    initial begin                        
// initialize memory        
for (i = 0; i < 32; i = i + 1)            
RAM[i] = 0;        // ram[word_addr] = data         // (byte_addr)         
RAM[5'h14] = 32'h000000a3;       // (50hex)         
RAM[5'h15] = 32'h00000027;       // (54hex)         
RAM[5'h16] = 32'h00000079;       // (58hex)         
RAM[5'h17] = 32'h00000115;       // (5chex)         // ram[5'h18] should be 0x00000258, the sum stored by sw instruction    
end

	always@ (posedge clk) begin
		if(we)
			RAM[addr>>2] <= datain;
	end

	assign dataout = ( ((addr>>2) < 256) && (addr % 16 == 0) )? RAM[addr>>2] : 0;

endmodule
