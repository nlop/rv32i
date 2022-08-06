library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity FlagReg is
    Port ( D : in STD_LOGIC_VECTOR (3 downto 0);
           LF,CLK,CLR : in STD_LOGIC;
           Q : out STD_LOGIC_VECTOR (3 downto 0));
end FlagReg;

architecture Behavioral of FlagReg is
begin

process (CLK, CLR) begin
    if(CLR = '1') then
        Q <= (others => '0');
    elsif falling_edge(CLK) then
        if(LF = '1') then
            Q <= D;
        end if;
    end if;
end process;
end Behavioral;
