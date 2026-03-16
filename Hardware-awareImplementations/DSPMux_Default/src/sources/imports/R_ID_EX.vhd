library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library work;
use work.constants.all;
use work.interfaces.all;

entity R_ID_EX is
    Port (
        I_clock : in STD_LOGIC;
        I_reset : in std_logic;
        inputs  : in I_RIDEX;
        outputs : out O_RIDEX
    );
end R_ID_EX;

architecture Behavioral of R_ID_EX is
    signal inst         : std_logic_vector(XLEN-1 downto 0);
    signal needsCSROROp   : std_logic;
    signal needsCSRANDOp  : std_logic;
    signal validOpCSRR  : std_logic;
    signal validOpCSRW  : std_logic;
    signal parregEnable : std_logic;
    signal regWrite     : std_logic;
    signal data         : std_logic_vector(XLEN-1 downto 0);
    signal regCSR       : std_logic_vector(11 downto 0);
    signal regS1        : std_logic_vector(log2XLEN-1 downto 0);
    signal regS2        : std_logic_vector(log2XLEN-1 downto 0);
    signal regD         : std_logic_vector(log2XLEN-1 downto 0);

begin
    process (I_clock, I_reset)
    begin
        if rising_edge(I_clock) then
            inst        <= inputs.DEC_outputs.inst;
            needsCSROROp  <= inputs.DEC_outputs.needsCSROROp;
            needsCSRANDOp <= inputs.DEC_outputs.needsCSRANDOp;
            validOpCSRR <= inputs.DEC_outputs.validOpCSRR;
            validOpCSRW <= inputs.DEC_outputs.validOpCSRW;
            parregEnable<= inputs.DEC_outputs.parregEnable;
            regWrite    <= inputs.DEC_outputs.regWrite;
            data        <= inputs.DEC_outputs.data;
            regCSR      <= inputs.DEC_outputs.regCSR;
            regS1       <= inputs.DEC_outputs.regS1;
            regS2       <= inputs.DEC_outputs.regS2;
            regD        <= inputs.DEC_outputs.regD;
        end if;
    end process;

    outputs.inst        <= inst;
    outputs.needsCSROROp  <= needsCSROROp;
    outputs.needsCSRANDOp <= needsCSRANDOp;
    outputs.validOpCSRR <= validOpCSRR;
    outputs.validOpCSRW <= validOpCSRW;
    outputs.parregEnable<= parregEnable;
    outputs.regWrite    <= regWrite;
    outputs.data        <= data;
    outputs.regCSR      <= regCSR;
    outputs.regS1       <= regS1;
    outputs.regS2       <= regS2;
    outputs.regD        <= regD;

end Behavioral;
