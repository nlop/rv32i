library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- 2^K * N instruction memory. Memory space length(A) is 32 to comply with
-- the RISC-V specification.
-- Parameters:
--      N : word size
--      M : address space
--      K : memory cells
entity InstrMem is
    generic (
        N : integer := 32;
        M : integer := 32;  
        K : integer := 10
    );
    port ( A : in STD_LOGIC_VECTOR (M - 1 downto 0);
           RD : out STD_LOGIC_VECTOR (N - 1 downto 0));
end InstrMem;

architecture Behavioral of InstrMem is
    -- Tipo de dato memoria de programa
    type InstrMemArr is array (0 to (2**K - 1)) of std_logic_vector(N - 1 downto 0);
-- Constantes del programa
--    Instrucciones
    constant I_OP_003 : std_logic_vector(6 downto 0) := "0000011";
    constant I_OP_019 : std_logic_vector(6 downto 0) := "0010011";
    constant S_OP_035 : std_logic_vector(6 downto 0) := "0100011";
    constant R_OP_051 : std_logic_vector(6 downto 0) := "0110011";
    constant B_OP_099 : std_logic_vector(6 downto 0) := "1100011";
    constant I_OP_103 : std_logic_vector(6 downto 0) := "1100111";
    constant J_OP_111 : std_logic_vector(6 downto 0) := "1101111";
--   Registros
    constant ZERO : std_logic_vector(4 downto 0) := (others => '0');
    constant RA : std_logic_vector(4 downto 0) := "00001";
    constant SP : std_logic_vector(4 downto 0) := "00010";
    constant GP : std_logic_vector(4 downto 0) := "00011";
    constant TP : std_logic_vector(4 downto 0) := "00100";
    constant T0 : std_logic_vector(4 downto 0) := "00101";
    constant T1 : std_logic_vector(4 downto 0) := "00110";
    constant T2 : std_logic_vector(4 downto 0) := "00111";
    constant FP : std_logic_vector(4 downto 0) := "01000";
    constant S1 : std_logic_vector(4 downto 0) := "01001";
    constant A0 : std_logic_vector(4 downto 0) := "01010";
    constant A1 : std_logic_vector(4 downto 0) := "01011";
    constant A2 : std_logic_vector(4 downto 0) := "01100";
    constant A3 : std_logic_vector(4 downto 0) := "01101";
    constant A4 : std_logic_vector(4 downto 0) := "01110";
    constant A5 : std_logic_vector(4 downto 0) := "01111";
    constant A6 : std_logic_vector(4 downto 0) := "10000";
    constant A7 : std_logic_vector(4 downto 0) := "10001";
    constant S2 : std_logic_vector(4 downto 0) := "10010";
    constant S3 : std_logic_vector(4 downto 0) := "10011";
    constant S4 : std_logic_vector(4 downto 0) := "10100";
    constant S5 : std_logic_vector(4 downto 0) := "10101";
    constant S6 : std_logic_vector(4 downto 0) := "10110";
    constant S7 : std_logic_vector(4 downto 0) := "10111";
    constant S8 : std_logic_vector(4 downto 0) := "11000";
    constant S9 : std_logic_vector(4 downto 0) := "11001";
    constant S10 : std_logic_vector(4 downto 0) := "11010";
    constant S11 : std_logic_vector(4 downto 0) := "11011";
    constant T3 : std_logic_vector(4 downto 0) := "11100";
    constant T4 : std_logic_vector(4 downto 0) := "11101";
    constant T5 : std_logic_vector(4 downto 0) := "11110";
    constant T6 : std_logic_vector(4 downto 0) := "11111";
    --  Function codes
    constant F7_ZERO : std_logic_vector(6 downto 0) := (others => '0');
    constant F7_ONE : std_logic_vector(6 downto 0) := "0100000";
    constant F3_HALF : std_logic_vector(2 downto 0) := "001";
    constant F3_BYTE : std_logic_vector(2 downto 0) := "000";
    constant F3_ZERO : std_logic_vector(2 downto 0) := (others => '0');
    constant F3_WORD : std_logic_vector(2 downto 0) := "010";
    constant F3_ADD : std_logic_vector(2 downto 0) := "000";
    constant F3_NE : std_logic_vector(2 downto 0) := "001";
    constant F3_SL : std_logic_vector(2 downto 0) := "001";
    constant F3_SR : std_logic_vector(2 downto 0) := "101";
    -- Immediate strings
    constant IMM_0x000 : std_logic_vector(11 downto 0) := x"000";
    constant IMM_0x001 : std_logic_vector(11 downto 0) := x"001";
    constant IMM_0x002 : std_logic_vector(11 downto 0) := x"002";
    constant IMM_0x004 : std_logic_vector(11 downto 0) := x"004";
    constant IMM_0x006 : std_logic_vector(11 downto 0) := x"006";
    constant IMM_0x008 : std_logic_vector(11 downto 0) := x"008";
    constant IMM_5_0x8 : std_logic_vector(4 downto 0) := "01000";
    constant IMM_0x700 : std_logic_vector(11 downto 0) := x"700";
    constant IMM_0xfff : std_logic_vector(11 downto 0) := x"fff";
    constant IMM_0x835 : std_logic_vector(11 downto 0) := x"835";
    constant IMM_H_008 : std_logic_vector(6 downto 0) := "0000000";
    constant IMM_L_008 : std_logic_vector(4 downto 0) := "01000";
    constant IMM_12_N2 : std_logic := '1';
    constant IMM_11_N2 : std_logic := '1';
    constant IMM_H_N2 : std_logic_vector(5 downto 0) := "111111";
    constant IMM_L_N2 : std_logic_vector(3 downto 0):= "1111";
    constant IMM_J_N4 : std_logic_vector(19 downto 0) := "11111111110111111111";
    -- NOP
    constant NOP : std_logic_vector(31 downto 0) := F7_ZERO & ZERO & ZERO & F3_ADD & ZERO & R_OP_051;
