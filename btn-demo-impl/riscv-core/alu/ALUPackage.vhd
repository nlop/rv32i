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
    generic (N : integer := 4;
            LOG2N : integer := 2);
    port ( A, B : in std_logic_vector (n - 1 downto 0);
           aluOP : in std_logic_vector (1 downto 0);
           funct3 : in std_logic_vector (2 downto 0);
           funct7 : in std_logic;
           S : out std_logic_vector (n - 1 downto 0);
    flg_ov, flg_n, flg_z, flg_c : out std_logic);
end component;
end package;
