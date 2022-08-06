library work;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.UCPackage.ALL;
use work.VARPackage.ALL;
use work.ALUPackage.ALL;
use work.REGPackage.ALL;

entity ESCOMIPS is
    Port ( CLK, CLR : in STD_LOGIC;
           INST_AUX : in STD_LOGIC_VECTOR(24 downto 0);
           PCOUT : out STD_LOGIC_VECTOR(9 downto 0);
           MICRO : out STD_LOGIC_VECTOR (19 downto 0);
           reData1, reData2, reALU, busSR : out STD_LOGIC_VECTOR(15 downto 0);
           SP : out STD_LOGIC_VECTOR(2 downto 0));
end ESCOMIPS;

architecture Behavioral of ESCOMIPS is

signal MICRO_AUX : STD_LOGIC_VECTOR(19 downto 0);
signal SDMP, SWD, SR, readData1, readData2, SOP1, SOP2, SEXT, extSIG, SDMD, dataOut : STD_LOGIC_VECTOR(15 downto 0);
signal PC : STD_LOGIC_VECTOR(9 downto 0);
signal SR2 : STD_LOGIC_VECTOR(3 downto 0);
signal FLAGS : STD_LOGIC_VECTOR(3 downto 0);
signal resALU : STD_LOGIC_VECTOR(15 downto 0);
-- signal INST_AUX : STD_LOGIC_VECTOR(24 downto 0);

begin
-- Memoria Programa
--PME : ProgMem 
--    Generic map(
--    INI => x"0010",
--    N => x"0004",
--    STEP => x"0001",
--    MEM_ADDR => x"010")
--    Port map(
--    PC => PC,
--    INTS => INST_AUX);
-- Stack
STA : Stack Port map(
    CLK => CLK,
    CLR => CLR,
    PCIN => SDMP(9 downto 0),
    UP => MICRO_AUX(18),
    DW => MICRO_AUX(17),
    WPC => MICRO_AUX(16),
    PCOUT => PC,
    SPOUT => SP);
-- Unidad de Control
UC : UniControl Port map(
    CLK => CLK,
    CLR => CLR,
    FLAGS => FLAGS,
    MICRO => MICRO_AUX,
    FUNCODE => INST_AUX(3 downto 0),
    OPCODE => INST_AUX(24 downto 20));
-- ALU
ALU : ALUNBits Generic map(N => 16)
    Port map(
    A => SOP1,
    B => SOP2,
    SEL => MICRO_AUX(7 downto 6),
    OP => MICRO_AUX(5 downto 4),
    FLG_OV => FLAGS(3),
    FLG_N => FLAGS(2),
    FLG_Z => FLAGS(1),
    FLG_C => FLAGS(0),
    S => resALU);   
-- Archivo de Registros
REG : RegisterFile Generic map(
    N => 16, REGBUS => 4, SHBITS => 4)
    Port map(
    CLK => CLK,
    CLR => CLR,
    writeData => SWD,
    writeReg => INST_AUX(19 downto 16),
    readReg1 => INST_AUX(15 downto 12),
    readReg2 => SR2,
    readData1 => readData1,
    readData2 => readData2,
    shamt => INST_AUX(7 downto 4),
    SHE => MICRO_AUX(12),
    DIR => MICRO_AUX(11),
    WR => MICRO_AUX(10));
-- RAM
RAM : DataMem Port map(
    CLK => CLK,
    ADDR => SDMD(9 downto 0),
    DIN => readData2,
    DOUT => dataOut,
    WD => MICRO_AUX(2));
-- Extensor de signo
extSIG <= "1111" & INST_AUX(11 downto 0) when INST_AUX(11) = '1' else "0000" & INST_AUX(11 downto 0);
-- Multiplexores
SOP1 <= readData1 when MICRO_AUX(9) = '0' else "000000" & PC;
SOP2 <= readData2 when MICRO_AUX(8) = '0' else SEXT;    
SWD <= INST_AUX(15 downto 0) when MICRO_AUX(14) = '0' else SR;
SR <= dataOut when MICRO_AUX(1) = '0' else resALU;
SR2 <= INST_AUX(11 downto 8) when MICRO_AUX(15) = '0' else INST_AUX(19 downto 16);
SEXT <= extSIG when MICRO_AUX(13) = '0' else "0000" & INST_AUX(11 downto 0);
SDMD <= resALU when MICRO_AUX(3) = '0' else INST_AUX(15 downto 0);
SDMP <= INST_AUX(15 downto 0) when MICRO_AUX(19) = '0' else SR;
-- Puertos auxiliares
-- INST_AUX <= INST;
PCOUT <= PC;
MICRO <= MICRO_AUX;
reData1 <= readData1;
reData2 <= readData2;
reALU <= resALU;
busSR <= SR;
end Behavioral;