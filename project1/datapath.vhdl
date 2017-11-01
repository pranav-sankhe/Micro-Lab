library std;
use std.standard.all;
library ieee;
use ieee.std_logic_1164.all;
use work.componentsRISC.all;
--------------------------------------------------

entity datapath is 
	port( 
		clock : in std_logic;
		reset: in std_logic;
		mux4ALU :in std_logic_vector(1 downto 0);
		mux8ALU :in std_logic_vector(2 downto 0);
		Mux2 :in std_logic_vector(4 downto 0);
		mux4RF :in std_logic_vector(3 downto 0);
		mux8RFa3 :in std_logic_vector(2 downto 0);
		en :in std_logic_vector(3 downto 0);
		var :in std_logic_vector(2 downto 0);
		cz_en: in std_logic_vector(1 downto 0);
		
		carry, zero: out std_logic;
		valid: out std_logic;
		op_code_bits: out std_logic_vector(3 downto 0);
		cz_bits : out std_logic_vector(1 downto 0);
		eq_T1_T2: out std_logic;
		
		);
end entity;

architecture behave of datapath is

	signal ;
begin

	IR_in_mux: mux2_16 
	port (IN1=> IRdec_data_out,
		  IN0=> mem_data_out, 
		  s=> Mux2(1),
		  OUTPUT=> IR_data_in);
		  
	IR: dregister 
	port (DIN=> IR_data_in,
		  clk=> clock, 
		  en=>  en(3),
		  DOUT=> IR_data_out);
	
	IR_dec: ir_decoder 
	port (s=> PE_data_out,
		  IR=> IR_data_out, 
		  new_IR=> IRdec_data_out);
		  
	RF_a1_mux: mux4_3  
	port (IN3=> "000",
		  IN2=> PE_data_out,
		  IN1=> "111",
		  IN0=> IR_data_out(11 downto 9), 
		  s=> mux4RF(1 downto 0),
		  OUTPUT=> RF_a1_in);
	
	RF_a2_mux: mux2_3 is 
	port (IN1=> "111",
		  IN0=> IR_data_out(8 downto 6), 
		  s=> Mux2(0),
		  OUTPUT=> RF_a2_in);
	
	RF_a3_mux: mux8_3 is 
	port (IN7=> "000",
		  IN6=> "000",
		  IN5=> "000",
		  IN4=> "111",
		  IN3=> PE_data_out,
		  IN2=> IR_data_out(5 downto 3),
		  IN1=> IR_data_out(8 downto 6),
		  IN0=> IR_data_out(11 downto 9), 
		  s=> mux8RFa3(2 downto 0),
		  OUTPUT=> RF_a3_in);
	
	RF_d3_mux: mux4_16 is 
	port (IN3=> "0000000000000000",
		  IN2=> T3_data_out,
		  IN1=> T2_data_out,
		  IN0=> LS7_data_out, 
		  s=> mux4RF(3 downto 2),
		  OUTPUT=> RF_d3_in);
	
	PE: priority is 
	port (INPUT=>PE_data_in, 
		  output=> PE_data_out,
		  valid=> valid);
		  
	RF: register_file is
	port (
		  a1=> RF_a1_in,   --a2 a1 to read the data
		  a2=> RF_a2_in,
		  a3=> RF_a3_in,   --a3 is the address where data to be written 
		  d3=> RF_d3_in,        -- d3 is the daata to write 
		  wr=>  var(2),   
		  d1=> RF_d1_out, 
		  d2=> RF_d2_out,
		  reset=> reset,
		  clk=> clock);
		  
	T1: dregister is 
	port (DIN=> RF_d1_out, 
		  clk=> clock, 
		  en=> en(0),
		  DOUT=> T1_data_out);
		
	T2_in_mux: mux2_16 is 
	port (IN1=> mem_data_out,
		  IN0=> RF_d2_out, 
		  s=> Mux2(2),
		  OUTPUT=> T2_data_in);  
	
		  
	T2: dregister is 
	port (DIN=> T2_data_in, 
		  clk=> clock, 
		  en=> en(1),
		  DOUT=> T2_data_out);
		  
	ALU1_mux: mux4_16 is 
	port (IN3=> "0000000000000000",
		  IN2=> T2_data_out,
		  IN1=> T1_data_out,
		  IN0=> T3_data_out, 
		  s=> mux4ALU(1 downto 0),
		  OUTPUT=> ALU_data_in_1);
	
	ALU2_mux: mux8_16 is 
	port (IN7=> "0000000000000000",
		  IN6=> "0000000000000000",
		  IN5=> "0000000000000000",
		  IN4=> SE10_data_out,
		  IN3=> SE7_data_out,
		  IN2=> "0000000000000000",
		  IN1=> "0000000000000001",
		  IN0=> T2_data_out), 
		  s=> mux8ALU(2 downto 0),
		  OUTPUT=> RF_a3_in);
	
	ALU: alu is 
	port( X=> ALU_data_in_1;
		  Y=> ALU_data_in_2;
		  x0=>,                 -- write opcode, ALU to be modified
		  x1=>, 
		  OUTPUT_ALU=> ALU_data_out,
		  carry=>carry_ALU_out,
		  zero=>zero_ALU_out);
	
	C: dflipflop is
	port (DIN=> carry_ALU_out, 
		  clk=> clock, 
		  en=> cz_en(1) and (op_code_bits = "0000"),
		  DOUT=> carry);
		  
	Z: dflipflop is
	port (DIN=> zero_ALU_out, 
		  clk=> clock, 
		  en=> cz_en(0),
		  DOUT=> zero);
	
	T3_in_mux: mux2_16 is 
	port (IN1=> mem_data_out,
		  IN0=> ALU_data_out, 
		  s=> Mux2(4),
		  OUTPUT=> T3_data_in);
	
	T3: dregister is 
	port (DIN=> T3_data_in, 
		  clk=> clock, 
		  en=> en(2),
		  DOUT=> T3_data_out);
		  
	mem_in_mux: mux2_16 is 
	port (IN1=> T1_data_out,
		  IN0=> T3_data_out, 
		  s=> Mux2(3),
		  OUTPUT=> mem_add_in);
	
	MEM: memory is 
    generic (data_width: integer:= 16; addr_width: integer := 4);
    port(din=> T1_data_out,
        dout=> mem_data_out,
        rbar=> var(0),
        wbar=> var(1),
        addrin=> mem_add_in);
		
	op_code_bits <= IR_data_out(15 downto 12);
	cz_bits <= IR_data_out(1 downto 0);
	eq_T1_T2 <= '1' when T2_data_in = RF_d1_out else '0';