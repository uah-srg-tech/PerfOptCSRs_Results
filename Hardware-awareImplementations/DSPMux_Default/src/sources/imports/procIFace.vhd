library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library work;
use work.constants.all;
use work.interfaces.all;

entity procIFace is
    Port(
        I_clock : in STD_LOGIC;
        inputs:     in  I_PROCIF;
        outputs:    out O_PROCIF
    );
end procIFace;

architecture Behavioral of procIFace is
    signal parregEnable: std_logic;
    signal special: special_array := (others=>XLEN_ZERO);

begin

    process (I_clock)
    begin
        if rising_edge(I_clock) then
            for i in outputs.special'range loop
                special(i)<=inputs.CSRs_outputs.special(i);
            end loop;
        end if;
    end process;

    outputs.special<=special;
    
end Behavioral;
