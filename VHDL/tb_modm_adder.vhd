------------------------------------------------------------
-- Testbench for modulo m adder (tb_modm_adder.vhd)
-- defines: tb_modm_adder
------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_modm_adder is
end tb_modm_adder;
 
architecture behavior of tb_modm_adder is 
	constant k : integer := 8;
 
	component modm_addition
		generic(
			k: integer
		);
		port(
			x, y, m : in  std_logic_vector(k-1 downto 0);
			z : out  std_logic_vector(k-1 downto 0)
		);
	end component;
	
	component modm_adder
		generic(
			k: integer
		);
		port(
			x, y, m : in  std_logic_vector(k-1 downto 0);
			z : out  std_logic_vector(k-1 downto 0)
		);
	end component;
   
	signal x, y, m: std_logic_vector(k-1 downto 0) := (others => '0');
	signal z1, z2: std_logic_vector(k-1 downto 0) := (others => '0');
 
begin
	dut1: modm_addition
		generic map (
			k => k
		)
		port map (
			x => x,
			y => y,
			m => m,
			z => z1
		);
	
	dut2: modm_adder
		generic map (
			k => k
		)
		port map (
			x => x,
			y => y,
			m => m,
			z => z2
		);

-- x should be less than m, y should be less than m.
  stim_proc: process
  begin
	m <= std_logic_vector(to_unsigned(239, k));
	x <= std_logic_vector(to_unsigned(129, k));
	y <= std_logic_vector(to_unsigned(105, k));
	wait for 100 ns;
	x <= std_logic_vector(to_unsigned(238, k));
	y <= std_logic_vector(to_unsigned(238, k));
	wait for 100 ns;
	x <= std_logic_vector(to_unsigned(102, k));
	y <= std_logic_vector(to_unsigned(179, k));
	wait for 100 ns;
	x <= std_logic_vector(to_unsigned(67, k));
	y <= std_logic_vector(to_unsigned(15, k));
	wait for 100 ns;
	x <= std_logic_vector(to_unsigned(19, k));
	y <= std_logic_vector(to_unsigned(185, k));
	wait for 100 ns;
	m <= std_logic_vector(to_unsigned(50, k));
	x <= std_logic_vector(to_unsigned(29, k));
	y <= std_logic_vector(to_unsigned(36, k));
	wait for 100 ns;
	x <= std_logic_vector(to_unsigned(49, k));
	y <= std_logic_vector(to_unsigned(49, k));
	wait for 100 ns;
	x <= std_logic_vector(to_unsigned(44, k));
	y <= std_logic_vector(to_unsigned(25, k));
	wait for 100 ns;
	x <= std_logic_vector(to_unsigned(10, k));
	y <= std_logic_vector(to_unsigned(10, k));
	wait for 100 ns;
	x <= std_logic_vector(to_unsigned(25, k));
	y <= std_logic_vector(to_unsigned(26, k));
	wait for 100 ns;
	x <= std_logic_vector(to_unsigned(25, k));
	y <= std_logic_vector(to_unsigned(25, k));
	wait for 100 ns;
	x <= std_logic_vector(to_unsigned(25, k));
	y <= std_logic_vector(to_unsigned(24, k));
	wait for 100 ns;
	wait;
  end process;

end;