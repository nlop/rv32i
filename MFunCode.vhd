library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;

entity MFunCode is
    Port ( FunCode : in STD_LOGIC_VECTOR (3 downto 0);
           CodeOut : out STD_LOGIC_VECTOR (19 downto 0));
end MFunCode;

architecture Behavioral of MFunCode is

type ROM is array (0 to 15) of STD_LOGIC_VECTOR(19 downto 0);

constant MEM : ROM := (
    "00000100010000110011", -- ADD (0)
    "00000100010001110010", -- SUB (1)
    "00000100010000000011", -- AND (2)
    "00000100010000010011", -- OR  (3)
    "00000100010000100011", -- XOR (4)
    "00000100010011010011", -- NAND(5)
    "00000100010011100011", -- NOR (6)
    "00000100010001100011", -- XNOR(7)
    "00000100010011000011", -- NOT (8)
    "00000001110000000000", -- SLL (9)
    "00000001010000000000", -- SRL (10)
    others => (others => '0'));
begin
    CodeOut <= MEM(CONV_INTEGER(FunCode));
end Behavioral;
