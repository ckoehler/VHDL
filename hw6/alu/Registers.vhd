--	Package File Template
--
--	Purpose: This package defines supplemental types, subtypes, 
--		 constants, and functions 


library IEEE;
use IEEE.STD_LOGIC_1164.all;
use ieee.numeric_std.all;

package registers_pkg is

-- Declare constants

  constant RegBasis		: integer := 4;
  constant RegQty : integer := 2**RegBasis;
  constant RegSize : integer := 8;
  constant HiZ: std_logic_vector(RegSize-1 downto 0) := (others => 'Z');
  constant Zeros: std_logic_vector(RegSize-1 downto 0) := (others => '0');

  procedure adder(l,r:  in unsigned; c:  in std_logic; res: out unsigned; co: out std_logic);

end registers_pkg;

package body registers_pkg is


  procedure adder(l, r: in unsigned; c: in std_logic; res: out unsigned; co: out std_logic) is
    constant l_left: integer := l'length-1;
    alias xl: unsigned(l_left downto 0) is l;
    alias xr: unsigned(l_left downto 0) is r;
    variable result: unsigned(l_left downto 0);
    variable cbit: std_logic := c;
  begin
    for i in 0 to l_left loop
      result(i) := cbit xor xl(i) xor xr(i);
      cbit := (cbit and xl(i)) or (cbit and xr(i)) or (xl(i) and xr(i));
    end loop;
		co := cbit;
    res := result;
  end adder;

end package body;
