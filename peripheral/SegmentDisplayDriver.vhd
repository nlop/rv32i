library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

-- Four 7-segment display driver
entity SegmentDisplayDriver is
    generic(
        DIV_CLK : integer := 16);
    port(
        CLK, CLR, WE : in std_logic;
        WD : in std_logic_vector(31 downto 0);
        AN : out std_logic_vector(3 downto 0);
        CX : out std_logic_vector(6 downto 0));
end SegmentDisplayDriver;

architecture Behavioral of SegmentDisplayDriver is
    -- Register
    component SimpleRegister is
    generic (N : integer := 4);
    port ( D : in std_logic_vector (N - 1 downto 0);
           Q : out std_logic_vector (N - 1 downto 0);
           CLR, CLK, L : in std_logic);
    end component;
    -- Ring counter
    component RingCounter is
    generic(N : integer := 4);
    port(
        CLK, CLR : in std_logic;
        Q : out std_logic_vector(N - 1 downto 0));
    end component;
    -- BCD
    component BCD is
    generic(N: integer := 2);
    port(
        CLK, CLR : in std_logic;
        Q : out std_logic_vector(N - 1 downto 0));
    end component;
    -- Demux
    component DemuxGeneric93 is
    generic ( 
                N : integer := 4;
                PORTS : integer := 2);
    port ( 
    dout : out std_logic_vector(N - 1 downto 0);
    din : in std_logic;
    sel : in std_logic_vector(PORTS - 1 downto 0));
    end component;
    -- Mux
    component MuxGeneric93 is 
    generic (
                N : integer := 4;
                PORTS : integer := 2);
    port (
             dout : out std_logic_vector(N - 1 downto 0);
             sel : in std_logic_vector(PORTS - 1 downto 0);
             din : in std_logic_vector((2**PORTS * N) - 1 downto 0));
    end component;
    component DigitEncoder is
        port(
                A : in std_logic_vector(3 downto 0);
                RD : out std_logic_vector(6 downto 0));
    end component;
    signal weDemuxOut : std_logic_vector(3 downto 0); 
    signal WeOut : std_logic_vector(3 downto 0); 
    signal dregOut : std_logic_vector((4 * 4) - 1 downto 0);
    signal dregMuxOut : std_logic_vector(3 downto 0);
    signal ringOut : std_logic_vector(3 downto 0);
    signal dispClkQ : std_logic_vector(DIV_CLK - 1 downto 0);
    signal bcdCount : std_logic_vector(1 downto 0);
begin
    dreg: for i in 0 to 3 generate 
        sri: SimpleRegister port map(
            CLK => CLK,
            CLR => CLR,
            L => WE,
            D => WD((4 * i + 4) - 1 downto (4 * i)),
            Q => dregOut((4 * i + 4) - 1 downto (4 * i)));
    end generate;

    dregmux: MuxGeneric93 port map(
        dout => dregMuxOut,
        din => dregOut,
        sel => bcdCount);

    bcdi: BCD port map(
        CLK => dispClkQ(DIV_CLK - 1),
        CLR => CLR,
        Q => bcdCount);

    -- BCD-to-AN
    AN(0) <= (not bcdCount(0)) and (not bcdCount(1));
    AN(1) <= bcdCount(0) and (not bcdCount(1));
    AN(2) <= (not bcdCount(0)) and bcdCount(1);
    AN(3) <= bcdCount(0) and bcdCount(1);

    dige: DigitEncoder port map(
        A => dregMuxOut,
        RD => CX);

    -- Display CLK
    dclkc: BCD generic map(
        N => DIV_CLK)
        port map(
        CLK => CLK,
        CLR => CLR,
        Q => dispClkQ);

end Behavioral;
