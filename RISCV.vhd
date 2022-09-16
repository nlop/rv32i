library ieee;
library work;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use work.ALUPackage.all;
use work.PipePackage.all;

entity RISCV is
    generic(
               N : integer := 32;
               LOG2N : integer := 5;
               M : integer := 5); 
    port(
    CLK, CLR : in std_logic;
    ramRD, instr : in std_logic_vector(N - 1 downto 0);
    ramWD, aluResult  : out std_logic_vector(N - 1 downto 0);
    pcout : out std_logic_vector(N - 1 downto 0);
    funct3 : out std_logic_vector(2 downto 0);
    ramWE : out std_logic);
    -- Constant
    constant N_CONTROLSIG_E : integer := 14;
    constant N_CONTROLSIG_M : integer := 7;
    constant N_CONTROLSIG_W : integer := 3;
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
                instr : in std_logic_vector(31 downto 0);
                src : in std_logic_vector(1 downto 0);
                ext : out std_logic_vector(31 downto 0));
    end component;
    --Control unit 
    component ControlUnit is
    port (
             op : in std_logic_vector(6 downto 0);
             aluOP : out std_logic_vector(1 downto 0);
             srcB : out std_logic;
             regWE3 : out std_logic;
             ramWE : out std_logic;
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
    -- Register file signals
    signal result : std_logic_vector(N - 1 downto 0);
    -- Pipeline signals 
    -- # Fetch
    -- ## PC
    signal pcF : std_logic_vector(N - 1 downto 0);
    signal PCplus4F : std_logic_vector(N - 1 downto 0);
    -- # Decode
    -- ## Control
    signal controlD_E : std_logic_vector(N_CONTROLSIG_E - 1 downto 0);
    signal instrD : std_logic_vector(N - 1 downto 0);
    signal ramWeD : std_logic;
    signal aluOpD : std_logic_vector(1 downto 0);
    signal regWE3D : std_logic;
    signal extSrcD : std_logic_vector(1 downto 0);
    signal srcBD : std_logic;
    signal resSrcD : std_logic_vector(1 downto 0);
    signal BrD : std_logic;
    signal BreD : std_logic;
    signal JmpD : std_logic;
    signal jmpSrcD : std_logic;
    -- ## Extender
    signal immExtD : std_logic_vector(N - 1 downto 0);
    -- ## PC
    signal pcD : std_logic_vector(N - 1 downto 0);
    signal PCplus4D : std_logic_vector(N - 1 downto 0);
    -- ## Register file
    signal RD1 : std_logic_vector(N -1 downto 0);
    signal RD2 : std_logic_vector(N -1 downto 0);
    -- # Execute 
    -- ## Register file
    signal rdE : std_logic_vector(M - 1 downto 0);
    -- ## Control
    signal controlE : std_logic_vector(N_CONTROLSIG_E - 1 downto 0);
    signal controlE_M : std_logic_vector(N_CONTROLSIG_M - 1 downto 0);
    -- ## ALU
    signal aluResE : std_logic_vector(N - 1 downto 0);
    signal Rd1E : std_logic_vector(N - 1 downto 0);
    signal Rd2E : std_logic_vector(N - 1 downto 0);
    signal flagsE : std_logic_vector(3 downto 0);
    signal inputBE: std_logic_vector(N - 1 downto 0);
    -- ## Condition checker
    signal breE : std_logic;
    -- ## Extender
    signal immExtE : std_logic_vector(N - 1 downto 0);
    -- ## PC
    signal pcE : std_logic_vector(N - 1 downto 0);
    signal PCjmpE : std_logic_vector(N - 1 downto 0);
    signal PCtargetE : std_logic_vector(N - 1 downto 0);
    signal wpcSrcE : std_logic;
    signal wpcE : std_logic_vector(N - 1 downto 0);
    signal PCplus4E : std_logic_vector(N - 1 downto 0);
    -- # Memory
    -- ## Control
    signal controlM : std_logic_vector(N_CONTROLSIG_M - 1 downto 0);
    signal controlM_W : std_logic_vector(N_CONTROLSIG_W - 1 downto 0);
    -- ## RAM
    signal writeDataM : std_logic_vector(N - 1 downto 0);
    -- ## Register file
    signal rdM : std_logic_vector(M - 1 downto 0);
    -- ## PC
    signal PCplus4M : std_logic_vector(N - 1 downto 0);
    -- ## ALU
    signal resultM : std_logic_vector(N - 1 downto 0);
    -- # Writeback
    -- ## Control
    signal controlW : std_logic_vector(N_CONTROLSIG_W - 1 downto 0);
    -- ## ALU
    signal resultW : std_logic_vector(N - 1 downto 0);
    -- ## RAM
    signal ramRdW : std_logic_vector(N - 1 downto 0);
    -- ## Register file
    signal rdW : std_logic_vector(M - 1 downto 0);
    -- ## PC
    signal PCplus4W : std_logic_vector(N - 1 downto 0);
begin
    -- Control unit
    cu: ControlUnit 
    port map (
                 op => instrD(6 downto 0),
                 aluOP => aluOpD,
                 srcB => srcBD,
                 regWE3 => regWE3D,
                 ramWE => ramWeD,
                 resSrc => resSrcD,
                 extSrc => extSrcD,
                 BR => BrD,
                 JMP => JmpD,
                 jmpSrc => jmpSrcD);
    -- PC
    pco: PC generic map (N => N)
    port map(
                PCOUT => pcF,
                WPC => wpcE,
                CLK => CLK,
                CLR => CLR);
    -- wpcSrc '1' when: (type B) codition is meet, (type J) instruction is jump
    -- else, use PC + 4 (PC + 1)
    wpcSrcE <= (breE and controlE(3)) or controlE(4);
    --                  ^ BR            ^ JMP
    -- WPC mux
    wpcE <= PCplus4F when wpcSrcE = '0' else PCjmpE;
    -- PCjmpE mux
    PCjmpE <= aluResE when controlE(5) = '1' else PCtargetE;
    -- PC+imm adder
    PCtargetE <= pcE + immExtE;    
    -- PC + 1 (PC + 4)
    PCplus4F <= pcF + 1;
    -- Register file instance
    rf: RegisterFile generic map (
                                     N => N,
                                     LOG2N => LOG2N,
                                     NREG => M)
    port map (
                 WD3 => resultW,
                 A1 => instrD(19 downto 15),
                 A2 => instrD(24 downto 20),
                 A3 => rdW,
                 CLK => CLK,
                 CLR => CLR,
                 WE3 => controlW(2),
                 RD1 => RD1,
                 RD2 => RD2);
    -- ALU unit
    alu: ALUNbits generic map (N => N, LOG2N => LOG2N)
    port map (
                 A => Rd1E,
                 B => inputBE,
                 aluOP => controlE(2 downto 1),
                 funct3 => controlE(12 downto 10),
                 funct7 => controlE(13),
                 S => aluResE,
                 flg_z => flagsE(0),
                 flg_n => flagsE(1),
                 flg_c => flagsE(2),
                 flg_ov => flagsE(3));
    -- srcB Mux
    sbmux: inputBE <= immExtE when controlE(0) = '0' else Rd2E;
    --                             ^ srcB
    -- Cond. checker
    cond: ConditionChecker 
    port map (
                 BRE => breE,
                 funct3 => controlE(12 downto 10),
                 Z => flagsE(0),
                 OV => flagsE(3),
                 C => flagsE(2),
                 N => flagsE(1));
    -- Result mux
    resmux: with controlW(1 downto 0) select
        result <= ramRdW when "00",
                  PCplus4W when "10",
                  resultW when others;
    -- Immediate extender
    ext: Extender port map (
                               instr => instrD,
                               src => extSrcD,
                               ext => immExtD);
    -- Control signals
    controlD_E <= (instrD(30) & instrD(14 downto 12) & regWE3D & resSrcD & ramWeD & jmpSrcD & JmpD & BrD & aluOpD & srcBD);
    controlE_M <= (controlE(12 downto 10) & controlE(9) & controlE(8 downto 7) & controlE(6));
    controlM_W <= (controlM(3) & controlM(2 downto 1));
    -- Pipeline
    pipeDecode: DecodePipe generic map (N => N)
        port map(
            CLK => CLK,
            CLR => CLR,
            L => '1',
            instrF => instr,
            pcF => pcF,
            PCplus4F => PCplus4F,
            instrD => instrD,
            pcD => pcD,
            PCplus4D => PCplus4D); 
    pipeExecute: ExecutePipe generic map(N => N,
        M => M,
        N_CONTROLSIG => N_CONTROLSIG_E)
        port map(
            CLK => CLK,
            CLR => CLR,
            L => '1',
            controlD => controlD_E,
            Rd1D => RD1,
            Rd2D => RD2,
            rdD => instrD(11 downto 7),
            pcD => pcD,
            immExtD => immExtD,
            PCplus4D => PCplus4D,
            controlE => controlE,
            Rd1E => Rd1E,
            Rd2E => Rd2E,
            rdE => rdE,
            pcE => pcE,
            immExtE => immExtE,
            PCplus4E => PCplus4E);
    pipeMemory: MemoryPipe generic map(N => N,
        M => M,
        N_CONTROLSIG => N_CONTROLSIG_M)
        port map(
            CLK => CLK,
            CLR => CLR,
            L => '1',
            controlE => controlE_M,
            resultE => aluResE,
            writeDataE => Rd2E,
            rdE => rdE,
            PCplus4E => PCplus4E,
            controlM => controlM,
            resultM => resultM,
            writeDataM => writeDataM,
            rdM => rdM,
            PCplus4M => PCplus4M);
    pipeWriteback: WritebackPipe generic map(N => N,
        M => M,
        N_CONTROLSIG => N_CONTROLSIG_W)
        port map(
            CLK => CLK,
            CLR => CLR,
            L => '1',
            controlM => controlM_W,
            resultM => resultM,
            ramRdM => ramRD,
            rdM => rdM,
            PCplus4M => PCplus4M,
            controlW => controlW,
            resultW => resultW,
            ramRdW => ramRdW,
            rdW => rdW,
            PCplus4W => PCplus4W);
    -- Map output signals
    ramWD <= writeDataM;
    funct3 <= controlM(6 downto 4);
    aluResult <= resultM;
    pcout <= pcF;
    ramWE <= controlM(0); 
end Behavioral;
