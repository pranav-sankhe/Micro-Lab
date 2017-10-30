library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity control_path is
port (
		clock : in std_logic;
		carry, zero: in std_logic;
		op_code: in std_logic_vector(3 downto 0);
		T1, T2: in std_logic_vector(15 downto 0);
		reset: in std_logic;
		
		mux4ALU:  out std_logic_vector(1 downto 0); -- Mux4 ALU 0 and 1 arranged as 1:0  --  
		mux8ALU:  out std_logic_vector(2 downto 0); -- Mux8 ALU 0, 1 and 2 arranged as 2:1:0 -- 
		mux4RF:   out std_logic_vector(3 downto 0); -- Mux4 Rfd3.0, Rfd3.1 Rfa1.0 and Rfa1.1 arranged as d31:d30:a11:a10 --      
		mux8RFa3: out std_logic_vector(2 downto 0); -- Mux8 RFa3.0, RFa3.1, RFa3.2 arranged as 2:1:0-- 
		en:       out std_logic_vector(3 downto 0); -- T1en, T2en, T3en, IR (enables); arranged as IR:T3:T2:T1 -- 
		Mux2:     out std_logic_vector(4 downto 0); -- Mux2 ALUout, mem_a, T2, IR, Rfa2 --
		var:      out std_logic_vector(2 downto 0); -- rbar_M	wbar_M	wr_RF  arranged as wr_RF:wbar_M:rbar_M-- 
		)
end control_path;

architecture behave of control_path is

type MyState is (fetch1, fetch2, fetch3, Add1,Add2, add3, add4, add5, lh1, lw1, lw2, 
					lw3, sw1, lm1, lm2, lm3, lm4,jal1, jal2, jlr1, sm1, sm2, sm3, beq1);
signal present_state, next_state : MyState 


begin
next_state_logic: process(present_state, carry, zero, op_code, T1, T2)
					begin
					if (reset)
					{
						next_state = fetch1;
					}
					if (present_state = fetch2)
					
					end process

if next_state = fetch1 then
	mux4ALU   <= 00;
	mux8ALU   <= 000;
	Mux2      <= 00000;
	mux4RF    <= 0000;
	mux8RFa3  <= 000;
	en        <= 0001;
	var       <= 011;
end if;


if next_state = fetch2 then
	mux4ALU   <= 01;
	mux8ALU   <= 001;
	Mux2      <= 01000;
	mux4RF    <= 0000;
	mux8RFa3  <= 000;
	en        <= 1100;
	var       <= 010;
end if;


if next_state = fetch3 then
	mux4ALU   <= 00;
	mux8ALU   <= 000;
	Mux2      <= 00000;
	mux4RF    <= 1000;
	mux8RFa3  <= 100;
	en        <= 0000;
	var       <= 111;
end if;


if next_state = Add1 then
	mux4ALU   <= 00;
	mux8ALU   <= 000;
	Mux2      <= 00000;
	mux4RF    <= 0000;
	mux8RFa3  <= 000;
	en        <= 0011;
	var       <= 011;
end if;

if next_state = Add2 then
	mux4ALU   <= 01;
	mux8ALU   <= 000;
	Mux2      <= 00000;
	mux4RF    <= 0000;
	mux8RFa3  <= 000;
	en        <= 0100;
	var       <= 011;
end if;


if next_state = add3 then
	mux4ALU   <= 00;
	mux8ALU   <= 000;
	Mux2      <= 00000;
	mux4RF    <= 1000;
	mux8RFa3  <= 010;
	en        <= 0000;
	var       <= 111;
end if;

if next_state = add4 then
	mux4ALU   <= 01;
	mux8ALU   <= 100;
	Mux2      <= 00000;
	mux4RF    <= 0000;
	mux8RFa3  <= 000;
	en        <= 0100;
	var       <= 011;
end if;


if next_state = add5 then
	mux4ALU   <= 00;
	mux8ALU   <= 000;
	Mux2      <= 00000;
	mux4RF    <= 1000;
	mux8RFa3  <= 001;
	en        <= 0000;
	var       <= 111;
end if;

