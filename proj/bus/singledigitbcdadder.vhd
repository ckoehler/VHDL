library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity singledigitbcdadder is
  port(
    A,B: in std_logic_vector(3 downto 0);
    Cin: in std_logic;
    
    S: out std_logic_vector(3 downto 0);
    Cout: out std_logic
  );
end singledigitbcdadder;

architecture singledigitbcdadder_arch of singledigitbcdadder is 


  signal Aint, Bint: integer range 0 to 31;
  signal Sint: integer range 0 to 31;

begin

  Aint <= to_integer(unsigned(A));
  Bint <= to_integer(unsigned(B));
  S <= std_logic_vector(to_unsigned(Sint,4));

  process(Aint,Bint,Cin,Sint)
    variable temp: integer := 0;
  begin
    if Cin='0' then
      temp := Aint + Bint;
    else
      temp := Aint + Bint + 1;
    end if;

    if  temp <= 9 then
        Sint <= temp;
        Cout <= '0';
    else
      Sint <= temp + 6;
      Cout <= '1';
    end if;
  end process;
end singledigitbcdadder_arch;
