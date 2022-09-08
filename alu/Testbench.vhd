library IEEE;
library work;
use IEEE.STD_LOGIC_1164.ALL;
use work.ALUPackage.ALL;

entity Testbench is
    end Testbench;

architecture Behavioral of Testbench is

    component ALUNbits is
        generic (N : integer := 4;
                 LOG2N : integer := 2);
        port ( A, B : in std_logic_vector (n - 1 downto 0);
               aluOP : in std_logic_vector (1 downto 0);
               funct3 : in std_logic_vector (2 downto 0);
               funct7 : in std_logic;
               S : out std_logic_vector (n - 1 downto 0);
        flg_ov, flg_n, flg_z, flg_c : out std_logic);
    end component;

    signal a,b,s : STD_LOGIC_VECTOR(31 downto 0);
    signal flg_ov, flg_n, flg_z, flg_c : STD_LOGIC;
    signal aluOP : std_logic_vector (1 downto 0);
    signal funct3 : std_logic_vector (2 downto 0);
    signal funct7 : std_logic;

begin
    ALU: AlUNBits
    generic map(N => 32, LOG2N => 5)
    port map(
                a => a,
                b => b,
                aluOP => aluOP,
                funct3 => funct3,
                funct7 => funct7,
                s => s,
                flg_ov => flg_ov,
                flg_n => flg_n,
                flg_z => flg_z,
                flg_c => flg_c);
    process
    begin
        funct7 <= '0';
        funct3 <= (others => '0');
        a <= x"ffffffff";
        b <= x"00000005";
        aluOP <= "10"; -- slli
        funct3 <= "001";
        wait for 10 ns;
        funct3 <= "101";
        wait for 10 ns;
        wait;
    end process;
end Behavioral;
