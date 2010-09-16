-- Quad2to1MUX test bench

-- MP Tull 

LIBRARY ieee;

USE ieee.std_logic_1164.ALL;

USE ieee.std_logic_unsigned.all;

USE ieee.numeric_std.ALL;

 

ENTITY Quad2to1MUX_TB1 IS

END Quad2to1MUX_TB1;

 

ARCHITECTURE behavior OF Quad2to1MUX_TB1 IS

 

-- Component Declaration for the Unit Under Test (UUT)

 

COMPONENT quad2to1mux

  PORT(

       A : IN  std_logic_vector(3 downto 0);

       B : IN  std_logic_vector(3 downto 0);

       S : IN  std_logic;

       E : IN  std_logic;

       M_Out : OUT  std_logic_vector(3 downto 0)

       );

END COMPONENT;

     
--Inputs

signal A : std_logic_vector(3 downto 0) := (others => '0');

signal B : std_logic_vector(3 downto 0) := (others => '0');

signal S : std_logic := '0';

signal E : std_logic := '0'; 
--Outputs

signal M_Out : std_logic_vector(3 downto 0);

 

BEGIN

 

-- Instantiate the Unit Under Test (UUT)

uut: quad2to1mux PORT MAP (

     A => A,

     B => B,

     S => S,

     E => E,

     M_Out => M_Out

     );

 

-- Stimulus process

stim_proc: process

begin

-- check that a disabled MUX outputs M_Out = "0000"  

  A <= "1111";  -- drive A inputs high

  B <= "1111";  -- drive B inputs high

  E <= '0';     -- disable MUX

  S <= '0';     -- select the A inputs

  wait for 50 ns;

 

-- Walk a '1' thru the A inputs with B inputs low

  A <= "0001"; -- walk a '1' thru A

  B <= "0000"; -- hold B inputs low

  E <= '1';    -- enable the MUX

 

  wait for 50 ns;

  A <= "0010";

  wait for 50 ns;

  A <= "0100";

  wait for 50 ns;

  A <= "1000";

  wait for 50 ns; 
-- Walk a '1' thru the B inputs with A inputs low

  S <= '1';     -- select the B inputs

  A <= "0000";  -- hold A inputs low

  B <= "0001";  -- walk a '1' thru B

 

  wait for 50 ns;

  B <= "0010";

  wait for 50 ns;

  B <= "0100";

  wait for 50 ns;

  B <= "1000";

  wait for 100 ns;

 

  assert (false)

    report "Simulation Successful - No Failures"

    severity failure;

 

end process; 

END; 