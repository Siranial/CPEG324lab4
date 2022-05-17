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
            RdSel,WE,Add1Sel,AddSubSel : out STD_LOGIC);
end component;

component bit8mux2to1 is
    Port ( A,B : in STD_LOGIC_VECTOR (7 downto 0);
           S : in STD_LOGIC;
           Y : out STD_LOGIC_vector (7 downto 0));
end component;

component bit2mux2to1 is
    Port ( A,B : in STD_LOGIC_VECTOR (1 downto 0);
           S : in STD_LOGIC;
           Y : out STD_LOGIC_vector (1 downto 0));
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

signal RsOut,RtOut : std_logic_vector (7 downto 0) := (others=>'0');
signal RdSel,WE,Add1Sel,AddSubSel : std_logic;
signal WS : std_logic_vector (1 downto 0) := (others=>'0');
signal AddIn1,AddOut : std_logic_vector (7 downto 0) := (others=>'0');

begin
--  Component instantiation.
-- Control Path Logic
contr: controller port map(
    OP => INSTR(7 downto 6), FUNC => INSTR(1 downto 0), 
    RdSel => RdSel, WE => WE, Add1Sel => Add1Sel, 
    AddSubSel => AddSubSel);
RDMux: bit2mux2to1 port map(A => INSTR(1 downto 0), B => INSTR(5 downto 4)
                            , S => RdSel, Y => WS);
Add1Mux: bit8mux2to1 port map(A => RsOut, B => "00000000", S => Add1Sel, Y => AddIn1);

-- Large Components
regbank: regb port map( wd => AddOut, ws => WS, rs1 => INSTR(5 downto 4), rs2 => INSTR(3 downto 2),
                        clk => clk, we => WE, rd1 => RsOut, rd2 => RtOut);
addsub: addSub8 port map(   A => AddIn1, B => RtOut, S => AddSubSel, Y => AddOut);

PRINT <= RsOut;

end Behavioral;