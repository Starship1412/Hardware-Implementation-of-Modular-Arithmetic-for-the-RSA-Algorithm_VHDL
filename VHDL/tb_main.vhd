library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_main is
end tb_main;

architecture testbench of tb_main is
	signal sw1_tb, sw2_tb, rst_tb, clk_tb : std_logic := '0';
	signal led_tb : std_logic;
	signal seg_tb : std_logic_vector(6 downto 0);
	signal dp_tb : std_logic;
	signal an_tb : std_logic_vector(3 downto 0);
	constant clk_period : time := 10 ns;

	component main
		port (
			sw1 : in  std_logic;
			sw2 : in  std_logic;
			rst : in  std_logic;
			clk : in  std_logic;
			led : out std_logic;
			seg : out std_logic_vector(6 downto 0);
			dp  : out std_logic;
			an  : out std_logic_vector(3 downto 0)
		);
	end component;

begin
	uut: main
		port map (
			sw1 => sw1_tb,
			sw2 => sw2_tb,
			rst => rst_tb,
			clk => clk_tb,
			led => led_tb,
			seg => seg_tb,
			dp  => dp_tb,
			an  => an_tb
		);

	clk_process : process
	begin
		while now < 2020000 ns loop
			clk_tb <= '0';
			wait for clk_period/2;
			clk_tb <= '1';
			wait for clk_period/2;
		end loop;
		wait;
	end process;

	rst_process : process
	begin
		rst_tb <= '1'; -- If at first rst_tb is '1', the HEX should be 0001, in LED it is 40 40 40 79.
		wait for 10000 ns;
		rst_tb <= '0'; -- 8000 in HEX is 00 40 40 40 in LED
		wait for 1000000 ns;
		rst_tb <= '1'; -- The previous v
		wait for 10000 ns;
		rst_tb <= '0';
		wait for 1000000 ns;
		wait;
	end process;

	stim_process: process
	begin
		sw1_tb <= '0';
		sw2_tb <= '0';
		wait for 990000 ns;

		sw1_tb <= '1';
		sw2_tb <= '1';
		wait for 1000000 ns;
		wait;
	end process;
end architecture testbench;