library IEEE;
use ieee.std_logic_1164.all;

entity my_ckt is
  port ( sig1: in bit;
         sig2: in bit;
         sig3: out bit;);
end my_ckt;

architecture my_ckt_arch of my_ckt is
  --<internal signals>
  signal sigA: bit; -- automatically inout
  component xor2
    port(
          i1,i1: in bit;
          o1: out bit);
  end component;

begin
  --<concurrent statements>
  sig3 <= sig1 and (not sig2);

  --<sequential statements>
  my_proc: process (CLK)
    --<variable declarations>
    variable tmp1: integer;
  begin
  -- case
  -- if
  -- for
  -- only in process
  end process my_proc;

end my_ckt_arch;

