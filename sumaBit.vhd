library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity sumaBit is
    Port ( a,b,cin : in STD_LOGIC;
           s,cout : out STD_LOGIC);
end sumaBit;

architecture Behavioral of sumaBit is
begin
    s <= a xor b xor cin;
    cout <= (a and cin) or (b and cin) or (b and a);
end Behavioral;
