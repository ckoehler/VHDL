--	Package File Template
--
--	Purpose: This package defines supplemental types, subtypes, 
--		 constants, and functions 


library IEEE;
use IEEE.STD_LOGIC_1164.all;

package registers_pkg is

-- Declare constants

  constant RegBasis		: integer := 4;
  constant RegQty : integer := 2**RegBasis;
  constant RegSize : integer := 8;
  constant HiZ: std_logic_vector(RegSize-1 downto 0) := (others => 'Z');
 
end registers_pkg;
