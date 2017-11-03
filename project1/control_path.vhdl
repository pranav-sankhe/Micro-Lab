library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity control_path is
port (
		clock : in std_logic;
		carry, zero: in std_logic;
		valid: in std_logic;
		op_code_bits: in std_logic_vector(3 downto 0);
		cz_bits : in std_logic_vector(1 downto 0);
		eq_T1_T2 : in std_logic;
		reset: in std_logic;

		mux4ALU :out std_logic_vector(1 downto 0);
		mux8ALU :out std_logic_vector(2 downto 0);
		Mux2 :out std_logic_vector(4 downto 0);
		mux4RF :out std_logic_vector(3 downto 0);
		mux8RFa3 :out std_logic_vector(2 downto 0);
		en :out std_logic_vector(3 downto 0);
		var :out std_logic_vector(2 downto 0)			
		);
end control_path;

architecture behave of control_path is

type MyState is (fetch1, fetch2, fetch3, Add1,Add2, add3, add4, add5, lh1, lw1, lw2, 
					lw3, sw1, lm1, lm2, lm3, lm4,jal1, jal2, jlr1, sm1, sm2, sm3, beq1);
type op_code_store is (ADD, ADZ, ADC, ADI, NDU, NDC, NDZ, LHI, LW, SW, LM, SM, BEQ, JAL, JLR);
signal present_state, next_state : MyState ;
signal op_code : op_code_store;

begin
op_code_assign: process (op_code_bits,cz_bits)
begin
if	(op_code_bits = "0000" and cz_bits ="00") then op_code <= add;
elsif	(op_code_bits = "0000" and cz_bits ="10") then op_code <= adc;
elsif	((op_code_bits = "0000") and (cz_bits ="01")) then op_code <= adz;
elsif	((op_code_bits = "0010") and (cz_bits ="00")) then op_code <= ndu;
elsif	((op_code_bits = "0010") and (cz_bits ="10")) then op_code <= ndc;
elsif	((op_code_bits = "0010") and (cz_bits ="01")) then op_code <= ndz;
elsif  (op_code_bits = "0001") then op_code <= adi;
elsif  (op_code_bits = "0011") then op_code <= lhi;
elsif  (op_code_bits = "0100") then op_code <= lw; 
elsif  (op_code_bits = "0101") then op_code <= sw;
elsif  (op_code_bits = "0110") then op_code <= lm;
elsif  (op_code_bits = "0111") then op_code <= sm;
elsif  (op_code_bits = "1100") then op_code <= beq;
elsif  (op_code_bits = "1000") then op_code <= jal;
elsif  (op_code_bits = "1001") then op_code <= jlr;
end if;
end process op_code_assign;

