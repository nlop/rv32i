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
-- constant CONST_MEM_ADDR : STD_LOGIC_VECTOR(11 downto 0) := CONV_STD_LOGIC_VECTOR(MEM_ADDR, 12);
--    Instrucciones
-- constant TIPO_R : STD_LOGIC_VECTOR(4 downto 0) := "00000";
-- constant ADD : STD_LOGIC_VECTOR(3 downto 0) := x"0";
-- constant SRLL : STD_LOGIC_VECTOR(3 downto 0) := x"a";
-- constant SUB : STD_LOGIC_VECTOR(3 downto 0) := x"1";
-- constant ADDI : STD_LOGIC_VECTOR(4 downto 0) := "00101";
-- constant SUBI : STD_LOGIC_VECTOR(4 downto 0) := "00110";
-- constant LI : STD_LOGIC_VECTOR(4 downto 0) := "00001";
-- constant LWI : STD_LOGIC_VECTOR(4 downto 0) := "00010";
-- constant LW : STD_LOGIC_VECTOR(4 downto 0) := "10111";
-- constant SW : STD_LOGIC_VECTOR(4 downto 0) := "00100";
-- constant SWI : STD_LOGIC_VECTOR(4 downto 0) := "00011";
-- constant CALL : STD_LOGIC_VECTOR(4 downto 0) := "10100";
-- constant BNEI : STD_LOGIC_VECTOR(4 downto 0) := "01110";
-- constant BEQI : STD_LOGIC_VECTOR(4 downto 0) := "01101";
-- constant BLTI : STD_LOGIC_VECTOR(4 downto 0) := "01111";
-- constant BLETI : STD_LOGIC_VECTOR(4 downto 0) := "10000";
-- constant BGTI : STD_LOGIC_VECTOR(4 downto 0) := "10001";
-- constant BGETI : STD_LOGIC_VECTOR(4 downto 0) := "10010";
-- constant RET : STD_LOGIC_VECTOR(4 downto 0) := "10101";
-- constant B : STD_LOGIC_VECTOR(4 downto 0) := "10011";
-- constant NOP : STD_LOGIC_VECTOR(4 downto 0) := "10110";
-- constant SU : STD_LOGIC_VECTOR(3 downto 0) := x"0";
--   Registros
-- constant R0 : STD_LOGIC_VECTOR(3 downto 0) := x"0";
-- constant R1 : STD_LOGIC_VECTOR(3 downto 0) := x"1";
-- constant R2 : STD_LOGIC_VECTOR(3 downto 0) := x"2";
-- constant R3 : STD_LOGIC_VECTOR(3 downto 0) := x"3";
-- constant R4 : STD_LOGIC_VECTOR(3 downto 0) := x"4";
-- constant R5 : STD_LOGIC_VECTOR(3 downto 0) := x"5";
-- constant R6 : STD_LOGIC_VECTOR(3 downto 0) := x"6";
-- constant R7 : STD_LOGIC_VECTOR(3 downto 0) := x"7";
-- constant R8 : STD_LOGIC_VECTOR(3 downto 0) := x"8";
-- constant R14 : STD_LOGIC_VECTOR(3 downto 0) := x"e";
-- constant R15 : STD_LOGIC_VECTOR(3 downto 0) := x"f";
--   Cadenas del programa
-- constant SLIT_16_00 : STD_LOGIC_VECTOR(15 downto 0) := x"0000";
-- constant SLIT_16_01 : STD_LOGIC_VECTOR(15 downto 0) := x"0001";
-- constant SLIT_16_16 : STD_LOGIC_VECTOR(15 downto 0) := x"0010";
-- constant SLIT_16_23 : STD_LOGIC_VECTOR(15 downto 0) := x"0017";
-- constant SLIT_12_00 : STD_LOGIC_VECTOR(11 downto 0) := x"000";
-- constant SLIT_12_01 : STD_LOGIC_VECTOR(11 downto 0) := x"001";
-- constant FILL : STD_LOGIC_VECTOR(15 downto 0) := x"000e";
-- constant BSORTA : STD_LOGIC_VECTOR(15 downto 0) := x"0014";
-- constant BSORTD : STD_LOGIC_VECTOR(15 downto 0) := x"001f";
-- constant CSHO : STD_LOGIC_VECTOR(15 downto 0) := x"000b";
-- constant SHO : STD_LOGIC_VECTOR(15 downto 0) := x"002e";
-- constant SWP : STD_LOGIC_VECTOR(15 downto 0) := x"0033";
-- constant NP : STD_LOGIC_VECTOR(15 downto 0) := x"000c";
-- constant CSWP : STD_LOGIC_VECTOR(11 downto 0) := x"002";
-- constant ORD : STD_LOGIC_VECTOR(11 downto 0) := x"ff6";
-- constant CMP : STD_LOGIC_VECTOR(11 downto 0) := x"ff9";
-- constant E1 : STD_LOGIC_VECTOR(11 downto 0) := x"ffd";
-- constant E2A : STD_LOGIC_VECTOR(15 downto 0) := x"001d";
-- constant E2D : STD_LOGIC_VECTOR(15 downto 0) := x"002a";
-- constant E3 : STD_LOGIC_VECTOR(11 downto 0) := x"ffe";
-- constant CBSORT : STD_LOGIC_VECTOR(11 downto 0) := x"003";
constant data : InstrMemArr := (
-- BubbleSort v0.2
    -- LI     & R0  & CONV_STD_LOGIC_VECTOR(INI, 16), --- 00 MAIN
    -- LI     & R1  & CONV_STD_LOGIC_VECTOR(N, 16),   --- 01
    -- SUBI   & R6  & R1 & SLIT_12_01,     --- 02
    -- LI     & R2  & CONV_STD_LOGIC_VECTOR(STEP, 16), --- 03
    -- LI     & R7  & CONV_STD_LOGIC_VECTOR(DIR, 16),  --- 04
    -- LI     & R8  & SLIT_16_00,          --- 05
    -- CALL   & SU  & FILL,                --- 06
    -- BEQI   & R7  & R8 & CBSORT,         --- 07
    -- CALL   & SU  & BSORTD,              --- 08
    -- B      & SU  & CSHO,                --- 09
    -- CALL   & SU  & BSORTA,              --- 10 CBSORT
    -- CALL   & SU  & SHO,                 --- 11 CSHO
    -- NOP    & SU  & SU & SU & SU & SU,   --- 12 NP
    -- B      & SU  & NP,                  --- 13
    -- LI     & R3  & SLIT_16_00,          --- 14 FILL
    -- SW     & R0  & R3  & CONST_MEM_ADDR,--- 15 E1
    -- ADDI   & R3  & R3  & SLIT_12_01,    --- 16
    -- TIPO_R & R0  & R0  & R2 & SU & SUB, --- 17
    -- BNEI   & R1  & R3  & E1,            --- 18
    -- RET    & SU  & SU  & SU & SU & SU,  --- 19  
    -- LI     & R15 & SLIT_16_00,          --- 20 BSORTA 
    -- LI     & R0  & SLIT_16_00,          --- 21 ORD
    -- LI     & R14 & SLIT_16_00,          --- 22
    -- LW     & R3  & R0  & CONST_MEM_ADDR,--- 23 CMP
    -- ADDI   & R5  & R0  & SLIT_12_01,    --- 24
    -- LW     & R4  & R5  & CONST_MEM_ADDR,--- 25
    -- BGTI   & R4  & R3  & CSWP,          --- 26
    -- B      & SU  & E2A,                 --- 27
    -- CALL   & SU & SWP,                  --- 28 CSWP
    -- ADDI   & R0  & R5  & SLIT_12_00,    --- 29 E2A
    -- BNEI   & R0  & R6  & CMP,           --- 30 
    -- BNEI   & R15 & R14 & ORD,           --- 31
    -- RET    & SU  & SU  & SU & SU & SU,  --- 32  
    -- LI     & R15 & SLIT_16_00,          --- 33 BSORTD 
    -- LI     & R0  & SLIT_16_00,          --- 34 ORD
    -- LI     & R14 & SLIT_16_00,          --- 35
    -- LW     & R3  & R0  & CONST_MEM_ADDR,--- 36 CMP
    -- ADDI   & R5  & R0  & SLIT_12_01,    --- 37
    -- LW     & R4  & R5  & CONST_MEM_ADDR,--- 38
    -- BLTI   & R4  & R3  & CSWP,          --- 39
    -- B      & SU  & E2D,                 --- 40
    -- CALL   & SU & SWP,                  --- 41 CSWP
    -- ADDI   & R0  & R5  & SLIT_12_00,    --- 42 E2D
    -- BNEI   & R0  & R6  & CMP,           --- 43 
    -- BNEI   & R15 & R14 & ORD,           --- 44
    -- RET    & SU  & SU  & SU & SU & SU,  --- 45  
    -- LI     & R0  & SLIT_16_00,          --- 46 SHO
    -- LW     & R2  & R0  & CONST_MEM_ADDR,--- 47 E3
    -- ADDI   & R0  & R0  & SLIT_12_01,    --- 48
    -- BNEI   & R0  & R1 & E3,             --- 49
    -- RET    & SU  & SU  & SU & SU & SU,  --- 50  
    -- LI     & R14 & SLIT_16_01,          --- 51 SWP
    -- SW     & R3  & R5  & CONST_MEM_ADDR,--- 52 
    -- SW     & R4  & R0  & CONST_MEM_ADDR,--- 53
    -- RET    & SU  & SU  & SU & SU & SU,  --- 54
    -- others => (NOP & SU & SU & SU & SU & SU)
    (others => '0'),
    x"11111111",
    x"22222222",
    others => (others => '0')
    );
begin
    RD <= data(to_integer(unsigned(A)));
end Behavioral;
