-- 3 to 8 line decoder test bench
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.all;
USE ieee.numeric_std.ALL;

ENTITY quad3to8decoder_tb1 IS
  END quad3to8decoder_tb1;

ARCHITECTURE behavior OF quad3to8decoder_tb1 IS

  -- Component Declaration for the Unit Under Test (UUT)

  COMPONENT quad3to8decoder
    PORT(
          A : IN  std_logic;
          B : IN  std_logic;
          C : IN  std_logic;
          ENABLE : IN  std_logic;
          Y_N : OUT  std_logic_vector(7 downto 0)
        );
  END COMPONENT;

  --Inputs
  signal A : std_logic := '0';
  signal B : std_logic := '0';
  signal C : std_logic := '0';
  signal ENABLE : std_logic := '0'; 
  --Outputs
  signal Y_N : std_logic_vector(7 downto 0);

BEGIN

  -- Instantiate the Unit Under Test (UUT)
  uut: quad3to8decoder PORT MAP (
                                A => A,
                                B => B,
                                C => C,
                                ENABLE => ENABLE,
                                Y_N => Y_N
                              ); 
  -- Stimulus process
  stim_proc: process

  begin  
    -- Enable the decoder and count "000" to "111" on the C, B, A inputs 
    ENABLE <= '1';
    A <= '0';
    B <= '0';
    C <= '0';
    wait for 50 ns;
    assert Y_N = "11111110"
      report "Boo"
      severity failure;

    A <= '1';
    B <= '0';
    C <= '0';
    wait for 50 ns;
    assert Y_N = "11111101"
      report "Boo"
      severity failure;

    A <= '0';
    B <= '1';
    C <= '0';
    wait for 50 ns;
    assert Y_N = "11111011"
      report "Boo"
      severity failure;

    A <= '1';
    B <= '1';
    C <= '0';
    wait for 50 ns;
    assert Y_N = "11110111"
      report "Boo"
      severity failure;

    A <= '0';
    B <= '0';
    C <= '1';
    wait for 50 ns;
    assert Y_N = "11101111"
      report "Boo"
      severity failure;

    A <= '1';
    B <= '0';
    C <= '1';
    wait for 50 ns;
    assert Y_N = "11011111"
      report "Boo"
      severity failure;

    A <= '0';
    B <= '1';
    C <= '1';
    wait for 50 ns;
    assert Y_N = "10111111"
      report "Boo"
      severity failure;

    A <= '1';
    B <= '1';
    C <= '1';
    wait for 50 ns;
    assert Y_N = "01111111"
      report "Boo"
      severity failure;
    --------- Place your stimulus code here --------------- 

    -- Deassert ENABLE and count 000-111 on C, B, A 

    --------- Place your stimulus code here ---------------- 

    assert (false)
    report "Simulation Successful - No Failures"
    severity failure; 
  end process; 

END;

