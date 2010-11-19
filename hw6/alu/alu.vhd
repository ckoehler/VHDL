library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.registers_pkg.all;

entity alu is
  port(
        CLK, TEN, MEMIO, XLD: in std_logic;
        -- S and T are source selection, D destination
        S,T,D: in integer range 0 to RegQty-1;
        -- command, or opcode input
        C: in std_logic_vector(4 downto 0);
        MEMBUS, IOBUS: in std_logic_vector(RegSize-1 downto 0);
        IBUS: inout std_logic_vector(RegSize-1 downto 0);
        CIN: in std_logic;
        
        Status: out std_logic_vector(3 downto 0) := "0000"
);

end alu;


architecture alu_arch of alu is

  type reg_type is array(0 to RegQty-1) of unsigned(RegSize-1 downto 0);

  signal R: reg_type;
  signal A,B: unsigned(RegSize-1 downto 0);
  signal ALUOUT: std_logic_vector(RegSize-1 downto 0);

  -- SGN, Z, OV, COUT
  signal SGN  : std_logic;
  signal Z    : std_logic;
  signal OV   : std_logic;
  signal COUT : std_logic;

  -- opcodes
  constant nop   : std_logic_vector(4 downto 0) :="00000";
  constant add   : std_logic_vector(4 downto 0) :="00001";
  constant subt  : std_logic_vector(4 downto 0) :="00010";
  constant inca  : std_logic_vector(4 downto 0) :="00011";
  constant addc  : std_logic_vector(4 downto 0) :="00100";
  constant subtc : std_logic_vector(4 downto 0) :="00101";
  constant nega  : std_logic_vector(4 downto 0) :="00110";
  constant deca  : std_logic_vector(4 downto 0) :="00111";
  constant nota  : std_logic_vector(4 downto 0) :="01000";
  constant anda  : std_logic_vector(4 downto 0) :="01001";
  constant ora   : std_logic_vector(4 downto 0) :="01010";
  constant xora  : std_logic_vector(4 downto 0) :="01011";
  constant xnora : std_logic_vector(4 downto 0) :="01100";
  constant lsla  : std_logic_vector(4 downto 0) :="01101";
  constant lsra  : std_logic_vector(4 downto 0) :="01110";
  constant asra  : std_logic_vector(4 downto 0) :="01111";
  constant rtla  : std_logic_vector(4 downto 0) :="10101";
  constant rtra  : std_logic_vector(4 downto 0) :="10110";
  constant swpa  : std_logic_vector(4 downto 0) :="10111";

begin



  alu:process(S,D,T,CIN,C,A,B)
    variable result: unsigned(RegSize-1 downto 0);
    variable CO: std_logic;
    constant nibble_size: integer := RegSize/2;

  begin
    A <= R(S);
    case C is
      when nop => 
        B <= x"00";
        adder(A, B, CIN, result, CO);
      when add => 
        B <= R(T);
        adder(A,B,'0', result, CO);
      when subt => 
        B <= not R(T);
        adder(A,B,'1', result, CO);
      when inca => 
        adder(A,"00000000", '1', result, CO);

      when addc => 
        B <= R(T);
        adder(A,B,CIN,result,CO);
      when subtc => 
        B <= R(T);
        adder(A,not B, CIN, result, CO);

      when deca => 
        adder(A,not "00000001",'1', result, CO);

      when nega => 
        adder(not A, "00000000", '1', result, CO);

      when nota => 
        result := not A;

      when anda => 
        B <= R(T);
        result := A and B;

      when ora => 
        B <= R(T);
        result := A or B;
      when xora => 

        B <= R(T);
        result := A xor B;

      when xnora => 
        B <= R(T);
        result := A xnor B;

      when lsla => 
        CO := A(RegSize-1); 
        result := A(RegSize-2 downto 0) & '0';

      when lsra => 
        CO := A(0); 
        result := '0' & A(RegSize-1 downto 1);

      when asra => 
        CO := A(0); 
        result := A(RegSize-1) & A(RegSize-1 downto 1);

      when rtla => 
        CO := A(RegSize-1); 
        result := A(RegSize-2 downto 0) & A(RegSize-1) ;

      when rtra => 
        CO := A(0); 
        result := A(0) & A(RegSize-1 downto 1);

      when swpa => 
        result := A(nibble_size-1 downto 0) & A(RegSize-1 downto nibble_size);

      when others => 
        NULL;
    end case;

    COUT <= CO;
    ALUOUT <= std_logic_vector(result);
  end process alu;

  process(CLK)
  begin
    if rising_edge(CLK) then
      if XLD='1' then
        R(D) <= unsigned(IBUS);
      elsif TEN='1' then
        R(D) <= unsigned(ALUOUT);
      end if;
    end if;
  end process;


  StatusRegisters:process(CLK)
  begin
    if rising_edge(CLK) then
      Status(3) <= SGN;
      Status(2) <= Z;
      Status(1) <= OV;
      Status(0) <= COUT;
    end if;
  end process;

  IBUS <= MemBUS when MEMIO='1' else
          IOBUS when MEMIO='0';


  SGN <= ALUOUT(RegSize-1);
  Z <= '1' when to_integer(unsigned(ALUOUT))=0 else
       '0';

  -- overflow: A(7) & B(7) != OUT(7)
  --0 0 0
  --0 1 0
  --1 0 1
  --1 1 0 
  OV <= (A(RegSize-1) xnor B(RegSize-1)) and (ALUOUT(RegSize-1) xor A((RegSize-1)));



end alu_arch;

