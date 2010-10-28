library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity regtransfer is
  port(
        TEN: in std_logic;
        S: in integer range 0 to 15;
        D: in integer range 0 to 15;
        CLK: in std_logic;
        MEMBUS: in std_logic_vector(7 downto 0);
        IOBUS: in std_logic_vector(7 downto 0);
        MEMIO: in std_logic;
        XLD: in std_logic;
        DOUT: inout std_logic_vector(7 downto 0)
);

end regtransfer;

architecture regtransfer_arch of regtransfer is

  type reg_type is array(0 to 15) of std_logic_vector(7 downto 0);

  signal IBUS: std_logic_vector(7 downto 0);
  signal R: reg_type;

begin

  process(CLK)
  begin
    if rising_edge(CLK) then
      if XLD='1' then
        R(D) <= IBUS;
      elsif TEN='1' then
        R(D) <= DOUT;
      end if;
    end if;
  end process;

  DOUT <= R(S);

  IBUS <= MemBUS when MEMIO='1' else
          IOBUS when MEMIO='0';

end regtransfer_arch;
