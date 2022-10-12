library ieee;
use ieee.std_logic_1164.all;

-- Generic N bit register with synchronous clear/reset signal.
-- Parameters:
--      N: word size
--
entity SimpleRegisterReset is
    generic ( N : integer := 16);
    port ( D : in std_logic_vector (N - 1 downto 0);
           Q : out std_logic_vector (N - 1 downto 0);
           CLR, CLK, L : in std_logic);
end SimpleRegisterReset;

architecture Behavioral of SimpleRegisterReset is

begin
    process(CLK)
    begin
        if rising_edge(CLK) then
            if CLR = '1' then
                Q <= (others => '0');
            elsif L = '1' then
                Q <= D;
            end if;
        end if;
    end process;
end Behavioral;
