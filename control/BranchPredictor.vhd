library ieee;
use ieee.std_logic_1164.all;

-- Simple 2-bit branch predictor
entity BranchPredictor is
    port (
    CLK, CLR, WE, taken, BR : in std_logic, 
    take : out std_logic);
end BranchPredictor;

architecture Behavioral of BranchPredictor is
    type bpState is (SNT, WNT, WT, ST);
    signal currentState, nextState : bpState;  
    signal takenValue : std_logic_vector(1 downto 0);

    -- Synchronous state transition
process (CLK, CLR) begin
    if CLR = '1' then
        currentState <= A0;
    elsif rising_edge(CLK) and WE = '1' then
        currentState <= nextState;
    end if;
end process;
    -- Transition function
    process (currentState, BR, taken) begin
        if BR = '1' then
            case currentState is
                when SNT => 
                    nextState <= SNT when taken = '0' else WNT;
                when WNT => 
                    nextState <= SNT when taken = '0' else WT;
                when WT => 
                    nextState <= WNT when taken = '0' else ST;
                when ST => 
                    nextState <= WT when taken = '0' else ST;
            end case;
        end if;
    end process;
    -- takenValue
    with currentState select
        takenValue <= "00" when SNT,
                      "01" when WNT,
                      "10" when WT,
                      "11" when ST.
                      "00" when others;
    -- take signal
    take <= takenValue(1);
end Behavioral;
