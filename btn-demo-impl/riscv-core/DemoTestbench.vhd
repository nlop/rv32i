library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity DemoTestbench is
--  Port ( );
end DemoTestbench;

architecture Behavioral of DemoTestbench is
    component DemoTop is
    generic(
               N : integer := 32;
               LOG2N : integer := 5;
               M : integer := 5; -- 
               ROM_ADDRS : integer := 32;
               K : integer := 8);
    port(
    CLK_BOARD, CLR : in std_logic;
    BTN : in std_logic_vector (4 downto 0);
    AN: out std_logic_vector(3 downto 0);
    CX: out std_logic_vector(6 downto 0);
    LED: out std_logic_vector(15 downto 0));
    end component;
    
    constant P : time := 1 ns;
    signal CLK, CLR : std_logic;
    signal BTN : std_logic_vector(4 downto 0);
    signal AN : std_logic_vector(3 downto 0);
    signal CX : std_logic_vector(6 downto 0);
    signal LED: std_logic_vector(15 downto 0);
begin

top1: DemoTop port map(
    CLK_BOARD => CLK,
    CLR => CLR,
    BTN => BTN,
    AN => AN,
    CX => CX,
    LED => LED);

clkp: process begin
    CLK <= '0';
    wait for P / 2;
    CLK <= '1';
    wait for P / 2;
end process;

test: process begin
    CLR <= '1';
    wait for 22 ns;
    CLR <= '0';
    wait for 12 ns;
    BTN <= "00010";
    wait for 300 ns;
    BTN <= "00001";
    wait for 200 ns;
    BTN <= "10001";
    wait for 300 ns;
    BTN <= (others => '0');
    wait;
end process;

end Behavioral;
