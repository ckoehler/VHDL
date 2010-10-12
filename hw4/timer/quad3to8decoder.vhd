library IEEE;
use ieee.std_logic_1164.all;

entity quad3to8decoder is
  port(
        A,B,C: in std_logic;
        Y_N: out std_logic_vector(7 downto 0);
        ENABLE: in std_logic;
        RESETN: in std_logic
      );
end quad3to8decoder;


architecture quad3to8decoder_arch of quad3to8decoder is
  component quad2to4decoder
    port(
          E: in std_logic;
          S: in std_logic_vector(1 downto 0);
          OUT_N: out std_logic_vector(3 downto 0)
        );
  end component;

  signal CN: std_logic;
  signal YTemp: std_logic_vector(7 downto 0);

begin
  CN <= not C;
  DecoderLow: quad2to4decoder
  port map(
            OUT_N => YTemp(3 downto 0),
            S(0) => A,
            S(1) => B,
            E => CN
          );

  DecoderHigh: quad2to4decoder
  port map(
            OUT_N => YTemp(7 downto 4),
            S(0) => A,
            S(1) => B,
            E => C
          );
  Y_N <= YTemp when ENABLE='1' else
         x"ff" when RESETN='0';

end quad3to8decoder_arch;
