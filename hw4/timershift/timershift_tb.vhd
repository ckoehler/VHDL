LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY timershift_tb IS
END timershift_tb;
 
ARCHITECTURE behavior OF timershift_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT timershift
    PORT(
         CLK : IN  std_logic;
         E : IN  std_logic;
         RESETN : IN  std_logic;
         T : OUT  std_logic_vector(5 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal CLK : std_logic := '0';
   signal E : std_logic := '0';
   signal RESETN : std_logic := '0';

 	--Outputs
   signal T : std_logic_vector(5 downto 0);

   -- Clock period definitions
   constant CLK_period : time := 50 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: timershift PORT MAP (
          CLK => CLK,
          E => E,
          RESETN => RESETN,
          T => T
        );

   -- Clock process definitions
   CLK_process :process
   begin
		CLK <= '0';
		wait for CLK_period/2;
		CLK <= '1';
		wait for CLK_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	
      RESETN <= '0';
      wait for 50 ns;
      RESETN <= '1';
      E <= '1';

      wait for 400 ns;

      E <= '0';
      wait for 50 ns;

      E <= '1';
      wait for 300 ns;

      RESETN <= '0';

      assert false
      report "All done!"
      severity failure;
   end process;

END;
