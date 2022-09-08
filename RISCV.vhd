library ieee;
library work;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use work.ALUPackage.all;

entity RISCV is
    constant P : time := 10 ns;
    constant N : integer := 32;
    constant LOG2N : integer := 5;
    constant M : integer := 5; -- register file 2^M * N
    constant ROM_ADDRS : integer := 32; -- ROM address space
    constant K : integer := 10;

end RISCV;

architecture Behavioral of RISCV is
    -- Instruction memory (ROM)
    component InstrMem is
        generic (
                    N : integer := 32;
                    M : integer := 32;  
                    K : integer := 10
                );
        port ( A : in std_logic_vector(ROM_ADDRS - 1 downto 0);
               RD : out std_logic_vector(N - 1 downto 0));
    end component;
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
    -- RAM 
    component RAM is       
        generic (
                    N : integer := 32;
                    K : integer := 10;
                    M : integer := 32);
        port (
                 A : in STD_LOGIC_VECTOR (M - 1 downto 0);
                 WD : in STD_LOGIC_VECTOR (N - 1 downto 0);
        WE, CLK : in STD_LOGIC;
        fun : in std_logic_vector(2 downto 0);
        RD : out STD_LOGIC_VECTOR (N - 1 downto 0));
    end component;
    -- Extender
    component Extender is
        port(
                INST : in std_logic_vector(31 downto 0);
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
                 resSrc : out std_logic;
                 extSrc : out std_logic_vector(1 downto 0);
                 BR : out std_logic);
    end component;
    -- Program counter
    component PC is
        generic (N : integer := 32);
        port (
                 PCOUT : out std_logic_vector(N - 1 downto 0);
                 WPC : in std_logic_vector(N - 1 downto 0);
        CLK, CLR, BRE, BR : in std_logic);
    end component;
    -- Conditional checker
    component ConditionChecker is
    port (
        BRE : out std_logic;
        funct3 : in std_logic_vector(2 downto 0);
        Z, OV, C, N : in std_logic);
    end component;
    -- === Signals ===
    signal CLK, CLR, SHE, DIR, WE3 : std_logic;
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
    -- RAM signals
    signal ramRD : std_logic_vector(N - 1 downto 0);
    -- Extender
    signal immExt : std_logic_vector(N - 1 downto 0);
    -- PC + 4
    signal PCtarget : std_logic_vector(N - 1 downto 0);
    -- Control
    signal aluOP : std_logic_vector(1 downto 0);
    signal wRamEn : std_logic;
    signal extSrc : std_logic_vector(1 downto 0);
    signal srcB : std_logic;
    signal resSrc : std_logic;
    signal BR : std_logic;
    signal BRE : std_logic;
begin
    -- Control unit
    cu: ControlUnit port map (
                                 op => instr(6 downto 0),
                                 aluOP => aluOP,
                                 srcB => srcB,
                                 WE3En => WE3,
                                 wRamEn => wRamEn,
                                 resSrc => resSrc,
                                 extSrc => extSrc,
                                 BR => BR);
    -- Instruction memory (ROM)
    rom: InstrMem port map (
                               A => PCS,
                               RD => instr);
    -- PC
    pco: PC generic map (N => N)
    port map(
                PCOUT => PCS,
                WPC => PCtarget,
                CLK => CLK,
                CLR => CLR,
                BR => BR,
                BRE => BRE);
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
    alu : ALUNbits generic map (N => N, LOG2N => LOG2N)
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
    cond: ConditionChecker port map (
        BRE => BRE,
        funct3 => instr(14 downto 12),
        Z => flags(0),
        OV => flags(3),
        C => flags(2),
        N => flags(1));
    -- RAM
    ram1: RAM port map (
                           A => aluRes,
                           WD => RD2,
                           WE => wRamEn,
                           CLK => CLK,
                           fun => instr(14 downto 12),
                           RD => ramRD);
    -- Result mux
    resmux: result <= ramRD when resSrc = '0' else aluRes;
    -- Immediate extender
    ext: Extender port map (
                               INST => instr,
                               SRC => extSrc,
                               EXT => immExt);
   -- PCtarget adder
    PCtarget <= PCS + immExt;    
   -- CLK
   clkp : process begin
       CLK <= '0';
       wait for P/2;
       CLK <= '1';
       wait for P/2;
   end process;
   -- Testbench
   test : process begin
       CLR <= '1';
       wait until rising_edge(CLK);
       CLR <= '0';
       wait for P * 4;
       wait;
   end process;
end Behavioral;
