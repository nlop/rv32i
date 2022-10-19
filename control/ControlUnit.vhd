library ieee;
use ieee.std_logic_1164.all;

entity ControlUnit is
    port (
             op : in std_logic_vector(6 downto 0);
             aluOP : out std_logic_vector(1 downto 0);
             srcB : out std_logic;
             regWE3 : out std_logic;
             ramWE : out std_logic;
             resSrc : out std_logic_vector(1 downto 0);
             extSrc : out std_logic_vector(2 downto 0);
             BR : out std_logic;
             JMP : out std_logic;
            jmpSrc : out std_logic);
end ControlUnit;

architecture Behavioral of ControlUnit is

begin

ctl: process (op) begin
    case op is
        -- Type I op = 03
        when "0000011" =>
            aluOP <= "00";  
            srcB <= '0';
            regWE3 <= '1';
            ramWE <= '0';
            resSrc <= "01";
            extSrc <= "000";
            BR <= '0';
            JMP <= '0';
            jmpSrc <= '0';
        -- Type I op = 19
        when "0010011" =>
            aluOP <= "10";  
            srcB <= '0';
            regWE3 <= '1';
            ramWE <= '0';
            resSrc <= "00";
            extSrc <= "000";
            BR <= '0';
            JMP <= '0';
            jmpSrc <= '0';
        -- Type U op = 23
        when "0010111" =>
            aluOP <= "00";  
            srcB <= '0';
            regWE3 <= '1';
            ramWE <= '0';
            resSrc <= "11";
            extSrc <= "100";
            BR <= '0';
            JMP <= '0';
            jmpSrc <= '0';
        -- Type S op = 35
        when "0100011" =>
            aluOP <= "00";  
            srcB <= '0';
            regWE3 <= '0';
            ramWE <= '1';
            resSrc <= "01";
            extSrc <= "001";
            BR <= '0';
            JMP <= '0';
            jmpSrc <= '0';
        -- Type R op = 51
        when "0110011" =>
            aluOP <= "11";  
            srcB <= '1';
            regWE3 <= '1';
            ramWE <= '0';
            resSrc <= "00";
            extSrc <= "000";
            BR <= '0';
            JMP <= '0';
            jmpSrc <= '0';
        -- Type U op = 55
        when "0110111" =>
            aluOP <= "00";  
            srcB <= '0';
            regWE3 <= '1';
            ramWE <= '0';
            resSrc <= "00";
            extSrc <= "101";
            BR <= '0';
            JMP <= '0';
            jmpSrc <= '0';
        -- Type B op = 99
        when "1100011" =>
            aluOP <= "01";  
            srcB <= '1';
            regWE3 <= '0';
            ramWE <= '0';
            resSrc <= "00";
            extSrc <= "010";
            BR <= '1';
            JMP <= '0';
            jmpSrc <= '0';
        -- Type I op = 103
        when "1100111" =>
            aluOP <= "00";  
            srcB <= '0';
            regWE3 <= '1';
            ramWE <= '0';
            resSrc <= "00";
            extSrc <= "000";
            BR <= '0';
            JMP <= '1';
            jmpSrc <= '1';
        -- Type J op = 111
        when "1101111" =>
            aluOP <= "00";  
            srcB <= '0';
            regWE3 <= '1';
            ramWE <= '0';
            resSrc <= "10";
            extSrc <= "011";
            BR <= '0';
            JMP <= '1';
            jmpSrc <= '0';
        when others => 
            aluOP <= "00";  
            srcB <= '0';
            regWE3 <= '0';
            ramWE <= '0';
            resSrc <= "01";
            extSrc <= "000";
            BR <= '0';
            JMP <= '0';
            jmpSrc <= '0';
    end case;
end process;
    end Behavioral;
