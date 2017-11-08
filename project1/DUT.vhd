library std;
use std.standard.all;
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
--use work.componentsRISC.all;

entity DUT is
port (
		clock: in std_logic;
		Clock_50: in std_logic;
		reset: in std_logic;
		ALU_data_out_dut, mem_data_out_dut, RF_d1_out_dut, RF_d2_out_dut: out std_logic_vector(15 downto 0);
		IR_data_out_dut: out std_logic_vector(15 downto 0)
	);
end entity;

architecture DUTWrap of DUT is

	component datapath is
		port ( 
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
		ALU_data_out_dut, mem_data_out_dut, RF_d1_out_dut, RF_d2_out_dut: out std_logic_vector(15 downto 0);
		IR_data_out_dut: out std_logic_vector(15 downto 0)
		);
	end component;

	component control_path is
		port (
		clock : in std_logic;
		carry, zero: in std_logic;
		valid: in std_logic;
		op_code_bits: in std_logic_vector(3 downto 0);
		cz_bits : in std_logic_vector(1 downto 0);
		eq_T1_T2 : in std_logic;
		reset: in std_logic;

		mux4ALU :out std_logic_vector(1 downto 0);  -- Mux4 ALU 0 and 1 arranged as 1:0  --
		mux8ALU :out std_logic_vector(2 downto 0);  -- Mux8 ALU 0, 1 and 2 arranged as 2:1:0 -- 
		Mux2 :out std_logic_vector(4 downto 0);     -- Mux2 ALUout, mem_a, T2, IR, Rfa2 -- 
		mux4RF :out std_logic_vector(3 downto 0);   -- Mux4 Rfd3.0, Rfd3.1 Rfa1.0 and Rfa1.1 arranged asd31:d30:a11:a10--
		mux8RFa3 :out std_logic_vector(2 downto 0); -- Mux8 RFa3.0, RFa3.1, RFa3.2 arranged as 2:1:0-- 
		en :out std_logic_vector(3 downto 0);       -- T1en, T2en, T3en, IR (enables); arranged as IR:T3:T2:T1 -- 
		var :out std_logic_vector(2 downto 0);      -- rbar_M	wbar_M	wr_RF  arranged as wr_RF:wbar_M:rbar_M--
		cz_en :out std_logic_vector(1 downto 0)     -- add and zero enables --
		);
	end component;

	signal mux4ALU_signal :std_logic_vector(1 downto 0);
	signal	mux8ALU_signal : std_logic_vector(2 downto 0);
	signal	Mux2_signal : std_logic_vector(4 downto 0);
	signal	mux4RF_signal : std_logic_vector(3 downto 0);
	signal	mux8RFa3_signal : std_logic_vector(2 downto 0);
	signal	en_signal : std_logic_vector(3 downto 0);
	signal	var_signal : std_logic_vector(2 downto 0);
	signal	cz_en_signal: std_logic_vector(1 downto 0);
		
	signal	carry_signal, zero_signal: std_logic;
	signal	valid_signal: std_logic;
	signal	op_code_bits_signal: std_logic_vector(3 downto 0);
	signal	cz_bits_signal : std_logic_vector(1 downto 0);
	signal	eq_T1_T2_signal: std_logic;
	signal 	ALU_data_out_duts, mem_data_out_duts, RF_d1_out_duts, RF_d2_out_duts: std_logic_vector(15 downto 0);
	signal 	IR_data_out_duts: std_logic_vector(15 downto 0);
	signal   reset_bar : std_logic;
begin
reset_bar <= not reset;
datapath1: datapath 
	port map(
		clock => clock,
		reset => reset_bar,
		mux4ALU => mux4ALU_signal,
		mux8ALU => mux8ALU_signal,
		Mux2 => Mux2_signal,
		mux4RF => mux4RF_signal,
		mux8RFa3 => mux8RFa3_signal,
		en => en_signal,
		var => var_signal,
		cz_en => cz_en_signal,
		
		carry => carry_signal, 
		zero => zero_signal,
		valid => valid_signal,
		op_code_bits => op_code_bits_signal,
		cz_bits => cz_bits_signal,
		eq_T1_T2 => eq_T1_T2_signal,
		ALU_data_out_dut => ALU_data_out_duts,
		mem_data_out_dut => mem_data_out_duts,
		RF_d1_out_dut => RF_d1_out_duts,
		RF_d2_out_dut => RF_d2_out_duts,
		IR_data_out_dut => IR_data_out_duts
		);

control_path1: control_path
	port map(
		clock => clock,
		reset => reset_bar,
		mux4ALU => mux4ALU_signal,
		mux8ALU => mux8ALU_signal,
		Mux2 => Mux2_signal,
		mux4RF => mux4RF_signal,
		mux8RFa3 => mux8RFa3_signal,
		en => en_signal,
		var => var_signal,
		cz_en => cz_en_signal,
		
		carry => carry_signal, 
		zero => zero_signal,
		valid => valid_signal,
		op_code_bits => op_code_bits_signal,
		cz_bits => cz_bits_signal,
		eq_T1_T2 => eq_T1_T2_signal
		);
	
	ALU_data_out_dut <= ALU_data_out_duts;
	mem_data_out_dut <= mem_data_out_duts;
	RF_d1_out_dut <= RF_d1_out_duts;
	RF_d2_out_dut <= RF_d2_out_duts;
	IR_data_out_dut <= IR_data_out_duts;

end DUTWrap;