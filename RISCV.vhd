library ieee;
library work;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use work.ALUPackage.all;
use work.PipePackage.all;

--
-- 5-stage pipelined RV32I processor
--
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
    constant N_CONTROLSIG_E : integer := 16;
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
                 extSrc : out std_logic_vector(2 downto 0);
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
        WE, CLK, CLR : in std_logic);
    end component;
    -- Conditional checker
    component ConditionChecker is
        port (
                 BRE : out std_logic;
                 funct3 : in std_logic_vector(2 downto 0);
        Z, OV, C, N : in std_logic);
    end component;
    -- Forwarding Unit
    component ForwardingUnit is
        generic (M : integer := 5);
        port (
        W3EnW, W3EnM : in std_logic;
        Rs1E : in std_logic_vector(M - 1 downto 0);
        Rs2E : in std_logic_vector(M - 1 downto 0);
        rdM : in std_logic_vector(M - 1 downto 0);
        rdW : in std_logic_vector(M - 1 downto 0);
        forwardAE : out std_logic_vector(1 downto 0);
        forwardBE : out std_logic_vector(1 downto 0));
    end component;
    -- Stall unit
    component StallUnit is
        generic (M : integer := 5);
        port (
                 resSrcE0 : in std_logic;
                 rdE : in std_logic_vector(M - 1 downto 0);
                 Rs1D : in std_logic_vector(M - 1 downto 0);
                 Rs2D : in std_logic_vector(M - 1 downto 0);
        notStallF, notStallD, flushE : out std_logic);
    end component;
    -- Branch predictor
    component BranchPredictor is
        port (
        CLK, CLR, WE, taken : in std_logic;
        take : out std_logic);
    end component;
    -- === Signals ===
    -- ~CLK
    signal nCLK : std_logic;
    -- > Fetch
    -- >> PC
    signal pcF : std_logic_vector(N - 1 downto 0);
    signal PCplus4F : std_logic_vector(N - 1 downto 0);
    -- > Decode
    -- >> Control
    signal controlD_E : std_logic_vector(N_CONTROLSIG_E - 1 downto 0);
    signal instrD : std_logic_vector(N - 1 downto 0);
    signal ramWeD : std_logic;
    signal aluOpD : std_logic_vector(1 downto 0);
    signal regWE3D : std_logic;
    signal extSrcD : std_logic_vector(2 downto 0);
    signal srcBD : std_logic;
    signal resSrcD : std_logic_vector(1 downto 0);
    signal BrD : std_logic;
    signal BreD : std_logic;
    signal JmpD : std_logic;
    signal jmpSrcD : std_logic;
    -- >> Extender
    signal immExtD : std_logic_vector(N - 1 downto 0);
    signal extOutD : std_logic_vector(N - 1 downto 0);
    signal zeroU : std_logic_vector(11 downto 0);
    signal zeroUSumD : std_logic;
    -- >> PC
    signal PCtargetD : std_logic_vector(N - 1 downto 0);
    signal pcD : std_logic_vector(N - 1 downto 0);
    signal PCplus4D : std_logic_vector(N - 1 downto 0);
    -- >> Register file
    signal RD1 : std_logic_vector(N -1 downto 0);
    signal RD2 : std_logic_vector(N -1 downto 0);
    -- >> Branch predictor
    signal branchTakeD, takeD : std_logic;
    -- > Execute 
    -- >> Register file
    signal rdE : std_logic_vector(M - 1 downto 0);
    signal Rs1E : std_logic_vector(M - 1 downto 0);
    signal Rs2E : std_logic_vector(M - 1 downto 0);
    -- >> Control
    signal controlE : std_logic_vector(N_CONTROLSIG_E - 1 downto 0);
    signal controlE_M : std_logic_vector(N_CONTROLSIG_M - 1 downto 0);
    -- >> ALU
    signal aluResE : std_logic_vector(N - 1 downto 0);
    signal fwinputAE : std_logic_vector(N - 1 downto 0);
    signal fwinputBE : std_logic_vector(N - 1 downto 0);
    signal Rd1E : std_logic_vector(N - 1 downto 0);
    signal Rd2E : std_logic_vector(N - 1 downto 0);
    signal flagsE : std_logic_vector(3 downto 0);
    signal inputBE: std_logic_vector(N - 1 downto 0);
    signal inputAE: std_logic_vector(N - 1 downto 0);
    -- >> Condition checker
    signal breE : std_logic;
    -- >> Extender
    signal immExtE : std_logic_vector(N - 1 downto 0);
    -- >> PC
    signal PCplus4E : std_logic_vector(N - 1 downto 0);
    signal PCtargetE : std_logic_vector(N - 1 downto 0);
    -- > Memory
    -- >> Control
    signal controlM : std_logic_vector(N_CONTROLSIG_M - 1 downto 0);
    signal controlM_W : std_logic_vector(N_CONTROLSIG_W - 1 downto 0);
    -- >> RAM
    signal writeDataM : std_logic_vector(N - 1 downto 0);
    -- >> Register file
    signal rdM : std_logic_vector(M - 1 downto 0);
    -- >> PC
    signal PCplus4M : std_logic_vector(N - 1 downto 0);
    signal PCtargetM : std_logic_vector(N - 1 downto 0);
    -- >> ALU
    signal aluResultM : std_logic_vector(N - 1 downto 0);
    -- > Writeback
    -- >> Control
    signal controlW : std_logic_vector(N_CONTROLSIG_W - 1 downto 0);
    -- >> ALU
    signal aluResultW : std_logic_vector(N - 1 downto 0);
    -- >> RAM
    signal ramRdW : std_logic_vector(N - 1 downto 0);
    -- >> Register file
    signal resultW : std_logic_vector(N - 1 downto 0);
    signal rdW : std_logic_vector(M - 1 downto 0);
    -- >> PC
    signal PCplus4W : std_logic_vector(N - 1 downto 0);
    signal PCtargetW : std_logic_vector(N - 1 downto 0);
    -- > Hazard control
    -- >> Forwarding unit
    signal forwardAE : std_logic_vector(1 downto 0);
    signal forwardBE : std_logic_vector(1 downto 0);
    -- >> Stall unit
    signal notStallF, notStallD, stallFlushE, stallResSrc : std_logic;
    -- >> Branching
    signal flushD : std_logic;
    signal flushE : std_logic;
    -- >> TEMP
    signal wpcBrD : std_logic_vector(N - 1 downto 0);
    signal wpcBrE : std_logic_vector(N - 1 downto 0);
    signal selWpcBreE : std_logic_vector(1 downto 0);
    signal wpcJmpD : std_logic_vector(N - 1 downto 0);
    signal wpcJmpE : std_logic_vector(N - 1 downto 0);
    signal wpcIn : std_logic_vector(N - 1 downto 0);
    signal wpcSel : std_logic_vector(2 downto 0);
    signal pcFlushDE : std_logic;
    signal pcFlushD : std_logic;
