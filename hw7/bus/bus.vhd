library IEEE;
library UNISIM;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use unisim.vcomponents.all;


entity buscontroller is
  port(
  ECLK, RESET : in std_logic;
  A           : in std_logic_vector(15 downto 8);
  AS          : in std_logic;
  RW          : in std_logic;
  INPORT1     : in std_logic_vector(7 downto 0);
  INPORT2     : in std_logic_vector(7 downto 0);
  INPORT3     : in std_logic_vector(7 downto 0);
  INPORT4     : in std_logic_vector(7 downto 0);

  AD          : inout std_logic_vector(7 downto 0);
  DOUT        : inout std_logic_vector(7 downto 0);

  ECLKOUT     : out std_logic;
  ECLKOUTDEL  : out std_logic;
  CLK8        : out std_logic; -- DCM 8 MHz clock
  RWOUT       : out std_logic;
  WE          : out std_logic;
  OE          : out std_logic;
  AOUT        : out std_logic_vector(15 downto 0);
  OUTPORT1    : out std_logic_vector(7 downto 0);
  OUTPORT2    : out std_logic_vector(7 downto 0);
  OUTPORT3    : out std_logic_vector(7 downto 0);
  OUTPORT4    : out std_logic_vector(7 downto 0)
);

end buscontroller;


architecture bus_arch of buscontroller is

  type multiport_t is array(0 to 3) of std_logic_vector(7 downto 0);

  signal CS: std_logic_vector(15 downto 0);
  signal CSIN: std_logic_vector(3 downto 0);
  signal CSEN: std_logic;
  signal ECLKBuf: std_logic;  -- ECLK from Input Buffer
  signal ECLKDelayBuf: std_logic;  -- ECLK from Input Buffer
  signal ECLKDelay: std_logic; -- local delayed ECLK
  signal DCMCLK8: std_logic;  -- CLK8 from DCM
