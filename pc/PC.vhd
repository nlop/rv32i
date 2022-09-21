library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_signed.all;

-- Program counter
--
-- Parameters:
--      N: word size
entity PC is
    generic (N : integer := 32);
    port (
             PCOUT : out std_logic_vector(N - 1 downto 0);
             WPC : in std_logic_vector(N - 1 downto 0);
    WE, CLK, CLR : in std_logic);
end PC;

architecture Behavioral of PC is
    signal Q : std_logic_vector(N - 1 downto 0);
begin
process (CLK, CLR) begin
    if CLR = '1' then
        Q <= (others => '0');
    elsif rising_edge(CLK) then
        if WE = '1' then
            Q <= WPC;
        end if;
    end if;
end process;
PCOUT <= Q;

end Behavioral;