begin
    -- ~CLK
    nCLK <= not CLK;
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
                WPC => wpcIn,
                WE => notStallF,
                CLK => CLK,
                CLR => CLR);
    -- WPC mux
    wpcSel(2) <= ((brD and JmpD) or ((not brD) and (not JmpD))) and ((controlE(3) and controlE(4)) or ((not controlE(3)) and (not controlE(4))));
    wpcSel(1) <= ((not controlE(3)) and controlE(4)) or ((JmpD and (not brD)) and (controlE(4) or (not controlE(3))));
    wpcSel(0) <= (controlE(3) and (not controlE(4))) or (((not brD) and JmpD) and (controlE(3) or (not controlE(4))));
    wpcmux: with wpcSel select
        wpcIn <= wpcBrD when "000",
                 wpcBrE when "001",
                 wpcJmpD when "011",
                 wpcJmpE when "010",
                 PCplus4F when others;
    -- WPC sources
    wpcBrD <= PCtargetD when takeD = '1' else PCplus4F;
    wpcJmpD <= PCtargetD when jmpSrcD = '0' else PCplus4F;
    wpcJmpE <= aluResE when controlE(5) = '1' else PCplus4F;
    selWpcBreE(1) <= breE and (not controlE(14));
    selWpcBreE(0) <= (not breE) and controlE(14);
    wpcbremux: with selWpcBreE select
        wpcBrE <= PCplus4E when "01",
                  PCtargetE when "10",
                  PCplus4F when others;
    -- PC flush
    pcFlushDE <= (not wpcSel(2)) and (((not wpcSel(1)) and wpcSel(0) and (breE xor controlE(14))) or (wpcSel(1) and (not wpcSel(0)) and controlE(5)));
    pcFlushD <= (not wpcSel(2)) and ((wpcSel(1) and wpcSel(0) and (not jmpSrcD)) or ((not wpcSel(1)) and (not wpcSel(0)) and takeD)); 
    -- PC+imm adder
    PCtargetD <= pcD + immExtD;
    -- PC + 4
    PCplus4F <= pcF + 4;
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
                 CLK => nCLK,
                 CLR => CLR,
                 WE3 => controlW(2),
                 RD1 => RD1,
                 RD2 => RD2);
    -- ALU unit
    alu: ALUNbits generic map (N => N, LOG2N => LOG2N)
    port map (
                 A => inputAE,
                 B => inputBE,
                 aluOP => controlE(2 downto 1),
                 funct3 => controlE(12 downto 10),
                 funct7 => controlE(13),
                 S => aluResE,
                 flg_z => flagsE(0),
                 flg_n => flagsE(1),
                 flg_c => flagsE(2),
                 flg_ov => flagsE(3));
    -- fwinputAE mux
    fwibamux: with forwardAE select
        fwinputAE <= Rd1E when "00",
                   resultW when "01",
                   aluResultM when others;
    -- fwinputBE mux
    fwibemux: with forwardBE select
        fwinputBE <= Rd2E when "00",
                     resultW when "01",
                     aluResultM when others;
    -- inputAE mux
    iaemux: inputAE <= fwinputAE when controlE(15) = '0' else (others => '0');
    --         ^ hack to support lui
    -- inputBE mux
    ibemux: inputBE <= immExtE when controlE(0) = '0' else fwinputBE;
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
        resultW <= ramRdW when "01",
                   PCplus4W when "10",
                   PCtargetW when "11",
                   aluResultW when others;
    -- Immediate extender
    ext: Extender port map (
                               instr => instrD,
                               src => extSrcD(1 downto 0),
                               ext => extOutD);
    -- Type U zeros
    zeroU <= (others => '0');
    zeroUSumD <= (extSrcD(2) and extSrcD(0));

    -- Extender mux
    immExtD <= (instrD(31 downto 12) & zeroU) when extSrcD(2) = '1' else extOutD;

    -- Control signals
    controlD_E <= (zeroUSumD & takeD & instrD(30) & instrD(14 downto 12) & regWE3D & resSrcD & ramWeD & jmpSrcD & JmpD & BrD & aluOpD & srcBD);
    controlE_M <= (controlE(12 downto 10) & controlE(9) & controlE(8 downto 7) & controlE(6));
    controlM_W <= (controlM(3) & controlM(2 downto 1));

    -- Pipeline stages
    pipeDecode: DecodePipe generic map (N => N)
    port map(
                CLK => CLK,
                CLR => flushD,
                L => notStallD,
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
                CLR => flushE,
                L => '1',
                controlD => controlD_E,
                Rd1D => RD1,
                Rd2D => RD2,
                rdD => instrD(11 downto 7),
                Rs1D => instrD(19 downto 15),
                Rs2D => instrD(24 downto 20),
                immExtD => immExtD,
                PCplus4D => PCplus4D,
                PCtargetD => PCtargetD,
                controlE => controlE,
                Rd1E => Rd1E,
                Rd2E => Rd2E,
                rdE => rdE,
                Rs1E => Rs1E,
                Rs2E => Rs2E,
                immExtE => immExtE,
                PCplus4E => PCplus4E,
                PCtargetE => PCtargetE);

    pipeMemory: MemoryPipe generic map(N => N,
                                       M => M,
                                       N_CONTROLSIG => N_CONTROLSIG_M)
    port map(
                CLK => CLK,
                CLR => CLR,
                L => '1',
                controlE => controlE_M,
                aluResultE => aluResE,
                writeDataE => fwinputBE,
                rdE => rdE,
                PCplus4E => PCplus4E,
                PCtargetE => PCtargetE,
                controlM => controlM,
                aluResultM => aluResultM,
                writeDataM => writeDataM,
                rdM => rdM,
                PCplus4M => PCplus4M,
                PCtargetM => PCtargetM);

    pipeWriteback: WritebackPipe generic map(N => N,
                                             M => M,
                                             N_CONTROLSIG => N_CONTROLSIG_W)
    port map(
                CLK => CLK,
                CLR => CLR,
                L => '1',
                controlM => controlM_W,
                aluResultM => aluResultM,
                ramRdM => ramRD,
                rdM => rdM,
                PCplus4M => PCplus4M,
                PCtargetM => PCtargetM,
                controlW => controlW,
                aluResultW => aluResultW,
                ramRdW => ramRdW,
                rdW => rdW,
                PCplus4W => PCplus4W,
                PCtargetW => PCtargetW);

    -- Hazard management
    fwunit: ForwardingUnit generic map (M => M)
    port map(
                W3EnM => controlM(3),
                W3EnW => controlW(2),
                Rs1E => Rs1E,
                Rs2E => Rs2E,
                rdM => rdM,
                rdW => rdW,
                forwardAE => forwardAE,
                forwardBE => forwardBE);

    -- Stall resSrc signal (adjusted to support 4x1 mux at WB)
    stallResSrc <= controlE(7) and (not controlE(8));
    stunit: StallUnit generic map (M => M)
    port map(
                resSrcE0 => stallResSrc,
                rdE => rdE,
                Rs1D => instrD(19 downto 15),
                Rs2D => instrD(24 downto 20),
                notStallF => notStallF,
                notStallD => notStallD,
                flushE => stallFlushE);

    -- Flush signals
    flushD <= (pcFlushDE or pcFlushD or CLR) when notStallD = '1' else '0';
    flushE <= stallFlushE or pcFlushDE or CLR;

    -- Branch predictor
    brp: BranchPredictor port map(
                                     CLK => CLK,
                                     CLR => CLR,
                                     WE => controlE(3),
                                     taken => breE,
                                     take => takeD);
    branchTakeD <= takeD and BrD;

    -- Map output signals
    ramWD <= writeDataM;
    funct3 <= controlM(6 downto 4);
    aluResult <= aluResultM;
    pcout <= pcF;
    ramWE <= controlM(0); 
end Behavioral;
