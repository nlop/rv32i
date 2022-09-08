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
    CLK, CLR, BRE, BR : in std_logic);
    --        ^ branch enable
    --             ^ branch instruction
end PC;

architecture Behavioral of PC is
    signal Q : std_logic_vector(N - 1 downto 0);
    signal JMP : std_logic;
begin
process (CLK, CLR) begin
    if CLR = '1' then
        Q <= (others => '0');
    elsif rising_edge(CLK) then
        if JMP = '1' then
            Q <= WPC;
        else
            Q <= Q + 1;
        end if;
    end if;
end process;
JMP <= BRE and BR;
PCOUT <= Q;

end Behavioral;
