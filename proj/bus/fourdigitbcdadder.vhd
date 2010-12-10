library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity fourdigitbcdadder is
  port(
        A,B: in std_logic_vector(15 downto 0);
        Cin: in std_logic;

        S: out std_logic_vector(15 downto 0);
        Cout: out std_logic
      );
end fourdigitbcdadder;

architecture fourdigitbcdadder_arch of fourdigitbcdadder is 


  -- intermediate carry signals
  signal C: std_logic_vector(4 downto 0);

  component singledigitbcdadder
    port (
    A, B: in std_logic_vector(3 downto 0);
    Cin: in std_logic;
    S: out std_logic_vector(3 downto 0); 
    Cout: out std_logic);
  end component;

begin
  C(0) <= Cin;
  BCD4: for i in 0 to 3 generate
  begin
    BCDx: singledigitbcdadder
    port map 
    (
      A => A(4*i+3 downto i*4), 
      B => B(4*i+3 downto i*4), 
      Cin => C(i),
      S => S(4*i+3 downto i*4), 
      Cout => C(i+1)
    );
  end generate;
  Cout <= C(4);

end fourdigitbcdadder_arch;