next_state_logic: process(present_state, valid, reset, carry, zero, op_code, eq_T1_T2)
					begin
					if (reset = '1') then next_state <= fetch1; 
					
					else
						
							if (present_state = fetch1) then next_state <= fetch2; end if;
							
							if (present_state = fetch2) then next_state <= fetch3; end if;
							
							if (present_state = fetch3) then
								
								if (present_state = fetch3 and op_code = JAL) then next_state<= jal1;
								elsif (present_state= fetch3 and op_code= LHI) then next_state <= LH1;
								elsif (present_state= fetch3 and op_code = JLR) then next_state <= LW3;
								elsif (present_state= fetch3 and (op_code = LM or  op_code=SM or op_code=ADD or op_code=ADI or op_code=NDU or op_code=LW or op_code=SW or op_code=BEQ or ((op_code=ADC)and (carry = '1')) or ((op_code=ADZ)and (zero = '1')) or ((op_code=NDC)and (carry='1')) or ((op_code=NDZ)and (zero='1')))) then next_state <= ADD1;
								else
									next_state <= fetch1;
								end if;
							end if;
							
							if (present_state= ADD1) then 
								
								if(op_code = LM  or  op_code = SM) then next_state <= LM1;
								elsif(op_code = ADD or op_code = ADC or op_code = ADZ or op_code = ndu or op_code = ndc or op_code = ndz ) then next_state <= add2;
								elsif(op_code = ADI) then next_state <= ADD4;
								elsif((op_code = BEQ) and(eq_T1_T2 = "1" ) then next_state <= BEQ1;
								elsif(op_code = LW  or  op_code = SW) then next_state <= LW1;
								elsif( op_code = JLR) then next_state <= jlr1;
								else
									next_state <= fetch1;
 								end if;
 							end if;
							
							if (present_state= Add2) then next_state <= add3; end if;
							
							if (present_state= add3) then next_state <= fetch1; end if;

							if (present_state= ADD4) then next_state <= add5; end if;
							
							if (present_state= add5) then next_state <= fetch1; end if;
							
							if (present_state= LM1) then 
							
									if((op_code=LM) and (valid='1')) then next_state <= lm2;
									elsif((op_code=SM) and (valid='1')) then next_state <= sm1;
									else next_state <= fetch1;
									end if;
							end if;

							if (present_state = lm2) then next_state <= lm3; end if;

							if (present_state = lm3) then next_state <= lm4;end if;

							if (present_state = lm4) then
							
									if(valid = '1') then next_state <= lm2;
									else
										next_state <= fetch1;
									end if;
							end if;


							if (present_state = sm1) then next_state <= sm2; end if;

							if (present_state = sm2) then next_state <= sm3;end if;

							if (present_state = sm3) then
							
									if(valid ='1') then next_state <= sm1;
									else
										next_state <= fetch1;
									end if;
							end if;

							if (present_state = lw1) then
							
								if(op_code = lw) then next_state <= lw2;
								elsif(op_code = sw) then next_state <= sw1;
								else
									next_state <= jal2;
								end if;
							end if;

							if (present_state = lw2) then next_state <= lw3; end if;

							if( present_state = lw3) then
							
								if(op_code = JLR) then next_state <= Add1;

								else
									next_state <= fetch1;
								end if;
							end if;
							
							if (present_state= jlr1) then next_state <= fetch1; end if;

							if (present_state= sw1) then next_state <= fetch1;end if;

							if (present_state= beq1) then next_state <= lw1;end if;

							if (present_state= jal1) then next_state <= jal2;end if;

							if (present_state= jal2) then next_state <= fetch1;end if;

							if (present_state= lh1) then next_state <= fetch1;end if;

						end if;
					
					end process;

state_latch: process(next_state, clock)
begin
	if rising_edge(clock) then
		present_state <= next_state;
	end if;
end process;

next_state_output: process(present_state)
begin

					
					if present_state = fetch1 then
						mux4ALU   <= "00";
						mux8ALU   <= "000";
						Mux2      <= "00000";
						mux4RF    <= "0000";
						mux8RFa3  <= "000";
						en        <= "0001";
						var       <= "011";
					end if;

					if present_state = fetch2 then
						mux4ALU   <= "01";
						mux8ALU   <= "001";
						Mux2      <= "01000";
						mux4RF    <= "0000";
						mux8RFa3  <= "000";
						en        <= "1100";
						var       <= "010";
					end if;


					if present_state = fetch3 then
						mux4ALU   <= "00";
						mux8ALU   <= "000";
						Mux2      <= "00000";
						mux4RF    <= "1000";
						mux8RFa3  <= "100";
						en        <= "0000";
						var       <= "111";
					end if;


					if present_state = Add1 then
						mux4ALU   <= "00";
						mux8ALU   <= "000";
						Mux2      <= "00000";
						mux4RF    <= "0000";
						mux8RFa3  <= "000";
						en        <= "0011";
						var       <= "011";
					end if;

					if present_state = Add2 then
						mux4ALU   <= "01";
						mux8ALU   <= "000";
						Mux2      <= "00000";
						mux4RF    <= "0000";
						mux8RFa3  <= "000";
						en        <= "0100";
						var       <= "011";
					end if;


					if present_state = add3 then
						mux4ALU   <= "00";
						mux8ALU   <= "000";
						Mux2      <= "00000";
						mux4RF    <= "1000";
						mux8RFa3  <= "010";
						en        <= "0000";
						var       <= "111";
					end if;

					if present_state = add4 then
						mux4ALU   <= "01";
						mux8ALU   <= "100";
						Mux2      <= "00000";
						mux4RF    <= "0000";
						mux8RFa3  <= "000";
						en        <= "0100";
						var       <= "011";
					end if;


					if present_state = add5 then
						mux4ALU   <= "00";
						mux8ALU   <= "000";
						Mux2      <= "00000";
						mux4RF    <= "1000";
						mux8RFa3  <= "001";
						en        <= "0000";
						var       <= "111";
					end if;

					if present_state = lh1 then
						mux4ALU   <= "00";
						mux8ALU   <= "000";
						Mux2      <= "00000";
						mux4RF    <= "0000";
						mux8RFa3  <= "000";
						en        <= "0000";
						var       <= "111";
					end if;


					if present_state = lw1 then
						mux4ALU   <= "10";
						mux8ALU   <= "100";
						Mux2      <= "00000";
						mux4RF    <= "0000";
						mux8RFa3  <= "000";
						en        <= "0100";
						var       <= "011";
					end if;

					if present_state = lw2 then
						mux4ALU   <= "00";
						mux8ALU   <= "000";
						Mux2      <= "10000";
						mux4RF    <= "0000";
						mux8RFa3  <= "000";
						en        <= "0100";
						var       <= "010";
					end if;


					if present_state = lw3 then
						mux4ALU   <= "00";
						mux8ALU   <= "000";
						Mux2      <= "00000";
						mux4RF    <= "1000";
						mux8RFa3  <= "000";
						en        <= "0000";
						var       <= "111";
					end if;


					if present_state = sw1 then
						mux4ALU   <= "00";
						mux8ALU   <= "000";
						Mux2      <= "00000";
						mux4RF    <= "0000";
						mux8RFa3  <= "000";
						en        <= "0000";
						var       <= "001";
					end if;


					if present_state = lm1 then
						mux4ALU   <= "01";
						mux8ALU   <= "010";
						Mux2      <= "00000";
						mux4RF    <= "0000";
						mux8RFa3  <= "000";
						en        <= "0100";
						var       <= "011";
					end if;


					if present_state = lm2 then
						mux4ALU   <= "00";
						mux8ALU   <= "000";
						Mux2      <= "00100";
						mux4RF    <= "0000";
						mux8RFa3  <= "000";
						en        <= "0010";
						var       <= "010";
					end if;


					if present_state = lm3 then
						mux4ALU   <= "00";
						mux8ALU   <= "000";
						Mux2      <= "00010";
						mux4RF    <= "0100";
						mux8RFa3  <= "011";
						en        <= "1000";
						var       <= "111";
					end if;


					if present_state = lm4 then
						mux4ALU   <= "00";
						mux8ALU   <= "001";
						Mux2      <= "00000";
						mux4RF    <= "0000";
						mux8RFa3  <= "000";
						en        <= "0100";
						var       <= "011";
					end if;


					if present_state = jal1 then
						mux4ALU   <= "00";
						mux8ALU   <= "011";
						Mux2      <= "00000";
						mux4RF    <= "1000";
						mux8RFa3  <= "000";
						en        <= "0100";
						var       <= "111";
					end if;


					if present_state = jal2 then
						mux4ALU   <= "00";
						mux8ALU   <= "000";
						Mux2      <= "00000";
						mux4RF    <= "1000";
						mux8RFa3  <= "100";
						en        <= "0000";
						var       <= "111";
					end if;


					if present_state = jlr1 then
						mux4ALU   <= "00";
						mux8ALU   <= "000";
						Mux2      <= "00000";
						mux4RF    <= "0100";
						mux8RFa3  <= "100";
						en        <= "0000";
						var       <= "111";
					end if;


					if present_state = sm1 then
						mux4ALU   <= "00";
						mux8ALU   <= "000";
						Mux2      <= "00010";
						mux4RF    <= "0010";
						mux8RFa3  <= "000";
						en        <= "1001";
						var       <= "011";
					end if;



					if present_state = sm2 then
						mux4ALU   <= "00";
						mux8ALU   <= "000";
						Mux2      <= "00000";
						mux4RF    <= "0000";
						mux8RFa3  <= "000";
						en        <= "0000";
						var       <= "101";
					end if;



					if present_state = sm3 then
						mux4ALU   <= "00";
						mux8ALU   <= "001";
						Mux2      <= "00000";
						mux4RF    <= "0000";
						mux8RFa3  <= "000";
						en        <= "0100";
						var       <= "011";
					end if;


					if present_state = beq1 then
						mux4ALU   <= "00";
						mux8ALU   <= "000";
						Mux2      <= "00001";
						mux4RF    <= "0000";
						mux8RFa3  <= "000";
						en        <= "0010";
						var       <= "011";
					end if;

				end process;
				end behave;
