library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity controller is
    Port ( OP,FUNC : in STD_LOGIC_VECTOR (1 downto 0);
           RdSel,WE,ImmSel,AddSubSel,PrintEn : out STD_LOGIC);
end controller;

architecture Behavioral of controller is

begin

RdSel <= OP(1) and not(OP(0));
WE <= not(OP(1) and OP(0));
ImmSel <= not(OP(1) and not(OP(0)));
AddSubSel <= OP(0);
PrintEn <= OP(1) and OP(0) and not(FUNC(1) and FUNC(0));

end Behavioral;