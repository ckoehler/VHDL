library IEEE;
use ieee.std_logic_1164.all;

entity mooreshift is
  PORT(
    CLK: in std_logic;
    X: in std_logic;
    RESETN: in std_logic;
    Z: out std_logic);

end mooreshift;

architecture mooreshift_arch of mooreshift is
  signal Q: std_logic_vector(3 downto 0);

begin
  process(CLK, RESETN)
  begin
    if RESETN='0' then
      Q <= "0000";
    elsif rising_edge(CLK) then
      Q <= Q(2 downto 0) & X;
    end if;
  end process;
  Z <= '1' when Q="1010" else 
       '0';

end mooreshift_arch;
