library IEEE;
library work;
use IEEE.STD_LOGIC_1164.ALL;
use work.UCPackage.ALL;

entity UniControl is
    Port ( 
        CLK, CLR        : in  STD_LOGIC;
        FunCode, Flags  : in  STD_LOGIC_VECTOR(3 downto 0);
        OpCode          : in  STD_LOGIC_VECTOR(4 downto 0);
        Micro           : out STD_LOGIC_VECTOR(19 downto 0));
end UniControl;

architecture Behavioral of UniControl is

signal FunCodeOut, OpCodeOut, MicroAux : STD_LOGIC_VECTOR(19 downto 0);
signal RCLR, TIPOR, BEQI, BNEI, BLTI, BLETI, BGTI, BGETI, NA, EQ, NE, LT, LE, GT, GE, SDOPC, SM : STD_LOGIC;
signal Q : STD_LOGIC_VECTOR(3 downto 0);
signal OpCodeAux : STD_LOGIC_VECTOR(4 downto 0);
begin
-- Buffer CLR
cbuff : process (CLK) begin
    if falling_edge(CLK) then
        RCLR <= CLR;
    end if;
end process;
-- Memoria de microcod. tipo R
mfunc : MFunCode Port map(
    FunCode => FunCode,
    CodeOut => FunCodeOut);
-- Memoria general de microcod.
mopc : MOpCode Port map(
    OpCode => OpCodeAux,
    CodeOut => OpCodeOut);
-- Decodificador instr.
inde : InstrDeco Port map(
    OpCode => OpCode,
    TIPOR => TIPOR,
    BEQI => BEQI,
    BNEI => BNEI,
    BLTI => BLTI,
    BLETI => BLETI,
    BGTI => BGTI,
    BGETI => BGETI);
-- Nivel
niv : Nivel Port map(
    CLK => CLK,
    CLR => RCLR,
    NA => NA);
-- Registro de banderas
flr : FlagReg Port map(
    CLK => CLK,
    CLR => CLR,
    D => Flags,
    Q => Q,
    LF => MicroAux(0));
-- Condicional    
con  : Cond Port map(
    Q => Q,
    EQ => EQ,
    NE => NE,
    LT => LT,
    LE => LE,
    GT => GT,
    GE => GE);
-- Controlador UC
ucc : UC Port map(
    TIPOR => TIPOR, BEQI => BEQI,
    BNEI => BNEI, BLTI => BLTI,
    BLETI => BLETI, BGTI => BGTI,
    BGETI => BGETI, EQ => EQ,
    NE => NE, LT => LT,
    LE => LE, GT => GT,
    GE => GE, CLK => CLK, 
    CLR => CLR, NA => NA,
    SDOPC => SDOPC, SM => SM);
----- Multiplexores
-- Mux memorias
MicroAux <= FunCodeOut when SM = '0' else OpCodeOut;
-- Mux SDOPC
OpCodeAux <= OpCode when SDOPC = '1' else "00000";
-- Microinstruccion
Micro <= MicroAux;
end Behavioral;