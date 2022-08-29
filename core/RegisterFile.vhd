library ieee;
use ieee.std_logic_1164.all;

-- Generic register file with 2^NREG registers with word size of N bits and
-- barrel shifter with support for NSHIFT bit shifts on both directions.
-- Parameters:
--      N: word size
--      NLOG2 : log2(N), used to map other generic components
--      NREG: number of registers = 2^NREG
--      NSHIFT: number of bit shifts supported by the barrel shifter = 2^NSHIFT
--
entity RegisterFile is
    generic( 
               N : integer := 16;
               NLOG2 : integer := 4;
               NREG : integer := 4;
               NSHIFT : integer := 4);

    port ( WD3 : in std_logic_vector (N - 1 downto 0);
    A3, A1, A2 : in std_logic_vector (NREG - 1 downto 0);
    shamt : in std_logic_vector(NSHIFT - 1 downto 0);
    CLK, CLR, SHE, DIR, WE3 : in std_logic;
    RD1, RD2 : out std_logic_vector (N - 1 downto 0));
end RegisterFile;

architecture Behavioral of RegisterFile is

    component SimpleRegister is
        generic ( N : integer := 16);
        port ( D : in std_logic_vector (N - 1 downto 0);
               Q : out std_logic_vector (N - 1 downto 0);
        CLR, CLK, L : in std_logic);
    end component;

    component BarrelShifter is
        generic ( 
                    N : integer := 16;
                    SHBITS : integer := 4 );
        port ( din : in std_logic_vector (N - 1 downto 0);
               dout : out std_logic_vector (N - 1 downto 0);
               shamt : in std_logic_vector (SHBITS - 1 downto 0);
               DIR : in std_logic);
    end component;

    component DemuxGeneric93 is
        generic ( 
                    N : integer := 16;
                    PORTS : integer := 4);
        port ( 
                 dout : out std_logic_vector(N - 1 downto 0);
                 din : in std_logic;
                 sel : in std_logic_vector(PORTS - 1 downto 0));
    end component;

    component MuxGeneric93 is 
        generic (
                    N : integer := 16;
                    PORTS : integer := 4);
        port (
                 dout : out std_logic_vector(N - 1 downto 0);
                 sel : in std_logic_vector(PORTS - 1 downto 0);
                 din : in std_logic_vector((2**PORTS * N) - 1 downto 0));
    end component;


    signal lbus, dbus, barrelOut, RD1_aux, RD2_aux : std_logic_vector(N - 1 downto 0);
    signal regReadBus : std_logic_vector((2**NREG * N) - 1 downto 0);

begin
-- Demultiplexor
    demu : DemuxGeneric93 
    generic map (
                    N => N,
                    PORTS => NLOG2)
    port map (
                 din => WE3,
                 sel => A3,
                 dout => lbus);
-- Multiplexor WD3
    dbus <= barrelOut when SHE = '1' else WD3;
-- Barrel shifter
    barrel : BarrelShifter 
    generic map (
                    N => N,
                    SHBITS => NSHIFT)
    port map (
                 din => RD1_aux,
                 dout => barrelOut,
                 shamt => shamt,
                 dir => DIR);
-- Multiplexor RD1
    rdDataMux1 : MuxGeneric93 
    generic map (
                    N => N,
                    PORTS => NREG)
    port map (
                 din => regReadBus,
                 sel => A1,
                 dout => RD1_aux);
-- Multiplexor RD2
    rdDataMux2 : MuxGeneric93
    generic map (
                    N => N,
                    PORTS => NREG)
    port map (
                 din => regReadBus,
                 sel => A2,
                 dout => RD2_aux);
    -- SimpleRegisters
    ciclo : for i in 0 to (2**NREG - 1) generate
        regn : SimpleRegister 
        generic map (N => N)
        port map(
                    d => dbus,
                    q => regReadBus((N * i + 2**NREG) - 1 downto (N * i)),
                    l => lbus(i),
                    clk => CLK,
                    clr => CLR);
    end generate;
    RD1 <= RD1_aux;
    RD2 <= RD2_aux;
end Behavioral;
