library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity UC is
    Port ( CLK, CLR, TIPOR, BEQI, BNEI, BLTI, BLETI, BGTI, BGETI, NA, EQ, NE, LT, LE, GT, GE : in STD_LOGIC;
           SDOPC, SM : out STD_LOGIC);
end UC;

architecture Behavioral of UC is

type ESTADO is (E0);
signal ESIG, EACT : ESTADO;

begin
process(CLK, CLR) begin
    if(CLR = '1') then
        EACT <= E0;
    elsif RISING_EDGE(CLK) then
        EACT <= ESIG;
    end if;
end process;

process(EACT, TIPOR, BEQI, BNEI, BLTI, BLETI, BGTI, BGETI, EQ, NE, LT, LE, GT, GE, NA) begin
    SM <= '0';
    SDOPC <= '0';
    if(EACT = E0) then
        ESIG <= E0;
    if(TIPOR = '0') then
        if(BEQI = '1') then
            if(NA = '0' and EQ = '1') then
                SDOPC <= '1';
                SM <= '1';
            else
                SM <= '1';
            end if;
        elsif(BNEI = '1') then
            if(NA = '0' and NE = '1') then
                SDOPC <= '1';
                SM <= '1';
            else
                SM <= '1';
            end if;
        elsif(BLTI = '1') then
            if(NA = '0' and LT = '1') then
                SDOPC <= '1';
                SM <= '1';
            else
                SM <= '1';
            end if;
        elsif(BLETI = '1') then
            if(NA = '0' and LE = '1') then
                SDOPC <= '1';
                SM <= '1';
            else
                SM <= '1';
            end if;
        elsif(BGTI = '1') then
            if(NA = '0' and GT = '1') then
                SDOPC <= '1';
                SM <= '1';
            else
                SM <= '1';
            end if;
        elsif(BGETI = '1') then
            if(NA = '0' and GE = '1') then
                SDOPC <= '1';
                SM <= '1';
            else
                SM <= '1';
            end if;
        else
            SDOPC <= '1';
            SM <= '1';  
        end if;
    end if;    
end if;
end process;
end Behavioral;
