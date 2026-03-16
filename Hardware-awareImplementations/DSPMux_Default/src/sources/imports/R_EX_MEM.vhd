library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library work;
use work.constants.all;
use work.interfaces.all;

entity R_EX_MEM is
    Port (
        I_clock : in STD_LOGIC;
        I_reset : in std_logic;
        inputs  : in I_REXMEM;
        outputs : out O_REXMEM
    );
end R_EX_MEM;

architecture Behavioral of R_EX_MEM is
    signal inst         : std_logic_vector(XLEN-1 downto 0);
    signal needsCSROROp : std_logic;
    signal needsCSRANDOp: std_logic;
    signal validOpCSRR  : std_logic;
    signal validOpCSRW  : std_logic;
    signal parregEnable : std_logic_vector(XLEN-1 downto 0);
    signal regWrite     : std_logic_vector(XLEN/4-1 downto 0);
    signal regCSR : std_logic_vector(11 downto 0);
    signal data   : std_logic_vector(XLEN-1 downto 0);
    signal regS1  : std_logic_vector(log2XLEN-1 downto 0);
    signal regS2  : std_logic_vector(log2XLEN-1 downto 0);
    signal regD   : std_logic_vector(log2XLEN-1 downto 0);

begin
    process (I_clock)
    begin
        if rising_edge(I_clock) then
            inst        <= inputs.RIDEX_outputs.inst;
            needsCSROROp  <= inputs.RIDEX_outputs.needsCSROROp;
            needsCSRANDOp <= inputs.RIDEX_outputs.needsCSRANDOp;
            validOpCSRR <= inputs.RIDEX_outputs.validOpCSRR;
            validOpCSRW <= inputs.RIDEX_outputs.validOpCSRW;
            parregEnable<= (others=>inputs.RIDEX_outputs.parregEnable);
            regWrite    <= (others=>inputs.RIDEX_outputs.regWrite);
            regCSR      <= inputs.RIDEX_outputs.regCSR;
            data        <= inputs.RIDEX_outputs.data;
            regS1       <= inputs.RIDEX_outputs.regS1;
            regS2       <= inputs.RIDEX_outputs.regS2;
            regD        <= inputs.RIDEX_outputs.regD;
        end if;
    end process;

    outputs.inst        <= inst;
    outputs.needsCSROROp  <= needsCSROROp;
    outputs.needsCSRANDOp <= needsCSRANDOp;
    outputs.validOpCSRR <= validOpCSRR;
    outputs.validOpCSRW <= validOpCSRW;
    outputs.parregEnable<= parregEnable;
    outputs.regWrite    <= regWrite;
    outputs.regCSR      <= regCSR;
    outputs.data        <= data;
    outputs.regS1       <= regS1;
    outputs.regS2       <= regS2;
    outputs.regD        <= regD;

end Behavioral;