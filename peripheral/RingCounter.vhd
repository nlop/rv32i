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
    constant Qzero : std_logic_vector(N - 2 downto 0) := (others => '0');
begin
    process(CLK, CLR)
    begin
        if CLR = '1' then
            Qint <= Qzero & '1'; 
        elsif rising_edge(CLK) then
            Qint(0) <= Qint (N - 1);
            for i in 1 to (N - 1) loop
                Qint(i) <= Qint(i - 1);
            end loop;
        end if;
    end process;
    Q <= Qint;
end Behavioral;

