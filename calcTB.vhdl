library ieee;
use ieee.std_logic_1164.all;

entity calc_TB is
end calc_TB;

architecture behav of calc_TB is

	component calc is
		Port ( INSTR : in STD_LOGIC_VECTOR (7 downto 0);
			   clk, reset : in STD_LOGIC;
			   PRINT : out STD_LOGIC_vector (7 downto 0));
	end component;

-- Input signals
signal INSTR: std_logic_vector (7 downto 0);
signal clk,reset: std_logic;
-- Output signals
signal PRINT: std_logic_vector (7 downto 0);

begin
-- Component Instantiation
calculator : calc port map(INSTR => INSTR, clk => clk, reset => reset, PRINT => PRINT);

--  Test cases for ALU
process
type pattern_type is record
--  The inputs of the ALU.
		INSTR: std_logic_vector (7 downto 0);
		clk,reset: std_logic;
--  The expected outputs of the ALU.
		PRINT: std_logic_vector (7 downto 0);

end record;
--  The patterns to apply.
type pattern_array is array (natural range <>) of pattern_type;
constant patterns : pattern_array :=
--  INSTR   ,clk,reset, PRINT
(("00000001",'0','0',"00000000"),
("00000001",'1','0',"00000000"),
("10000001",'0','0',"00000000"),
("10000001",'1','0',"00000001")
);
begin
--  Check each pattern.
	for n in patterns'range loop
--  Set the inputs.
		instr <= patterns(n).instr;
		clk <= patterns(n).clk;
		reset <= patterns(n).reset;
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