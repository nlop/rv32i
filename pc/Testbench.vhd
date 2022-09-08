library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity Testbench is

    end Testbench;

architecture Behavioral of Testbench is
    component PC is
        generic (N : integer := 32);
        port (
                 PCOUT : out std_logic_vector(N - 1 downto 0);
                 WPC : in std_logic_vector(N - 1 downto 0);
        CLK, CLR, JEN, JINST : in std_logic);
    end component;

    constant P : time := 10 ns;

    signal PCO : std_logic_vector(31 downto 0);
    signal WPC : std_logic_vector(31 downto 0);
    signal CLK, CLR, JEN, JINST : std_logic;

begin
    pc1: PC port map(
                        PCOUT => PCO,
                        WPC => WPC,
                        CLK => CLK,
                        CLR => CLR,
                        JEN => JEN,
                        JINST => JINST);

    clkp: process begin
        CLK <= '0';
        wait for P/2;
        CLK <= '1';
        wait for P/2;
    end process;

test: process begin
    WPC <= (others => '0'); 
    JEN <= '0';
    JINST <= '0';
    CLR <= '1';
    wait until rising_edge(CLK);
    CLR <= '0';
    wait for 40 ns;
    JINST <= '1';
    wait until rising_edge(CLK);
    WPC <= x"aaaaaaaa";
    JEN <= '1';
    wait until rising_edge(CLK);
    WPC <= (others => '0');
    JEN <= '0';
    JINST <= '0';
    wait for 30 ns;
    wait;
end process;

end Behavioral;
