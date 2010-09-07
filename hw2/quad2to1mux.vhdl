library IEEE;
use ieee.std_logic_1164.all;

entity quad2to1mux is
  port(
        A,B: in std_logic_vector(3 downto 0);
        MOUT: out std_logic_vector(3 downto 0);
        E,S: in std_logic);
end quad2to1mux;

architecture quad2to1mux_arch of quad2to1mux is

begin

  MOUT <= A when E = '1' and S = '0' else 
          B when E = '1' and S = '1' else 
          "0000";
end quad2to1mux_arch;



