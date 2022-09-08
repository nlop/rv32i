library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity RegisterFileTest is
    generic (
                N : integer := 32;
                LOG2N : integer := 5;
                NREG : integer := 5);
end RegisterFileTest;

architecture Behavioral of RegisterFileTest is

    component RegisterFile is
    generic( 
               N : integer := 16;
               LOG2N : integer := 4;
               NREG : integer := 4);

    port ( WD3 : in std_logic_vector (N - 1 downto 0);
    A3, A1, A2 : in std_logic_vector (NREG - 1 downto 0);
    CLK, CLR, WE3 : in std_logic;
    RD1, RD2 : out std_logic_vector (N - 1 downto 0));
    end component;
    signal WD3,RD1, RD2 : std_logic_vector(N - 1 downto 0);
    signal A3, A1, A2 : std_logic_vector(NREG - 1 downto 0);
    signal CLK, CLR, WE3 : std_logic;

begin
    rf : RegisterFile 
    generic map (
                    N => N,
                    LOG2N => LOG2N,
                    NREG => NREG)
    port map(
                WD3 => WD3,
                A3 => A3,
                A1 => A1,
                A2 => A2,
                CLK => CLK,
                CLR => CLR,
                WE3 => WE3,
                RD1 => RD1,
                RD2 => RD2);
-- Se�al CLK
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
    WD3 <= (others => '0');
    A1 <= (others => '0');
    A2 <= (others => '0');
    A3 <= (others => '0');
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
    wait;
end process;
end Behavioral;
