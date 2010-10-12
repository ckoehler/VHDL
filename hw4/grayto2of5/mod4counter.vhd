library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mod4counter is
  PORT(
        CLK: in std_logic;
        SHIFT: in std_logic;
        CLRN: in std_logic;
        Q: out std_logic_vector(1 downto 0)
      );

end mod4counter;

architecture mod4counter_arch of mod4counter is

  signal counter: std_logic_vector(1 downto 0);

begin
  process(CLK)
  begin
    if CLRN='0' then
      counter <= "11";
    elsif rising_edge(CLK) then
      if SHIFT='1' then
        if counter="11" then
          counter <= "00";
        else
          counter <= std_logic_vector(unsigned(counter) + 1);      
        end if;
      end if;
    end if;
  end process;

  Q <= counter;

end mod4counter_arch;
