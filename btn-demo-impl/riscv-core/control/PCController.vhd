library ieee;
use ieee.std_logic_1164.all;

-- Program counter (PC) controller used to manage different sources of WPC at
-- different stages of the pipeline given their respective JMP and BR signals
entity PCController is
    port (
    jmpD, brD, takeD, brE, breE, takeE : in std_logic;
    wpcSel : out std_logic_vector(1 downto 0);
    flushD, flushE : out std_logic);
end PCController;

architecture Behavioral of PCController is
    signal brTakeD, brNotTakeE, brTakeFailE : std_logic;
begin
    process(jmpD, brTakeD, brNotTakeE, brTakeFailE)
    begin
        if brNotTakeE = '1' then
            wpcSel <= "01";     -- PCtargetE
            flushD <= '1';
            flushE <= '1';
        elsif brTakeFailE = '1' then
            wpcSel <= "11";     -- PCplus4E
            flushD <= '1';
            flushE <= '1';
        elsif (brTakeD or jmpD) = '1' then
            wpcSel <= "00";     -- PCtargetD
            flushD <= '1';
            flushE <= '0';
        else
            wpcSel <= "10";     -- PCplus4F
            flushD <= '0';
            flushE <= '0';
        end if;
    end process;

    brTakeD <= brD and takeD;                       -- Take branch early (predictor --> jump)
    brNotTakeE <= brE and breE and (not takeE);     -- Take branch later (predictor --> don't jump)
    brTakeFailE <= brE and takeE and (not breE);    -- Fetch next instruction (predictor fail --> jumped when condition wasn't met)
    
end Behavioral;
