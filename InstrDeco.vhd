library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity InstrDeco is
    Port ( OpCode : in STD_LOGIC_VECTOR (4 downto 0);
           TIPOR, BEQI, BNEI, BLTI, BLETI, BGTI, BGETI : out STD_LOGIC);
end InstrDeco;

architecture Behavioral of InstrDeco is

begin
process(OpCode) begin
    TIPOR <= '0'; BEQI <= '0'; BNEI <= '0'; BLTI <= '0';
    BLETI <= '0'; BGTI <= '0'; BGETI <= '0';
    
    case OpCode is
        when "00000" => 
            TIPOR <= '1';
        when "01101" =>
            BEQI <= '1';
        when "01110" =>
            BNEI <= '1';
        when "01111" =>
            BLTI <= '1';
        when "10000" =>
            BLETI <= '1';
        when "10001" =>
            BGTI <= '1';
        when "10010" =>
            BGETI <= '1';
        when others =>
            TIPOR <= '0';
    end case;
end process;

end Behavioral;
