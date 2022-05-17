library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity controller is
    Port ( OP,FUNC : in STD_LOGIC_VECTOR (1 downto 0);
           RdSel,WE,Add1Sel,AddSubSel : out STD_LOGIC);
end controller;

architecture Behavioral of controller is

begin

RdSel <= OP(1);
WE <=   (not(OP(1)) and not(OP(0))) or (not(op(1)) and op(0)) 
        or (OP(1) and not(OP(0)) and not(FUNC(1) or FUNC(0)));
Add1Sel <= OP(1);
AddSubSel <= not(FUNC(0));

end Behavioral;