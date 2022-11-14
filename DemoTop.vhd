library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Demo's main entity with port mapping, memory and RV32I core instance.
--
-- Generic parameters:
--      N - word size 
--      LOG2N - log2(N)
--      M - register file organization (2^M * N)
--      ROM_ADDRS - ROM address space
--      K - RAM address space (2^K bytes)
entity DemoTop is
    generic(
               N : integer := 32;
               LOG2N : integer := 5;
               M : integer := 5; -- 
               ROM_ADDRS : integer := 32;
               K : integer := 8;
               CLK_DIV: integer := 12);
    port(
    CLK_BOARD, CLR : in std_logic;
    BTN : in std_logic_vector (4 downto 0);
    AN: out std_logic_vector(3 downto 0);
    CX: out std_logic_vector(6 downto 0);
    LED: out std_logic_vector(15 downto 0));
end DemoTop;

architecture Behavioral of DemoTop is
    -- RV32I core
    component RISCV is
        generic(
                   N : integer := 32;
                   LOG2N : integer := 5;
                   M : integer := 5); 
        port(
        CLK, CLR : in std_logic;
        ramRD, instr : in std_logic_vector(N - 1 downto 0);
        ramWD, aluResult  : out std_logic_vector(N - 1 downto 0);
        pcout : out std_logic_vector(N - 1 downto 0);
        funct3 : out std_logic_vector(2 downto 0);
        ramWE : out std_logic;
        debug: out std_logic_vector(N - 1 downto 0));
    end component;
    -- RAM
    component RAM is       
        generic (
                    N : integer := 32;
                    K : integer := 10;
                    M : integer := 32);
        port (
                 A : in STD_LOGIC_VECTOR (M - 1 downto 0);
                 WD : in STD_LOGIC_VECTOR (N - 1 downto 0);
        WE, CLK : in STD_LOGIC;
        fun : in std_logic_vector(2 downto 0);
        RD : out STD_LOGIC_VECTOR (N - 1 downto 0));
    end component;
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
    -- Four 7-segment display driver
    component SegmentDisplayDriver is
        generic(
                   DIV_CLK : integer := CLK_DIV);
    port(
        CLK, CLR, WE : in std_logic;
        WD : in std_logic_vector(31 downto 0);
        AN : out std_logic_vector(3 downto 0);
        CX : out std_logic_vector(6 downto 0));
    end component;
    -- BCD
    component BCD is
        generic(N: integer := 2);
        port(
        CLK, CLR : in std_logic;
        Q : out std_logic_vector(N - 1 downto 0));
    end component;
    -- Button debouncer
    component debouncer is
        Generic ( DEBNC_CLOCKS : INTEGER range 2 to (INTEGER'high) := 2**CLK_DIV;
                  PORT_WIDTH : INTEGER range 1 to (INTEGER'high) := 5);
        Port ( SIGNAL_I : in  STD_LOGIC_VECTOR ((PORT_WIDTH - 1) downto 0);
               CLK_I : in  STD_LOGIC;
               SIGNAL_O : out  STD_LOGIC_VECTOR ((PORT_WIDTH - 1) downto 0));
    end component;
    -- Clock Wizard Vergilog module
    -- component clk_wiz_0 is 
    -- port (clk_out1: out std_logic;
    --     reset: in std_logic;
    --     clk_in1: in std_logic);
    -- end component;
--          == Signals == 
--      > PC
    signal pc: std_logic_vector(N - 1 downto 0);
    signal instr: std_logic_vector(N - 1 downto 0);
--      > RAM
    signal ramRD : std_logic_vector(N - 1 downto 0);
--      > Core
    signal funct3: std_logic_vector(2 downto 0);
    signal addressBus: std_logic_vector(N - 1 downto 0);
--      > Display
    signal dispWD: std_logic_vector(3 downto 0);
--      > Button
    signal buttonRD: std_logic_vector(4 downto 0);
    constant zeroPad : std_logic_vector(26 downto 0) := (others => '0');
--      > IO buses
    signal writeBus, readBus: std_logic_vector(N - 1 downto 0);
    signal controlWE: std_logic;
    signal controlBus : std_logic_vector(1 downto 0);

-- > DEBUG
    signal regDebug : std_logic_vector(N - 1 downto 0);
-- > Clock Wiz. 
    signal CLK : std_logic;
begin
    CLK <= CLK_BOARD;
    -- CK's instance
    -- cw0: clk_wiz_0 port map( 
    --     clk_out1 => CLK,
    --     reset => CLR,
    --     clk_in1 => CLK_BOARD);
    -- RAM (mapped to address 0x00000000 - 0x000000ff)
    ram1: RAM generic map (
        N => N,
        K => K,
        M => ROM_ADDRS)
    port map (
        A => addressBus,
        WD => writeBus,
        WE => controlBus(0),
        CLK => CLK,
        fun => funct3,
        RD => ramRD);

    -- Instruction memory (ROM)
    rom: InstrMem port map (
        A => pc,
        RD => instr);

    -- RV32I core
    riscv1: RISCV generic map(
        N => N,
        LOG2N => LOG2N,
        M => M)
    port map(
        CLK => CLK,
        CLR => CLR,
        ramRD => readBus,
        instr => instr,
        ramWD => writeBus,
        aluResult => addressBus,
        pcout => pc,
        funct3 => funct3,
        ramWE => controlWE,
        debug => regDebug);

    -- Debouncer (mapped to address 0x80000000)
    dbnc: Debouncer port map(
        CLK_I => CLK,
        SIGNAL_I => BTN,
        SIGNAL_O => buttonRD);

    -- Display driver instance (mapped to address 0x40000000)
    dispdr: SegmentDisplayDriver port map(
        CLK => CLK,
        CLR => CLR,
        WE => controlBus(1),
        WD => writeBus,
        AN => AN,
        CX => CX);

    -- RD mux
    rdmux: with addressBus(31) select
        readBus <= ramRD when '0',
                   (zeroPad & buttonRD) when others;

    -- WD signals
    wdmux: with addressBus(30) select
        controlBus <= "0" & controlWE when '0',
                      controlWE & "0" when others;
    
    -- LED reg debug
    LED <= regDebug(15 downto 0);
end Behavioral;
