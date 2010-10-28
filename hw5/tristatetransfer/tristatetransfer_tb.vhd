LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use ieee.numeric_std.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;

ENTITY tristatetransfer_tb IS
  END tristatetransfer_tb;

ARCHITECTURE behavior OF tristatetransfer_tb IS 

    -- Component Declaration for the Unit Under Test (UUT)

  COMPONENT tristatetransfer
    PORT(
          CLK : IN  std_logic;
          TEN : IN  std_logic;
          MEMIO : IN  std_logic;
          S: in integer range 0 to 15;
          D: in integer range 0 to 15;
          XLD : IN  std_logic;
          MEMBUS : IN  std_logic_vector(7 downto 0);
          IOBUS : IN  std_logic_vector(7 downto 0);
          ZBUS : INOUT  std_logic_vector(7 downto 0)
        );
  END COMPONENT;


   --Inputs
  signal CLK : std_logic := '0';
  signal TEN : std_logic := '0';
  signal MEMIO : std_logic := '0';
  signal S : integer range 0 to 15;
  signal D : integer range 0 to 15;
  signal XLD : std_logic := '0';
  signal MEMBUS : std_logic_vector(7 downto 0) := (others => '0');
  signal IOBUS : std_logic_vector(7 downto 0) := (others => '0');

   --BiDirs
  signal ZBUS : std_logic_vector(7 downto 0);

   -- Clock period definitions
  constant CLK_period : time := 50 ns;

  type values_t is array(0 to 15) of integer range 0 to 255;
  constant values: values_t := (0, 17, 34, 51, 68, 85, 102, 119, 136, 153, 170, 187, 204, 221, 238, 255);

BEGIN

   -- Instantiate the Unit Under Test (UUT)
  uut: tristatetransfer PORT MAP (
                                   CLK => CLK,
                                   TEN => TEN,
                                   MEMIO => MEMIO,
                                   XLD => XLD,
                                   S => S,
                                   D => D,
                                   MEMBUS => MEMBUS,
                                   IOBUS => IOBUS,
                                   ZBUS => ZBUS
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
  XLD <= '1';
  MEMIO <= '1';

  memioinputloop: for i in 0 to 7 loop
    MEMBUS <= std_logic_vector(to_unsigned(values(i),8));
    D <= i;
    S <= i;
    wait for 50 ns;
  end loop memioinputloop;

  MEMIO <= '0';
  iobusinputloop: for i in 8 to 15 loop
    IOBUS <= std_logic_vector(to_unsigned(values(i),8));
    D <= i;
    S <= i;
    wait for 50 ns;
  end loop iobusinputloop;

  XLD <= '0';
  TEN <= '1';

  S <= 3;
  D <= 0;
  wait for 50 ns;

  S <= 1;
  D <= 5;
  wait for 50 ns;

  S <= 2;
  D <= 6;
  wait for 50 ns;

  S <= 4;
  D <= 3;
  wait for 50 ns;

  S <= 0;
  D <= 7;
  wait for 50 ns;

  S <= 15;
  D <= 0;
  wait for 50 ns;

  S <= 8;
  D <= 10;
  wait for 50 ns;

  S <= 10;
  D <= 12;
  wait for 50 ns;

  S <= 13;
  D <= 15;
  wait for 50 ns;

  assert false
  report "All done"
  severity failure;
end process;

END;
