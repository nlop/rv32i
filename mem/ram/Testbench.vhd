library ieee;
use ieee.std_logic_1164.all;

entity Testbench is
end Testbench;

architecture Behavioral of Testbench is

    component RAM is       
        generic (
                    N : integer := 32;
                    K : integer := 10;
                    M : integer := 32);
        port (
                 A : in STD_LOGIC_VECTOR (M - 1 downto 0);
                 WD : in STD_LOGIC_VECTOR (N - 1 downto 0);
        WE, CLK : in STD_LOGIC;
        fun : in std_logic_vector(2 downto 0);
        RD : out STD_LOGIC_VECTOR (N - 1 downto 0));
    end component;

    constant P : time := 10 ns;

    signal A : std_logic_vector(31 downto 0);
    signal WD : std_logic_vector(31 downto 0);
    signal RD : std_logic_vector(31 downto 0);
    signal fun : std_logic_vector(2 downto 0);
    signal WE, CLK : std_logic;
begin
    ram1: RAM port map (
                           A => A,
                           WD => WD,
                           WE => WE,
                           CLK => CLK,
                           fun => fun,
                           RD => RD);

    clkp: process begin
        CLK <= '0';
        wait for P/2;
        CLK <= '1';
        wait for P/2;
    end process;

test: process begin
    A <= (others => '0');
    WD <= (others => '0');
    fun <= (others => '0');
    WE <= '0';
    wait until rising_edge(CLK);
    WD <= x"00000000";
    fun <= "010";
    WE <= '1';
    wait until rising_edge(CLK);
    A <= x"00000004";
    WD <= x"11111111";
    wait until rising_edge(CLK);
    A <= x"00000008";
    WD <= x"22222222";
    wait until rising_edge(CLK);
    WE <= '0';
    wait until rising_edge(CLK);
    A <= x"00000004";
    wait until rising_edge(CLK);
    A <= x"00000000";
    wait until rising_edge(CLK);
    WE <= '1';
    fun <= "000";
    WD <= x"ffffffff";
    wait until rising_edge(CLK);
    fun <= "111";
    WE <= '0';
    wait until rising_edge(CLK);
    A <= x"00000008";
    wait until rising_edge(CLK);
    A <= x"00000004";
    wait until rising_edge(CLK);
    WE <= '1';
    fun <= "001";
    WD <= (others => '0');
    wait until rising_edge(CLK);
    fun <= "111";
    WE <= '0';
    wait;
end process;
end Behavioral;
