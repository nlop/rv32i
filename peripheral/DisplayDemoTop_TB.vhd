library ieee;
use ieee.std_logic_1164.all;

entity DisplayDemoTop_TB is
end DisplayDemoTop_TB;

architecture Testbench of DisplayDemoTop_TB is

    component DisplayDemoTop is
    port(
        CLK, CLR: in std_logic;
        AN: out std_logic_vector(3 downto 0);
        CX: out std_logic_vector(6 downto 0));
    end component;

    signal CLK, CLR: std_logic;
    signal AN: std_logic_vector(3 downto 0);
    signal CX: std_logic_vector(6 downto 0);
    
    constant P : time := 10 ns;
begin
    clkp: process 
    begin
        CLK <= '0';
        wait for P/2;
        CLK <= '1';
        wait for P/2;
    end process;

    test: process
    begin
        CLR <= '1';
        wait for 35 ns;
        CLR <= '0';
        wait;
    end process;

    ddt: DisplayDemoTop port map(
        CLK => CLK,
        CLR => CLR,
        AN => AN,
        CX => CX);

end Testbench;
