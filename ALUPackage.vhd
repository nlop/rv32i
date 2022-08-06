library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

package ALUPackage is
-- Sumador 1 bit
component sumaBit is
    Port(a, b, cin : in STD_LOGIC;
        s , cout :  out STD_LOGIC);
end component;
-- ALU 1 bit
component ALUBit is
    Port ( a,b,cin : in STD_LOGIC;
           op,sel : in STD_LOGIC_VECTOR(1 downto 0);
           s,cout : out STD_LOGIC);
end component;
-- ALU N bits
component ALUNbits is
    generic ( N : integer := 4);
    Port ( a,b : in STD_LOGIC_VECTOR (N - 1 downto 0);
           op,sel : in STD_LOGIC_VECTOR (1 downto 0);
           s : out STD_LOGIC_VECTOR (N - 1 downto 0);
           flg_ov, flg_n, flg_z, flg_c : out STD_LOGIC);
end component;
end package;