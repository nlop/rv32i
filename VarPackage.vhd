library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

package VarPackage is
-- Tipo de dato memoria stack
Type StackArray is array(0 to (2**3 -1)) of STD_LOGIC_VECTOR(9 downto 0);
-- Tipo de dato memoria de programa
Type MEM_PROG is array (0 to (2**10 - 1)) of STD_LOGIC_VECTOR(24 downto 0);
-- Tipo de dato memoria de datos
Type MEM_DATA is array (0 to (2**10 - 1) ) of STD_LOGIC_VECTOR(15 downto 0);
-- Stack
component Stack is
    Port ( PCIN : in STD_LOGIC_VECTOR (9 downto 0);
           UP,DW,WPC,CLK,CLR : in STD_LOGIC;
           PCOUT : out STD_LOGIC_VECTOR (9 downto 0);
           SPOUT : out STD_LOGIC_VECTOR(2 downto 0));
end component;
-- Memoria Programa
component ProgMem is
    Generic (
        INI      : integer := 4; -- Inicio
        N        : integer := 4; -- N elementos
        STEP     : integer := 1; -- Espacio entre elementos
        MEM_ADDR : integer := 0;  -- Dir. memoria inicio arreglo
        DIR      : integer := 0  -- Dir. asc (0) desc (1)
    );
    Port ( pc : in STD_LOGIC_VECTOR (9 downto 0);
           ints : out STD_LOGIC_VECTOR (24 downto 0));
end component;
-- Memoria Datos
component DataMem is
    Port ( addr : in STD_LOGIC_VECTOR (9 downto 0);
           din : in STD_LOGIC_VECTOR (15 downto 0);
           WD, CLK : in STD_LOGIC;
           dout : out STD_LOGIC_VECTOR (15 downto 0));
end component;
end package;
