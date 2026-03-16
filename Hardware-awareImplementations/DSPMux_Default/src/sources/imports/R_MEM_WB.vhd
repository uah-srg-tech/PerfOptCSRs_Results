library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library work;
use work.constants.all;
use work.interfaces.all;

entity R_MEM_WB is
    Port (
        I_clock : in STD_LOGIC;
        I_reset : in std_logic;
        inputs  : in I_RMEMWB;
        outputs : out O_RMEMWB
    );
end R_MEM_WB;

architecture Behavioral of R_MEM_WB is
    signal inst         : std_logic_vector(XLEN-1 downto 0);
    signal needsCSROROp : std_logic_vector(XLEN-1 downto 0);
    signal needsCSRANDOp: std_logic_vector(XLEN-1 downto 0);
    signal validOpCSRR  : std_logic_vector(XLEN/2-1 downto 0);
    signal validOpCSRW  : std_logic;
    signal parregEnable : std_logic_vector(XLEN-1 downto 0);
    signal regWrite     : std_logic_vector(XLEN/2-1 downto 0);
    signal regCSR       : std_logic_vector(11 downto 0);
    signal data         : std_logic_vector(XLEN-1 downto 0);
    signal regS1        : std_logic_vector(log2XLEN-1 downto 0);
    signal regS2        : std_logic_vector(log2XLEN-1 downto 0);
    signal regD         : std_logic_vector(log2XLEN-1 downto 0);

    attribute extract_reset : string;
    attribute extract_reset of data: signal is "false";

begin
    process (I_clock)
    begin
        if rising_edge(I_clock) then
            inst        <= inputs.REXMEM_outputs.inst;
            needsCSROROp  <= (others=>inputs.REXMEM_outputs.needsCSROROp);
            needsCSRANDOp <= (others=>inputs.REXMEM_outputs.needsCSRANDOp);
            validOpCSRR <= (others=>inputs.REXMEM_outputs.validOpCSRR);
            validOpCSRW <= inputs.REXMEM_outputs.validOpCSRW;
            parregEnable<= inputs.REXMEM_outputs.parregEnable;
            regCSR      <= inputs.REXMEM_outputs.regCSR;
            regS2       <= inputs.REXMEM_outputs.regS2;
            regD        <= inputs.REXMEM_outputs.regD;
        end if;
    end process;
    
    process(I_clock)
    begin
        if rising_edge(I_clock) then
            for j in XLEN-1 downto 0 loop
                regWrite(j/2) <= inputs.REXMEM_outputs.regWrite(j/4);
                data(j)     <= not (inputs.REXMEM_outputs.data(j) and inputs.REXMEM_outputs.regWrite(j/4));
            end loop;
        end if;
    end process;

    outputs.inst        <= inst;
    outputs.needsCSROROp  <= needsCSROROp;
    outputs.needsCSRANDOp <= needsCSRANDOp;
    outputs.validOpCSRR <= validOpCSRR;
    outputs.validOpCSRW <= validOpCSRW;
    outputs.parregEnable<= parregEnable;
    outputs.regWrite    <= regWrite;
    outputs.parregEnable<= parregEnable;
    outputs.regCSR      <= regCSR;
    outputs.data        <= data;
    outputs.regS1       <= regS1;
    outputs.regS2       <= regS2;
    outputs.regD        <= regD;

end Behavioral;