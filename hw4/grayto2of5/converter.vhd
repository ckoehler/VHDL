library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity converter is
  PORT(
        A: in std_logic_vector(3 downto 0);
        ERR: out std_logic;
        Z: out std_logic_vector(4 downto 0);
        E: in std_logic
      );
end converter;

architecture converter_arch of converter is
  signal tempz: std_logic_vector(4 downto 0);
  type array_t is array(0 to 15) of std_logic_vector(4 downto 0);
  constant Two_of_5: array_t := ("00011", "00110", "01001", "00101", "01100", "10001", "01010", 
  "10010", "11111", "11111", "11111", "11111", "11111", "11111", "11000", "10100");

begin

  tempz <= Two_of_5(to_integer(unsigned(A)));
  ERR <= '1' when tempz="11111" else
         '0';
  Z <= tempz when E='1';
end converter_arch;

