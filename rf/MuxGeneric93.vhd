library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Generic 2^PORTS : 1 multiplexer with N bit output compatible with VHDL-93
entity MuxGeneric93 is 
    generic (
                N : integer := 16;
                PORTS : integer := 4);
    port (
             dout : out std_logic_vector(N - 1 downto 0);
             sel : in std_logic_vector(PORTS - 1 downto 0);
             din : in std_logic_vector((2**PORTS * N) - 1 downto 0));
end MuxGeneric93;
architecture Behavioral of MuxGeneric93 is
    type MuxIn is array(0 to 2**PORTS - 1) of STD_LOGIC_VECTOR(N - 1 downto 0);
    signal muxdata : MuxIn;
begin
    muxi: for i in 0 to (2**PORTS - 1) generate
        muxdata(i) <= din((N * i + 2**PORTS) - 1 downto N * i);
    end generate;
    dout <= muxdata(to_integer(unsigned(sel)));
end Behavioral;

