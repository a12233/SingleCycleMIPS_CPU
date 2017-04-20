module instruction_memory(rd_address, op, rs, rt, rd, sa, funct, imm, addr, IR);
	input [31:0] rd_address;
	output reg [5:0] op;
	output reg [4:0] rs;
	output reg [4:0] rt;
	output reg [4:0] rd;
	output reg [4:0] sa;
	output reg [5:0] funct;
	output reg [15:0] imm;
	output reg [25:0] addr;
	reg [31:0] memory [0:31];
	output reg [31:0] IR;

	initial begin
        memory[0] = 32'h3c010000;    // (00) main:   lui  $1, 0  
        memory[1]= 32'h34240050;    // (04)         ori  $4, $1, 80  
        memory[2]= 32'h20050004;    // (08)         addi $5, $0,  4  
        memory[3]=32'h0c000018;    // (0c) call:   jal  sum  
        memory[4]=32'hac820000;    // (10)         sw   $2, 0($4)  
        memory[5] =32'h8c890000;    // (14)         lw   $9, 0($4)  
        memory[6] =32'h01244022;    // (18)         sub  $8, $9, $4  
        memory[7] =32'h20050003;    // (1c)         addi $5, $0,  3  
        memory[8] =32'h20a5ffff;    // (20) loop2:  addi $5, $5, -1  
        memory[9] =32'h34a8ffff;    // (24)         ori  $8, $5, 0xffff  
        memory[10] =32'h39085555;    // (28)         xori $8, $8, 0x5555  
        memory[11] = 32'h2009ffff;    // (2c)         addi $9, $0, -1  
        memory[12] = 32'h312affff;    // (30)         andi $10,$9, 0xffff  
        memory[13] = 32'h01493025;    // (34)         or   $6, $10, $9  
        memory[14] = 32'h01494026;    // (38)         xor  $8, $10, $9  
        memory[15] = 32'h01463824;    // (3c)         and  $7, $10, $6  
        memory[16] = 32'h10a00001;    // (40)         beq  $5, $0, shift  
        memory[17] = 32'h08000008;    // (44)         j    loop2  
        memory[18] = 32'h2005ffff;    // (48) shift:  addi $5, $0, -1  
        memory[19] = 32'h000543c0;    // (4c)         sll  $8, $5, 15  
        memory[20] = 32'h00084400;    // (50)         sll  $8, $8, 16  
        memory[21] = 32'h00084403;    // (54)         sra  $8, $8, 16  
        memory[22] =  32'h000843c2;    // (58)         srl  $8, $8, 15  
        memory[23] =  32'h08000017;    // (5c) finish: j    finish  
        memory[24] = 32'h00004020;    // (60) sum:    add  $8, $0, $0  
        memory[25] = 32'h8c890000;    // (64) loop:   lw   $9, 0($4)  
        memory[26] = 32'h20840004;    // (68)         addi $4, $4,  4  
        memory[27] = 32'h01094020;    // (6c)         add  $8, $8, $9  
        memory[28] = 32'h20a5ffff;    // (70)         addi $5, $5, -1  
        memory[29] = 32'h14a0fffb;    // (74)         bne  $5, $0, loop  
        memory[30] =  32'h00081000;    // (78)         sll  $2, $8, 0  
        memory[31] =  32'h03e00008;    // (7c)         jr   $31
end    
	
	always@(rd_address) begin
	    IR <= memory[rd_address>>2];
	end
	
	always@(IR) begin
	    op <= IR[31:26];
        rs <= IR[25:21];
        rt <= IR[20:16];
        rd <= IR[15:11];
        sa <= IR[10:6];
        funct <= IR[5:0];
        imm <= IR[15:0];
        addr <= IR[25:0];
	end


endmodule


