library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- 7-segment display encoder (common cathode)
entity DigitEncoder is
    port(
            A : in std_logic_vector(3 downto 0);
            RD : out std_logic_vector(6 downto 0));
end DigitEncoder;

architecture Behavioral of DigitEncoder is
    type DigitMem is array (0 to 15) of std_logic_vector(6 downto 0);
    constant mem : DigitMem := (
--       gfedcba
        "1000000", -- 0 (0x40)
        "1111001", -- 1 (0x79)
        "0100100", -- 2 (0x24)
        "0110000", -- 3 (0x30)
        "0011001", -- 4 (0x19)
        "0010010", -- 5 (0x12)
        "0000010", -- 6 (0x02)
        "1111000", -- 7 (0x38)
        "0000000", -- 8 (0x0)
        "0011000", -- 9 (0x18)
        "0001000", -- a (0x08)
        "0000011", -- b (0x03)
        "1000110", -- c (0x46)
        "0100001", -- d (0x21)
        "0011000", -- e (0x18)
        "0001110"); -- f (0x0e)
begin
    RD <= mem(to_integer(unsigned(A)));
end Behavioral;
