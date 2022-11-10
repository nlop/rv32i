library ieee;
use ieee.std_logic_1164.all;

-- Generic register file with 2^NREG registers with word size of N bits.
-- Parameters:
--      N: word size
--      LOG2N : log2(N), used to map other generic components
--      NREG: number of registers = 2^NREG
entity RegisterFile is
    generic( 
               N : integer := 16;
               LOG2N : integer := 4;
               NREG : integer := 4);

    port ( WD3 : in std_logic_vector (N - 1 downto 0);
    A3, A1, A2 : in std_logic_vector (NREG - 1 downto 0);
    CLK, CLR, WE3 : in std_logic;
    RD1, RD2 : out std_logic_vector (N - 1 downto 0);
    DEB: out std_logic_vector(N - 1 downto 0));
end RegisterFile;

architecture Behavioral of RegisterFile is
    constant DEBUG_REG : integer := 18; -- Debug register
    component SimpleRegister is
        generic ( N : integer := 16);
        port ( D : in std_logic_vector (N - 1 downto 0);
               Q : out std_logic_vector (N - 1 downto 0);
        CLR, CLK, L : in std_logic);
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
    signal lbus, RD1_aux, RD2_aux : std_logic_vector(N - 1 downto 0);
    signal regReadBus : std_logic_vector((2**NREG * N) - 1 downto 0);
    signal zero : std_logic_vector(N - 1 downto 0);

begin
-- Demultiplexor
    demu : DemuxGeneric93 
    generic map (
                    N => N,
                    PORTS => LOG2N)
    port map (
                 din => WE3,
                 sel => A3,
                 dout => lbus);
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
    -- Zero register
    zero <= (others => '0');
    zeroreg: SimpleRegister 
    generic map (N => N)
    port map(
        d => zero,
        q => regReadBus((N * 0 + 2**NREG) - 1 downto (N * 0)),
        l => lbus(0),
        clk => CLK,
        clr => CLR);
    -- SimpleRegister instances
    rfloop: for i in 1 to (2**NREG - 1) generate
        regn : SimpleRegister 
        generic map (N => N)
        port map(
                    d => WD3,
                    q => regReadBus((N * i + 2**NREG) - 1 downto (N * i)),
                    l => lbus(i),
                    clk => CLK,
                    clr => CLR);
    end generate;
    DEB <= regReadBus((N * DEBUG_REG + 2**NREG) - 1 downto (N * DEBUG_REG));
    RD1 <= RD1_aux;
    RD2 <= RD2_aux;
end Behavioral;
