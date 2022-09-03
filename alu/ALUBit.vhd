library IEEE;
library work;
use IEEE.STD_LOGIC_1164.ALL;
use work.ALUPackage.SumaBit;

entity ALUBit is
    port ( A , B, cin : in STD_LOGIC;
           op , sel : in STD_LOGIC_VECTOR(1 downto 0);
           S, cout : out STD_LOGIC);
end ALUBit;

architecture Behavioral of ALUBit is

signal aux_a, aux_b, and1, or1, xor1, sum1, carry : STD_LOGIC;

begin
    aux_a <= a when ( sel(1) = '0') else not a;
    aux_b <= b when ( sel(0) = '0') else not b;
    and1 <= aux_a and aux_b;
    or1 <= aux_a or aux_b;
    xor1 <= aux_a xor aux_b;
    suma : sumaBit port map (
        a => aux_a,
        b => aux_b,
        cin => cin,
        s => sum1,
        cout => carry);
    process(op, and1, sum1, or1, xor1)
    begin
        case op is
            when "00" =>
                cout <= '0';
                s <= and1;
            when "01" =>
                cout <= '0';
                s <= or1;
            when "10" =>
                cout <= '0';
                s <= xor1;
            when others =>
                cout <= carry;
                s <= sum1;
        end case;
    end process;
end Behavioral;
