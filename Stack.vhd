library IEEE;
library work;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use work.VARPackage.StackArray;

entity Stack is
    Port ( PCIN : in STD_LOGIC_VECTOR (9 downto 0);
           UP,DW,WPC,CLK,CLR : in STD_LOGIC;
           PCOUT : out STD_LOGIC_VECTOR (9 downto 0);
           SPOUT : out STD_LOGIC_VECTOR(2 downto 0));
end Stack;
architecture Behavioral of Stack is
-- Señal stack pointer
signal ST : StackArray;
signal SP : STD_LOGIC_VECTOR(2 downto 0); 
signal SP_AUX : integer;
begin
-- Stack pointer
process(CLK, CLR)
variable SP_VAR : integer;
begin
    if(CLR = '1') then
        SP_VAR := 0;
        ST <= (others => (others => '0'));
    elsif(RISING_EDGE(CLK)) then
        if(WPC = '0' and UP = '0' and DW = '0') then
            ST(SP_VAR) <= ST(SP_VAR) + 1;
        elsif(WPC = '1' and UP = '0' and DW = '0') then
            ST(SP_VAR) <= PCIN;
        elsif(WPC = '1' and UP = '1' and DW = '0') then
            SP_VAR := SP_VAR + 1;
            ST(SP_VAR) <= PCIN; 
        elsif(WPC = '0' and UP = '0' and DW = '1') then
            SP_VAR := SP_VAR - 1;
            ST(SP_VAR) <= ST(SP_VAR) + 1;
        end if;
    SP_AUX <= SP_VAR;
    end if;
end process; 
-- SP
SP <= CONV_STD_LOGIC_VECTOR(SP_AUX, 3);
-- PCOUT
PCOUT <= ST(CONV_INTEGER(SP));
-- SPOUT
SPOUT <= SP;
end Behavioral;