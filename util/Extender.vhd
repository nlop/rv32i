library ieee;
use ieee.std_logic_1164.all;

entity Extender is
    port(
        INST : in std_logic_vector(31 downto 0);
        SRC : in std_logic_vector(1 downto 0);
        EXT : out std_logic_vector(31 downto 0));
end Extender;

architecture Behavioral of Extender is
    constant N : integer := 32;
    constant IMM_LEN : integer := 12;
    constant IMM_LEN_J : integer := 20;
    signal sign : std_logic_vector(N - IMM_LEN - 1 downto 0);
    signal sign_J : std_logic_vector(N - IMM_LEN_J - 1 downto 0);
    signal src_I, src_S, src_B, src_J : std_logic_vector(N - 1 downto 0);
begin
    -- Sign extension
    sign <= (others => INST(N - 1));
    sign_J <= (others => INST(N - 1));

    -- Type I : 12bit signed (00)
   src_I <= sign & INST(31 downto 20);
    -- Type S : 12bit signed (01)
   src_S <= sign & INST(31 downto 25) & INST(11 downto 7);
    -- Type B : 13bit signed (10)
   src_B <= sign & INST(7) & INST(30 downto 25) & INST(11 downto 8) & '0';
    -- Type J : 21bit signed (11)
   src_J <= sign_J & INST(19 downto 12) & INST(20) & INST(30 downto 21) & '0';

   -- Src mux
   srcmux: with SRC select
       EXT <= src_I when "00",
              src_S when "01",
              src_B when "10",
              src_J when others;
end Behavioral;
