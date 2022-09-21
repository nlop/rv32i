library ieee;
use ieee.std_logic_1164.all;

package PipePackage is

    component DecodePipe is
        generic(N : integer := 32);
        port(
        CLK, CLR, L : in std_logic;
        instrF : in std_logic_vector(N - 1 downto 0);
        pcF : in std_logic_vector(N - 1 downto 0);
        PCplus4F : in std_logic_vector(N - 1 downto 0);
        instrD : out std_logic_vector(N - 1 downto 0);
        pcD : out std_logic_vector(N - 1 downto 0);
        PCplus4D : out std_logic_vector(N - 1 downto 0));
    end component;

    component ExecutePipe is
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
    end component;

    component MemoryPipe is 
        generic(N : integer := 32;
                M : integer := 5;
                N_CONTROLSIG : integer := 7);
        port(
        CLK, CLR, L : in std_logic;
        controlE : in std_logic_vector(N_CONTROLSIG - 1 downto 0);
        aluResultE : in std_logic_vector(N - 1 downto 0);
        writeDataE : in std_logic_vector(N - 1 downto 0);
        rdE : in std_logic_vector(M - 1 downto 0);
        PCplus4E : in std_logic_vector(N - 1 downto 0);
        controlM : out std_logic_vector(N_CONTROLSIG - 1 downto 0);
        aluResultM : out std_logic_vector(N - 1 downto 0);
        writeDataM : out std_logic_vector(N - 1 downto 0);
        rdM : out std_logic_vector(M - 1 downto 0);
        PCplus4M : out std_logic_vector(N - 1 downto 0));
    end component; 

    component WritebackPipe is
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
        controlW : out std_logic_vector(N_CONTROLSIG - 1 downto 0);
        aluResultW : out std_logic_vector(N - 1 downto 0);
        ramRdW : out std_logic_vector(N - 1 downto 0);
        rdW : out std_logic_vector(M - 1 downto 0);
        PCplus4W : out std_logic_vector(N - 1 downto 0));
    end component;

end PipePackage;
