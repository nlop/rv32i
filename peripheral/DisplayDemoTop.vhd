library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity DisplayDemoTop is
    port(
        CLK, CLR: in std_logic;
        AN: out std_logic_vector(3 downto 0);
        CX: out std_logic_vector(6 downto 0));
end DisplayDemoTop;

architecture Behavioral of DisplayDemoTop is
    constant MAIN_DIV_CLK : integer := 2;
    constant DIG_CLK_N : integer := 4;
    constant Q_ZEROS : std_logic_vector(15 downto 0) := (others => '0');

    component BCD is
    generic(N: integer := 2);
    port(
        CLK, CLR : in std_logic;
        Q : out std_logic_vector(N - 1 downto 0));
    end component;

    component SegmentDisplayDriver is
    generic(
        DIV_CLK : integer := MAIN_DIV_CLK);
    port(
        CLK, CLR, WE : in std_logic;
        WD : in std_logic_vector(31 downto 0);
        AN : out std_logic_vector(3 downto 0);
        CX : out std_logic_vector(6 downto 0));
    end component;
    signal digitClkQ : std_logic_vector(DIG_CLK_N - 1 downto 0);
    signal Q: std_logic_vector(3 downto 0);
    signal Qplus1 : std_logic_vector(3 downto 0);
    signal Qplus2 : std_logic_vector(3 downto 0);
    signal Qplus3 : std_logic_vector(3 downto 0);
    signal sddWD : std_logic_vector(31 downto 0);
begin
    -- 7s display driver
    sdr: SegmentDisplayDriver port map(
        CLK => CLK,
        CLR => CLR,
        WD => sddWD,
        WE => digitClkQ(DIG_CLK_N - 1),
        AN => AN,
        CX => CX);

    -- Digit change clk
    bcd0: BCD generic map(N => DIG_CLK_N)
        port map(
            CLK => CLK,
            CLR => CLR,
            Q => digitClkQ);

    -- Digit count
    bcd1: BCD generic map(N => 4)
    port map(
        CLK => digitClkQ(DIG_CLK_N - 1),
        CLR => CLR,
        Q => Q);
    Qplus1 <= Q + 1;
    Qplus2 <= Qplus1 + 1;
    Qplus3 <= Qplus2 + 1;
    sddWD <= Q_ZEROS & (Qplus3 & Qplus2 & Qplus1 & Q);
    
end Behavioral;
