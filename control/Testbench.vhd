library ieee;
use ieee.std_logic_1164.all;

entity Testbench is

    end Testbench;

architecture Behavioral of Testbench is

    component ControlUnit is
        port (
                 op : in std_logic_vector(6 downto 0);
                 aluOP : out std_logic_vector(1 downto 0);
                 srcB : out std_logic;
                 WE3En : out std_logic;
                 wRamEn : out std_logic;
                 resSrc : out std_logic;
                 extSrc : out std_logic_vector(1 downto 0);
                 jinst : out std_logic);
    end component;

    signal op : std_logic_vector(6 downto 0);
    signal aluOP : std_logic_vector(1 downto 0);
    signal srcB : std_logic;
    signal WE3En : std_logic;
    signal wRamEn : std_logic;
    signal resSrc : std_logic;
    signal extSrc : std_logic_vector(1 downto 0);
    signal jinst : std_logic;

begin
    cu: ControlUnit port map(
        op => op,
        aluOP => aluOP,
        srcB => srcB,
        WE3En => WE3En,
        wRamEn => wRamEn,
        resSrc => resSrc,
        extSrc => extSrc,
        jinst => jinst);
    test: process begin
        op <= "0000011";
        wait for 10 ns;
        op <= "0010011";
        wait for 10 ns;
        op <= "0100011";
        wait for 10 ns;
        op <= "0110011";
        wait for 10 ns;
        op <= "0010111";
        wait for 10 ns;
        op <= "1101111";
        wait for 10 ns;
        wait;
    end process;
end Behavioral;
