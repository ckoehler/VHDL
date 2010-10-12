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
        A: in std_logic;

        -- load what's on P when this is asserted
        LDN: in std_logic;

        -- clock...
        CLK: in std_logic;

        -- indicates an error, invalid code
        ERR: out std_logic;

        -- the 5 bit output
        Z: out std_logic_vector(4 downto 0)

      );
end grayto2of5;


architecture grayto2of5_arch of grayto2of5 is

  signal latches: std_logic_vector(3 downto 0);
  signal count: std_logic_vector(1 downto 0);
  signal output_latches: std_logic;

  component converter
    port(
          A: in std_logic_vector(3 downto 0);
          ERR: out std_logic;
          Z: out std_logic_vector(4 downto 0);
          E: in std_logic
        );
  end component;


  component mod4counter
    port(
          CLK: in std_logic;
          SHIFT: in std_logic;
          CLRN: in std_logic;
          Q: out std_logic_vector(1 downto 0)
        );
  end component;


begin

  -- the converter
  the_converter: converter
  port map(
          ERR => ERR,
          Z => Z,
          A => latches,
          E => output_latches
          );

  counter: mod4counter
  port map(
            CLK => CLK,
            SHIFT => SHIFT,
            CLRN => CLRN,
            Q => count
          );

  process(CLK)
  begin
    if CLRN='0' then
      latches <= "0000";
    elsif rising_edge(CLK) then
      if LDN='0' then
        latches <= P;
      elsif SHIFT='1' then
        latches <= latches(2 downto 0) & A;
      end if;
    end if;
  end process;

  output_latches <= '1' when count="11" else
                    '0';

end grayto2of5_arch;

