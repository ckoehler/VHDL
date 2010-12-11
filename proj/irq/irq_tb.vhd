LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE std.textio.all;
use ieee.std_logic_textio.all;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY irq_tb IS
END irq_tb;
 
ARCHITECTURE behavior OF irq_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT buscontroller
    PORT(
         ECLK : IN  std_logic;
         RESET : IN  std_logic;
         A : IN  std_logic_vector(15 downto 8);
         AS : IN  std_logic;
         RW : IN  std_logic;
         INPORT0 : IN  std_logic_vector(7 downto 0);
         INPORT1 : IN  std_logic_vector(7 downto 0);
         INPORT2 : IN  std_logic_vector(7 downto 0);
         INPORT3 : IN  std_logic_vector(7 downto 0);
         INT_IN : IN  std_logic_vector(3 downto 0);
         AD : INOUT  std_logic_vector(7 downto 0);
         DOUT : INOUT  std_logic_vector(7 downto 0);
         ECLKOUT : OUT  std_logic;
         ECLKOUTDEL : OUT  std_logic;
         CLK8 : OUT  std_logic;
         RWOUT : OUT  std_logic;
         WE : OUT  std_logic;
         OE : OUT  std_logic;
         AOUT : OUT  std_logic_vector(15 downto 0);
         OUTPORT0 : OUT  std_logic_vector(7 downto 0);
         OUTPORT1 : OUT  std_logic_vector(7 downto 0);
         OUTPORT2 : OUT  std_logic_vector(7 downto 0);
         OUTPORT3 : OUT  std_logic_vector(7 downto 0);
         IRQN : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal ECLK : std_logic := '0';
   signal RESET : std_logic := '0';
   signal A : std_logic_vector(15 downto 8) := (others => '0');
   signal AS : std_logic := '0';
   signal RW : std_logic := '0';
   signal INPORT0 : std_logic_vector(7 downto 0) := (others => '0');
   signal INPORT1 : std_logic_vector(7 downto 0) := (others => '0');
   signal INPORT2 : std_logic_vector(7 downto 0) := (others => '0');
   signal INPORT3 : std_logic_vector(7 downto 0) := (others => '0');
   signal INT_IN : std_logic_vector(3 downto 0) := (others => '0');

	--BiDirs
   signal AD : std_logic_vector(7 downto 0);
   signal DOUT : std_logic_vector(7 downto 0);

 	--Outputs
   signal ECLKOUT : std_logic;
   signal ECLKOUTDEL : std_logic;
   signal CLK8 : std_logic;
   signal RWOUT : std_logic;
   signal WE : std_logic;
   signal OE : std_logic;
   signal AOUT : std_logic_vector(15 downto 0);
   signal OUTPORT0 : std_logic_vector(7 downto 0);
   signal OUTPORT1 : std_logic_vector(7 downto 0);
   signal OUTPORT2 : std_logic_vector(7 downto 0);
   signal OUTPORT3 : std_logic_vector(7 downto 0);
   signal IRQN : std_logic;

   -- Clock period definitions
   constant ECLK_period : time := 500 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: buscontroller PORT MAP (
          ECLK => ECLK,
          RESET => RESET,
          A => A,
          AS => AS,
          RW => RW,
          INPORT0 => INPORT0,
          INPORT1 => INPORT1,
          INPORT2 => INPORT2,
          INPORT3 => INPORT3,
          INT_IN => INT_IN,
          AD => AD,
          DOUT => DOUT,
          ECLKOUT => ECLKOUT,
          ECLKOUTDEL => ECLKOUTDEL,
          CLK8 => CLK8,
          RWOUT => RWOUT,
          WE => WE,
          OE => OE,
          AOUT => AOUT,
          OUTPORT0 => OUTPORT0,
          OUTPORT1 => OUTPORT1,
          OUTPORT2 => OUTPORT2,
          OUTPORT3 => OUTPORT3,
          IRQN => IRQN
        );

   -- Clock process definitions
   ECLK_process :process
   begin
		ECLK <= '0';
		wait for ECLK_period/2;
		ECLK <= '1';
		wait for ECLK_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
		file cmdfile: text;
		variable l_in, l_out: line;
		variable vRW: std_ulogic;
		variable vA,vAD1,vAD2: std_logic_vector(7 downto 0);
		variable vINT_IN: std_logic_vector(3 downto 0);
	begin		
		file_open(cmdfile, "irq_tb.vec", read_mode);
    AD <= "ZZZZZZZZ";
    DOUT <= "ZZZZZZZZ";
    INPORT0 <= x"00";
    INPORT1 <= x"55";
    INPORT2 <= x"AA";
    INPORT3 <= x"FF";
		 -- wait quite a while for the DCM to init
    wait for 6000 ns;

		while not endfile(cmdfile) loop
			
			readline(cmdfile, l_in);
			next when l_in'length = 0;

			read(l_in,vRW);
			hread(l_in,vA);
			hread(l_in,vAD1);
			hread(l_in,vAD2);
			hread(l_in,vINT_IN);

      INT_IN <= vINT_IN;
			
			-- first cycle
			wait for 62.5 ns;
			A <= vA;
			RW <= vRW;
			wait for 20 ns;
			AD <= vAD1;
			AS <= '1';
			wait for 100 ns;
			AS <= '0';
			wait for 20 ns;
			AD <= "ZZZZZZZZ";
			wait for 47.5 ns;
			wait for 125 ns;
			if RW='0' then
				AD <= vAD2;
			end if;
			wait for 125 ns;

		end loop;

    wait for ECLK_period * 2;

			-- insert stimulus here 

		assert false
		report "All done"
		severity failure;
   end process;

END;
