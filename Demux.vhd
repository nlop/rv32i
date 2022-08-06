library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Demux is
    generic( N : integer := 16);
    Port ( din : in STD_LOGIC;
           sel : in STD_LOGIC_VECTOR (3 downto 0);
           dout : out STD_LOGIC_VECTOR (N - 1 downto 0));
end Demux;

architecture Behavioral of Demux is

begin
    process(din, sel) 
        variable sel_int : integer := to_integer(unsigned(sel));
    begin
        dout <= (others => '0');
        dout(sel_int) <= din;
    end process;
end Behavioral;
