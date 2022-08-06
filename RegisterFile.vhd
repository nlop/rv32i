library IEEE;
library work;
use IEEE.STD_LOGIC_1164.ALL;
use work.REGPackage.ALL;

entity RegisterFile is
    Generic( 
    N : integer := 16;
    REGBUS : integer := 4;
    SHBITS : integer := 4);
    
    Port ( writeData : in STD_LOGIC_VECTOR (N - 1 downto 0);
           writeReg, readReg1, readReg2 : in STD_LOGIC_VECTOR (REGBUS - 1 downto 0);
           shamt : in STD_LOGIC_VECTOR(SHBITS - 1 downto 0);
           CLK, CLR, SHE, DIR, WR : in STD_LOGIC;
           readData1, readData2 : out STD_LOGIC_VECTOR (N - 1 downto 0));
end RegisterFile;

architecture Behavioral of RegisterFile is

component Registro is
    Port ( d : in STD_LOGIC_VECTOR (N - 1 downto 0);
           q : out STD_LOGIC_VECTOR (N - 1 downto 0);
           clr, clk, l : in STD_LOGIC);
end component;

signal lbus,dbus,barrelOut,readDataAux1, readDataAux2 : STD_LOGIC_VECTOR(N - 1 downto 0);
signal qvector : DATA_MUX;

begin
-- Demultiplexor
demu : Demux Generic map (N => N)
    Port map (
    din => WR,
    sel => writeReg,
    dout => lbus);
-- Multiplexor writeData
dbus <= barrelOut when SHE = '1' else writeData;
 -- Barrel shifter
barrel : BarrelShifter Generic map(
    N => N, SHAM_LEN => SHBITS)
    Port map (
    din => readDataAux1,
    dout => barrelOut,
    shamt => shamt,
    dir => DIR);
-- Multiplexor readData1
rdDataMux1 : Mux Port map (
    din => qvector,
    sel => readReg1,
    dout => readDataAux1);
-- Multiplexor readData2
rdDataMux2 : Mux Port map (
    din => qvector,
    sel => readReg2,
    dout => readDataAux2);
-- Registros
    ciclo : for i in 0 to N - 1 generate
        regn : Registro Port map(
            d => dbus,
            q => qvector(i),
            l => lbus(i),
            clk => CLK,
            clr => CLR);
    end generate;
    readData1 <= readDataAux1;
    readData2 <= readDataAux2;
end Behavioral;
