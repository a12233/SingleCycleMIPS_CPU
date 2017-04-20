`timescale 1ns/1ps

module top_tb();
	reg clk;
	reg rst;

    wire [31:0] pc;
    wire [31:0] inst;
    wire [31:0] aluout;
    wire [31:0] memout;
    wire finish;

	top top1(clk, rst, pc, inst, aluout, memout, finish);

	initial begin
		clk = 0;
		rst = 0;
		#2 rst = 1;
		#15 rst = 0;
	end

	always #10 clk = !clk;
endmodule