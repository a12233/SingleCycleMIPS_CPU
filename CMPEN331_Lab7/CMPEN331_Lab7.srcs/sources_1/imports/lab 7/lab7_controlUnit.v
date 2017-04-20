module Control_Unit(op, FuncCode, Zero, m2reg, pcsrc, wmem, aluc, shift, aluimm, wreg, sext, regrt, jal);
	input [5:0] op;
	input [5:0] FuncCode;
	input Zero;
	output reg m2reg;
	output reg [1:0] pcsrc;
	output reg wmem;
	output reg [3:0] aluc;
	output reg shift;
	output reg aluimm;
	output reg wreg;
	output reg sext;
	output reg regrt;
	output reg jal;

	parameter [5:0] i_rtype = 6'b000000, i_addi = 6'b001000, i_andi = 6'b001100, i_ori = 6'b001101, 
					i_xori = 6'b001110, i_lw = 6'b100011, i_sw = 6'b101011, i_beq = 6'b000100, i_bne = 6'b 000101,
					i_lui = 6'b001111, i_j = 6'b000010, i_jal = 6'b000011, i_add = 6'b100000, i_sub = 6'b100010,
					i_and = 6'b100100, i_or = 6'b100101, i_xor = 6'b100110, i_sll = 6'b000000, i_srl = 6'b000010,
					i_sra = 6'b000011, i_jr = 6'b001000;

	initial begin
		m2reg <= 0;
		pcsrc <= 2'd0;
		wmem <= 0;
		aluc <= 4'd0;
		shift <= 0;
		aluimm <= 0;
		wreg <= 0;
	end

	always@(*) begin
		case(op)
			i_rtype: begin
				wreg = 1;
				regrt = 0;
				jal = 0;
				m2reg = 0;
				shift = 0;
				aluimm = 0;
				sext = 1'bx;
				wmem = 0;
				pcsrc = 2'b00;

				case(FuncCode)
					i_add: begin aluc = 4'bx000; end
					i_sub: begin aluc = 4'bx100; end
					i_and: begin aluc = 4'bx001; end
					i_or: begin aluc = 4'bx101; end
					i_xor: begin aluc = 4'bx010; end
					i_sll: begin aluc = 4'b0011; shift = 1; end
					i_srl: begin aluc = 4'b0111; shift = 1; end
					i_sra: begin aluc = 4'b1111; shift = 1; end
					i_jr: begin
					          wreg = 0; 
					          aluc = 4'bxxxx; 
							  regrt = 1'bx;
							  jal = 1'bx;
							  m2reg = 1'bx;
							  shift = 1'bx;
							  aluimm = 1'bx;
							  sext = 1'bx; 
							  pcsrc = 2'b10;
						end
				endcase
			end
			i_addi: begin
				wreg = 1;
				regrt = 1;
				jal = 0;
				m2reg = 0;
				shift = 0;
				aluimm = 1;
				sext = 1;
				aluc = 4'bx000;
				wmem = 0;
				pcsrc = 2'b00;
			end
			i_andi: begin
				wreg = 1;
				regrt = 1;
				jal = 0;
				m2reg = 0;
				shift = 0;
				aluimm = 1;
				sext = 0;
				aluc = 4'bx001;
				wmem = 0;
				pcsrc = 2'b00;
			end
			i_ori: begin
				wreg = 1;
				regrt = 1;
				jal = 0;
				m2reg = 0;
				shift = 0;
				aluimm = 1;
				sext = 0;
				aluc = 4'bx101;
				wmem = 0;
				pcsrc = 2'b00;
			end
			i_xori: begin
				wreg 	= 1;
				regrt 	= 1;
				jal 	= 0;
				m2reg 	= 0;
				shift 	= 0;
				aluimm 	= 1;
				sext 	= 0;
				aluc 	= 4'bx010;
				wmem 	= 0;
				pcsrc 	= 2'b00;
			end
			i_lw: begin
				wreg 	= 1;
				regrt 	= 1;
				jal 	= 0;
				m2reg 	= 1;
				shift 	= 0;
				aluimm 	= 1;
				sext 	= 1;
				aluc 	= 4'bx000;
				wmem 	= 0;
				pcsrc 	= 2'b00;
			end
			i_sw: begin
				wreg 	= 0;
				regrt 	= 1'bx;
				jal 	= 1'bx;
				m2reg 	= 1'bx;
				shift 	= 0;
				aluimm 	= 1;
				sext 	= 1;
				aluc 	= 4'bx000;
				wmem 	= 1;
				pcsrc 	= 2'b00;
			end
			i_beq: begin
				wreg 	= 0;
				regrt 	= 1'bx;
				jal 	= 1'bx;
				m2reg 	= 1'bx;
				shift 	= 0;
				aluimm 	= 0;
				sext 	= 1;
				aluc 	= 4'bx010;
				wmem 	= 0;
				if(Zero == 0) begin
					pcsrc = 2'b00;
				end
				else if(Zero==1) begin
					pcsrc = 2'b01;
				end
			end
			i_bne: begin
				wreg 	= 0;
				regrt 	= 1'bx;
				jal 	= 1'bx;
				m2reg 	= 1'bx;
				shift 	= 0;
				aluimm 	= 0;
				sext 	= 1;
				aluc 	= 4'bx010;
				wmem 	= 0;
				if(Zero == 1) begin
					pcsrc = 2'b00;
				end
				else if(Zero==0) begin
					pcsrc = 2'b01;
				end
			end
			i_lui: begin
				wreg 	= 1;
				regrt 	= 1;
				jal 	= 0;
				m2reg 	= 0;
				shift 	= 1'bx;
				aluimm 	= 1;
				sext 	= 1'b0;
				aluc 	= 4'bx110;
				wmem 	= 0;
				pcsrc 	= 2'b00;
			end
			i_j: begin
			  wreg = 0;
			  regrt = 1'bx;
			  jal = 1'bx;
			  m2reg = 1'bx;
			  shift = 1'bx;
			  aluimm = 1'bx;
			  sext = 1'bx; 
			  aluc = 4'bxxxx; 
			  wmem = 0;
			  pcsrc = 2'b11;
			end
			i_jal: begin
			  wreg = 1;
			  regrt = 1'bx;
			  jal = 1'b1;
			  m2reg = 1'bx;
			  shift = 1'bx;
			  aluimm = 1'bx;
			  sext = 1'bx; 
			  aluc = 4'bxxxx; 
			  wmem = 0;
			  pcsrc = 2'b11;
			end
		endcase
	end

endmodule

