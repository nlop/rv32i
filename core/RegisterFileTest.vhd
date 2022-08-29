library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity RegisterFileTest is
    generic (
                N : integer := 32;
                NLOG2 : integer := 5;
                NREG : integer := 5;
                NSHIFT : integer := 5);
end RegisterFileTest;

architecture Behavioral of RegisterFileTest is

    component RegisterFile is
        generic( 
                   N : integer := 16;
                   NLOG2 : integer := 4;
                   NREG : integer := 4;
                   NSHIFT : integer := 4);

        port ( WD3 : in std_logic_vector (N - 1 downto 0);
        A3, A1, A2 : in std_logic_vector (NREG - 1 downto 0);
        shamt : in std_logic_vector(NSHIFT - 1 downto 0);
        CLK, CLR, SHE, DIR, WE3 : in std_logic;
        RD1, RD2 : out std_logic_vector (N - 1 downto 0));
    end component;
    signal WD3,RD1, RD2 : std_logic_vector(N - 1 downto 0);
    signal A3, A1, A2, shamt : std_logic_vector(NREG - 1 downto 0);
    signal CLK, CLR, SHE, DIR, WE3 : std_logic;

begin
    rf : RegisterFile 
    generic map (
                    N => N,
                    NLOG2 => NLOG2,
                    NREG => NREG,
                    NSHIFT => NSHIFT)
    port map(
                WD3 => WD3,
                A3 => A3,
                A1 => A1,
                A2 => A2,
                shamt => shamt,
                CLK => CLK,
                CLR => CLR,
                DIR => DIR,
                SHE => SHE,
                WE3 => WE3,
                RD1 => RD1,
                RD2 => RD2);
-- Señal CLK
process begin
    CLK <= '0';
    wait for 5 ns;
    CLK <= '1';
    wait for 5 ns;
end process;
-- Pruebas con archivos
process begin		
    CLR <= '1';
    WE3 <= '0';
    DIR <= '0';
    SHE <= '0';
    WD3 <= (others => '0');
    A1 <= (others => '0');
    A2 <= (others => '0');
    A3 <= (others => '0');
    shamt <= (others => '0');
    wait until rising_edge(CLK);
    CLR <= '0';
    A3 <= "0" & x"1";
    WE3 <= '1';
    WD3 <= x"00001111";
    wait until rising_edge(CLK);
    A3 <= "0" & x"2";
    WD3 <= x"00002222";
    wait until rising_edge(CLK);
    A3 <= "0" & x"3";
    WD3 <= x"00003333";
    wait until rising_edge(CLK);
    WE3 <= '0';
    A1 <= "0" & x"1";
    A2 <= "0" & x"2";
    wait until rising_edge(CLK);
    A1 <= "0" & x"3";
    wait until rising_edge(CLK);
    A3 <= "0" & x"4";
    A2 <= "0" & x"4";
    SHE <= '1';
    WE3 <= '1';
    shamt <= "0" & x"4";
    wait until rising_edge(CLK);
    A3 <= "0" & x"5";
    A1 <= "0" & x"1";
    DIR <= '1';
    WE3 <= '1';
    wait until rising_edge(CLK);
    A1 <= "0" & x"5";
    SHE <= '0';
    WE3 <= '0';
    wait;
end process;
end Behavioral;
