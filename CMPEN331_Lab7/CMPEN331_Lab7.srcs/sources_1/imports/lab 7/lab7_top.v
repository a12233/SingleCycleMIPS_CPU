module top(clk, rst, finish);
	input clk;
	input rst;

	wire [31:0] w_data;
	wire [31:0] pc_addr; //address of next instruction determined by mux4_pcsrc
	wire [31:0] qa;
	output finish;
	wire [31:0] inst;
	wire [31:0] ALUOut;
	wire [31:0] dataout;
    wire [31:0] pc; //address of next instruction output by program_counter every clock cycle
    
	wire [31:0] p4; //current pc + 4
	wire [5:0] op;
	wire [4:0] rs;
	wire [4:0] rt;
	wire [4:0] rd;
	wire [4:0] sa;
	wire [5:0] funct;
	wire [15:0] imm;
	wire [25:0] addr;
	wire [31:0] exImm;
	wire m2reg;
	wire [1:0] pcsrc;
	wire wmem;
	wire [3:0] aluc;
	wire shift;
	wire aluimm;
	wire wreg;
	wire sext;
	wire regrt;
	wire jal;
	wire [31:0] data; //data from mux2 between ALUOut and dataout
	wire [31:0] wn;
	wire [31:0] A;
	wire [31:0] B;
	wire [31:0] qb;
	wire Zero;
	wire [31:0] wn1;


	program_counter program_counter1(pc_addr, clk, rst, pc);
	instruction_memory instruction_memory1(pc, op, rs, rt, rd, sa, funct, imm, addr, inst);
	adder adder1(pc, 32'd4, p4);
	Control_Unit Control_Unit1 (op, funct, Zero, m2reg, pcsrc, wmem, aluc, shift, aluimm, wreg, sext, regrt, jal);
	mux2 mux2_regrt(rd, rt, regrt, wn1);
	regfile regfile1(rs, rt, w_data, wn, wreg, clk, 1, qa, qb);
	Extend_Immediate e(imm, sext, exImm);
	mux2 mux2_aluimm(qb, exImm, aluimm, B);
	mux2 mux2_shift(qa, {27'b0,sa}, shift, A);
	MIPSALU MIPSALU1(aluc, A, B, ALUOut, Zero);
	Data_Memory Data_Memory1(clk, ALUOut, qb, wmem, dataout);
	mux2 mux2_m2reg(ALUOut, dataout, m2reg, data);
	mux2 mux2_jal(data, p4, jal, w_data);
	mux2 mux2_jal_wn(wn1, 32'd31, jal, wn);
	mux4_pcsrc mux4_pcsrc1(pcsrc, p4, exImm, qa, addr, pc_addr);
	
	assign finish = (pc == 32'h5c) ? 1 : 0;





endmodule