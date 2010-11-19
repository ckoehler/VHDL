LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
USE ieee.numeric_std.ALL;

ENTITY alu_tb2 IS
  END alu_tb2;

ARCHITECTURE behavior OF alu_tb2 IS 

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

    -- add R10 + R10 -> R4
    C <= "00001";
    D <= 4;
    S <= 10;
    T <= 10;
    wait for 50 ns;

    -- add R15 + R0 + CIN -> R3
    C <= "00100";
    D <= 3;
    S <= 15;
    T <= 0;
    CIN <= '1';
    wait for 50 ns;

    -- R0 - R1 -> R4
    C <= "00010";
    D <= 4;
    S <= 0;
    T <= 1;
    CIN <= '0';
    wait for 50 ns;

    -- R10 - R3 w/ CIN -> R3
    C <= "00101";
    D <= 3;
    S <= 10;
    T <= 3;
    CIN <= '1';
    wait for 50 ns;

    -- LSL R10
    C <= "01101";
    D <= 10;
    S <= 10;
    CIN <= '0';
    wait for 50 ns;

    -- RR R10 -> R10
    C <= "10110";
    D <= 10;
    S <= 10;
    wait for 50 ns;

    -- ASR R10 -> R10
    C <= "01111";
    D <= 10;
    S <= 10;
    wait for 50 ns;

    -- LSR R55 -> R5
    C <= "01110";
    D <= 5;
    S <= 5;
    wait for 50 ns;

    -- RL R5
    C <= "10101";
    D <= 5;
    S <= 5;
    wait for 50 ns;

    -- swap R10
    C <= "10111";
    D <= 10;
    S <= 10;
    wait for 50 ns;


    assert false
    report "All done"
    severity failure;
  end process;

END;
