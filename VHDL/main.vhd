library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity main is
    port (
        sw1     : in  std_logic; -- choose cleartext or cryptotext
        sw2     : in  std_logic; -- choose publ_k or priv_k
        rst     : in  std_logic;
        clk     : in  std_logic;
        led     : out std_logic;
        seg     : out std_logic_vector(6 downto 0);
        dp      : out std_logic;
        an      : out std_logic_vector(3 downto 0)
    );
end entity main;

architecture Behavioral of main is

    constant priv_k     : std_logic_vector(15 downto 0) := std_logic_vector(to_unsigned(54463, 16));
    constant publ_k     : std_logic_vector(15 downto 0) := std_logic_vector(to_unsigned(127, 16));
    constant cleartext  : std_logic_vector(15 downto 0) := std_logic_vector(to_unsigned(32768, 16)); -- 8000 in HEX
    constant cryptotext : std_logic_vector(15 downto 0) := std_logic_vector(to_unsigned(61967, 16)); -- F20F in HEX
    constant m          : std_logic_vector(15 downto 0) := std_logic_vector(to_unsigned(63383, 16));
    
    constant k     : integer := 16;
    constant log_k : integer := 4;
    
    signal x, y, z : std_logic_vector(k-1 downto 0);
    
    component modm_exponentiation
        generic (
            k      : integer;
            log_k  : integer
        );
        port (
            x     : in  std_logic_vector(k-1 downto 0);
            y     : in  std_logic_vector(k-1 downto 0);
            m     : in  std_logic_vector(k-1 downto 0);
            clk   : in  std_logic;
            reset : in  std_logic;
            z     : out std_logic_vector(k-1 downto 0);
            done  : out std_logic
        );
    end component;
    
    component display
        port (
            clk           : in  std_logic;
            hex2led_input : in std_logic_vector(15 downto 0);
            seg           : out std_logic_vector(6 downto 0);
            dp            : out std_logic;
            an            : out std_logic_vector(3 downto 0)
        );
    end component;
    
begin
    mod_exp_inst : modm_exponentiation
        generic map (
            k     => k,
            log_k => log_k
        )
        port map (
            x     => x,
            y     => y,
            m     => m,
            clk   => clk,
            reset => rst,
            z     => z,
            done  => led
        );

    display_inst : display
        port map (
            clk           => clk,
            hex2led_input => z,
            seg           => seg,
            dp            => dp,
            an            => an
        );

    process (sw2, sw1)
    begin
        if sw1 = '0' then
            y <= cleartext;
        else
            y <= cryptotext;
        end if;
        if sw2 = '0' then
            x <= publ_k;
        else
            x <= priv_k;
        end if;
    end process;
end architecture Behavioral;