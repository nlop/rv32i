library ieee;
use ieee.std_logic_1164.all;

entity ConditionChecker is
    port (
        BRE : out std_logic;
        funct3 : in std_logic_vector(2 downto 0);
        Z, OV, C, N : in std_logic);
end ConditionChecker;

architecture Behavioral of ConditionChecker is
    -- Conditional flags
    signal EQ, NE, LT, GE, LTU, GEU : std_logic;
begin
    jmux: with funct3 select
        BRE <= EQ when "000",
               NE when "001",
               LT when "100",
               GE when "101",
               LTU when "110",
               GEU when "111",
               '0' when others;
    -- Conditionals
    EQ <= Z; -- equal
    NE <= not Z; -- not equal
    LT <= N xor OV ; -- less than
    GE <= not LT; -- greater than or equal
    LTU <= not C; -- less than unsigned
    GEU <= C; -- greater than or equal unsigned
end Behavioral;