if next_state = lh1 then
	mux4ALU   <= 00;
	mux8ALU   <= 000;
	Mux2      <= 00000;
	mux4RF    <= 0000;
	mux8RFa3  <= 000;
	en        <= 0000;
	var       <= 111;
end if;


if next_state = lw1 then
	mux4ALU   <= 10;
	mux8ALU   <= 100;
	Mux2      <= 00000;
	mux4RF    <= 0000;
	mux8RFa3  <= 000;
	en        <= 0100;
	var       <= 011;
end if;

if next_state = lw2 then
	mux4ALU   <= 00;
	mux8ALU   <= 000;
	Mux2      <= 10000;
	mux4RF    <= 0000;
	mux8RFa3  <= 000;
	en        <= 0100;
	var       <= 010;
end if;


if next_state = lw3 then
	mux4ALU   <= 00;
	mux8ALU   <= 000;
	Mux2      <= 00000;
	mux4RF    <= 1000;
	mux8RFa3  <= 000;
	en        <= 0000;
	var       <= 111;
end if;


if next_state = sw1 then
	mux4ALU   <= 00;
	mux8ALU   <= 000;
	Mux2      <= 00000;
	mux4RF    <= 0000;
	mux8RFa3  <= 000;
	en        <= 0000;
	var       <= 001;
end if;


if next_state = lm1 then
	mux4ALU   <= 01;
	mux8ALU   <= 010;
	Mux2      <= 00000;
	mux4RF    <= 0000;
	mux8RFa3  <= 000;
	en        <= 0100;
	var       <= 011;
end if;


if next_state = lm2 then
	mux4ALU   <= 00;
	mux8ALU   <= 000;
	Mux2      <= 00100;
	mux4RF    <= 0000;
	mux8RFa3  <= 000;
	en        <= 0010;
	var       <= 010;
end if;


if next_state = lm3 then
	mux4ALU   <= 00;
	mux8ALU   <= 000;
	Mux2      <= 00010;
	mux4RF    <= 0100;
	mux8RFa3  <= 011;
	en        <= 1000;
	var       <= 111;
end if;


if next_state = lm4 then
	mux4ALU   <= 00;
	mux8ALU   <= 001;
	Mux2      <= 00000;
	mux4RF    <= 0000;
	mux8RFa3  <= 000;
	en        <= 0100;
	var       <= 011;
end if;


if next_state = jal1 then
	mux4ALU   <= 00;
	mux8ALU   <= 011;
	Mux2      <= 00000;
	mux4RF    <= 1000;
	mux8RFa3  <= 000;
	en        <= 0100;
	var       <= 111;
end if;


if next_state = jal2 then
	mux4ALU   <= 00;
	mux8ALU   <= 000;
	Mux2      <= 00000;
	mux4RF    <= 1000;
	mux8RFa3  <= 100;
	en        <= 0000;
	var       <= 111;
end if;


if next_state = jlr1 then
	mux4ALU   <= 00;
	mux8ALU   <= 000;
	Mux2      <= 00000;
	mux4RF    <= 0100;
	mux8RFa3  <= 100;
	en        <= 0000;
	var       <= 111;
end if;


if next_state = sm1 then
	mux4ALU   <= 00;
	mux8ALU   <= 000;
	Mux2      <= 00010;
	mux4RF    <= 0010;
	mux8RFa3  <= 000;
	en        <= 1001;
	var       <= 011;
end if;



if next_state = sm2 then
	mux4ALU   <= 00;
	mux8ALU   <= 000;
	Mux2      <= 00000;
	mux4RF    <= 0000;
	mux8RFa3  <= 000;
	en        <= 0000;
	var       <= 101;
end if;



if next_state = sm3 then
	mux4ALU   <= 00;
	mux8ALU   <= 001;
	Mux2      <= 00000;
	mux4RF    <= 0000;
	mux8RFa3  <= 000;
	en        <= 0100;
	var       <= 011;
end if;


if next_state = beq1 then
	mux4ALU   <= 00;
	mux8ALU   <= 000;
	Mux2      <= 00001;
	mux4RF    <= 0000;
	mux8RFa3  <= 000;
	en        <= 0010;
	var       <= 011;
end if;


