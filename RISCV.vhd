library ieee;
use ieee.std_logic_1164.all;

entity RISCV is
    constant P : time := 10 ns;
    constant N : integer := 32;
    constant LOG2N : integer := 5;
    constant M : integer := 5; -- register file 2^M * N
    constant ROM_ADDRS : integer := 32; -- ROM address space
    constant K : integer := 10;

end RISCV;

architecture RTL of RISCV is
    -- Instruction memory (ROM)
    component InstrMem is
        generic (
                    N : integer := 32;
                    M : integer := 32;  
                    K : integer := 10
                );
        port ( A : in std_logic_vector(ROM_ADDRS - 1 downto 0);
               RD : out std_logic_vector(N - 1 downto 0));
    end component;
    -- N bits generic ALU
    component ALUNbits is
        generic (N : integer := 4);
        port ( A, B : in std_logic_vector (N - 1 downto 0);
        op, sel : in std_logic_vector (1 downto 0);
        S : out std_logic_vector (N - 1 downto 0);
        flg_ov, flg_n, flg_z, flg_c : out std_logic);
    end component;
    -- Generic register file
    component RegisterFile is
        generic( 
                   N : integer := 16;
                   NLOG2 : integer := 4;
                   NREG : integer := 4;
                   NSHIFT : integer := 4);

        port ( WD3 : in std_logic_vector (N - 1 downto 0);
        A3, A1, A2 : in std_logic_vector (NREG - 1 downto 0);
        shamt : in std_logic_vector(NSHIFT - 1 downto 0);
        CLK, CLR, SHE, DIR, WE3 : in std_logic;
        RD1, RD2 : out std_logic_vector (N - 1 downto 0));
    end component;
    -- === Signals ===
    signal CLK, CLR, SHE, DIR, WE3 : std_logic;
    signal pc : std_logic_vector(N - 1 downto 0);
    -- Register file signals
    signal instr : std_logic_vector(N - 1 downto 0);
    signal shamt : std_logic_vector(LOG2N - 1 downto 0);
    signal WD3 : std_logic_vector(N - 1 downto 0);
    signal RD1 : std_logic_vector(N -1 downto 0);
    signal RD2 : std_logic_vector(N -1 downto 0);
    -- ALU signals
    signal sel : std_logic_vector(1 downto 0);
    signal op : std_logic_vector(1 downto 0);
    signal res : std_logic_vector(N - 1 downto 0);
    signal flags : std_logic_vector(3 downto 0);

begin
    -- Instruction memory (ROM)
    rom : InstrMem port map (
                                A => pc,
                                RD => instr);
    -- Register file instance
    rf : RegisterFile generic map (
                                      N => N,
                                      NLOG2 => LOG2N,
                                      NREG => M,
                                      NSHIFT => LOG2N)
    port map (
                 WD3 => WD3,
                 A1 => instr(19 downto 15),
                 A2 => instr(24 downto 20),
                 A3 => instr(11 downto 7),
                 shamt => shamt,
                 CLK => CLK,
                 CLR => CLR,
                 SHE => SHE,
                 DIR => DIR,
                 WE3 => WE3,
                 RD1 => RD1,
                 RD2 => RD2);
    -- ALU unit
    alu : ALUNbits generic map (
                                   N => N)
    port map (
                 A => RD1,
                 B => RD2,
                 sel => sel,
                 op => op,
                 S => res,
                 flg_z => flags(0),
                 flg_n => flags(1),
                 flg_c => flags(2),
                 flg_ov => flags(3));
   -- CLK
   clkp : process begin
       CLK <= '0';
       wait for P/2;
       CLK <= '1';
       wait for P/2;
   end process;
   -- Testbench
   test : process begin
       CLR <= '1';
       DIR <= '0';
       SHE <= '0';
       WE3 <= '0';
       WD3 <= (others => '0');
       pc <= (others => '0');
       WD3 <= (others => '0');
       shamt <= (others => '0');
       sel <= (others => '0');
       op <= (others => '0');
       wait until rising_edge(CLK);
       CLR <= '0';
       wait until rising_edge(CLK);
       wait;
   end process;
end RTL;
