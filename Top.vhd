library ieee;
use ieee.std_logic_1164.all;

entity Top is
    generic(
               N : integer := 32;
               LOG2N : integer := 5;
               M : integer := 5; -- register file 2^M * N
               ROM_ADDRS : integer := 32; -- ROM address space
               K : integer := 10);
    port(
    CLK, CLR : in std_logic;
    writeData, dataAddr : buffer std_logic_vector(N - 1 downto 0);
    memWrite : buffer std_logic);
end Top;

architecture Test of Top is
    component RISCV is
        generic(
                   N : integer := 32;
                   LOG2N : integer := 5;
                   M : integer := 5); 
    -- Ports
        port(
        CLK, CLR : in std_logic;
        ramRD, instr : in std_logic_vector(N - 1 downto 0);
        ramWD, aluResult  : out std_logic_vector(N - 1 downto 0);
        pcout : out std_logic_vector(N - 1 downto 0);
        funct3 : out std_logic_vector(2 downto 0);
        ramWE : out std_logic);
    end component;
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

    signal pc : std_logic_vector(N - 1 downto 0);
    signal instr : std_logic_vector(N - 1 downto 0);
    signal aluRes : std_logic_vector(N - 1 downto 0);
    signal ramRD, ramWD : std_logic_vector(N - 1 downto 0);
    signal funct3 : std_logic_vector(2 downto 0);
    signal ramWE : std_logic;
begin
    -- RAM
    ram1: RAM generic map (
                              N => N,
                              K => K,
                              M => ROM_ADDRS)
    port map (
                 A => aluRes,
                 WD => ramWD,
                 WE => ramWE,
                 CLK => CLK,
                 fun => funct3,
                 RD => ramRD);
    -- Instruction memory (ROM)
    rom: InstrMem port map (
                                           A => pc,
                                           RD => instr);
    -- RISC-V processor
    riscv1: RISCV generic map(
                                 N => N,
                                 LOG2N => LOG2N,
                                 M => M)
    port map(
                CLK => CLK,
                CLR => CLR,
                ramRD => ramRD,
                instr => instr,
                ramWD => ramWD,
                aluResult => aluRes,
                pcout => pc,
                funct3 => funct3,
                ramWE => ramWE);
    -- Map output signals
    memWrite <= ramWE;
    writeData <= ramWD;
    dataAddr <= aluRes;
end Test;
