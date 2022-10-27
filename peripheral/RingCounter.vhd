library ieee;
use ieee.std_logic_1164.all;

-- Generic N-bit ring counter (Johnson counter)
entity RingCounter is
    generic(N : integer := 4);
    port(
        CLK, CLR : in std_logic;
        Q : out std_logic_vector(N - 1 downto 0));
end RingCounter;

architecture Behavioral of RingCounter is
    signal Qint : std_logic_vector(N - 1 downto 0);
    signal Qzero : std_logic_vector(N - 2 downto 0);
begin
    process(CLK, CLR)
    begin
        if CLR = '1' then
            Qint <= '1' & Qzero; 
        elsif rising_edge(CLK) then
            Qint(N - 1) <= Qint (0);
            for i in 0 to (N - 2) loop
                Qint(i) <= Qint(i + 1);
            end loop;
        end if;
    end process;
    Qzero <= (others => '0');
    Q <= Qint;
end Behavioral;

