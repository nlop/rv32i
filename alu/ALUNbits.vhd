library IEEE;
library work;
use IEEE.STD_LOGIC_1164.ALL;
use work.ALUPackage.ALL;

entity ALUNbits is
    generic (N : integer := 4;
            LOG2N : integer := 2);
    port ( A, B : in std_logic_vector (N - 1 downto 0);
           aluOP : in std_logic_vector (1 downto 0);
           funct3 : in std_logic_vector (2 downto 0);
           funct7 : in std_logic;
           S : out std_logic_vector (N - 1 downto 0);
    flg_ov, flg_n, flg_z, flg_c : out std_logic);
end ALUNbits;

architecture Behavioral of ALUNbits is


    component BarrelShifter is
        generic (N : integer := 16; 
                 LOG2N : integer := 4);
        port ( din : in std_logic_vector (N - 1 downto 0);
               dout : out std_logic_vector (N - 1 downto 0);
               shamt : in std_logic_vector (LOG2N - 1 downto 0);
               DIR : in std_logic;
               SRAE : in std_logic);
        -- constant SHBITS : integer := integer(ceil(log2(real(N) + real(1)))) - 1;
        --                                                ^ prevent rounding errors
    end component;

    signal op, sel : std_logic_vector (1 downto 0);
    signal c : std_logic_vector(N downto 0);
    signal flg_z_int : std_logic;
    signal flg_n_int : std_logic;
    signal flg_ov_int : std_logic;
    signal s_aux : std_logic_vector(N - 1 downto 0);
    signal s_alu : std_logic_vector(N - 1 downto 0);
    -- Barrel shifter
    signal barrelOut : std_logic_vector(N - 1 downto 0);
    signal shDir : std_logic;
    -- Set instr signals
    signal zeros : std_logic_vector(N - 2 downto 0);
    signal slt : std_logic_vector(N -1 downto 0);
    signal sltu : std_logic_vector(N -1 downto 0);

begin
    -- Zeros
    zeros <= (others => '0');
    -- Set instruction
    slt <= zeros & (flg_n_int xor flg_ov_int);
    sltu <= zeros & not C(n);
    -- Carry
    c(0) <= sel(0);
    -- Result(S) mux
    S <= s_alu when aluOP(1) = '0' else s_aux;
    -- Result (aluOP = 1-) mux
    with funct3 select
        s_aux <= slt when "010",
             sltu when "011",
             barrelOut when "001" | "101",
             s_alu when others;
    -- Generate ALU units
    ciclo : for i in 0 to N - 1 generate
        alun : ALUBit port map(
                                  a => a(i),
                                  b => b(i),
                                  sel => sel,
                                  cin => c(i),
                                  op => op,
                                  s => s_alu(i),
                                  cout => c(i + 1));
    end generate;
    -- Barrel shifter
    bs: BarrelShifter generic map (
        N => N,
        LOG2N => LOG2N)
    port map (
        din => A,
        dout => barrelOut,
        shamt => B(LOG2N - 1 downto 0),
        DIR => shDir,
        SRAE => funct7);
    -- Shift direction
    -- shDir = 0 >>, shDir = 1 <<
    shDir <= not funct3(2);
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
                    when "000" => -- addi/subi
                        op <= "11";
                        sel <= "00"; 
                    when "100" => -- xori
                        op <= "10";
                        sel <= "00";
                    when "110" => -- ori
                        op <= "01";
                        sel <= "00";
                    when "010" | "011" => -- slti, sltiu
                        op <= "11";
                        sel <= "01";
                    when others => -- andi
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
                    when "010" | "011" => -- slt, sltu
                        op <= "11";
                        sel <= "01";
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
    process(s_alu, a, b, sel, op)
        variable aux : STD_LOGIC;
    begin
        aux := '0';
        zfor : for i in 0 to N - 1 loop
            aux := aux or s_alu(i);
        end loop;
        flg_z_int <= not aux;
    end process;
    -- Flag int
    flg_n_int <= s_alu(N - 1);
    flg_ov_int <= c(N - 1) xor c(N);
    -- Banderas
    flg_ov <= flg_ov_int;
    flg_n <= flg_n_int;
    flg_c <= c(N);
    flg_z <= flg_z_int;
end Behavioral;
