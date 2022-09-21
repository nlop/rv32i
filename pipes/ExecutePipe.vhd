library ieee;
use ieee.std_logic_1164.all;

-- Decode stage pipe.
--
-- Control signals:
--
-- control(13) := funct7(5)
-- control(12:10) := funct3
-- control(9) := regWE3 (RegWrite)  
-- control(8:7) := resSrc (resultSrc)  
-- control(6) := ramWE (MemWrite)  
-- control(5) := jmpSrc  
-- control(4) := JMP (jump)  
-- control(3) := BR (branch)  
-- control(2:1) := aluOP (ALUControl)  
-- control(0) := srcB (ALUSrcD)  
--
entity ExecutePipe is
    generic(N : integer := 32;
        M : integer := 5;
           N_CONTROLSIG : integer := 14);
    port(
        CLK, CLR, L : in std_logic;
        controlD : in std_logic_vector(N_CONTROLSIG - 1 downto 0);
        Rd1D : in std_logic_vector(N - 1 downto 0);
        Rd2D : in std_logic_vector(N - 1 downto 0);
        rdD : in std_logic_vector(M - 1 downto 0);
        pcD : in std_logic_vector(N - 1 downto 0);
        Rs1D : in std_logic_vector(M - 1 downto 0);
        Rs2D : in std_logic_vector(M - 1 downto 0);
        immExtD : in std_logic_vector(N - 1 downto 0);
        PCplus4D : in std_logic_vector(N - 1 downto 0);
        controlE : out std_logic_vector(N_CONTROLSIG - 1 downto 0);
        Rd1E : out std_logic_vector(N - 1 downto 0);
        Rd2E : out std_logic_vector(N - 1 downto 0);
        rdE : out std_logic_vector(M - 1 downto 0);
        pcE : out std_logic_vector(N - 1 downto 0);
        Rs1E : out std_logic_vector(M - 1 downto 0);
        Rs2E : out std_logic_vector(M - 1 downto 0);
        immExtE : out std_logic_vector(N - 1 downto 0);
        PCplus4E : out std_logic_vector(N - 1 downto 0));
end ExecutePipe;

architecture RTL of ExecutePipe is

    component SimpleRegisterReset is
    generic ( N : integer := 16);
    port ( D : in std_logic_vector (N - 1 downto 0);
           Q : out std_logic_vector (N - 1 downto 0);
           CLR, CLK, L : in std_logic);
    end component;
begin
    controlReg: SimpleRegisterReset
        generic map (N => controlD'LENGTH)
        port map(controlD, controlE, CLR, CLK, L);
    Rd1Reg: SimpleRegisterReset
        generic map (N => Rd1D'LENGTH)
        port map(Rd1D, Rd1E, CLR, CLK, L);
    Rd2Reg: SimpleRegisterReset
        generic map (N => Rd2D'LENGTH)
        port map(Rd2D, Rd2E, CLR, CLK, L);
    rdReg: SimpleRegisterReset
        generic map (N => rdD'LENGTH)
        port map(rdD, rdE, CLR, CLK, L);
    pcReg: SimpleRegisterReset
        generic map (N => pcD'LENGTH)
        port map(pcD, pcE, CLR, CLK, L);
    immExtReg: SimpleRegisterReset
        generic map (N => immExtD'LENGTH)
        port map(immExtD, immExtE, CLR, CLK, L);
    Rs1Reg: SimpleRegisterReset
        generic map (N => Rs1D'LENGTH)
        port map(Rs1D, Rs1E, CLR, CLK, L);
    Rs2Reg: SimpleRegisterReset
        generic map (N => Rs2D'LENGTH)
        port map(Rs2D, Rs2E, CLR, CLK, L);
    PCplus4Reg: SimpleRegisterReset
        generic map (N => PCplus4D'LENGTH)
        port map(PCplus4D, PCplus4E, CLR, CLK, L);
end RTL;
