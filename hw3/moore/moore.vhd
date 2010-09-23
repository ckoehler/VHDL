library IEEE;
use ieee.std_logic_1164.all;

entity moore_sm is
  port(
        CLK: in std_logic;
        RESETN: in std_logic;
        X: in std_logic;
        Z: out std_logic);

end moore_sm;

architecture moore_sm_arch of moore_sm is

  type state_type is (start, S1, S10, S101, S1010);
  signal state: state_type;

begin
  process(CLK, RESETN)
  begin
    if RESETN='0' then
      state <= start;
    elsif rising_edge(CLK) then
      case state is
        when start => 
          if X='1' then 
            state <= S1;
          end if;
        when S1 => 
          if X='0' then 
            state <= S10;
          else 
            state <= S1;
          end if;
        when S10 => 
          if X='0' then
            state <= start;
          else
            state <= S101;
          end if;
        when S101 => 
          if X='0' then
            state <= S1010;
          else
            state <= S1;
          end if;
        when S1010 => 
          if X='0' then
            state <= start;
          else
            state <= S101;
          end if;
        when others => 
          null;
      end case;
    end if;
  end process;
  Z <= '1' when state=S1010 else '0';
end moore_sm_arch;
