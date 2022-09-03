library IEEE;
library work;
use IEEE.STD_LOGIC_1164.ALL;
use work.ALUPackage.ALL;

entity ALUNbits is
    generic (N : integer := 4);
    Port ( a,b : in STD_LOGIC_VECTOR (N - 1 downto 0);
           op,sel : in STD_LOGIC_VECTOR (1 downto 0);
           s : out STD_LOGIC_VECTOR (N - 1 downto 0);
           flg_ov, flg_n, flg_z, flg_c : out STD_LOGIC);
end ALUNbits;

architecture Behavioral of ALUNbits is

signal c : STD_LOGIC_VECTOR(N downto 0);
signal s_aux : STD_LOGIC_VECTOR(N - 1 downto 0);

begin
    c(0) <= sel(0);
    s <= s_aux;
    ciclo : for i in 0 to N - 1 generate
        alun : ALUBit port map(
            a => a(i),
            b => b(i),
            sel => sel,
            cin => c(i),
            op => op,
            s => s_aux(i),
            cout => c(i + 1));
    end generate;
    -- Bandera z
    process(s_aux, a, b, sel, op)
    variable aux : STD_LOGIC;
    begin
        aux := '0';
        zfor : for i in 0 to N - 1 loop
           aux := aux or s_aux(i);
        end loop;
        flg_z <= not aux;
    end process;
    -- Banderas
    flg_ov <= c(N - 1) xor c(N);
    flg_n <= s_aux(N - 1);
    flg_c <= c(N);
end Behavioral;
