library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mod6counter_timer is
  PORT(
        CLK: in std_logic;
        E: in std_logic;
        RESETN: in std_logic;
        T: out std_logic_vector(5 downto 0)
      );

end mod6counter_timer;

architecture mod6counter_timer_arch of mod6counter_timer is

  signal count: std_logic_vector(2 downto 0);
  signal T_N: std_logic_vector(7 downto 0);

  component quad3to8decoder
    port(
          A,B,C: in std_logic;      
          Y_N: out std_logic_vector(7 downto 0);
          ENABLE: in std_logic;
          RESETN: in std_logic
        );
  end component;


begin

  the_decoder: quad3to8decoder
  port map(
            A => count(0),
            B => count(1),
            C => count(2),
            Y_N => T_N,
            ENABLE => E,
            RESETN => RESETN
          );


  process(CLK)
  begin
    if RESETN='0' then
      count <= "000";
    elsif rising_edge(CLK) then
      if E='1' then
        if count >= "101" then
          count <= "000";
        else
          count <= std_logic_vector(unsigned(count) + 1);      
        end if;
      end if;
    end if;
  end process;

  T <= not T_N(5 downto 0);

end mod6counter_timer_arch;

