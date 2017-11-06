library ieee;
use ieee.std_logic_1164.all;
--use ieee.std_logic_textio.all;
library std;
use std.textio.all;

entity Testbench is
end entity;

architecture Behave of Testbench is

    constant num_inputs : integer := 26;
    constant num_outputs : integer := 10;
    
    signal clk: std_logic := '1';
    signal reset: std_logic := '1';
    signal din: std_logic_vector(num_inputs-1 downto 0);
    signal dout: std_logic_vector(num_outputs-1 downto 0);
    signal IR_show, RF_d2_show, RF_d1_show, T1_show, T2_show, T3_show, mem_show, ALU_show: std_logic_vector(15 downto 0);
    
    function to_std_logic_vector(x: bit_vector) return std_logic_vector is
      variable ret_val: std_logic_vector(1 to x'length);
      alias lx: bit_vector(1 to x'length) is x;
  begin
    for I in 1 to x'length loop
        if(lx(I) = '1') then
            ret_val(I) := '1';
        else
            ret_val(I) := '0';
        end if;
    end loop;
    return(ret_val);
  end to_std_logic_vector;

  function to_bit_vector(x: std_logic_vector) return bit_vector is
      variable ret_val: bit_vector(1 to x'length);
      alias lx: std_logic_vector(1 to x'length) is x;
  begin
    for I in 1 to x'length loop
        if(lx(I) = '1') then
            ret_val(I) := '1';
        else
            ret_val(I) := '0';
        end if;
    end loop;
    return(ret_val);
  end to_bit_vector;

    entity datapath is 
    port (--28 inputs
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
        --10 outputs
        carry, zero: out std_logic;
        valid: out std_logic;
        op_code_bits: out std_logic_vector(3 downto 0);
        cz_bits : out std_logic_vector(1 downto 0);
        eq_T1_T2: out std_logic;
        IR_show, RF_d2_show, RF_d1_show, T1_show, T2_show, T3_show, mem_show, ALU_show: out std_logic_vector(15 downto 0)
        );

begin
    clk <= not clk after 10 ns; -- assume 20ns clock.
    reset <= '0';

    dp: datapath port map(
        clock => clk,
        reset => reset,
        mux4ALU => din(25 downto 24),
        mux8ALU => din(23 downto 21),
        Mux2 => din(20 downto 16),
        mux4RF => din(15 downto 12),
        mux8RFa3 => din(11 downto 9),
        en => din(8 downto 5),
        var => din(4 downto 2),
        cz_en => din(1 downto 0),

        carry => dout(9),
        zero => dout(8),
        valid => dout(7),
        op_code_bits => dout(6 downto 3),
        cz_bits => dout(2 downto 1),
        eq_T1_T2 => dout(0)
        
        IR_show => IR_show,
        RF_d2_show => RF_d2_show,
        RF_d1_show => RF_d1_show,
        T1_show => T1_show,
        T2_show => T2_show,
        T3_show => T3_show,
        mem_show => mem_show,
        ALU_show => ALU_show
        );

    -- reset process
    --process
    --begin
    --    wait until clk = '1';
    --    reset <= '0';
    --    wait;
    --end process;

    process 
        variable err_flag : boolean := false;
        File INFILE: text open read_mode is "TRACEFILE.txt";
        FILE OUTFILE: text  open write_mode is "OUTPUTS.txt";
        
        ---------------------------------------------------
        -- DUT variables
        variable din_var: bit_vector(num_inputs-1 downto 0);
        variable read_var, dout_var: bit_vector(num_outputs-1 downto 0);
        ----------------------------------------------------
        
        

        variable INPUT_LINE: Line;
        variable OUTPUT_LINE: Line;
        variable LINE_COUNT: integer := 0;
        
    begin

        while not endfile(INFILE) loop 
            LINE_COUNT := LINE_COUNT + 1;
            readLine (INFILE, INPUT_LINE);
            
            
            read (INPUT_LINE, din_var);
            din <= to_std_logic_vector(din_var);
            --carry <= din_var(9);
            --zero <= din_var(8);
            --valid <= din_var(7);
            --op_code_bits <= din_var(6 downto 3);
            --cz_bits <= din_var(2 downto 1);
            --eq_T1_T2 <= din_var(0);

            read(INPUT_LINE, read_var);

            wait until clk = '0';
            dout_var := to_bit_vector(dout);
            --dout(23 downto 22) <= mux4ALU;
            --dout(21 downto 19) <= mux8ALU;
            --dout(18 downto 14) <= Mux2;
            --dout(13 downto 10) <= mux4RF;
            --dout(9 downto 7) <= mux8RFa3;
            --dout(6 downto 3) <= en;
            --dout(2 downto 0) <= var;
            write(OUTPUT_LINE,dout_var);
            writeline(OUTFILE,OUTPUT_LINE);
            if (read_var /= dout_var) then
                write(OUTPUT_LINE,string'("ERROR: in line "));
                write(OUTPUT_LINE, LINE_COUNT);
                writeline(OUTFILE, OUTPUT_LINE);
                err_flag := true;
            end if;
            wait until clk='1';
        end loop;
        
        assert (err_flag) report "SUCCESS, all tests passed." severity note;
        assert (not err_flag) report "FAILURE, some tests failed." severity error;
        
        --finished <= '1';
        wait;
    end process;
	 
	--process(din,dout,start,done,erdy,srdy,clk,reset)
 --       variable scLine: Line;
 --       variable scIn: std_logic_vector(19 downto 0);
 --       FILE scFile: text  open write_mode is "in.txt";
 --   begin
 --       scIn(19) := start;
 --       scIn(18) := erdy;
 --       scIn(17) := reset;
 --       scIn(16) := clk;
 --       scIn(15 downto 0) := din;
        
 --       write(scLine,string'("SDR 20 TDI("));
 --       hwrite(scLine,scIn);
 --       write(scLine,string'(") 16 TDO("));
 --       hwrite(scLine,dout);
        
 --       if(done='1') then
 --           if(clk='1') then
 --               write(scLine,string'(") MASK(FFFF)"));
 --           else
 --               write(scLine,string'(") MASK(0000)"));
 --           end if;
 --       else
 --           write(scLine,string'(") MASK(0000)"));
 --       end if;
        
 --       writeline(scFile, scLine);
 --       write(scLine,string'("RUNTEST 1 MSEC"));
 --       writeline(scFile, scLine);
 --   end process;

 --   dut: System port map(
 --       din => din, dout => dout,
 --       start => start, done => done, erdy => erdy, srdy => srdy,
 --       clk => clk, reset => reset);

end Behave;
