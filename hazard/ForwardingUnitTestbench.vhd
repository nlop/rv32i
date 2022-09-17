library ieee;
use ieee.std_logic_1164.all;

entity ForwardingUnitTestbench is
    end entity;

architecture Behavioral of ForwardingUnitTestbench is
    constant M : integer := 5;
    component ForwardingUnit is
        generic (M : integer := 5);
        port (
        W3EnW, W3EnM : in std_logic;
        Rs1E : in std_logic_vector(M - 1 downto 0);
        Rs2E : in std_logic_vector(M - 1 downto 0);
        rdM : in std_logic_vector(M - 1 downto 0);
        rdW : in std_logic_vector(M - 1 downto 0);
        forwardAE : out std_logic_vector(1 downto 0);
        forwardBE : out std_logic_vector(1 downto 0));
    end component;

    signal W3EnW, W3EnM : std_logic;
    signal Rs1E : std_logic_vector(M - 1 downto 0);
    signal Rs2E : std_logic_vector(M - 1 downto 0);
    signal rdM : std_logic_vector(M - 1 downto 0);
    signal rdW : std_logic_vector(M - 1 downto 0);
    signal forwardAE : std_logic_vector(1 downto 0);
    signal forwardBE : std_logic_vector(1 downto 0);
begin

    fwunit: ForwardingUnit port map(W3EnW, W3EnM, Rs1E, Rs2E, rdM, rdW, forwardAE, forwardBE);

    test: process begin
        W3EnM <= '0';
        W3EnW <= '0';
        Rs2E <= (others => '0');
        rdM <= (others => '0');
        Rs1E <= (others => '0');
        rdW <= (others => '0');
        wait for 10 ns;
        W3EnW <= '1';
        Rs1E <= "00111";
        rdW <= "00111";
        wait for 10 ns;
        W3EnW <= '0';
        Rs1E <= (others => '0');
        rdW <= (others => '0');
        wait for 10 ns;
        W3EnM <= '1';
        Rs2E <= "00110";
        rdM <= "00110";
        wait for 10 ns;
        wait;
    end process;
end Behavioral;
