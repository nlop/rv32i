library IEEE;
library work;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use work.VARPackage.MEM_DATA;

entity DataMem is       
    Port ( addr : in STD_LOGIC_VECTOR (9 downto 0);
           din : in STD_LOGIC_VECTOR (15 downto 0);
           WD, CLK : in STD_LOGIC;
           dout : out STD_LOGIC_VECTOR (15 downto 0));
end DataMem;

architecture Behavioral of DataMem is
signal data : MEM_DATA;
begin
    process (CLK, WD) begin
        if(rising_edge(CLK)) then
           if(WD = '1') then
                data(conv_integer(addr)) <= din;       
           end if;
        end if;
    end process;
    dout <= data(conv_integer(addr));
end Behavioral;
