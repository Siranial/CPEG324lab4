library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity bit8mux2to1 is
    Port ( A,B : in STD_LOGIC_VECTOR (7 downto 0);
           S : in STD_LOGIC;
           Y : out STD_LOGIC_vector (7 downto 0));
end bit8mux2to1;

architecture Behavioral of bit8mux2to1 is

begin
    with S select Y <=
        A when '0',
        B when others;

end Behavioral;