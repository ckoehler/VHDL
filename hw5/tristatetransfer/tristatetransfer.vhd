library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.registers_pkg.all;

entity tristatetransfer is
  port(
        CLK, TEN, MEMIO, XLD: in std_logic;
        S,D: in integer range 0 to RegQty-1;
        MEMBUS, IOBUS: in std_logic_vector(RegSize-1 downto 0);
        ZBUS: inout std_logic_vector(RegSize-1 downto 0)
);

end tristatetransfer;


architecture tristatetransfer_arch of tristatetransfer is

  type reg_type is array(0 to RegQty-1) of std_logic_vector(RegSize-1 downto 0);

  signal R: reg_type;

begin

  process(CLK)
  begin
    if rising_edge(CLK) then
      if XLD='1' or TEN='1' then
        R(D) <= ZBUS;
      end if;
    end if;
  end process;

  ZBUS <= R(S) when TEN='1' and XLD='0' else
          MemBUS when MEMIO='1' and XLD='1' else
          IOBUS when MEMIO='0' and XLD='1' else
          HiZ;

end tristatetransfer_arch;
