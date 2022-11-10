library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

-- Generic N bit decade counter
entity BCD is
    generic(N: integer := 2);
    port(
        CLK, CLR : in std_logic;
        Q : out std_logic_vector(N - 1 downto 0));
end BCD;

architecture Behavioral of BCD is
    signal Qint : std_logic_vector(N - 1 downto 0);
begin
    bcdp: process(CLK, CLR) 
    begin
        if CLR = '1' then
            Qint <= (others => '0');
        elsif rising_edge(CLK) then
            Qint <= Qint + 1;
        end if;
    end process;
    Q <= Qint;
end Behavioral;

