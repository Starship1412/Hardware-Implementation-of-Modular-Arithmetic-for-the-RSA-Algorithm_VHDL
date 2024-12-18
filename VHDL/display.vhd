--------------------------------------------------------------------------------
-- Company:        Xilinx
-- Engineer:       Steven Elzinga
--
-- Create Date:    12:23:44 01/27/05
-- Design Name:    stopwatch
-- Module Name:    stopwatch - stopwatch_arch
-- Project Name:   ISE in Depth Tutorial
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

entity display is
    port (
        clk           : in std_logic;
        hex2led_input : in std_logic_vector(15 downto 0);
        seg           : out std_logic_vector(6 downto 0);
        dp            : out std_logic;
        an            : out std_logic_vector(3 downto 0)
    );
end display;

architecture display_arch of display is

    component hex2led is
        port (
            HEX : in std_logic_vector(3 downto 0);
            LED : out std_logic_vector(6 downto 0)
        );
    end component;

    component led_control is
        port (
            CLK : in std_logic;
            DISP0 : in std_logic_vector(6 downto 0);
            DISP1 : in std_logic_vector(6 downto 0);
            DISP2 : in std_logic_vector(6 downto 0);
            DISP3 : in std_logic_vector(6 downto 0);
            AN : out std_logic_vector(3 downto 0);
            DP : out std_logic;
            SEVEN_SEG : out std_logic_vector(6 downto 0)
        );
    end component;

    signal DISP0, DISP1, DISP2, DISP3 : std_logic_vector (6 downto 0);

begin

    HEX2LED_1 : hex2led port map (
        HEX => hex2led_input(3 downto 0),
        LED => DISP0);

    HEX2LED_2 : hex2led port map (
        HEX => hex2led_input(7 downto 4),
        LED => DISP1);

    HEX2LED_3 : hex2led port map (
        HEX => hex2led_input(11 downto 8),
        LED => DISP2);

    HEX2LED_4 : hex2led port map (
        HEX => hex2led_input(15 downto 12),
        LED => DISP3);

    LEDCONTROL_1 : led_control port map (
        CLK => clk,
        DISP0 => DISP0,
        DISP1 => DISP1,
        DISP2 => DISP2,
        DISP3 => DISP3,
        AN => an,
        SEVEN_SEG => seg,
        DP => dp);

end display_arch;