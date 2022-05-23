library ieee;
use ieee.std_logic_1164.all;

entity calc_TB is
end calc_TB;

architecture behav of calc_TB is

component calc is
	Port ( INSTR : in STD_LOGIC_VECTOR (7 downto 0);
			clk : in STD_LOGIC;
			PRINT : out STD_LOGIC_vector (7 downto 0));
end component;

-- Input signals
signal INSTR: std_logic_vector (7 downto 0);
signal clk: std_logic;
-- Output signals
signal PRINT: std_logic_vector (7 downto 0);

begin
-- Component Instantiation
calculator : calc port map(INSTR => INSTR, clk => clk, PRINT => PRINT);

--  Test cases for ALU
process
type pattern_type is record
--  The inputs of the ALU.
		INSTR: std_logic_vector (7 downto 0);
		clk: std_logic;
--  The expected outputs of the ALU.
		PRINT: std_logic_vector (7 downto 0);

end record;
--  The patterns to apply.
type pattern_array is array (natural range <>) of pattern_type;
constant patterns : pattern_array :=
--  INSTR   ,clk, PRINT
(("10000001",'0',"UUUUUUUU"),
("10000001",'1',"UUUUUUUU"), -- load 1 into reg0
("11000000",'0',"UUUUUUUU"),
("11000000",'1',"00000001"), -- print reg0, result 1
("10010101",'0',"00000001"),
("10010101",'1',"UUUUUUUU"), -- load 5 into reg1
("01000110",'0',"UUUUUUUU"),
("01000110",'1',"UUUUUUUU"), -- reg0 - reg1 -> reg2, result -4
("11100000",'0',"UUUUUUUU"),
("11100000",'1',"11111100"), -- print reg2, result -4
("11100000",'0',"11111100"),
("11100000",'1',"11111100") -- print reg2, result -4
);
begin
--  Check each pattern.
	for n in patterns'range loop
--  Set the inputs.
		instr <= patterns(n).instr;
		clk <= patterns(n).clk;
--  Wait for the results.
		wait for 1 ns;
--  Check the outputs.
		assert print = patterns(n).print
		report "bad print value" severity error;
	end loop;
	assert false report "end of test" severity note;
--  Wait forever; this will finish the simulation.
	wait;
end process;
end behav;