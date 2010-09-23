LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;

ENTITY mooreshift_tb IS
END mooreshift_tb;

ARCHITECTURE behavior OF mooreshift_tb IS 

    -- Component Declaration for the Unit Under Test (UUT)

  COMPONENT mooreshift
    PORT(
          CLK : IN  std_logic;
          RESETN : IN  std_logic;
          X : IN  std_logic;
          Z : OUT  std_logic
        );
  END COMPONENT;


   --Inputs
  signal CLK : std_logic := '0';
  signal RESETN : std_logic := '0';
  signal X : std_logic := '0';

   --Outputs
  signal Z : std_logic;

   -- Clock period definitions
  constant CLK_period : time := 50 ns;

BEGIN

   -- Instantiate the Unit Under Test (UUT)
  uut: mooreshift PORT MAP (
                           CLK => CLK,
                           RESETN => RESETN,
                           X => X,
                           Z => Z
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
    RESETN <= '0';
    wait for 100 ns;

    RESETN <= '1';
    X <= '1';
    wait for 50 ns;
    assert(Z='0')
      report "output not right"
      severity failure;

    X <= '0';
    wait for 50 ns;
    assert(Z='0')
      report "output not right"
      severity failure;

    X <= '1';
    wait for 50 ns;
    assert(Z='0')
      report "output not right"
      severity failure;

    X <= '0';
    wait for 50 ns;
    assert(Z='1')
      report "output not right"
      severity failure;

    X <= '1';
    wait for 50 ns;
    assert(Z='0')
      report "output not right"
      severity failure;

    X <= '0';
    wait for 50 ns;
    assert(Z='1')
      report "output not right"
      severity failure;

    X <= '0';
    wait for 50 ns;
    assert(Z='0')
      report "output not right"
      severity failure;

    X <= '0';
    wait for 50 ns;
    assert(Z='0')
      report "output not right"
      severity failure;

    X <= '1';
    wait for 50 ns;
    assert(Z='0')
      report "output not right"
      severity failure;

    X <= '1';
    wait for 50 ns;
    assert(Z='0')
      report "output not right"
      severity failure;

    X <= '0';
    wait for 50 ns;
    assert(Z='0')
      report "output not right"
      severity failure;

    X <= '0';
    wait for 50 ns;
    assert(Z='0')
      report "output not right"
      severity failure;

    X <= '1';
    wait for 50 ns;
    assert(Z='0')
      report "output not right"
      severity failure;

    X <= '0';
    wait for 50 ns;
    assert(Z='0')
      report "output not right"
      severity failure;

    X <= '1';
    wait for 50 ns;
    assert(Z='0')
      report "output not right"
      severity failure;

    X <= '1';
    wait for 50 ns;
    assert(Z='0')
      report "output not right"
      severity failure;

    X <= '0';
    wait for 50 ns;
    assert(Z='0')
      report "output not right"
      severity failure;

    X <= '1';
    wait for 50 ns;
    assert(Z='0')
      report "output not right"
      severity failure;

    X <= '0';
    wait for 50 ns;
    assert(Z='1')
      report "output not right"
      severity failure;

    RESETN <= '0';
    wait for 50 ns;
    RESETN <= '1';
    wait for 50 ns;

    assert(false)
      report "all good!"
      severity failure;

    wait;
  end process;

END;
