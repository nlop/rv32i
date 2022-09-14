library ieee;
use ieee.std_logic_1164.all;

entity ControlUnit is
    port (
             op : in std_logic_vector(6 downto 0);
             aluOP : out std_logic_vector(1 downto 0);
             srcB : out std_logic;
             WE3En : out std_logic;
             wRamEn : out std_logic;
             resSrc : out std_logic_vector(1 downto 0);
             extSrc : out std_logic_vector(1 downto 0);
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
            WE3En <= '1';
            wRamEn <= '0';
            resSrc <= "00";
            extSrc <= "00";
            BR <= '0';
            JMP <= '0';
            jmpSrc <= '0';
        -- Type I op = 19
        when "0010011" =>
            aluOP <= "10";  
            srcB <= '0';
            WE3En <= '1';
            wRamEn <= '0';
            resSrc <= "01";
            extSrc <= "00";
            BR <= '0';
            JMP <= '0';
            jmpSrc <= '0';
        -- Type S op = 35
        when "0100011" =>
            aluOP <= "00";  
            srcB <= '0';
            WE3En <= '0';
            wRamEn <= '1';
            resSrc <= "00";
            extSrc <= "01";
            BR <= '0';
            JMP <= '0';
            jmpSrc <= '0';
        -- Type R op = 51
        when "0110011" =>
            aluOP <= "11";  
            srcB <= '1';
            WE3En <= '1';
            wRamEn <= '0';
            resSrc <= "01";
            extSrc <= "00";
            BR <= '0';
            JMP <= '0';
            jmpSrc <= '0';
        -- Type B op = 99
        when "1100011" =>
            aluOP <= "01";  
            srcB <= '1';
            WE3En <= '0';
            wRamEn <= '0';
            resSrc <= "01";
            extSrc <= "10";
            BR <= '1';
            JMP <= '0';
            jmpSrc <= '0';
        -- Type I op = 103
        when "1100111" =>
            aluOP <= "00";  
            srcB <= '0';
            WE3En <= '1';
            wRamEn <= '0';
            resSrc <= "01";
            extSrc <= "00";
            BR <= '0';
            JMP <= '1';
            jmpSrc <= '1';
        -- Type J op = 111
        when "1101111" =>
            aluOP <= "00";  
            srcB <= '0';
            WE3En <= '1';
            wRamEn <= '0';
            resSrc <= "10";
            extSrc <= "11";
            BR <= '0';
            JMP <= '1';
            jmpSrc <= '0';
        when others => 
            aluOP <= "00";  
            srcB <= '0';
            WE3En <= '0';
            wRamEn <= '0';
            resSrc <= "00";
            extSrc <= "00";
            BR <= '0';
            JMP <= '0';
            jmpSrc <= '0';
    end case;
end process;
    end Behavioral;
