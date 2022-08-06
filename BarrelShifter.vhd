library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity BarrelShifter is
    generic ( 
        N : integer := 16;
        SHBITS : integer := 4 );
    Port ( din : in STD_LOGIC_VECTOR (N - 1 downto 0);
           dout : out STD_LOGIC_VECTOR (N - 1 downto 0);
           shamt : in STD_LOGIC_VECTOR (SHBITS - 1 downto 0);
           dir : in STD_LOGIC);
end BarrelShifter;

architecture Behavioral of BarrelShifter is

begin
process(din, dir, shamt)
variable aux : std_logic_vector(N - 1 downto 0);
begin
aux := din;
    -- Corrimiento a la IZQ                
    if(dir = '1') then
        for i in 0 to SHBITS - 1 loop
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
        -- Corrimiento a la DER
        for i in 0 to SHBITS - 1 loop
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
                    aux(j) := '0';
                end if;
            end loop;
        end loop;
    end if;
    dout <= aux;
end process;

end Behavioral;