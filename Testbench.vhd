library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Testbench is
    --  Port ( );
    end Testbench;

architecture Behavioral of Testbench is
    component Top is
        generic(
                   N : integer := 32;
                   LOG2N : integer := 5;
                   M : integer := 5; -- register file 2^M * N
                   ROM_ADDRS : integer := 32; -- ROM address space
                   K : integer := 8);
        port(
        CLK, CLR : in std_logic;
        writeData, dataAddr : buffer std_logic_vector(N - 1 downto 0);
        memWrite : buffer std_logic);
    end component;
    signal CLK, CLR : std_logic;
    constant P : time := 10 ns;
    signal writeData, dataAddr : std_logic_vector(31 downto 0);
    signal memWrite : std_logic;

begin
clkp: process begin
    CLK <= '0';
    wait for P / 2;
    CLK <= '1';
    wait for P / 2;
end process;

init: process begin
    CLR <= '1';
    wait for 22 ns;
    CLR <= '0';
    wait;
end process;

top1: Top port map(
                      CLK => CLK,
                      CLR => CLR,
                      writeData => writeData,
                      dataAddr => dataAddr,
                      memWrite => memWrite);

test: process(CLK) begin
    if (CLK'event and CLK = '0' and memWrite = '1') then
        if (dataAddr = x"00000037" and writeData = x"00000019") then
            report "No error: Simulation succeded" severity failure;
        elsif (dataAddr = x"00000019") then
            report "Simulation failed!" severity failure;
        end if;
    end if;
end process;

end Behavioral;
