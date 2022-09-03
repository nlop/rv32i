library ieee;
use ieee.std_logic_1164.all;

-- Generic N bit register
-- Parameters:
--      N: word size
--
entity SimpleRegister is
    generic ( N : integer := 16);
    port ( D : in std_logic_vector (N - 1 downto 0);
           Q : out std_logic_vector (N - 1 downto 0);
           CLR, CLK, L : in std_logic);
end SimpleRegister;

architecture Behavioral of SimpleRegister is

begin
    process(CLK, CLR)
    begin
        if (CLR = '1') then
            Q <= (others=>'0');
        elsif rising_edge(CLK) then
            if (L = '1') then
                Q <= D;
            end if;
        end if;
    end process;
end Behavioral;
