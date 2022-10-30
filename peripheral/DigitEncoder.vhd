library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- 7-segment display encoder (common cathode)
entity DigitEncoder is
    port(
            A : in std_logic_vector(3 downto 0);
            RD : out std_logic_vector(7 downto 0));
end DigitEncoder;

architecture Behavioral of DigitEncoder is
    type DigitMem is array (0 to 15) of std_logic_vector(7 downto 0);
    constant mem : DigitMem := ("11111111", others => (others => '0')); -- TODO: init 
    --                           dgfedcba
begin
    RD <= mem(to_integer(unsigned(A)));
end Behavioral;


