library ieee;
use ieee.std_logic_1164.all;

-- Processor stalling unit. Used to handle errors on instructions with 
-- high latency e.g. lw
entity StallUnit is
    generic (M : integer := 5);
    port (
        resSrcE0 : in std_logic;
        rdE : in std_logic_vector(M - 1 downto 0);
        Rs1D : in std_logic_vector(M - 1 downto 0);
        Rs2D : in std_logic_vector(M - 1 downto 0);
        notStallF, notStallD, flushE : out std_logic);
end StallUnit;

architecture Behavioral of StallUnit is
    signal lwStall : std_logic;
begin
    lwsp: process(Rs1D, Rs2D, resSrcE0) begin
        if (resSrcE0 = '1') and ((Rs1D = rdE) or (Rs2D = rdE)) then
            lwStall <= '1';
        else
            lwStall <= '0';
        end if;
    end process;
    notStallF <= not lwStall;
    notStallD <= not lwStall;
    flushE <= lwStall;
end Behavioral;
