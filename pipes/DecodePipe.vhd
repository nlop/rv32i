library ieee;
use ieee.std_logic_1164.all;

entity DecodePipe is
    generic(N : integer := 32);
    port(
        CLK, CLR, L : in std_logic;
        instrF : in std_logic_vector(N - 1 downto 0);
        pcF : in std_logic_vector(N - 1 downto 0);
        PCplus4F : in std_logic_vector(N - 1 downto 0);
        instrD : out std_logic_vector(N - 1 downto 0);
        pcD : out std_logic_vector(N - 1 downto 0);
        PCplus4D : out std_logic_vector(N - 1 downto 0));
end DecodePipe;

architecture RTL of DecodePipe is
    component SimpleRegister is
    generic ( N : integer := 16);
        port ( D : in std_logic_vector (N - 1 downto 0);
               Q : out std_logic_vector (N - 1 downto 0);
               CLR, CLK, L : in std_logic);
    end component;
begin
    instrReg: SimpleRegister 
        generic map(N => instrF'LENGTH)
        port map(instrF, instrD, CLR, CLK, L);

    pcReg: SimpleRegister 
        generic map(N => pcF'LENGTH)
        port map(pcF, pcD, CLR, CLK, L);

    PCplus4Reg: SimpleRegister 
        generic map(N => PCplus4F'LENGTH)
        port map(PCplus4F, PCplus4D, CLR, CLK, L);
end RTL;
