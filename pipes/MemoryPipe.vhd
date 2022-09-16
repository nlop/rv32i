library ieee;
use ieee.std_logic_1164.all;

-- Memory stage pipe.
--
-- Control signals:
--
-- control(6:4) := funct3
-- control(3) := regWE3 (RegWrite)  
-- control(2:1) := resSrc (resultSrc)  
-- control(0) := ramWE (MemWrite)  
--
entity MemoryPipe is 
    generic(N : integer := 32;
            M : integer := 5;
            N_CONTROLSIG : integer := 7);
    port(
    CLK, CLR, L : in std_logic;
    controlE : in std_logic_vector(N_CONTROLSIG - 1 downto 0);
    resultE : in std_logic_vector(N - 1 downto 0);
    writeDataE : in std_logic_vector(N - 1 downto 0);
    rdE : in std_logic_vector(M - 1 downto 0);
    PCplus4E : in std_logic_vector(N - 1 downto 0);
    controlM : out std_logic_vector(N_CONTROLSIG - 1 downto 0);
    resultM : out std_logic_vector(N - 1 downto 0);
    writeDataM : out std_logic_vector(N - 1 downto 0);
    rdM : out std_logic_vector(M - 1 downto 0);
    PCplus4M : out std_logic_vector(N - 1 downto 0));
end MemoryPipe; 

architecture RTL of MemoryPipe is
    component SimpleRegister is
        generic ( N : integer := 16);
        port ( D : in std_logic_vector (N - 1 downto 0);
               Q : out std_logic_vector (N - 1 downto 0);
        CLR, CLK, L : in std_logic);
    end component;
begin
    controlReg: SimpleRegister 
    generic map(N => controlE'LENGTH)
    port map(controlE, controlM, CLR, CLK, L);
             resultReg: SimpleRegister 
             generic map(N => resultE'LENGTH)
    port map(resultE, resultM, CLR, CLK, L);
             writeDataReg: SimpleRegister 
             generic map(N => writeDataE'LENGTH)
    port map(writeDataE, writeDataM, CLR, CLK, L);
             rdReg: SimpleRegister 
             generic map(N => rdE'LENGTH)
    port map(rdE, rdM, CLR, CLK, L);
             PCplus4Reg: SimpleRegister 
             generic map(N => PCplus4E'LENGTH)
    port map(PCplus4E, PCplus4M, CLR, CLK, L);
end RTL;
