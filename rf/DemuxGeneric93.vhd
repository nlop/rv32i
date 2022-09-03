library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Generic 1 : 2^PORTS demultiplexer with N bits output. N = 2^PORTS
entity DemuxGeneric93 is
    generic ( 
                N : integer := 16;
                PORTS : integer := 4);
    port ( 
    dout : out std_logic_vector(N - 1 downto 0);
    din : in std_logic;
    sel : in std_logic_vector(PORTS - 1 downto 0));
end DemuxGeneric93;

architecture Behavioral of DemuxGeneric93 is
    subtype MuxInternal is std_logic_vector(2**PORTS - 1 downto 0);
    signal muxint : MuxInternal;
begin
    demuxi: for i in 0 to (N - 1) generate
        dout(i) <= muxint(i); 
    end generate;

    process(din, sel) begin
        muxint <= (others => '0');
        muxint(to_integer(unsigned(sel))) <= din;
    end process;


end Behavioral;
