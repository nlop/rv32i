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
    constant U_OP_023 : std_logic_vector(6 downto 0) := "0010111";
    constant S_OP_035 : std_logic_vector(6 downto 0) := "0100011";
    constant R_OP_051 : std_logic_vector(6 downto 0) := "0110011";
    constant U_OP_055 : std_logic_vector(6 downto 0) := "0110111";
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
    constant F3_ZERO : std_logic_vector(2 downto 0) := (others => '0');
    constant F3_WORD : std_logic_vector(2 downto 0) := "010";
    constant F3_BYTE : std_logic_vector(2 downto 0) := "000";
    constant F3_UBYTE : std_logic_vector(2 downto 0) := "100";
    constant F3_ADD : std_logic_vector(2 downto 0) := "000";
    constant F3_AND : std_logic_vector(2 downto 0) := "111";
    constant F3_XOR : std_logic_vector(2 downto 0) := "100";
    constant F3_OR : std_logic_vector(2 downto 0) := "110";
    constant F3_EQ : std_logic_vector(2 downto 0) := "000";
    constant F3_NE : std_logic_vector(2 downto 0) := "001";
    constant F3_LT : std_logic_vector(2 downto 0) := "100";
    constant F3_SL : std_logic_vector(2 downto 0) := "001";
    constant F3_SR : std_logic_vector(2 downto 0) := "101";
    -- Immediate strings
    constant IMM_0x000 : std_logic_vector(11 downto 0) := x"000";
    constant IMM_0x001 : std_logic_vector(11 downto 0) := x"001";
    constant IMM_0x002 : std_logic_vector(11 downto 0) := x"002";
    constant IMM_0x004 : std_logic_vector(11 downto 0) := x"004";
    constant IMM_0x006 : std_logic_vector(11 downto 0) := x"006";
    constant IMM_0x008 : std_logic_vector(11 downto 0) := x"008";
    constant IMM_0x009 : std_logic_vector(11 downto 0) := x"009";
    constant IMM_0x060 : std_logic_vector(11 downto 0) := x"060";
    constant IMM_0x065 : std_logic_vector(11 downto 0) := x"065";
    constant IMM_0x100 : std_logic_vector(11 downto 0) := x"100";
    constant IMM_0x108 : std_logic_vector(11 downto 0) := x"108";
    constant IMM_0x700 : std_logic_vector(11 downto 0) := x"700";
    constant IMM_0xfff : std_logic_vector(11 downto 0) := x"fff";
    constant IMM_0x835 : std_logic_vector(11 downto 0) := x"835";
    constant IMM_5_0x8 : std_logic_vector(4 downto 0) := "01000";
    constant IMM_H_0x000 : std_logic_vector(6 downto 0) := "0000000";
    constant IMM_L_0x000 : std_logic_vector(4 downto 0) := "00000";
    constant IMM_H_0x001 : std_logic_vector(6 downto 0) := "0000000";
    constant IMM_L_0x001 : std_logic_vector(4 downto 0) := "00001";
    constant IMM_H_0x004 : std_logic_vector(6 downto 0) := "0000000";
    constant IMM_L_0x004 : std_logic_vector(4 downto 0) := "00100";
    constant IMM_H_0x008 : std_logic_vector(6 downto 0) := "0000000";
    constant IMM_L_0x008 : std_logic_vector(4 downto 0) := "01000";
    constant IMM_12_N2 : std_logic := '1';
    constant IMM_11_N2 : std_logic := '1';
    constant IMM_H_N2 : std_logic_vector(5 downto 0) := "111111";
    constant IMM_L_N2 : std_logic_vector(3 downto 0):= "1111";
    constant IMM_J_N4 : std_logic_vector(19 downto 0) := "11111111110111111111";
    -- NOP
    constant NOP : std_logic_vector(31 downto 0) := F7_ZERO & ZERO & ZERO & F3_ADD & ZERO & R_OP_051; -- add zero, zero, zero