begin

  -- DCM_SP: Digital Clock Manager Circuit
  --         Spartan-3E
  -- Xilinx HDL Language Template, version 12.2
  delayedDCM:DCM_SP
  generic map 
  (
    CLKDV_DIVIDE => 4.0, --  Divide by: 1.5,2.0,2.5,3.0,3.5,4.0,4.5,5.0,5.5,6.0,6.5
                         --     7.0,7.5,8.0,9.0,10.0,11.0,12.0,13.0,14.0,15.0 or 16.0
    CLKFX_DIVIDE => 1,   --  Can be any interger from 1 to 32
    CLKFX_MULTIPLY => 2, --  Can be any integer from 1 to 32
    CLKIN_DIVIDE_BY_2 => FALSE, --  TRUE/FALSE to enable CLKIN divide by two feature
    CLKIN_PERIOD => 500.0, --  Specify period of input clock
    CLKOUT_PHASE_SHIFT => "FIXED", --  Specify phase shift of "NONE", "FIXED" or "VARIABLE" 
    CLK_FEEDBACK => "1X",         --  Specify clock feedback of "NONE", "1X" or "2X" 
    DESKEW_ADJUST => "SYSTEM_SYNCHRONOUS", -- "SOURCE_SYNCHRONOUS", "SYSTEM_SYNCHRONOUS" or
                                           --     an integer from 0 to 15
    DLL_FREQUENCY_MODE => "LOW",     -- "HIGH" or "LOW" frequency mode for DLL
    DUTY_CYCLE_CORRECTION => TRUE, --  Duty cycle correction, TRUE or FALSE
    PHASE_SHIFT => 32,        --  Amount of fixed phase shift from -255 to 255
    STARTUP_WAIT => FALSE
  ) --  Delay configuration DONE until DCM_SP LOCK, TRUE/FALSE
  port map 
  (
    CLK0 => ECLKDelay,     -- 0 degree DCM CLK ouptput
    CLK180 => open, -- 180 degree DCM CLK output
    CLK270 => open, -- 270 degree DCM CLK output
    CLK2X => open,   -- 2X DCM CLK output
    CLK2X180 => open, -- 2X, 180 degree DCM CLK out
    CLK90 => open,   -- 90 degree DCM CLK output
    CLKDV => open,   -- Divided DCM CLK out (CLKDV_DIVIDE)
    CLKFX => open,   -- DCM CLK synthesis out (M/D)
    CLKFX180 => open, -- 180 degree CLK synthesis out
    LOCKED => open, -- DCM LOCK status output
    PSDONE => open, -- Dynamic phase adjust done output
    STATUS => open, -- 8-bit DCM status bits output
    CLKFB => ECLKDelayBuf,   -- DCM clock feedback
    CLKIN => ECLKDelayBuf,   -- Clock input (from IBUFG, BUFG or DCM)
    PSCLK => '0',   -- Dynamic phase adjust clock input
    PSEN => '0',     -- Dynamic phase adjust enable input
    PSINCDEC => '0', -- Dynamic phase adjust increment/decrement
    RST => '0'        -- DCM asynchronous reset input
  );

  IBUFG2_inst : IBUFG
  generic map 
  (
    IOSTANDARD => "DEFAULT"
  )
  port map 
  (
    O => ECLKDelayBuf, -- Clock buffer output
    I => ECLK    -- Clock buffer input (connect directly to top-level port)
  );

  theDCM:DCM_SP
  generic map 
  (
    CLKDV_DIVIDE => 2.0, --  Divide by: 1.5,2.0,2.5,3.0,3.5,4.0,4.5,5.0,5.5,6.0,6.5
                         --     7.0,7.5,8.0,9.0,10.0,11.0,12.0,13.0,14.0,15.0 or 16.0
    CLKFX_DIVIDE => 1,   --  Can be any interger from 1 to 32
    CLKFX_MULTIPLY => 4, --  Can be any integer from 1 to 32
    CLKIN_DIVIDE_BY_2 => FALSE, --  TRUE/FALSE to enable CLKIN divide by two feature
    CLKIN_PERIOD => 500.0, --  Specify period of input clock
    CLKOUT_PHASE_SHIFT => "NONE", --  Specify phase shift of "NONE", "FIXED" or "VARIABLE" 
    CLK_FEEDBACK => "1X",         --  Specify clock feedback of "NONE", "1X" or "2X" 
    DESKEW_ADJUST => "SYSTEM_SYNCHRONOUS", -- "SOURCE_SYNCHRONOUS", "SYSTEM_SYNCHRONOUS" or
                                           --     an integer from 0 to 15
    DLL_FREQUENCY_MODE => "LOW",     -- "HIGH" or "LOW" frequency mode for DLL
    DUTY_CYCLE_CORRECTION => TRUE, --  Duty cycle correction, TRUE or FALSE
    PHASE_SHIFT => 0,        --  Amount of fixed phase shift from -255 to 255
    STARTUP_WAIT => FALSE) --  Delay configuration DONE until DCM_SP LOCK, TRUE/FALSE
  port map 
  (
    CLK0 => open,     -- 0 degree DCM CLK ouptput
    CLK180 => open, -- 180 degree DCM CLK output
    CLK270 => open, -- 270 degree DCM CLK output
    CLK2X => open,   -- 2X DCM CLK output
    CLK2X180 => open, -- 2X, 180 degree DCM CLK out
    CLK90 => open,   -- 90 degree DCM CLK output
    CLKDV => open,   -- Divided DCM CLK out (CLKDV_DIVIDE)
    CLKFX => DCMCLK8,   -- DCM CLK synthesis out (M/D)
             --CLKFX180 => CLK8, -- 180 degree CLK synthesis out
    LOCKED => open, -- DCM LOCK status output
    PSDONE => open, -- Dynamic phase adjust done output
    STATUS => open, -- 8-bit DCM status bits output
    CLKFB => ECLKBuf,   -- DCM clock feedback
    CLKIN => ECLKBuf,   -- Clock input (from IBUFG, BUFG or DCM)
    PSCLK => open,   -- Dynamic phase adjust clock input
    PSEN => open,     -- Dynamic phase adjust enable input
    PSINCDEC => open, -- Dynamic phase adjust increment/decrement
    RST => '0'        -- DCM asynchronous reset input
  );

  IBUFG_inst : IBUFG
  generic map 
  (
    IOSTANDARD => "DEFAULT")
  port map 
  (
    O => ECLKBuf, -- Clock buffer output
    I => ECLK    -- Clock buffer input (connect directly to top-level port)
  );
  BUFG_inst : BUFG
  port map 
  (
    O => CLK8,     -- Clock buffer output
    I => DCMCLK8   -- Clock buffer input
  );


  -- End of DCM_SP_inst instantiation

  as_latching: process(AS)
  begin
    if(AS='1') then
      AOUT(7 downto 0) <= AD;
    end if;
  end process;

  -- if RW='0' and CS(12) = '0'
  outport_latching: process(ECLK)
  begin
    if falling_edge(ECLK) then
      if RW='0' and CS(12)='0' then
        OUTPORT1 <= AD(7 downto 0);
      elsif RW='1' and CS(12)='0' then
        AD(7 downto 0) <= INPORT1; 
      end if;
    end if;
  end process;


  AOUT(15 downto 8) <= A;
  DOUT <= AD when ECLKDelay='0';

  CSEN <= ECLK or ECLKDelay;
  CSIN <= A(15 downto 12);
  CS <= "1111111111111110" when CSIN="0000" and CSEN='1' else
        "1111111111111101" when CSIN="0001" and CSEN='1' else
        "1111111111111011" when CSIN="0010" and CSEN='1' else
        "1111111111110111" when CSIN="0011" and CSEN='1' else
        "1111111111101111" when CSIN="0100" and CSEN='1' else
        "1111111111011111" when CSIN="0101" and CSEN='1' else
        "1111111110111111" when CSIN="0110" and CSEN='1' else
        "1111111101111111" when CSIN="0111" and CSEN='1' else
        "1111111011111111" when CSIN="1000" and CSEN='1' else
        "1111110111111111" when CSIN="1001" and CSEN='1' else
        "1111101111111111" when CSIN="1010" and CSEN='1' else
        "1111011111111111" when CSIN="1011" and CSEN='1' else
        "1110111111111111" when CSIN="1100" and CSEN='1' else
        "1101111111111111" when CSIN="1101" and CSEN='1' else
        "1011111111111111" when CSIN="1110" and CSEN='1' else
        "0111111111111111" when CSIN="1111" and CSEN='1' else
        "1111111111111111";

  ECLKOUT <= ECLK;
  ECLKOUTDEL <= ECLKDelay;


  RWOUT <= RW;
  WE <= RW;
  OE <= not RW;

end bus_arch;

