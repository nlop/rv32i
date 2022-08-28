library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

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

component BarrelShifter is
    Port ( din : in STD_LOGIC_VECTOR (N - 1 downto 0);
           dout : out STD_LOGIC_VECTOR (N - 1 downto 0);
           shamt : in STD_LOGIC_VECTOR (SHBITS - 1 downto 0);
           dir : in STD_LOGIC);
end component;

component DemuxGeneric93 is
    generic ( 
                N : integer := 16;
                PORTS : integer := 4);
    port ( 
    dout : out std_logic_vector(N - 1 downto 0);
    din : in std_logic;
    sel : in std_logic_vector(PORTS - 1 downto 0));
end component;

component MuxGeneric93 is 
    generic (
                N : integer := 16;
                PORTS : integer := 4);
    port (
             dout : out std_logic_vector(N - 1 downto 0);
             sel : in std_logic_vector(PORTS - 1 downto 0);
             din : in std_logic_vector((2**PORTS * N) - 1 downto 0));
end component;


signal lbus,dbus,barrelOut,readDataAux1, readDataAux2 : STD_LOGIC_VECTOR(N - 1 downto 0);
signal regReadBus : std_logic_vector((2**REGBUS * N) - 1 downto 0);

begin
-- Demultiplexor
demu : DemuxGeneric93 Port map (
    din => WR,
    sel => writeReg,
    dout => lbus);
-- Multiplexor writeData
dbus <= barrelOut when SHE = '1' else writeData;
 -- Barrel shifter
barrel : BarrelShifter Port map (
    din => readDataAux1,
    dout => barrelOut,
    shamt => shamt,
    dir => DIR);
-- Multiplexor readData1
rdDataMux1 : MuxGeneric93 port map (
    din => regReadBus,
    sel => readReg1,
    dout => readDataAux1);
-- Multiplexor readData2
rdDataMux2 : MuxGeneric93 port map (
    din => regReadBus,
    sel => readReg2,
    dout => readDataAux2);
-- Registros
    ciclo : for i in 0 to N - 1 generate
        regn : Registro port map(
            d => dbus,
            q => regReadBus((N * i + 2**REGBUS) - 1 downto (N * i)),
            l => lbus(i),
            clk => CLK,
            clr => CLR);
    end generate;
    readData1 <= readDataAux1;
    readData2 <= readDataAux2;
end Behavioral;
