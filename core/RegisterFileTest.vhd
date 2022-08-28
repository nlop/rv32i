library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity RegisterFileTest is
--  Port ( );
end RegisterFileTest;

architecture Behavioral of RegisterFileTest is

    component RegisterFile is
    Generic( 
    N : integer := 16;
    REGBUS : integer := 4;
    SHBITS : integer := 4);
    Port ( writeData : in STD_LOGIC_VECTOR (N - 1 downto 0);
           writeReg, readReg1, readReg2 : in STD_LOGIC_VECTOR (REGBUS - 1 downto 0);
           shamt : in STD_LOGIC_VECTOR(SHBITS - 1 downto 0);
           CLK, CLR, SHE, DIR, WR : in STD_LOGIC;
           readData1, readData2 : out STD_LOGIC_VECTOR (N - 1 downto 0));
    end component;
signal writeData,readData1, readData2 : STD_LOGIC_VECTOR(15 downto 0);
signal writeReg, readReg1, readReg2, shamt : STD_LOGIC_VECTOR(3 downto 0);
signal CLK, CLR, SHE, DIR, WR : STD_LOGIC;

begin
rf : RegisterFile port map(
    writeData => writeData,
    writeReg => writeReg,
    readReg1 => readReg1,
    readReg2 => readReg2,
    shamt => shamt,
    CLK => CLK,
    CLR => CLR,
    DIR => DIR,
    SHE => SHE,
    WR => WR,
    readData1 => readData1,
    readData2 => readData2);
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
    WR <= '0';
    DIR <= '0';
    SHE <= '0';
    writeData <= (others => '0');
    readReg1 <= (others => '0');
    readReg2 <= (others => '0');
    writeReg <= (others => '0');
    shamt <= (others => '0');
    wait until rising_edge(CLK);
    CLR <= '0';
    writeReg <= x"1";
    WR <= '1';
    writeData <= x"1111";
    wait until rising_edge(CLK);
    WR <= '0';
    wait until rising_edge(CLK);
    WR <= '1';
    writeReg <= x"2";
    writeData <= x"2222";
    wait until rising_edge(CLK);
    WR <= '0';
    wait until rising_edge(CLK);
    WR <= '1';
    writeReg <= x"3";
    writeData <= x"3333";
    wait until rising_edge(CLK);
    WR <= '0';
    readReg1 <= x"1";
    readReg2 <= x"2";
    wait until rising_edge(CLK);
    readReg1 <= x"3";
    wait until rising_edge(CLK);
    WR <= '0';
    wait;
end process;
end Behavioral;
