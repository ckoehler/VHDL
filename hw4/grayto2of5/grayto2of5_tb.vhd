LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
USE ieee.numeric_std.ALL;
 
ENTITY grayto2of5_tb IS
END grayto2of5_tb;
 
ARCHITECTURE behavior OF grayto2of5_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT grayto2of5
    PORT(
         CLRN : IN  std_logic;
         P : IN  std_logic_vector(3 downto 0);
         SHIFT : IN  std_logic;
         SERIAL_IN : IN  std_logic;
         LDN : IN  std_logic;
         CLK : IN  std_logic;
         ERROR2of5 : OUT  std_logic;
         D : OUT  std_logic_vector(4 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal CLRN : std_logic := '0';
   signal P : std_logic_vector(3 downto 0) := (others => '0');
   signal SHIFT : std_logic := '0';
   signal SERIAL_IN : std_logic := '0';
   signal LDN : std_logic := '0';
   signal CLK : std_logic := '0';

 	--Outputs
   signal ERROR2of5 : std_logic;
   signal D : std_logic_vector(4 downto 0);

   -- Clock period definitions
   constant CLK_period : time := 50 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: grayto2of5 PORT MAP (
          CLRN => CLRN,
          P => P,
          SHIFT => SHIFT,
          SERIAL_IN => SERIAL_IN,
          LDN => LDN,
          CLK => CLK,
          ERROR2of5 => ERROR2of5,
          D => D
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

      --
      --
      -- Scenario 1
      --
      --

      --CLRN <= '0';

      --wait for 50 ns;
      --CLRN <= '1';
      --LDN <= '0';

      --P <= "0000";
      --wait for 50 ns;
      --assert D="00011"
      --report "wrong value"
      --severity failure;

      --P <= "0001";
      --wait for 50 ns;
      --assert D="00110"
      --report "wrong value"
      --severity failure;

      --P <= "0011";
      --wait for 50 ns;
      --assert D="00101"
      --report "wrong value"
      --severity failure;

      --P <= "0010";
      --wait for 50 ns;
      --assert D="01001"
      --report "wrong value"
      --severity failure;

      --P <= "0110";
      --wait for 50 ns;
      --assert D="01010"
      --report "wrong value"
      --severity failure;

      --P <= "0100";
      --wait for 50 ns;
      --assert D="01100"
      --report "wrong value"
      --severity failure;

      --P <= "0101";
      --wait for 50 ns;
      --assert D="10001"
      --report "wrong value"
      --severity failure;

      --P <= "0111";
      --wait for 50 ns;
      --assert D="10010"
      --report "wrong value"
      --severity failure;

      --P <= "1111";
      --wait for 50 ns;
      --assert D="10100"
      --report "wrong value"
      --severity failure;

      --P <= "1110";
      --wait for 50 ns;
      --assert D="11000"
      --report "wrong value"
      --severity failure;

      --P <= "1100";
      --wait for 50 ns;
      --assert D="11111"
      --report "wrong value"
      --severity failure;

      --P <= "1101";
      --wait for 50 ns;
      --assert D="11111"
      --report "wrong value"
      --severity failure;

      --P <= "1001";
      --wait for 50 ns;
      --assert D="11111"
      --report "wrong value"
      --severity failure;

      --P <= "1011";
      --wait for 50 ns;
      --assert D="11111"
      --report "wrong value"
      --severity failure;

      --P <= "1010";
      --wait for 50 ns;
      --assert D="11111"
      --report "wrong value"
      --severity failure;

      --P <= "1000";
      --wait for 50 ns;
      --assert D="11111"
      --report "wrong value"
      --severity failure;


      --
      --
      -- Scenario 2
      --
      --
      LDN <= '1';
      CLRN <= '0';
      wait for 50 ns;
      CLRN <= '1';

      assert D="00011"
      report "wrong value"
      severity failure;

      SHIFT <= '0';
      wait for 50 ns;
      SHIFT <= '1';
      SERIAL_IN <= '1';
      wait for 200 ns;

      SHIFT <= '0';
      
      wait for 50 ns;
      SHIFT <= '1';
      LDN <= '0';
      P <= "1110";
      SERIAL_IN <= '0';

      wait for 50 ns;
      LDN <= '1';

      wait for 200 ns;

      SERIAL_IN <= '1';
      wait for 300 ns;


      assert false
      report "All done!"
      severity failure;
   end process;

END;
