library IEEE;
use ieee.std_logic_1164.all;

entity quad2to4decoder is
  port(
        S: in std_logic_vector(1 downto 0);
        OUT_N: out std_logic_vector(3 downto 0);
        E: in std_logic);
end quad2to4decoder;

architecture quad2to4decoder_arch of quad2to4decoder is

begin

  OUT_N <= "1110" when E='1' and S="00" else
           "1101" when E='1' and S="01" else
           "1011" when E='1' and S="10" else
           "0111" when E='1' and S="11" else
           "1111";

end quad2to4decoder_arch;




