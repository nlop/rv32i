library work;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.REGPackage.DATA_MUX;

entity Mux is
    generic ( N : integer := 16);
    Port(
        din : in DATA_MUX;
        sel : in STD_LOGIC_VECTOR(3 downto 0);
        dout : out STD_LOGIC_VECTOR (N - 1 downto 0));
end Mux;
architecture Behavioral of Mux is
begin
    dout <= din(to_integer(unsigned(sel)));
end Behavioral;
