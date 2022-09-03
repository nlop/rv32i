library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Generic 2^K * N random access memory with address bus of M bits
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
    type RamBank is array (0 to (2**(K + 2) - 1)) of Byte;
    -- Array signal to split WD
    type WDA_Array is array (0 to N/B - 1) of Byte;

    signal data : RamBank;
    signal RDA_full, RDA_half, RDA_byte : std_logic_vector(N - 1 downto 0);
    signal Z_half : std_logic_vector(N/2 - 1 downto 0);
    signal Z_byte : std_logic_vector(N - B - 1 downto 0);
    signal WDA_a : WDA_Array; 

begin
    -- Zeros
    Z_half <= (others => '0');
    Z_byte <= (others => '0');

    -- Map write buses
    wda: for i in 0 to N/B - 1 generate
        WDA_a(i) <=  WD(B*i + B - 1 downto B*i);
    end generate;

    -- Read buses
    RDA_full <= data(to_integer(unsigned(A))) 
                & data(to_integer(unsigned(A) + 1)) 
                & data(to_integer(unsigned(A) + 2)) 
                & data(to_integer(unsigned(A) + 3));
    RDA_half <= Z_half & RDA_full(N - 1 downto N - N/2);
    RDA_byte <= Z_byte & RDA_full(N - 1 downto N - B);

    -- RD mux
    rdmux: with fun select
        RD <= RDA_half when "001",
              RDA_byte when "000",
              RDA_full when others;

process (CLK, WE) begin
    if(rising_edge(CLK)) then
        if(WE = '1') then
            case fun is
                when "001" => 
                    for i in 0 to (N/(2*B) - 1) loop
                        data(to_integer(unsigned(A) + i)) <=  WDA_a(i);
                    end loop;
                when "000" => 
                    data(to_integer(unsigned(A))) <= WDA_a(0);       
                when others =>
                    for i in 0 to N/B - 1 loop
                        data(to_integer(unsigned(A) + i)) <=  WDA_a(i);
                    end loop;
            end case;
        end if;
    end if;
end process;
end Behavioral;
