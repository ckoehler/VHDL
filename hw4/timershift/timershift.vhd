library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity timershift is
  PORT(
        CLK: in std_logic;
        E: in std_logic;
        RESETN: in std_logic;
        T: out std_logic_vector(5 downto 0)
      );

end timershift;

architecture timershift_arch of timershift is

  signal count: std_logic_vector(5 downto 0);
begin

  process(CLK)
  begin
    if RESETN='0' then
      count <= "000001";
    elsif rising_edge(CLK) then
      if E='1' then
        if count >= "100000" then
          count <= "000001";
        else
          count <= count(4 downto 0) & '0';      
        end if;
      end if;
    end if;
  end process;

  T <= count;

end timershift_arch;


