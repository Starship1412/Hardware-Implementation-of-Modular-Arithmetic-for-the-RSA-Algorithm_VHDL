----------------------------------------------------------------------------
-- Modulo m exponentiation (modm_exponentiation.vhd)
-- defines: modm_exponentiation
----------------------------------------------------------------------------
library ieee; 
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity modm_exponentiation is
    generic(
        k: integer;
        log_k: integer
    );
    port (
        x, y, m: in std_logic_vector(k-1 downto 0);
        clk, reset: in std_logic;
        z: out std_logic_vector(k-1 downto 0);
        done: out std_logic
    );
end modm_exponentiation;

architecture rtl of modm_exponentiation is
    signal p, q, product, int_x, register_in: std_logic_vector(k-1 downto 0);
    constant one: std_logic_vector(k-1 downto 0) := (0 => '1', others => '0');
    signal save, update, step_type, load, reg_en, x_i, finished: std_logic;
    signal mult_reset, mult_done: std_logic;
    type state is (Init, Prepare_sqr, Compute_sqr, End_sqr, Do_mul, Prepare_mul, Compute_mul, End_mul, More, Done_st);
    signal current_state, next_state: state;
    signal count: std_logic_vector(log_k-1 downto 0);
    constant zero : std_logic_vector(log_k-1 downto 0) := (others => '0');

    component modm_multiplier is
        generic(
            k: integer;
            log_k: integer
        );
        port (
            x, y, m: in std_logic_vector(k-1 downto 0);
            clk, reset: in std_logic;
            z: out std_logic_vector(k-1 downto 0);
            done: out std_logic
        );
    end component;

begin
    main_component_multiplier: modm_multiplier
        generic map(
            k => k,
            log_k => log_k
        )
        port map(
            x => p, 
            y => q, 
            m => m,
            clk => clk, 
            reset => mult_reset, 
            z => product, 
            done => mult_done
        );

    with load select register_in <= one when '1', product when others;

    with step_type select q <= p when '0', y when others;

    reg_en <= save or load;

    parallel_register: process(clk)
        begin
        if clk'event and clk = '1' then
            if reg_en = '1' then 
                p <= register_in;
            end if;
        end if;
    end process parallel_register;

    z <= product;

    shift_register: process(clk)
    begin
        if clk'event and clk='1' then
            if load = '1' then 
                int_x <= x;
            elsif update = '1' then
                for i in k-1 downto 1 loop
                    int_x(i) <= int_x(i-1);
                end loop;
                int_x(0) <= '0';
            end if;
        end if;
    end process shift_register;

    x_i <= int_x(k-1);

    counter: process(clk)
    begin
        if clk'event and clk = '1' then
            if load = '1' then 
	            count <= std_logic_vector(to_unsigned(k-1, log_k));
            elsif update = '1' then 
	            count <= std_logic_vector(unsigned(count) - to_unsigned(1, log_k));
            end if;
        end if;
    end process counter; 

    finished <= '1' when count = zero else '0';

    fsm_state_update: process(clk)
    begin
        if clk'event and clk = '1' then
            if reset = '1' then
                current_state <= Init;
            else
                current_state <= next_state;
            end if;
        end if;
    end process fsm_state_update;

    fsm_next_state: process(current_state, x_i, mult_done, finished)
    begin
        next_state <= current_state;
        case current_state is
            when Init         => next_state <= Do_mul;
            when Do_mul       => if x_i = '1' then next_state <= Prepare_mul; else next_state <= More; end if;
            when Prepare_mul  => next_state <= Compute_mul;
            when Compute_mul  => if mult_done = '1' then next_state <= End_mul; end if;
            when End_mul      => next_state <= More;
            when Prepare_sqr  => next_state <= Compute_sqr;
            when Compute_sqr  => if mult_done = '1' then next_state <= End_sqr; end if;
            when End_sqr      => next_state <= Do_mul;
            when More         => if finished = '1' then next_state <= Done_st; else next_state <= Prepare_sqr; end if;
            when Done_st      => 
        end case;
    end process fsm_next_state;

    fsm_output: process(current_state)
    begin
        case current_state is
            when Init         => update <= '0'; load <= '1'; save <= '0'; step_type <= '0'; mult_reset <= '0'; done <= '0';
            when Do_mul       => update <= '0'; load <= '0'; save <= '0'; step_type <= '0'; mult_reset <= '0'; done <= '0';
            when Prepare_mul  => update <= '0'; load <= '0'; save <= '0'; step_type <= '1'; mult_reset <= '1'; done <= '0';
            when Compute_mul  => update <= '0'; load <= '0'; save <= '0'; step_type <= '1'; mult_reset <= '0'; done <= '0';
            when End_mul      => update <= '0'; load <= '0'; save <= '1'; step_type <= '0'; mult_reset <= '0'; done <= '0';
            when Prepare_sqr  => update <= '0'; load <= '0'; save <= '0'; step_type <= '0'; mult_reset <= '1'; done <= '0';
            when Compute_sqr  => update <= '0'; load <= '0'; save <= '0'; step_type <= '0'; mult_reset <= '0'; done <= '0';
            when End_sqr      => update <= '1'; load <= '0'; save <= '1'; step_type <= '0'; mult_reset <= '0'; done <= '0';
            when More         => update <= '0'; load <= '0'; save <= '0'; step_type <= '0'; mult_reset <= '0'; done <= '0';
            when Done_st      => update <= '0'; load <= '0'; save <= '0'; step_type <= '0'; mult_reset <= '0'; done <= '1';
        end case;
    end process fsm_output;
end rtl;