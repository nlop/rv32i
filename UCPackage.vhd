library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

package UCPackage is
-- Registro de banderas
component FlagReg is
    Port ( D : in STD_LOGIC_VECTOR (3 downto 0);
           LF,CLK,CLR : in STD_LOGIC;
           Q : out STD_LOGIC_VECTOR (3 downto 0));
end component;
-- Bloque condicional
component Cond is
    Port ( Q : in STD_LOGIC_VECTOR (3 downto 0);
           EQ, NE, LT, LE, GT, GE : out STD_LOGIC);
end component;
-- Decodificador instrucciones
component InstrDeco is
    Port ( OpCode : in STD_LOGIC_VECTOR (4 downto 0);
           TIPOR, BEQI, BNEI, BLTI, BLETI, BGTI, BGETI : out STD_LOGIC);
end component;
-- Mem. FunCode
component MFunCode is
    Port ( FunCode : in STD_LOGIC_VECTOR (3 downto 0);
           CodeOut : out STD_LOGIC_VECTOR (19 downto 0));
end component;
-- Mem. OpCode
component MOpCode is
    Port ( OpCode : in STD_LOGIC_VECTOR (4 downto 0);
           CodeOut : out STD_LOGIC_VECTOR(19 downto 0));
end component;
-- Gen. nivel
component Nivel is
    Port ( CLK,CLR : in STD_LOGIC;
           NA : out STD_LOGIC);
end component;
-- Controlador UC
component UC is
    Port ( CLK, CLR, TIPOR, BEQI, BNEI, BLTI, BLETI, BGTI, BGETI, NA, EQ, NE, LT, LE, GT, GE : in STD_LOGIC;
           SDOPC, SM : out STD_LOGIC);
end component;
-- Unidad de Control
component UniControl is
   Port ( 
        CLK, CLR        : in  STD_LOGIC;
        FunCode, Flags  : in  STD_LOGIC_VECTOR(3 downto 0);
        OpCode          : in  STD_LOGIC_VECTOR(4 downto 0);
        Micro           : out STD_LOGIC_VECTOR(19 downto 0));
end component;
end UCPackage;