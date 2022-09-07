library ieee;
use ieee.std_logic_1164.all;

entity ControlUnit is
    port (
             op : in std_logic_vector(6 downto 0);
             aluOP : out std_logic_vector(1 downto 0);
             srcB : out std_logic;
             WE3En : out std_logic;
             wRamEn : out std_logic;
             resSrc : out std_logic;
             extSrc : out std_logic_vector(1 downto 0);
             jinst : out std_logic);
end ControlUnit;

architecture Behavioral of ControlUnit is

begin

ctl: process (op) begin
    case op is
        -- Type I op 0x03
        when "0000011" =>
            aluOP <= "00";  
            srcB <= '0';
            WE3En <= '1';
            wRamEn <= '0';
            resSrc <= '0';
            extSrc <= "00";
            jinst <= '0';
        -- Type I op 0x19
        when "0010011" =>
            aluOP <= "10";  
            srcB <= '0';
            WE3En <= '1';
            wRamEn <= '0';
            resSrc <= '1';
            extSrc <= "00";
            jinst <= '0';
        -- Type S op 0x35
        when "0100011" =>
            aluOP <= "00";  
            srcB <= '0';
            WE3En <= '0';
            wRamEn <= '1';
            resSrc <= '0';
            extSrc <= "00";
            jinst <= '0';
        -- Type S op 0x51
        when "0110011" =>
            aluOP <= "10";  
            srcB <= '1';
            WE3En <= '1';
            wRamEn <= '0';
            resSrc <= '1';
            extSrc <= "00";
            jinst <= '0';
        when others => 
            aluOP <= "00";  
            srcB <= '0';
            WE3En <= '0';
            wRamEn <= '0';
            resSrc <= '0';
            extSrc <= "00";
            jinst <= '0';
    end case;
                  -- Type B op 0x99
                  --when "1100011" =>
                  --    aluOP <= "01";  
                  --    srcB <= '1';
                  --    WE3En <= '0';
                  --    wRamEn <= '0';
                  --    resSrc <= '1';
                  --    extSrc <= "";
                  --    jinst <= '0';
        end process;
    end Behavioral;
