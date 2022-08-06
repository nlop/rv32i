library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

package REGPackage is
-- Dato MUX
type DATA_MUX is array(0 to 15) of STD_LOGIC_VECTOR(15 downto 0);
-- Mux
component Mux is
    Port(
        din : in DATA_MUX;
        sel : in STD_LOGIC_VECTOR(3 downto 0);
        dout : out STD_LOGIC_VECTOR (15 downto 0));
end component;
-- Demux
component Demux is
    generic( N : integer := 16);
    Port ( din : in STD_LOGIC;
           sel : in STD_LOGIC_VECTOR (3 downto 0);
           dout : out STD_LOGIC_VECTOR (N - 1 downto 0));
end component;
-- Barrel shifter
component BarrelShifter is
    generic ( 
        N : integer := 16;
        SHAM_LEN : integer := 4 );
    Port ( din : in STD_LOGIC_VECTOR (N - 1 downto 0);
           dout : out STD_LOGIC_VECTOR (N - 1 downto 0);
           shamt : in STD_LOGIC_VECTOR (SHAM_LEN - 1 downto 0);
           dir : in STD_LOGIC);
end component;
-- Archivo Registros
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
end package;
