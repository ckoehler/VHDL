library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity graycounter is
  PORT(
        CLK: in std_logic;
        E: in std_logic;
        RESET: in std_logic;
    -- loads D into G if low. Is overridden by RESET.
        LDN: in std_logic;
    -- loads the counter directly if LDN is low
        D: in std_logic_vector(3 downto 0);
    -- count up if high, down if low
        UD: in std_logic;

    -- high if G="0000" and UD='1',
    -- low  if G="1000" and UD='0'
        COUT: out std_logic;
        G: out std_logic_vector(3 downto 0)
      );
end graycounter;

architecture graycounter_arch of graycounter is

  component converter
    port(
          A: in std_logic_vector(3 downto 0);
          Z: out std_logic_vector(3 downto 0)
        );
  end component;

  signal counter: std_logic_vector(3 downto 0);

begin

  -- first, hook up the converter to the output.
  -- our internal counter goes to the input of the converter,
  -- and the output of the converter goes to our output Z.
  grayconverter: converter
  port map(
            A => counter, 
            Z => G
          );

  -- now define the process
  process(CLK)
  begin
    -- all this stuff is synchronous
    if rising_edge(CLK) then
      if(RESET='1') then
        counter <= "0000";
      elsif(LDN='0') then
        counter <= D;
      elsif(E='1') then
        if(UD='1') then
          if(counter="1111") then
            counter <= "0000";
          else
            counter <= std_logic_vector(unsigned(counter) + 1);
            --counter <= counter + '1';
          end if;
        else
          if(counter="0000") then
            counter <= "1111";
          else
            counter <= std_logic_vector(unsigned(counter) - 1);
            --counter <= counter - "0001";
          end if;
        end if;
      end if;
    end if;
  end process;
  COUT <= '1' when counter="1111" and UD='1' else
          '1' when counter="0000" and UD='0' else
          '0';

end graycounter_arch;
