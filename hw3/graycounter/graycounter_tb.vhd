LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;

ENTITY graycounter_tb IS
  END graycounter_tb;

ARCHITECTURE behavior OF graycounter_tb IS 

    -- Component Declaration for the Unit Under Test (UUT)

  COMPONENT graycounter
    PORT(
          CLK : IN  std_logic;
          E : IN  std_logic;
          RESET : IN  std_logic;
          LDN : IN  std_logic;
          D : IN  std_logic_vector(3 downto 0);
          UD : IN  std_logic;
          COUT : OUT  std_logic;
          G : OUT  std_logic_vector(3 downto 0)
        );
  END COMPONENT;


   --Inputs
  signal CLK : std_logic := '0';
  signal E : std_logic := '0';
  signal RESET : std_logic := '0';
  signal LDN : std_logic := '0';
  signal D : std_logic_vector(3 downto 0) := (others => '0');
  signal UD : std_logic := '0';

   --Outputs
  signal COUT : std_logic;
  signal G : std_logic_vector(3 downto 0);

   -- Clock period definitions
  constant CLK_period : time := 50 ns;

BEGIN

   -- Instantiate the Unit Under Test (UUT)
  uut: graycounter PORT MAP (
                              CLK => CLK,
                              E => E,
                              RESET => RESET,
                              LDN => LDN,
                              D => D,
                              UD => UD,
                              COUT => COUT,
                              G => G
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

   -- first simulation
   --RESET <= '1';
   --wait for 50 ns;

   --RESET <= '0';
   --UD <= '1';
   --E <= '1';
   --LDN <= '1';

   ---- count
   --wait for 800 ns;

   --assert(false)
   --report("All done")
   --severity(failure);

   -- second simulation
  RESET <= '1';
  wait for 50 ns;
  RESET <= '0';
  UD <= '0';
  E <= '1';
  LDN <= '1';

  -- count
  wait for 200 ns;

  UD <= '1';
  
  wait for 400 ns;

  D <= "0001";
  LDN <= '0';
  UD <= '0';
  wait for 50 ns;
  LDN <= '1';

  wait for 400 ns;

  assert(false)
  report "All done"
  severity failure;


end process;

END;
