library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Forwarding unit to prevent read-after-write(RAW) hazards.
--
entity ForwardingUnit is
    generic (M : integer := 5);
    port (
    W3EnW, W3EnM : in std_logic;
    Rs1E : in std_logic_vector(M - 1 downto 0);
    Rs2E : in std_logic_vector(M - 1 downto 0);
    rdM : in std_logic_vector(M - 1 downto 0);
    rdW : in std_logic_vector(M - 1 downto 0);
    forwardAE : out std_logic_vector(1 downto 0);
    forwardBE : out std_logic_vector(1 downto 0));
end ForwardingUnit;

architecture Behavioral of ForwardingUnit is
    constant zeroReg : std_logic_vector(M - 1 downto 0) := (others => '0');
begin
    pforwardA: process (Rs1E, rdM, W3EnM) begin
        if ((Rs1E = rdM) and W3EnM = '1') and Rs1E /= zeroReg then
            forwardAE <= "10";
        elsif ((Rs1E = rdW) and W3EnW = '1') and Rs1E /= zeroReg then
            forwardAE <= "01";
        else 
            forwardAE <= "00";
        end if;
    end process;

    pforwardB: process (Rs2E, rdM, W3EnM) begin
        if ((Rs2E = rdM) and W3EnM = '1') and Rs2E /= zeroReg then
            forwardBE <= "10";
        elsif ((Rs2E = rdW) and W3EnW = '1') and Rs2E /= zeroReg then
            forwardBE <= "01";
        else 
            forwardBE <= "00";
        end if;
    end process;
end Behavioral;
