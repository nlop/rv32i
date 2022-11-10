library ieee;
use ieee.std_logic_1164.all;

-- N bits barrel shifter.
-- 
-- Parameters:
--      N: word size
--      LOG2N: log2(word size)
--
entity BarrelShifter is
    generic (N : integer := 16; 
             LOG2N : integer := 4);
    port ( din : in std_logic_vector (N - 1 downto 0);
           dout : out std_logic_vector (N - 1 downto 0);
           shamt : in std_logic_vector (LOG2N - 1 downto 0);
           DIR : in std_logic;
           SRAE : in std_logic);
    -- constant SHBITS : integer := integer(ceil(log2(real(N) + real(1)))) - 1;
    --                                                ^ prevent rounding errors
end BarrelShifter;

architecture Behavioral of BarrelShifter is

begin
process(din, shamt, DIR, SRAE)
variable aux : std_logic_vector(N - 1 downto 0);
begin
aux := din;
    -- Left shift                
    if(dir = '1') then
        for i in 0 to LOG2N - 1 loop
            for j in N - 1 downto 2**i loop
                if shamt(i) = '0' then
                    aux(j) := aux(j); 
                else
                    aux(j) := aux(j - 2**i);
                end if;
            end loop;
            for j in 2**i-1 downto 0 loop
                if shamt(i) = '0' then
                    aux(j) := aux(j);
                else
                    aux(j) := '0';
                end if;
            end loop;
        end loop;
    else
        -- Right shift
        for i in 0 to LOG2N - 1 loop
            for j in 0 to N - 2**i - 1 loop
                if shamt(i) = '0' then
                    aux(j) := aux(j); 
                else
                    aux(j) := aux(j + 2**i);
                end if;
            end loop;
            for j in N - 2**i to N - 1 loop
                if shamt(i) = '0' then
                    aux(j) := aux(j);
                else
                    if SRAE = '1' then -- Enable arithmetic shift
                        aux(j) := din(N - 1);
                    else
                        aux(j) := '0';
                    end if;
                end if;
            end loop;
        end loop;
    end if;
    dout <= aux;
end process;

end Behavioral;
