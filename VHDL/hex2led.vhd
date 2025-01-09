--------------------------------------------------------------------------------
-- Company:        Xilinx
-- Engineer:       Steven Elzinga
--
-- Create Date:    15:40:17 02/01/05
-- Design Name:    Stopwatch
-- Module Name:    hex2led - hex2led_arch
-- Project Name:   ISE In Depth Tutorial
-- Target Device:  xc3s200-4ft256
-- Tool versions:  ISE 7.1i
-- Description:
--
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
--------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity hex2led is
	port (
		HEX : in std_logic_vector(3 downto 0);
		LED : out std_logic_vector(6 downto 0)
	);
end hex2led;

architecture hex2led_arch of hex2led is

begin

-- 7 segment encoding
--      0
--     ---  
--  5 |   | 1
--     ---   <- 6
--  4 |   | 2
--     ---
--      3

	with HEX select
		LED  <= "1111001" when "0001",   --0x79 1
				"0100100" when "0010",   --0x24 2
				"0110000" when "0011",   --0x30 3
				"0011001" when "0100",   --0x19 4
				"0010010" when "0101",   --0x12 5
				"0000010" when "0110",   --0x02 6
				"1111000" when "0111",   --0x78 7
				"0000000" when "1000",   --0x00 8
				"0010000" when "1001",   --0x10 9
				"0001000" when "1010",   --0x08 A
				"0000011" when "1011",   --0x03 b
				"1000110" when "1100",   --0x46 C
				"0100001" when "1101",   --0x21 d
				"0000110" when "1110",   --0x06 E
				"0001110" when "1111",   --0x0E F
				"1000000" when others;   --0x40 0
end hex2led_arch; -- So 8000 in HEX is 00 40 40 40 in LED, F20F in HEX is 0E 24 40 0E in LED.