constant data : InstrMemArr := (
    -- Forwarding unit demo
    --IMM_0x006 & ZERO & F3_ADD & T0 & I_OP_019, -- addi t0, zero, 0x006
    --IMM_0x004 & ZERO & F3_ADD & T1 & I_OP_019, -- addi t1, zero, 0x001
    --F7_ZERO & T1 & T0 & F3_ADD & T2 & R_OP_051, -- add t2, t0, t1
    --IMM_0x008 & T2 & F3_SL & T3 & I_OP_019, -- slli t3, t2, 0x08
    -- 
    -- Stall unit demo
    -- IMM_0x835 & ZERO & F3_ADD & T0 & I_OP_019, -- addi t0, zero, 0x835
    -- IMM_H_0x008 & T0 & ZERO & F3_WORD & IMM_L_0x008 & S_OP_035, -- sw t0, 0x008(zero)
    -- IMM_0x002 & ZERO & F3_ADD & T2 & I_OP_019, -- addi t2, zero, 0x002
    -- IMM_0x008 & ZERO & F3_WORD & T1 & I_OP_003, -- lw t1, 0x008(zero)
    -- F7_ZERO & T2 & T1 & F3_XOR & T3 & R_OP_051, -- xor t3, t1, t2
    -- F7_ZERO & T2 & T1 & F3_SL & T4 & R_OP_051, -- sll t4, t1, t2
    -- F7_ZERO & T2 & T1 & F3_OR & T5 & R_OP_051, -- or t5, t1, t2

    -- Jump demo
    -- NOP,                                            -- [00] nop
    -- IMM_0x000 & ZERO & F3_ADD & T0 & I_OP_019,      -- [04] redo: addi t0, zero, 0x0
    -- IMM_0x065 & ZERO & F3_ADD & T1 & I_OP_019,      -- [08] addi t1, zero, 0x64
    -- IMM_0x000 & ZERO & F3_ADD & T2 & I_OP_019,      -- [0C] addi t2, zero, 0x0
    -- IMM_0x060 & ZERO & F3_ADD & T3 & I_OP_019,      -- [10] addi t3, zero, 0x60
    -- IMM_0x100 & ZERO & F3_ADD & T4 & I_OP_019,      -- [14] addi t4, zero, 0x100
    -- x"fedff" & RA & J_OP_111,                       -- [18] call redo

    -- Branch demo
    -- NOP,                                            -- [00] nop
    -- x"00a" & ZERO & F3_ADD & T0 & I_OP_019,         -- [04] addi t0, zero, 0xa
    -- IMM_0x000 & ZERO & F3_ADD & T1 & I_OP_019,      -- [08] addi t1, zero, 0x0
    -- IMM_0x000 & ZERO & F3_ADD & T2 & I_OP_019,      -- [0C] addi t2, zero, 0x0
    -- x"0" & "000" & T0 & T1 & F3_LT & "10100" & B_OP_099,  -- [10] for: blt t1, t0, do
    -- NOP,                                            -- [14] done: nop
    -- x"ffdff" & ZERO & J_OP_111,                     -- [18] j done
    -- NOP,                                            -- [1C] done
    -- NOP,                                            -- [20] done
    -- IMM_0x001 & T1 & F3_ADD & T1 & I_OP_019,        -- [24] do: addi t1, t1, 1
    -- IMM_0x002 & T2 & F3_ADD & T2 & I_OP_019,        -- [28] addi t2, t2, 2
    -- x"fe5ff" & RA & J_OP_111,                       -- [2C] j for

    -- Peripherals demo
    -- x"80000" & T0 & U_OP_055,                       -- [00] lui t0, 0x80000
    -- IMM_0x000 & T0 & F3_ADD & T0 & I_OP_019,        -- [04] addi t0, t0, 0x000
    -- IMM_0x004 & ZERO & F3_ADD & S1 & I_OP_019,      -- [08] addi s1, zero, 0x004
    -- IMM_0x000 & T0 & F3_WORD & T1 & I_OP_003,       -- [0C] lw t1, 0(t0) # read BTN
    -- x"40000" & T0 & U_OP_055,                       -- [10] lui t0, 0x40000
    -- x"000" & T0 & F3_ADD & T0 & I_OP_019,           -- [14] addi t0, zero, 0x000
    -- x"00003" & T2 & U_OP_055,                       -- [18] lui t2, 0x00003
    -- x"210" & T2 & F3_ADD & T2 & I_OP_019,           -- [1C] addi t2, t2, 0x210
    -- IMM_H_0x000 & T2 & T0 & F3_WORD & IMM_L_0x000 & S_OP_035, -- [20] sw t2, 0x0(t0)
    -- NOP,                                            -- [24] done: nop
    -- x"ffdff" & ZERO & J_OP_111,                     -- [28] j done

    -- Demo main
    x"1ec" & ZERO & F3_ADD & SP & I_OP_019,             -- [00] init: addi sp, zero, 0x1fc  # init sp
    IMM_0x000 & ZERO & F3_ADD & S1 & I_OP_019,          -- [04] addi s1, zero, 0x0    # N
    IMM_0x000 & ZERO & F3_ADD & S2 & I_OP_019,          -- [08] addi s2, zero, 0x0    # alreadyPushed
    x"040" & ZERO & F3_ADD & S3 & I_OP_019,             -- [0C] addi s3, zero, 0x40   # max(N)
    IMM_0x000 & ZERO & F3_ADD & A0 & I_OP_019,          -- [10] addi a0, zero, 0x0
    x"01800" & RA & J_OP_111,                           -- [14] call disp_write(0)
    x"01800" & RA & J_OP_111,                           -- [18] loop: call read_btn()
    F7_ZERO & ZERO & A0 & F3_ADD & T1 & R_OP_051,       -- [1C] add t1, zero, a0
    x"002" & T1 & F3_AND & T2 & I_OP_019,               -- [20] andi t2, t1, 0x002    # up pushed
    x"0" & "000" & ZERO & T2 & F3_EQ & "10000" & B_OP_099,  -- [24] beq t2, zero, case_dw
    x"002" & T2 & F3_AND & T2 & I_OP_019,                   -- [28] andi t2, s2, 0x002    
    x"0" & "000" & ZERO & T2 & F3_NE & "10000" & B_OP_099   -- [2C] bne t2, zero, case_dw     # up already pushed?
    x"0" & "000" & S3 & S1 & F3_LT & "10000" & B_OP_099     -- [30] blt s1, s3, n_plus        # N < max(N)?
    x"01800" & ZERO & J_OP_111                          -- [34] j default
    IMM_0x001 & S1 & F3_ADD & S1 & I_OP_019,            -- [38] n_plus: addi s1, zero, 1
    F7_ZERO & ZERO & S1 & F3_ADD & A0 & R_OP_051,       -- [3C] add a0, zero, s1
    x"01800" & RA & J_OP_111,                           -- [40] call disp_write(s1)
    x"002" & S2 & F3_OR & S2 & I_OP_019,                -- [44] ori s2, s2, 0x002             # up pushed = 1
    x"01800" & ZERO & J_OP_111                          -- [48] j default
    x"010" & T1 & F3_AND & T2 & I_OP_019,               -- [4C] case_dw: andi t2, t1, 0x010   # dw pushed
    x"0" & "000" & ZERO & T2 & F3_EQ & "10000" & B_OP_099,  -- [50] beq t2, zero, case_r
    x"010" & T2 & F3_AND & T2 & I_OP_019,                   -- [54] andi t2, s2, 0x010    
    x"0" & "000" & ZERO & T2 & F3_NE & "10000" & B_OP_099   -- [58] bne t2, zero, case_r      # dw already pushed?
    x"0" & "000" & S1 & ZERO & F3_LT & "10000" & B_OP_099   -- [5C] blt zero, s1, n_minus     # 0 < N ?
    x"01800" & ZERO & J_OP_111                          -- [60] j default
    x"fff" & S1 & F3_ADD & S1 & I_OP_019,               -- [64] n_minus: addi s1, zero, -1
    F7_ZERO & ZERO & S1 & F3_ADD & A0 & R_OP_051,       -- [68] add a0, zero, s1
    x"01800" & RA & J_OP_111,                           -- [6C] call disp_write(s1)
    x"010" & S2 & F3_OR & S2 & I_OP_019,                -- [70] ori s2, s2, 0x002             # up pushed = 1
    x"01800" & ZERO & J_OP_111                          -- [74] j default
    x"008" & T1 & F3_AND & T2 & I_OP_019,               -- [78] case_r: andi t2, t1, 0x008   # r pushed
    x"0" & "000" & ZERO & T2 & F3_EQ & "10000" & B_OP_099,  -- [7C] beq t2, zero, case_c
    x"008" & T2 & F3_AND & T2 & I_OP_019,                   -- [80] andi t2, s2, 0x008    
    x"0" & "000" & ZERO & T2 & F3_NE & "10000" & B_OP_099   -- [84] bne t2, zero, case_c      # r already pushed?
    IMM_0x000 & ZERO & F3_ADD & A0 & I_OP_019,          -- [88] addi a0, zero, 0x0
    x"01800" & RA & J_OP_111,                           -- [8C] call disp_write(0)
    NOP,                                                -- [90] TODO: call f(N)
    NOP,                                                -- [94] call disp_write(a0)
    x"01800" & ZERO & J_OP_111                          -- [98] j default
    x"008" & S2 & F3_OR & S2 & I_OP_019,                -- [9C] ori s2, s2, 0x008             # r pushed = 1
    x"01800" & ZERO & J_OP_111                          -- [A0] j default
    x"001" & T1 & F3_AND & T2 & I_OP_019,               -- [A4] case_c: andi t2, t1, 0x001    # c pushed
    x"0" & "000" & ZERO & T2 & F3_EQ & "10000" & B_OP_099,  -- [A8] beq t2, zero, default
    x"01800" & ZERO & J_OP_111                          -- [AC] j init
    F7_ZERO & ZERO & S1 & F3_ADD & A0 & R_OP_051,       -- [B0] default: and s2, s2, t1
    x"01800" & ZERO & J_OP_111                          -- [B4] j loop
    x"80000" & T0 & U_OP_055,                           -- [B8] read_btn: lui t0, 0x80000
    IMM_0x000 & T0 & F3_ADD & T0 & I_OP_019,            -- [BC] addi t0, t0, 0x000
    IMM_0x000 & A0 & F3_WORD & T1 & I_OP_003,           -- [C0] lw a0, 0(t0)                # read BTN
    IMM_0x000 & RA & F3_ZERO & ZERO & I_OP_103,         -- [C4] ret (jalr, zero, ra, 0x0)
    x"40000" & T0 & U_OP_055,                           -- [C8] disp_write: lui t0, 0x40000
    IMM_0x000 & T0 & F3_ADD & T0 & I_OP_019,            -- [CC] addi t0, t0, 0x000
    IMM_H_0x000 & T2 & T0 & F3_WORD & IMM_L_0x000 & S_OP_035, -- [0D0] sw a0, 0x0(t0)
    IMM_0x000 & RA & F3_ZERO & ZERO & I_OP_103,         -- [D4] ret (jalr, zero, ra, 0x0)

    -- Branch predictor demo (factorial n!)
    -- IMM_0x000 & ZERO & F3_ADD & T0 & I_OP_019,      -- [00] addi t0, zero, 0x0
    -- IMM_0x065 & ZERO & F3_ADD & T1 & I_OP_019,      -- [04] addi t1, zero, 0x64
    -- IMM_0x000 & ZERO & F3_ADD & T2 & I_OP_019,      -- [08] addi t2, zero, 0x0
    -- IMM_0x060 & ZERO & F3_ADD & T3 & I_OP_019,      -- [0C] addi t3, zero, 0x60
    -- x"01800" & RA & J_OP_111,                       -- [10] call series
    -- IMM_H_0x000 & T2 & T3 & F3_WORD & IMM_L_0x000 & S_OP_035, -- [14] sw t2, 0x0(t2)
    -- NOP, -- [18] end: nop
    -- x"ffdff" & ZERO & J_OP_111, -- [1C] j nop
    -- F7_ZERO & T0 & T2 & F3_ADD & T2 & R_OP_051,     -- [20] sum: add t2, t2, t0
    -- IMM_0x001 & T0 & F3_ADD & T0 & I_OP_019,        -- [24] addi t0, t0, 0x1
    -- x"f" & "111" & T1 & T0 & F3_LT & "11001" & B_OP_099, -- [28] series: blt t0, t1, sum (-8)
    -- IMM_0x000 & RA & F3_ZERO & ZERO & I_OP_103,     -- [2C] ret (jalr, zero, ra, 0x0)

    -- U-type instruction demo
    -- x"abcde" & T0 & U_OP_055,                   -- lui t0, 0xabcde
    -- IMM_0x835 & T0 & F3_ADD & T0 & I_OP_019,    -- addi t0, zero, 0x835
    -- NOP,                                        -- end: nop
    -- x"ffdff" & ZERO & J_OP_111,                 -- j nop

    -- Recursion demo (fibonacci), sol: S2 = 0x1055 when n = 19
    -- IMM_0x100 & ZERO & F3_ADD & SP & I_OP_019,      -- [00] addi sp, zero, 0x100  # init sp at 0x100
    -- IMM_0x108 & ZERO & F3_ADD & S1 & I_OP_019,      -- [04] addi s1, zero, 0x108
    -- IMM_0x000 & ZERO & F3_ADD & A0 & I_OP_019,      -- [08] addi a0, zero, 0x000 # a = 0
    -- IMM_0x001 & ZERO & F3_ADD & A1 & I_OP_019,      -- [0C] addi a1, zero, 0x001 # b = 1
    -- x"014" & ZERO & F3_ADD & A2 & I_OP_019,         -- [10] addi a2, zero, 0x014 # n = 20 (n - 1)
    -- x"ff4" & SP & F3_ADD & SP & I_OP_019,           -- [14] addi sp, sp, -12
    -- IMM_H_0x000 & A0 & SP & F3_WORD & IMM_L_0x000 & S_OP_035, -- [18] sw a0, 0x000(sp) # push arguments onto the stack
    -- IMM_H_0x004 & A1 & SP & F3_WORD & IMM_L_0x004 & S_OP_035, -- [1C] sw a1, 0x004(sp)
    -- IMM_H_0x008 & A2 & SP & F3_WORD & IMM_L_0x008 & S_OP_035, -- [20] sw a2, 0x008(sp)
    -- x"02000" & RA & J_OP_111,                       -- [24] call fibo
    -- F7_ZERO & ZERO & A0 & F3_ADD & S2 & R_OP_051,   -- [28] add s2, a0, zero
    -- IMM_H_0x000 & S2 & S1 & F3_WORD & IMM_L_0x000 & S_OP_035, -- [2C] sw s2, 0x000(s1) 
    -- IMM_0x000 & SP & F3_WORD & A0 & I_OP_003,       -- [30] lw a0, 0x000(sp) # pop arguments from stack
    -- IMM_0x004 & SP & F3_WORD & A1 & I_OP_003,       -- [34] lw a1, 0x004(sp)
    -- IMM_0x008 & SP & F3_WORD & A2 & I_OP_003,       -- [38] lw a2, 0x008(sp)
    -- NOP,                                            -- [3C] done: nop
    -- x"ffdff" & ZERO & J_OP_111,                     -- [40] j done
    -- x"ffc" & SP & F3_ADD & SP & I_OP_019,           -- [44] fibo: addi sp, sp, -4
    -- IMM_H_0x000 & RA & SP & F3_WORD & IMM_L_0x000 & S_OP_035, -- [48] sw a0, 0x000(sp) # push ra onto the stack
    -- IMM_0x001 & ZERO & F3_ADD & T0 & I_OP_019,      -- [4C] addi a1, zero, 1
    -- F7_ONE & T0 & A2 & F3_ADD & A2 & R_OP_051,      -- [50] sub  a2, a2, t0
    -- x"0" & "000" & A2 & ZERO & F3_LT & "10000" & B_OP_099, -- [54] blt zero, a2, rec
    -- IMM_0x000 & SP & F3_WORD & RA & I_OP_003,       -- [58] return: lw ra, 0x000(sp)
    -- IMM_0x004 & SP & F3_ADD & SP & I_OP_019,        -- [5C] addi sp, sp, 4
    -- IMM_0x000 & RA & F3_ZERO & ZERO & I_OP_103,     -- [60] ret (jalr, zero, ra, 0x0)
    -- F7_ZERO & ZERO & A1 & F3_ADD & T1 & R_OP_051,   -- [64] rec: add t1, zero, a1
    -- F7_ZERO & A0 & A1 & F3_ADD & A1 & R_OP_051,     -- [68] add a1, a1, a0
    -- F7_ZERO & ZERO & T1 & F3_ADD & A0 & R_OP_051,   -- [6C] add a0, zero, t1
    -- x"fd5ff" & RA & J_OP_111,                       -- [70] call fibo
    -- x"fe5ff" & ZERO & J_OP_111,                     -- [74] j return

    -- Sorting demo
    -- x"038" & ZERO & F3_ADD & S1 & I_OP_019,                     -- [000] addi s1, zero, 0x38 # seed for pseudo-rand function
    -- x"7d2a1" & S1 & U_OP_055,                                   -- [004] lui s1, 0x7d2a1 
    -- x"1ec" & ZERO & F3_ADD & SP & I_OP_019,                     -- [008] addi sp, zero, 0x1fc # init sp
    -- x"005" & ZERO & F3_ADD & A0 & I_OP_019,                     -- [00C] addi a0, zero, 0x5 # N
    -- x"200" & ZERO & F3_ADD & A1 & I_OP_019,                     -- [010] addi a1, zero, 0x200 # start ptr
    -- x"ff8" & SP & F3_ADD & SP & I_OP_019,                       -- [014] addi sp, sp, -8
    -- IMM_H_0x000 & A0 & SP & F3_WORD & IMM_L_0x000 & S_OP_035,   -- [018] sw a0, 0(sp)
    -- IMM_H_0x004 & A1 & SP & F3_WORD & IMM_L_0x004 & S_OP_035,   -- [01C] sw a1, 4(sp)
    -- x"03000" & RA & J_OP_111,                                   -- [020] call fill                                                        
    -- IMM_0x000 & SP & F3_WORD & A2 & I_OP_003,                   -- [024] lw a0, 0(sp)
    -- IMM_0x004 & SP & F3_WORD & A2 & I_OP_003,                   -- [028] lw a1, 4(sp)
    -- x"09C00" & RA & J_OP_111,                                   -- [02C] call sort                                                        
    -- IMM_0x000 & SP & F3_WORD & A2 & I_OP_003,                   -- [030] lw a0, 0(sp)
    -- IMM_0x004 & SP & F3_WORD & A2 & I_OP_003,                   -- [034] lw a1, 4(sp)
    -- x"0ec00" & RA & J_OP_111,                                   -- [038] call read
    -- IMM_0x000 & SP & F3_WORD & A2 & I_OP_003,                   -- [03C] lw a0, 0(sp)
    -- IMM_0x004 & SP & F3_WORD & A2 & I_OP_003,                   -- [040] lw a1, 4(sp)
    -- IMM_0x008 & SP & F3_ADD & SP & I_OP_019,                    -- [044] addi sp, sp, 8
    -- NOP,                                                        -- [048] done: nop
    -- x"ffdff" & ZERO & J_OP_111,                                 -- [04C] j done
    -- x"ff8" & SP & F3_ADD & SP & I_OP_019,                       -- [050] fill: addi sp, sp, -8
    -- IMM_H_0x000 & RA & SP & F3_WORD & IMM_L_0x000 & S_OP_035,   -- [054] sw ra, 0(sp)
    -- IMM_H_0x004 & A0 & SP & F3_WORD & IMM_L_0x004 & S_OP_035,   -- [058] sw a0, 4(sp)
    -- F7_ZERO & A0 & ZERO & F3_ADD & T0 & R_OP_051,               -- [05C] add t0, zero, a0
    -- F7_ZERO & A1 & ZERO & F3_ADD & T1 & R_OP_051,               -- [060] add t1, zero, a1
    -- x"0" & "000" & T0 & ZERO & F3_LT & "10100" & B_OP_099,      -- [064] for1: blt zero, t0, gen
    -- IMM_0x000 & SP & F3_WORD & RA & I_OP_003,                   -- [068] lw ra, 0(sp)
    -- IMM_0x004 & SP & F3_WORD & A0 & I_OP_003,                   -- [06C] lw a0, 4(sp)
    -- x"008" & SP & F3_ADD & SP & I_OP_019,                       -- [070] addi sp, sp, 8
    -- IMM_0x000 & RA & F3_ZERO & ZERO & I_OP_103,                 -- [074] ret (jalr, zero, ra, 0)
    -- x"ff8" & SP & F3_ADD & SP & I_OP_019,                       -- [078] gen: addi sp, sp, -8
    -- IMM_H_0x000 & T0 & SP & F3_WORD & IMM_L_0x000 & S_OP_035,   -- [07C] sw t0, 0(sp)
    -- IMM_H_0x004 & T1 & SP & F3_WORD & IMM_L_0x004 & S_OP_035,   -- [080] sw t1, 4(sp)
    -- x"02000" & RA & J_OP_111,                                   -- [084] call rand                                                        
    -- IMM_0x000 & SP & F3_WORD & T0 & I_OP_003,                   -- [088] lw t0, 0(sp)
    -- IMM_0x004 & SP & F3_WORD & T1 & I_OP_003,                   -- [08C] lw t1, 4(sp)
    -- x"008" & SP & F3_ADD & SP & I_OP_019,                       -- [090] addi sp, sp, 8
    -- x"fff" & T0 & F3_ADD & T0 & I_OP_019,                       -- [094] addi t0, t0, -1
    -- IMM_H_0x000 & A0 & T1 & F3_BYTE & IMM_L_0x000 & S_OP_035,   -- [098] sb a0, 0(t1)
    -- IMM_0x001 & T1 & F3_ADD & T1 & I_OP_019,                    -- [09C] addi t1, t1, 1
    -- x"fc5ff" & ZERO & J_OP_111,                                 -- [0A0] j for1
    -- x"00c" & S1 & F3_SR & T0 & I_OP_019,                        -- [0A4] rand: srli t0, s1, 12 
    -- F7_ZERO & S1 & T0 & F3_XOR & T0 & R_OP_051,                 -- [0A8] xor t0, t0, s1
    -- x"019" & T0 & F3_SL & T1 & I_OP_019,                        -- [0AC] slli t1, t0, 25 
    -- F7_ZERO & T1 & T0 & F3_XOR & T0 & R_OP_051,                 -- [0B0] xor t0, t0, t1
    -- x"01b" & T0 & F3_SR & T1 & I_OP_019,                        -- [0B4] srli t1, t0, 27 
    -- F7_ZERO & T1 & T0 & F3_XOR & T0 & R_OP_051,                 -- [0B8] xor t0, t0, t1
    -- F7_ZERO & T0 & ZERO & F3_ADD & S1 & R_OP_051,               -- [0BC] add s1, zero, t0
    -- F7_ZERO & T0 & ZERO & F3_ADD & A0 & R_OP_051,               -- [0C0] add a0, zero, t0
    -- IMM_0x000 & RA & F3_ZERO & ZERO & I_OP_103,                 -- [0C4] ret (jalr, zero, ra, 0)
    -- x"ff8" & SP & F3_ADD & SP & I_OP_019,                       -- [0C8] sort: addi sp, sp, -8
    -- IMM_H_0x000 & S1 & SP & F3_WORD & IMM_L_0x000 & S_OP_035,   -- [0CC] sw s1, 0(sp) # push s1, s2 onto the stack
    -- IMM_H_0x004 & S2 & SP & F3_WORD & IMM_L_0x004 & S_OP_035,   -- [0D0] sw s2, 4(sp)
    -- F7_ZERO & A0 & ZERO & F3_ADD & S1 & R_OP_051,               -- [0D4] redo: add s1, zero, a0 # s1 = N
    -- F7_ZERO & A1 & ZERO & F3_ADD & S2 & R_OP_051,               -- [0D8] add s2, zero, a1 # s2 = A (ptr)
    -- IMM_0x000 & ZERO & F3_ADD & T0 & I_OP_019,                  -- [0DC] addi t0, zero, 0 # swap = 0
    -- IMM_0x001 & ZERO & F3_ADD & T1 & I_OP_019,                  -- [0E0] addi t1, zero, 1
    -- x"0" & "000" & A0 & T1 & F3_LT & "11000" & B_OP_099,        -- [0E4] for2: blt t1, a0, fb
    -- x"f" & "111" & ZERO & T0 & F3_NE & "01101"  & B_OP_099,     -- [0E8] do: bne t0, zero, redo
    -- IMM_0x000 & SP & F3_WORD & S1 & I_OP_003,                   -- [0EC] lw s1, 0(sp)
    -- IMM_0x004 & SP & F3_WORD & S2 & I_OP_003,                   -- [0F0] lw s2, 4(sp)
    -- IMM_0x008 & SP & F3_ADD & SP & I_OP_019,                    -- [0F4] addi sp, sp, 8
    -- IMM_0x000 & RA & F3_ZERO & ZERO & I_OP_103,                 -- [0F8] ret (jalr, zero, ra, 0)
    -- IMM_0x000 & S2 & F3_UBYTE & T3 & I_OP_003,                  -- [0FC] fb: lbu t3, 0(s2) # A[n - 1]
    -- IMM_0x001 & S2 & F3_UBYTE & T4 & I_OP_003,                  -- [100] lbu t4, 1(s2) # A[n]
    -- x"0" & "000" & T3 & T4 & F3_LT & "10000" & B_OP_099,        -- [104] blt t4, t3, swp (t4 < t3?)
    -- IMM_0x001 & S2 & F3_ADD & S2 & I_OP_019,                    -- [108] iadd: addi s2, s2, 1
    -- IMM_0x001 & T1 & F3_ADD & T1 & I_OP_019,                    -- [10C] addi t1, t1, 1
    -- x"fd5ff" & ZERO & J_OP_111,                                 -- [110] j for2
    -- IMM_H_0x000 & T4 & S2 & F3_BYTE & IMM_L_0x000 & S_OP_035,   -- [114] swp: sb t4, 0(s2)
    -- IMM_H_0x001 & T3 & S2 & F3_BYTE & IMM_L_0x001 & S_OP_035,   -- [118] sb t3, 1(s2)
    -- IMM_0x001 & ZERO & F3_ADD & T0 & I_OP_019,                  -- [11C] addi t0, zero, 1 # swap = 1
    -- x"fe9ff" & ZERO & J_OP_111,                                 -- [120] j iadd
    -- IMM_0x000 & ZERO & F3_ADD & T0 & I_OP_019,                  -- [124] read: addi t0, zero, 0
    -- F7_ZERO & A1 & ZERO & F3_ADD & T1 & R_OP_051,               -- [128] add t1, zero, a1
    -- x"0" & "000" & A0 & T0 & F3_LT & "01000" & B_OP_099,        -- [12C] for3: blt t0, a0, re1
    -- IMM_0x000 & RA & F3_ZERO & ZERO & I_OP_103,                 -- [130] ret (jalr, zero, ra, 0)
    -- IMM_0x000 & T1 & F3_UBYTE & T3 & I_OP_003,                  -- [134] re1: lbu t3, 0(t1) # A[n]
    -- IMM_0x001 & T1 & F3_ADD & T1 & I_OP_019,                    -- [138] addi t1, t1, 1
    -- IMM_0x001 & T0 & F3_ADD & T0 & I_OP_019,                    -- [13C] addi t0, t0, 1
    -- x"fedff" & ZERO & J_OP_111,                                 -- [144] j for3
    others => NOP
    );
begin
    RD <= data(to_integer(unsigned(A(31 downto 2))));
end Behavioral;
