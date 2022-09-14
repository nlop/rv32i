library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity InstrMemTestbench is
end InstrMemTestbench;

architecture Behavioral of InstrMemTestbench is

    component InstrMemProgrammable is
    generic (
        -- INI : integer := 4; -- Inicio
        N : integer := 32;
        M : integer := 32;  
        K : integer := 10
    );
    port ( A : in STD_LOGIC_VECTOR (M - 1 downto 0);
           RD : out STD_LOGIC_VECTOR (N - 1 downto 0));
    end component;

    signal A : std_logic_vector(31 downto 0);
    signal RD : std_logic_vector(31 downto 0);

begin

    imem : InstrMemProgrammable port map (
        A => A,
        RD => RD);

process 
    variable ADDR : integer := 0;
begin
    A <= (others => '0');
    for i in 0 to 32 loop
        wait for 10 ns;
        A <= A + 1;
    end loop;
    wait;
end process;
end Behavioral;
