library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

library work;
use work.constants.all;
use work.interfaces.all;

entity decode is
    Port (
        I_clock : in STD_LOGIC;
        I_reset : in std_logic;
        inputs  : in I_DEC;
        outputs : out O_DEC
    );
end decode;

architecture Behavioral of decode is
    signal needsCSROROp   : std_logic;
    signal needsCSRANDOp   : std_logic;
    signal validOpCSRR  : std_logic;
    signal validOpCSRW  : std_logic;
    signal parregEnable : std_logic;
    signal regWrite     : std_logic;
    signal exception    : std_logic;

    signal data         : std_logic_vector(XLEN-1 downto 0);
    signal regCSR       : std_logic_vector(11 downto 0);
    signal regS1        : std_logic_vector(log2XLEN-1 downto 0);
    signal regS2        : std_logic_vector(log2XLEN-1 downto 0);
    signal regD         : std_logic_vector(log2XLEN-1 downto 0);

    signal opCode       : std_logic_vector(6 downto 0);
    signal fun3         : std_logic_vector(2 downto 0);

    signal inst_aux : std_logic_vector(XLEN-1 downto 0);

    signal hazard_stop  : std_logic;

begin
    process(I_clock)
    begin
        if rising_edge(I_clock) then    -- Simulating the entry from the register here.
            inst_aux <= inputs.inst;
        end if;
    end process;

    outputs.inst       <= inst_aux;

    outputs.needsCSROROp  <= needsCSROROp;
    outputs.needsCSRANDOp <= needsCSRANDOp;
    outputs.validOpCSRR <= validOpCSRR;
    outputs.validOpCSRW <= validOpCSRW;
    outputs.regWrite    <= regWrite;
--    outputs.exception   <= exception;

    outputs.parregEnable<= exception;

    outputs.data    <= data;
    outputs.regCSR  <= regCSR;
    outputs.regS1   <= regS1;
    outputs.regS2   <= regS2;
    outputs.regD    <= regD;

    opCode  <= inst_aux(6  downto 0);
    fun3    <= inst_aux(14 downto 12);

    process(inst_aux,opCode,fun3,regS1,regD,I_reset,hazard_stop)
    begin
            needsCSROROp  <= '0';
            needsCSRANDOp <= '0';
            validOpCSRR <= '0';
            validOpCSRW <= '0';
            regWrite    <= '0';
            exception   <= '0';

            data    <= std_logic_vector(resize(signed(inst_aux(31 downto 20)), data'length));
            regCSR  <= inst_aux(31 downto 20);
            regS1   <= inst_aux(19 downto 15);
            regS2   <= inst_aux(24 downto 20);
            regD    <= inst_aux(11 downto 7);
            
            case OPcode is
                when OP_OPIMM     => 
                    regWrite<= '1';

                when OP_SYSTEM  =>
                    case fun3 is
                        when FUNC_PRIV =>
                        when FUNC_CSRRW =>
                            validOpCSRW <= '1';
                            needsCSROROp  <= '1';-- To reduce the number of inputs to the LUTs in CSRs write.
                            needsCSRANDOp <= '1';-- To reduce the number of inputs to the LUTs in CSRs write.
                            if regD /= R0 then
                                validOpCSRR <= '1';
                            end if;
                        when FUNC_CSRRS =>
                            validOpCSRR <= '1';
                            if regS1 /= R0 then
                                validOpCSRW <= '1';
                                needsCSROROp  <= '1';
                            end if;
                        when FUNC_CSRRC =>
                            validOpCSRR <= '1';
                            if regS1 /= R0 then
                                validOpCSRW <= '1';
                                needsCSRANDOp  <= '1';
                            end if;
--                        when FUNC_CSRRWI =>
--                            validOpCSRW <= '1';
--                            data   <= std_logic_vector(resize(unsigned(inst_aux(19 downto 15)), data'length));
--                            if regD /= R0 then
--                                validOpCSRR <= '1';
--                            end if;
--                        when FUNC_CSRRSI =>
--                            validOpCSRR <= '1';
--                            data   <= std_logic_vector(resize(unsigned(inst_aux(19 downto 15)), data'length));
--                            if regS1 /= R0 then
--                                validOpCSRW <= '1';
--                            end if;
--                        when FUNC_CSRRCI =>
--                            validOpCSRR <= '1';
--                            data   <= std_logic_vector(resize(unsigned(inst_aux(19 downto 15)), data'length));
--                            if regS1 /= R0 then
--                                validOpCSRW <= '1';
--                            end if;
                        when others     =>
                            exception <= '1';
                    end case;
                when others     =>
                    exception <= '1';
            end case;
    end process;

end Behavioral;
