entity BranchChecker is
    port (
        JEN : out std_logic;
        FUN3 : in std_logic_vector(2 downto 0);
        Z, OV, C, N : in std_logic);
end BranchChecker;

architecture Behavioral of BranchChecker is
    -- Conditional flags
    signal EQ, NE, LT, GE, LTU, GEU : std_logic;
begin
    jmux: with FUN3 select
        JEN <= EQ when "000"
               NE when "001"
               LT when "100"
               GE when "101"
               LTU when "110"
               GEU when "111"
               '0' when others;
    -- Conditionals
    EQ <= Z;
    NE <= not Z;
    LT <= not C ;
    GE <= C;
    LTU <= LT;
    GEU <= GE;
end Behavioral;