constant data : InstrMemArr := (
    -- Demo 1
    --IMM_0x006 & ZERO & F3_ADD & T0 & I_OP_019, -- addi t0, zero, 0x006
    --IMM_0x001 & ZERO & F3_ADD & T3 & I_OP_019, -- addi t3, zero, 0x001
    --IMM_0x700 & ZERO & F3_ADD & T1 & I_OP_019, -- addi t1, zero, 0x700 
    --IMM_0x002 & ZERO & F3_ADD & T2 & I_OP_019, -- addi t2, zero, 0x002
    --F7_ONE & T3 & T0 & F3_ADD & T0 & R_OP_051, -- sub t0, t0, t3
    --F7_ZERO & T2 & T1 & F3_ADD & T1 & R_OP_051, -- add t1, t1, t2
    --IMM_12_N2 & IMM_H_N2 & T0 & ZERO & F3_NE & IMM_L_N2 & IMM_11_N2 & B_OP_099, -- blt t2, zero, -2
    --IMM_H_008 & T1 & ZERO & F3_WORD & IMM_L_008 & S_OP_035, -- sw t1, 0x008(zero)
    --IMM_0x008 & ZERO & F3_WORD & T0 & I_OP_003, -- lw t0, 0x008(zero)
    --NOP,
    --NOP,
    IMM_0x835 & ZERO & F3_ADD & T0 & I_OP_019, -- addi t0, zero, 0xf53
    IMM_0x002 & ZERO & F3_ADD & T2 & I_OP_019, -- addi t2, zero, 0x002
    NOP,
    NOP,
    NOP,
    NOP,
    --IMM_0x004 & ZERO & F3_ADD & T2 & I_OP_019, -- addi t2, zero, 0x002
    IMM_0x008 & T0 & F3_SL & T1 & I_OP_019, -- slli t1, t0, 0x08
    --IMM_H_008 & T1 & ZERO & F3_WORD & IMM_L_008 & S_OP_035, -- sw t1, 0x008(zero)
    --F7_ONE & T2 & T0 & F3_SR & T1 & R_OP_051, -- sra t1, t0, t2
    --F7_ONE & IMM_5_0x8 & T0 & F3_SR & T1 & I_OP_019, -- srai t1, t0, 0x08
    NOP,
    NOP,
    NOP,
    NOP,
    IMM_H_008 & T1 & ZERO & F3_WORD & IMM_L_008 & S_OP_035, -- sw t1, 0x008(zero)
    NOP,
    NOP,
    NOP,
    NOP,
    IMM_0x008 & ZERO & F3_WORD & T0 & I_OP_003, -- lw t0, 0x008(zero)
    -- IMM_J_N4 & RA & J_OP_111, -- jal ra, -4
    -- IMM_0x001 & ZERO & F3_ZERO & RA & I_OP_103,
    others => NOP
    );
begin
    RD <= data(to_integer(unsigned(A)));
end Behavioral;
