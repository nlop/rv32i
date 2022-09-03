library IEEE;
library work;
use IEEE.STD_LOGIC_1164.ALL;
use work.ALUPackage.ALL;

entity Testbench is
end Testbench;

architecture Behavioral of Testbench is

component ALUNbits is
    Generic (N : integer := 32);
    Port ( a,b : in STD_LOGIC_VECTOR (N - 1 downto 0);
           op,sel : in STD_LOGIC_VECTOR (1 downto 0);
           s : out STD_LOGIC_VECTOR (N - 1 downto 0);
           flg_ov, flg_n, flg_z, flg_c : out STD_LOGIC);
end component;

signal a,b,s : STD_LOGIC_VECTOR(31 downto 0);
signal flg_ov, flg_n, flg_z, flg_c : STD_LOGIC;
signal op,sel : STD_LOGIC_VECTOR(1 downto 0);

begin

ALU: AlUNBits
    port map(
    a => a,
    b => b,
    op => op,
    sel => sel,
    s => s,
    flg_ov => flg_ov,
    flg_n => flg_n,
    flg_z => flg_z,
    flg_c => flg_c);
process
begin
    a <= x"00000005"; -- A = 5
    b <= x"fffffffe"; -- B = -2
    op <= "11"; -- Suma
    sel <= "00";
    wait for 10 ns; 
    sel <= "01"; -- Resta
    wait for 10 ns; 
    sel <= "00"; -- AND
    op <= "00";
    wait for 10 ns;
    sel <= "11"; -- NAND
    op <= "01";
    wait for 10 ns;
    sel <= "00"; -- OR
    op <= "01";
    wait for 10 ns;
    sel <= "11"; -- NOR
    op <= "00";
    wait for 10 ns;
    sel <= "00"; -- XOR
    op <= "10";
    wait for 10 ns;
    sel <= "01"; -- XNOR
    op <= "10";
    wait for 10 ns;
    --b <= "0111"; -- B = 7
    --sel <= "00"; -- Suma
    --op <= "11"; 
    --wait for 10ns;
    --b <= "0101"; -- B = 5
    --sel <= "01"; -- Resta
    --wait for 10ns;
    --sel <= "11";
    --op <= "01"; -- NAND (NOT)
    wait;
end process;
end Behavioral;
