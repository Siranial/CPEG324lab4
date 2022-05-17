library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity bit2mux2to1 is
    Port ( A,B : in STD_LOGIC_VECTOR (1 downto 0);
           S : in STD_LOGIC;
           Y : out STD_LOGIC_vector (1 downto 0));
end bit2mux2to1;

architecture Behavioral of bit2mux2to1 is

begin
    with S select Y <=
        A when '0',
        B when others;

end Behavioral;