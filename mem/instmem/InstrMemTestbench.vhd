library ieee;
use ieee.std_logic_1164.all;

entity InstrMemTestbench is
end InstrMemTestbench;

architecture Behavioral of InstrMemTestbench is

    component InstrMem is
    generic (
        -- INI : integer := 4; -- Inicio
        N : integer := 32;
        M : integer := 32;  
        K : integer := 10
        -- STEP     : integer := 1; -- Espacio entre elementos
        -- MEM_ADDR : integer := 0;  -- Dir. memoria inicio arreglo
        -- DIR      : integer := 0  -- Dir. asc (0) desc (1)
    );
    port ( A : in STD_LOGIC_VECTOR (M - 1 downto 0);
           RD : out STD_LOGIC_VECTOR (N - 1 downto 0));
    end component;

    signal A : std_logic_vector(31 downto 0);
    signal RD : std_logic_vector(31 downto 0);

begin

    imem : InstrMem port map (
        A => A,
        RD => RD);

process begin
    A <= (others => '0');
    wait for 10 ns;
    A <= x"00000001";
    wait for 10 ns;
    A <= x"00000002";
    wait for 10 ns;
    A <= x"00000003";
    wait for 10 ns;
    A <= x"00000004";
    wait for 10 ns;
    A <= x"00000005";
    wait;
end process;
end Behavioral;
