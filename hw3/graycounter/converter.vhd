library IEEE;
use ieee.std_logic_1164.all;

entity converter is
  PORT(
        A: in std_logic_vector(3 downto 0);
        Z: out std_logic_vector(3 downto 0)
      );
end converter;

architecture converter_arch of converter is

begin
  Z(0) <= A(0) xor A(1);
  Z(1) <= A(1) xor A(2);
  Z(2) <= A(2) xor A(3);
  Z(3) <= A(3);
end converter_arch;
