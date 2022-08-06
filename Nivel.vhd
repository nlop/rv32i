library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Nivel is
    Port ( CLK,CLR : in STD_LOGIC;
           NA : out STD_LOGIC);
end Nivel;

architecture Behavioral of Nivel is
signal NCLK, PCLK : STD_LOGIC;
begin
nclkp : process (CLK, CLR) begin
    if(CLR = '1') then
        NCLK <= '0';   
    elsif rising_edge(CLK) then
        NCLK <= not NCLK;
    end if;
end process;

pclkp : process (CLK, CLR) begin
    if(CLR = '1') then
        PCLK <= '0';   
    elsif falling_edge(CLK) then
        PCLK <= not PCLK;
    end if;
end process;

NA <= NCLK xor PCLK;
end Behavioral;
