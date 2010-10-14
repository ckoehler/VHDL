library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mod4counter is
  PORT(
        CLK: in std_logic;
        SHIFT: in std_logic;
        CLRN: in std_logic;
        LDN: in std_logic;
        Q: out integer range 0 to 3
      );

end mod4counter;

architecture mod4counter_arch of mod4counter is

  signal counter: integer range 0 to 3;

begin
  process(CLK, CLRN)
  begin
    if CLRN='0' then
      counter <= 3;
    elsif rising_edge(CLK) then
      if LDN='0' then
        counter <= 3;
      elsif SHIFT='1' then
        if counter=3 then
          counter <= 0;
        else
          counter <= counter + 1;
        end if;
      end if;
    end if;
  end process;

  Q <= counter;

end mod4counter_arch;
