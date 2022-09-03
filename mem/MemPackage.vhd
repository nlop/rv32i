library ieee;
use ieee.std_logic_1164.all;

package MemPackage is
    constant N : integer := 32; -- Word size
    constant DATA_MEM_SIZE : integer := 10; -- Data memory size = 2^DATA_MEM_SIZE - 1
-- Tipo de dato memoria de datos
type DataMem Arr is array (0 to (2**DATA_MEM_SIZE - 1) ) of std_logic_vector(N - 1 downto 0);
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
