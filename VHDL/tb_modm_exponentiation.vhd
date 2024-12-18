------------------------------------------------------------
-- Testbench for modulo m exponentiation (tb_modm_exponentiation.vhd)
-- defines: tb_modm_exponentiation
------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_modm_exponentiation is
end tb_modm_exponentiation;

architecture behavior of tb_modm_exponentiation is 
    constant k : integer := 8;
    constant log_k : integer := 3;

    component modm_exponentiation
        generic(
            k: integer;
            log_k: integer
        );
        port(
            x, y, m: in std_logic_vector(k-1 downto 0);
            clk, reset: in std_logic;
            z: out std_logic_vector(k-1 downto 0);
            done: out std_logic
        );
    end component;

    signal x_tb, y_tb, m_tb: std_logic_vector(k-1 downto 0) := (others => '0');
    signal clk_tb, reset_tb: std_logic;
    signal z_tb: std_logic_vector(k-1 downto 0);
    signal done_tb: std_logic;
    constant clk_period : time := 10 ns;

begin
    dut: modm_exponentiation
        generic map (
            k => k,
            log_k => log_k
        )
        port map (
            x => x_tb,
            y => y_tb,
            m => m_tb,
            clk => clk_tb,
            reset => reset_tb,
            z => z_tb,
            done => done_tb
        );
    
	clk_process : process
	begin
		while now < 30000 ns loop
			clk_tb <= '0';
			wait for clk_period/2;
			clk_tb <= '1';
			wait for clk_period/2;
		end loop;
		wait;
	end process;
    
-- x should be less than m, y should be less than m.
    stim_proc: process
    begin
        reset_tb <= '1';
        m_tb <= std_logic_vector(to_unsigned(239, k));
        x_tb <= std_logic_vector(to_unsigned(8, k));
        y_tb <= std_logic_vector(to_unsigned(2, k));
--        m_tb <= (16 => '0', others => '1');
--        x_tb <= (16 => '0', others => '1');
--        y_tb <= (191 => '0', others => '1');
        wait for 200 ns;
        reset_tb <= '0';
        wait;
    end process;
end;