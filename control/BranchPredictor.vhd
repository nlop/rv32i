library ieee;
use ieee.std_logic_1164.all;

-- Simple 2-bit branch predictor
entity BranchPredictor is
    port (
    CLK, CLR, WE, taken : in std_logic;
    take : out std_logic);
end BranchPredictor;

architecture Behavioral of BranchPredictor is
    type bpState is (SNT, WNT, WT, ST);
    signal currentState, nextState : bpState;  
    signal takenValue : std_logic_vector(1 downto 0);
begin
    -- Synchronous state transition
    process (CLK, CLR) 
    begin
        if CLR = '1' then
            currentState <= SNT;
        elsif rising_edge(CLK) and WE = '1' then
            currentState <= nextState;
        end if;
    end process;
    -- Transition function
    process (currentState, taken) 
    begin
        case currentState is
            when SNT => 
                if taken = '1' then
                    nextState <= WNT;
                else
                    nextState <= SNT;
                end if;
            when WNT => 
                if taken = '1' then
                    nextState <= WT;
                else
                    nextState <= SNT;
                end if;
            when WT => 
                if taken = '1' then
                    nextState <= ST;
                else
                    nextState <= WNT;
                end if;
            when ST => 
                if taken = '1' then
                    nextState <= ST;
                else
                    nextState <= WT;
                end if;
        end case;
    end process;
    -- takenValue
    with currentState select
        takenValue <= "00" when SNT,
                      "01" when WNT,
                      "10" when WT,
                      "11" when ST,
                      "00" when others;
    -- take signal
    take <= takenValue(1);
end Behavioral;
