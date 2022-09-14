library ieee;
library std;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
use std.textio.all;
use ieee.std_logic_textio.all;


-- 2^K * N instruction memory. Memory space length(A) is 32 to comply with
-- the RISC-V specification.
-- Parameters:
--      N : word size
--      M : address space
--      K : memory cells
entity InstrMemProgrammable is
    generic (
        N : integer := 32;
        M : integer := 32;  
        K : integer := 10
    );
    port ( A : in STD_LOGIC_VECTOR (M - 1 downto 0);
           RD : out STD_LOGIC_VECTOR (N - 1 downto 0));
end InstrMemProgrammable;

architecture Behavioral of InstrMemProgrammable is
    type InstrMemArr is array (0 to (2**K - 1)) of std_logic_vector(N - 1 downto 0);
    -- Fill memory
    impure function init_intr_mem return InstrMemArr is
        file text_file : text open read_mode is "/home/sebs/riscv-core/riscvtest.txt";
        variable text_line : line;
        variable mem : InstrMemArr;
        variable i : integer := 0;
    begin
        for j in 0 to (2**K - 1) loop
            mem(j) := (others => '0');
        end loop;
        while not endfile(text_file) loop
            readline(text_file, text_line);
            hread(text_line, mem(i));
            i := i + 1;
        end loop;
        return mem;
    end function;
    signal data : InstrMemArr := init_intr_mem;

begin
    RD <= data(to_integer(unsigned(A)));
end Behavioral;
