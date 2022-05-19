library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity calc is
    Port ( INSTR : in STD_LOGIC_VECTOR (7 downto 0);
           clk, reset : in STD_LOGIC;
           PRINT : out STD_LOGIC_vector (7 downto 0));
end calc;

architecture Behavioral of calc is

component controller is
    Port ( OP,FUNC : in STD_LOGIC_VECTOR (1 downto 0);
            RdSel,WE,ImmSel,AddSubSel,PrintEn : out STD_LOGIC);
end component;

component bit2mux2to1 is
    Port ( A,B : in STD_LOGIC_VECTOR (1 downto 0);
           S : in STD_LOGIC;
           Y : out STD_LOGIC_vector (1 downto 0));
end component;

component bit8mux2to1 is
    Port ( A,B : in STD_LOGIC_VECTOR (7 downto 0);
           S : in STD_LOGIC;
           Y : out STD_LOGIC_vector (7 downto 0));
end component;

component regb is
    Port (  wd: in std_logic_vector (7 downto 0) := (others=>'0');
            ws: in std_logic_vector (1 downto 0) := (others=>'0');
            rs1: in std_logic_vector (1 downto 0) := (others=>'0');
            rs2: in std_logic_vector (1 downto 0) := (others=>'0');
            clk, we: in std_logic;
            rd1: out std_logic_vector (7 downto 0) := (others=>'0');
            rd2: out std_logic_vector (7 downto 0) := (others=>'0')
            );
end component;

component addSub8 is
    Port ( A,B : in STD_LOGIC_VECTOR (7 downto 0);
            S : in STD_LOGIC;
            Y : out STD_LOGIC_vector (7 downto 0));
end component;

-- Control signals
signal RdSel,WE,ImmSel,AddSubSel,PrintEn: std_logic;
signal RdIn: std_logic_vector(1 downto 0);
-- Sign extended Immediate
signal SignExtImm: std_logic_vector(7 downto 0) := (others=>'0');


-- Register Outputs and Inputs
signal RsCon,RtCon,writeData: std_logic_vector(7 downto 0);

-- Adder outputs and inputs
signal adderOut: std_logic_vector(7 downto 0);


begin
--  Component instantiation.
-- controls the datapath
contr : controller port map(
    OP => INSTR(7 downto 6), FUNC => INSTR(1 downto 0),
    RdSel => RdSel, WE => WE, ImmSel => ImmSel, AddSubSel => AddSubSel, PrintEn => PrintEn);

-- choose between rd and rs target register
rdmux : bit2mux2to1 port map(
    A => INSTR(1 downto 0), B => INSTR(5 downto 4), 
    S => RdSel, Y => RdIn);

-- choose between immediate and adder data
immux : bit8mux2to1 port map(
    A => SignExtImm, B => adderOut,
    S => ImmSel, Y => writeData);

-- decide to print data or nothing
pntmux : bit8mux2to1 port map(
    A => "UUUUUUUU", B => RsCon,
    S => PrintEn, Y => PRINT);

-- stores data in 4 8 bit registers
regbank : regb port map(
    wd => writeData, ws => RdIn, rs1 => INSTR(5 downto 4), 
    rs2 => INSTR(3 downto 2), clk => clk, 
    we => WE, rd1 => RsCon, rd2 => RtCon);

-- computation unit with adding and subtracting
adder : addSub8 port map(
    A => RsCon, B => RtCon, S => AddSubSel, Y => adderOut);

-- Sign extension of immediate
SignExtImm(3 downto 0) <= INSTR(3 downto 0);

end Behavioral;