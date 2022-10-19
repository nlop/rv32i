library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

-- Generic 2^K * N random access memory with an address bus of M bits. Supports 
-- addressing modes by word, half-word and byte.
entity RAM is       
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
end RAM;

architecture Behavioral of RAM is
    constant B : integer := 8;
    subtype Byte is std_logic_vector(B - 1 downto 0);
    type RamBank is array (0 to (2**K - 1)) of Byte;
    -- Array signal to split WD
    type WDA_Array is array (0 to N/B - 1) of Byte;
    type Addr_Array is array (0 to N/B - 1) of std_logic_vector(K - 1 downto 0);

    signal data : RamBank;
    signal addr : std_logic_vector(N - 1 downto 0);
    signal addr_Zero : std_logic_vector(N - K - 1 downto 0);
    signal RDA_full : std_logic_vector(N - 1 downto 0);
    signal RDA_half: std_logic_vector(N/2 - 1 downto 0);
    signal RDA_byte : std_logic_vector(B - 1 downto 0);
    signal Z_half : std_logic_vector(N/2 - 1 downto 0);
    signal Z_byte: std_logic_vector(N - B - 1 downto 0);
    signal Sign_half : std_logic_vector(N/2 - 1 downto 0);
    signal Sign_byte : std_logic_vector(N - B - 1 downto 0);
    signal WDA_a : WDA_Array; 
    signal Addr_a : Addr_Array;

begin
    -- Adjust A signal to K bits
    addr_Zero <= (others => '0');
    iaddr: for i in 0 to (N/B - 1) generate
        Addr_a(i) <= A(K - 1 downto 0) + i;
    end generate;
    -- Zeros
    Z_half <= (others => '0');
    Z_byte <= (others => '0');

    -- Sign extensions
    Sign_half <= (others => RDA_half(N - N/2 - 1));
    Sign_byte <= (others => RDA_byte(B - 1));
    
    -- Split write bus
    wda: for i in 0 to N/B - 1 generate
        WDA_a(i) <=  WD(B*i + B - 1 downto B*i);
    end generate;

    -- Read buses
    ird: for i in 0 to (N/B - 1) generate
        RDA_full(B*i + B - 1 downto B * i) <= data(to_integer(unsigned(Addr_a(i))));
    end generate;
    RDA_half(N/2 - 1 downto 0) <= RDA_full(N - N/2 - 1 downto 0);
    RDA_byte(B - 1 downto 0) <= RDA_full(B - 1 downto 0);

    -- RD mux
    rdmux: with fun select
        RD <= Sign_half & RDA_half when "001",
              Sign_byte & RDA_byte when "000",
              Z_half & RDA_half when "101",
              Z_byte & RDA_byte when "100",
              RDA_full when others;

    process (CLK, WE) begin
        if(rising_edge(CLK)) then
            if(WE = '1') then
                case fun is
                    when "001" => 
                        for i in 0 to (N/(2*B) - 1) loop
                            data(to_integer(unsigned(Addr_a(i)))) <=  WDA_a(i);
                        end loop;
                    when "000" => 
                        data(to_integer(unsigned(addr))) <= WDA_a(0);       
                    when others =>
                        for i in 0 to N/B - 1 loop
                            data(to_integer(unsigned(Addr_a(i)))) <=  WDA_a(i);
                        end loop;
                end case;
            end if;
        end if;
    end process;
end Behavioral;
