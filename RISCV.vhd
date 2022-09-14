library ieee;
library work;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use work.ALUPackage.all;

entity RISCV is
    generic(
               N : integer := 32;
               LOG2N : integer := 5;
               M : integer := 5); 
    port(
    CLK, CLR : in std_logic;
    readData, inst : in std_logic_vector(N - 1 downto 0);
    writeData, aluResult  : out std_logic_vector(N - 1 downto 0);
    pcout : out std_logic_vector(N - 1 downto 0);
    funct3 : out std_logic_vector(2 downto 0);
    wRAM : out std_logic);
end RISCV;

architecture Behavioral of RISCV is
    -- Generic register file
    component RegisterFile is
        generic( 
                   N : integer := 16;
                   LOG2N : integer := 4;
                   NREG : integer := 4);

        port ( WD3 : in std_logic_vector (N - 1 downto 0);
        A3, A1, A2 : in std_logic_vector (NREG - 1 downto 0);
        CLK, CLR, WE3 : in std_logic;
        RD1, RD2 : out std_logic_vector (N - 1 downto 0));
    end component;
    -- Extender
    component Extender is
        port(
                inst : in std_logic_vector(31 downto 0);
                SRC : in std_logic_vector(1 downto 0);
                EXT : out std_logic_vector(31 downto 0));
    end component;
    --Control unit 
    component ControlUnit is
        port (
                 op : in std_logic_vector(6 downto 0);
                 aluOP : out std_logic_vector(1 downto 0);
                 srcB : out std_logic;
                 WE3En : out std_logic;
                 wRamEn : out std_logic;
                 resSrc : out std_logic_vector(1 downto 0);
                 extSrc : out std_logic_vector(1 downto 0);
                 BR : out std_logic;
                 JMP : out std_logic;
                 jmpSrc : out std_logic);
    end component;
    -- Program counter
    component PC is
        generic (N : integer := 32);
        port (
                 PCOUT : out std_logic_vector(N - 1 downto 0);
                 WPC : in std_logic_vector(N - 1 downto 0);
        CLK, CLR : in std_logic);
    end component;
    -- Conditional checker
    component ConditionChecker is
        port (
                 BRE : out std_logic;
                 funct3 : in std_logic_vector(2 downto 0);
        Z, OV, C, N : in std_logic);
    end component;
    -- === Signals ===
    signal WE3 : std_logic;
    signal PCS : std_logic_vector(N - 1 downto 0);
    -- Register file signals
    signal instr : std_logic_vector(N - 1 downto 0);
    signal RD1 : std_logic_vector(N -1 downto 0);
    signal RD2 : std_logic_vector(N -1 downto 0);
    signal result : std_logic_vector(N - 1 downto 0);
    -- ALU signals
    signal aluRes : std_logic_vector(N - 1 downto 0);
    signal flags : std_logic_vector(3 downto 0);
    signal inputB : std_logic_vector(N - 1 downto 0);
    -- Extender
    signal immExt : std_logic_vector(N - 1 downto 0);
    -- PC aux
    signal wpcAux : std_logic_vector(N - 1 downto 0);
    -- PC target (J)
    signal PCtarget : std_logic_vector(N - 1 downto 0);
    -- PC + imm
    signal PCimm : std_logic_vector(N - 1 downto 0);
    -- PC + 4
    signal PCplus4 : std_logic_vector(N - 1 downto 0);
    -- Control
    signal aluOP : std_logic_vector(1 downto 0);
    signal extSrc : std_logic_vector(1 downto 0);
    signal srcB : std_logic;
    signal resSrc : std_logic_vector(1 downto 0);
    signal BR : std_logic;
    signal BRE : std_logic;
    signal JMP : std_logic;
    signal wpcSrc : std_logic;
    signal jmpSrc : std_logic;
begin
    -- Control unit
    cu: ControlUnit 
    port map (
                 op => instr(6 downto 0),
                 aluOP => aluOP,
                 srcB => srcB,
                 WE3En => WE3,
                 wRamEn => wRAM,
                 resSrc => resSrc,
                 extSrc => extSrc,
                 BR => BR,
                 JMP => JMP,
                 jmpSrc => jmpSrc);
    -- PC
    pco: PC generic map (N => N)
    port map(
                PCOUT => PCS,
                WPC => WPCAux,
                CLK => CLK,
                CLR => CLR);
    -- wpcSrc '1' when: (type B) codition is meet, (type J) instruction is jump
    -- else, use PC + 4 (PC + 1)
    wpcSrc <= (BRE and BR) or JMP;
    -- WPC mux
    WPCAux <= PCplus4 when wpcSrc = '0' else PCtarget;
    -- PCtarget mux
    PCtarget <= result when jmpSrc = '1' else PCimm;
    -- PC+imm adder
    PCimm <= PCS + immExt;    
    -- PC + 1 (PC + 4)
    PCplus4 <= PCS + 1;
    -- Register file instance
    rf: RegisterFile generic map (
                                     N => N,
                                     LOG2N => LOG2N,
                                     NREG => M)
    port map (
                 WD3 => result,
                 A1 => instr(19 downto 15),
                 A2 => instr(24 downto 20),
                 A3 => instr(11 downto 7),
                 CLK => CLK,
                 CLR => CLR,
                 WE3 => WE3,
                 RD1 => RD1,
                 RD2 => RD2);
    -- ALU unit
    alu: ALUNbits generic map (N => N, LOG2N => LOG2N)
    port map (
                 A => RD1,
                 B => inputB,
                 aluOP => aluOP,
                 funct3 => instr(14 downto 12),
                 funct7 => instr(30),
                 S => aluRes,
                 flg_z => flags(0),
                 flg_n => flags(1),
                 flg_c => flags(2),
                 flg_ov => flags(3));
    -- srcB Mux
    sbmux: inputB <= immExt when srcB = '0' else RD2;
    -- Cond. checker
    cond: ConditionChecker 
    port map (
                 BRE => BRE,
                 funct3 => instr(14 downto 12),
                 Z => flags(0),
                 OV => flags(3),
                 C => flags(2),
                 N => flags(1));
    -- Result mux
    resmux: with resSrc select
        result <= readData when "00",
                  PCplus4 when "10",
                  aluRes when others;
    -- Immediate extender
    ext: Extender port map (
                               inst => instr,
                               SRC => extSrc,
                               EXT => immExt);
    -- Map output signals

    writeData <= RD2;
    funct3 <= instr(14 downto 12);
    aluResult <= aluRes;
    pcout <= PCS;
    -- Map input signals
    instr <= inst;
end Behavioral;
