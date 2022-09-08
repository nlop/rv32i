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
    A <= x"fffffff4";
    WD <= (others => '0');
    fun <= (others => '0');
    WE <= '0';
    wait until rising_edge(CLK);
    WD <= x"00000000";
    fun <= "010";
    WE <= '1';
    wait until rising_edge(CLK);
    A <= x"fffffff8";
    WD <= x"11111111";
    wait until rising_edge(CLK);
    A <= x"fffffffc";
    WD <= x"ffff0cff";
    wait until rising_edge(CLK);
    WE <= '0';
    wait until rising_edge(CLK);
    A <= x"fffffff4";
    wait until rising_edge(CLK);
    A <= x"fffffff8";
    wait until rising_edge(CLK);
    A <= x"fffffffc";
    fun <= "101";
    wait until rising_edge(CLK);
    fun <= "001";
    wait until rising_edge(CLK);
    fun <= "100";
    wait until rising_edge(CLK);
    fun <= "000";
    wait until rising_edge(CLK);
    WE <= '1';
    A <= x"fffffff8";
    fun <= "001";
    WD <= x"ffffffff";
    wait until rising_edge(CLK);
    fun <= "111";
    WE <= '0';
    wait until rising_edge(CLK);
    WE <= '1';
    fun <= "000";
    WD <= x"eeeeeeee";
    wait until rising_edge(CLK);
    WE <= '0';
    fun <= "111";
    wait until rising_edge(CLK);
    wait;
end process;
end Behavioral;
