library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity grayto2of5 is
  PORT(
        -- clear the converter
        CLRN: in std_logic;

        -- what will be loaded when LDN is asserted
        P: in std_logic_vector(3 downto 0);

        -- listen for stuff on A when this is asserted
        SHIFT: in std_logic;

        -- serial input
        SERIAL_IN: in std_logic;

        -- load what's on P when this is asserted
        LDN: in std_logic;

        -- clock...
        CLK: in std_logic;

        -- indicates an error, invalid code
        ERROR2of5: out std_logic;

        -- the 5 bit output
        D: out std_logic_vector(4 downto 0)

      );
end grayto2of5;


architecture grayto2of5_arch of grayto2of5 is

  signal latches: std_logic_vector(3 downto 0);
  signal shift_register: std_logic_vector(3 downto 0);
  signal counter: integer range 0 to 3;

  component converter
    port(
          A: in std_logic_vector(3 downto 0);
          Z: out std_logic_vector(4 downto 0)
        );
  end component;


begin

  -- the converter
  the_converter: converter
  port map(
          Z => D,
          A => latches
          );


  -- shift register process
  process(CLK, CLRN)
  begin
    if CLRN='0' then
      shift_register <= "0000";
    elsif rising_edge(CLK) then
      if LDN='0' then
        shift_register <= P;
      elsif SHIFT='1' then
        shift_register <= shift_register(2 downto 0) & SERIAL_IN;
      end if;
    end if;
  end process;

  -- error handling
  ERROR2of5 <= '1' when latches="1000" or latches="1001" or latches="1010" or latches="1011" or latches="1100" or latches="1101" else
               '0';

  -- SR to latches logic process 
  process(counter, shift_register)
  begin
    if counter=3 then
      latches <= shift_register;
    end if;
  end process;

  -- counter process
  process(CLK, CLRN)
  begin
    if CLRN='0' then
      counter <= 3;
    elsif rising_edge(CLK) then
      if LDN='0' then
        counter <= 3;
      elsif SHIFT='1' then
        if counter=3 then
          counter <= 0;
        else
          counter <= counter + 1;
        end if;
      end if;
    end if;
  end process;


end grayto2of5_arch;

