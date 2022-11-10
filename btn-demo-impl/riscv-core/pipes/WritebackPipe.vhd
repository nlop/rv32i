library ieee;
use ieee.std_logic_1164.all;
-- Writeback stage pipe.
--
-- Control signals:
--
-- control(2) := WE3En (RegWrite)  
-- control(1:0) := resSrc (resultSrc)  
entity WritebackPipe is
    generic(N : integer := 32;
            M : integer := 5;
            N_CONTROLSIG : integer := 3);
    port(
    CLK, CLR, L : in std_logic;
    controlM : in std_logic_vector(N_CONTROLSIG - 1 downto 0);
    aluResultM : in std_logic_vector(N - 1 downto 0);
    ramRdM : in std_logic_vector(N - 1 downto 0);
    rdM : in std_logic_vector(M - 1 downto 0);
    PCplus4M : in std_logic_vector(N - 1 downto 0);
    PCtargetM : in std_logic_vector(N - 1 downto 0);
    controlW : out std_logic_vector(N_CONTROLSIG - 1 downto 0);
    aluResultW : out std_logic_vector(N - 1 downto 0);
    ramRdW : out std_logic_vector(N - 1 downto 0);
    rdW : out std_logic_vector(M - 1 downto 0);
    PCplus4W : out std_logic_vector(N - 1 downto 0);
    PCtargetW : out std_logic_vector(N - 1 downto 0));
end WritebackPipe;

architecture RTL of WritebackPipe is
    component SimpleRegisterReset is
        generic ( N : integer := 16);
        port ( D : in std_logic_vector (N - 1 downto 0);
               Q : out std_logic_vector (N - 1 downto 0);
        CLR, CLK, L : in std_logic);
    end component;
begin
    controlReg: SimpleRegisterReset 
    generic map(N => controlM'LENGTH)
    port map(controlM, controlW, CLR, CLK, L);
             resultReg: SimpleRegisterReset 
             generic map(N => aluResultM'LENGTH)
    port map(aluResultM, aluResultW, CLR, CLK, L);
             ramRD: SimpleRegisterReset 
             generic map(N => ramRdM'LENGTH)
    port map(ramRdM, ramRdW, CLR, CLK, L);
             rdReg: SimpleRegisterReset 
             generic map(N => RdM'LENGTH)
    port map(RdM, RdW, CLR, CLK, L);
             PCplus4Reg: SimpleRegisterReset 
             generic map(N => PCplus4M'LENGTH)
    port map(PCplus4M, PCplus4W, CLR, CLK, L);
             PCtargetReg: SimpleRegisterReset 
             generic map(N => PCplus4M'LENGTH)
    port map(PCtargetM, PCtargetW, CLR, CLK, L);
end RTL;
