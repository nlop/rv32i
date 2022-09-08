library IEEE;
library work;
use IEEE.STD_LOGIC_1164.ALL;
use work.ALUPackage.ALL;

entity ALUNbits is
    generic (N : integer := 4);
    port ( a, b : in std_logic_vector (n - 1 downto 0);
           aluOP : in std_logic_vector (1 downto 0);
           funct3 : in std_logic_vector (2 downto 0);
           funct7 : in std_logic;
           s : out std_logic_vector (n - 1 downto 0);
    flg_ov, flg_n, flg_z, flg_c : out std_logic);
end ALUNbits;

architecture Behavioral of ALUNbits is

    signal op, sel : std_logic_vector (1 downto 0);
    signal c : std_logic_vector(n downto 0);
    signal s_aux : std_logic_vector(n - 1 downto 0);

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
    -- ALU control
    ctl: process(aluOP, funct3, funct7) begin
        case aluOP is
            when "00" => -- add (I op=3)
                sel <= "00";
                op <= "11";
            when "01" => -- sub (B)
                sel <= "01";
                op <= "11";
            when "10" => -- I, op=19; 
                case funct3 is
                    when "000" => -- add/sub
                        op <= "11";
                        sel <= "00"; 
                    when "100" => -- xor
                        op <= "10";
                        sel <= "00";
                    when "110" => -- or
                        op <= "01";
                        sel <= "00";
                    when others => -- and
                        op <= "00";
                        sel <= "00";
                end case;
            when "11" => -- R, op=51
                case funct3 is
                    when "000" => -- add/sub
                        op <= "11";
                        if funct7 = '0' then
                            sel <= "00"; 
                        else
                            sel <= "01";
                        end if;
                    when "100" => -- xor
                        op <= "10";
                        sel <= "00";
                    when "110" => -- or
                        op <= "01";
                        sel <= "00";
                    when others => -- and
                        op <= "00";
                        sel <= "00";
                end case;
            when others =>
                op <= "00";
                sel <= "00";
        end case;
    end process;

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
