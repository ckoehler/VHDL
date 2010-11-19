LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
USE ieee.numeric_std.ALL;

ENTITY alu_tb IS
  END alu_tb;

ARCHITECTURE behavior OF alu_tb IS 

    -- Component Declaration for the Unit Under Test (UUT)

  COMPONENT alu
    PORT(
          CLK : IN  std_logic;
          TEN : IN  std_logic;
          MEMIO : IN  std_logic;
          XLD : IN  std_logic;
          CIN : IN  std_logic;
          C : IN  std_logic_vector(4 downto 0);
          S : IN integer range 0 to 15;
          T : IN integer range 0 to 15;
          D : IN integer range 0 to 15;
          MEMBUS : IN  std_logic_vector(7 downto 0);
          IOBUS : IN  std_logic_vector(7 downto 0);
          IBUS : INOUT  std_logic_vector(7 downto 0);
          Status : OUT  std_logic_vector(3 downto 0)
        );
  END COMPONENT;


   --Inputs
  signal CLK : std_logic := '0';
  signal TEN : std_logic := '0';
  signal MEMIO : std_logic := '0';
  signal XLD : std_logic := '0';
  signal CIN : std_logic := '0';
  signal S : integer range 0 to 15;
  signal T : integer range 0 to 15;
  signal D : integer range 0 to 15;
  signal C : std_logic_vector(4 downto 0) := (others => '0');
  signal MEMBUS : std_logic_vector(7 downto 0) := (others => '0');
  signal IOBUS : std_logic_vector(7 downto 0) := (others => '0');

   --BiDirs
  signal IBUS : std_logic_vector(7 downto 0);

   --Outputs
  signal Status : std_logic_vector(3 downto 0);

   -- Clock period definitions
  constant CLK_period : time := 50 ns;

  type values_t is array(0 to 15) of integer range 0 to 255;
  constant values: values_t := (0, 17, 34, 51, 68, 85, 102, 119, 136, 153, 170, 187, 204, 221, 238, 255);

BEGIN

   -- Instantiate the Unit Under Test (UUT)
  uut: alu PORT MAP (
                      CLK => CLK,
                      TEN => TEN,
                      MEMIO => MEMIO,
                      XLD => XLD,
                      CIN => CIN,
                      S => S,
                      T => T,
                      D => D,
                      C => C,
                      MEMBUS => MEMBUS,
                      IOBUS => IOBUS,
                      IBUS => IBUS,
                      Status => Status
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

    -- R1 to R4 w/ nop
    C <= "00000";
    D <= 4;
    S <= 1;
    wait for 50 ns;

    -- add R2 + R3 -> R1
    C <= "00001";
    D <= 1;
    S <= 2;
    T <= 3;
    wait for 50 ns;

    -- subtract R7 - R2 -> R4
    C <= "00010";
    D <= 4;
    S <= 7;
    T <= 2;
    wait for 50 ns;

    -- inc R7 + 1 -> R2
    C <= "00011";
    D <= 2;
    S <= 7;
    wait for 50 ns;

    -- dec R2 - 1 -> R2
    C <= "00111";
    D <= 2;
    S <= 2;
    wait for 50 ns;

    -- add R5 + R5 -> R1
    C <= "00001";
    D <= 1;
    S <= 5;
    T <= 5;
    wait for 50 ns;

    -- not R1 -> R0
    C <= "01000";
    D <= 0;
    S <= 1;
    wait for 50 ns;

    -- R5 and R10 -> R1
    C <= "01001";
    D <= 1;
    S <= 5;
    T <= 10;
    wait for 50 ns;

    -- R5 or R10 -> R2
    C <= "01010";
    D <= 2;
    S <= 5;
    T <= 10;
    wait for 50 ns;

    -- R5 xor R15 -> R3
    C <= "01011";
    D <= 3;
    S <= 5;
    T <= 15;
    wait for 50 ns;

    -- R5 xnor R10 -> R4
    C <= "01100";
    D <= 4;
    S <= 5;
    T <= 10;
    wait for 50 ns;


    assert false
    report "All done"
    severity failure;
  end process;

END;
