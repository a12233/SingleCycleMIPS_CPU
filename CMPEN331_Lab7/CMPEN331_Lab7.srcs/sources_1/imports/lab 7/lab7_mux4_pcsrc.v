module mux4_pcsrc(pcsrc, p4, exImm, reg_addr, j_addr, pc_addr);
	input [1:0] pcsrc;
	input [31:0] p4;
	input [31:0] exImm;
	input [31:0] reg_addr;
	input [25:0] j_addr;
	output reg [31:0] pc_addr;

	wire [31:0] BranchAddr;
	wire [31:0] RegAddr;
	wire [31:0] JumpAddr;

	assign BranchAddr = p4 + (exImm << 2);
	assign RegAddr = reg_addr;
	assign JumpAddr = {p4[31:28], j_addr, 2'b00};

    always @(*) begin
        case(pcsrc)
            0: pc_addr = p4;
            1: pc_addr = BranchAddr;
            2: pc_addr = RegAddr;
            3: pc_addr = JumpAddr; 
        endcase
	end



endmodule