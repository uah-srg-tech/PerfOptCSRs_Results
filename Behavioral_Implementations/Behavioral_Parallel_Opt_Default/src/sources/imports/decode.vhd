----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 31.07.2024 14:10:36
-- Design Name: 
-- Module Name: decode - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

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
    signal validOpCSRR_s: std_logic;
    signal validOpCSRW_s: std_logic;
    signal parregEnable : std_logic;
    signal regWrite     : std_logic;
    signal exception    : std_logic;
    signal excepR_flag_s: std_logic;
    signal excepW_flag_s: std_logic;

    signal data         : std_logic_vector(XLEN-1 downto 0);
    signal regCSR_s     : std_logic_vector(11 downto 0);
    signal regS1        : std_logic_vector(log2XLEN-1 downto 0);
    signal regS2        : std_logic_vector(log2XLEN-1 downto 0);
    signal regD         : std_logic_vector(log2XLEN-1 downto 0);

    signal opCode       : std_logic_vector(6 downto 0);
    signal fun3         : std_logic_vector(2 downto 0);

    signal inst_aux : std_logic_vector(XLEN-1 downto 0);

    signal hazard_stop  : std_logic;

----    attribute keep: string;
----    attribute keep of exception : signal is "true";
----    attribute keep of inst_aux  : signal is "true";
--    attribute MAX_FANOUT:integer;
--    attribute MAX_FANOUT of regCSR : signal is 15;
begin
    process(I_clock)
    begin
        if I_reset = '1' then
            inst_aux <= NOP;
--            isCSR       <= '0';
--            validOpCSRR <= '0';
--            validOpCSRW <= '0';
--            regWrite    <= '0';
--            exception   <= '0';
--        end if;
        elsif rising_edge(I_clock) then    -- Simulating the entry from the register here.
            inst_aux <= inputs.inst;
        end if;
    end process;

    outputs.inst       <= inst_aux;

    outputs.needsCSROROp  <= needsCSROROp;
    outputs.needsCSRANDOp <= needsCSRANDOp;
    outputs.validOpCSRR <= validOpCSRR_s;
    outputs.validOpCSRW <= validOpCSRW_s;
    outputs.regWrite    <= regWrite;
    outputs.exception   <= exception;
    outputs.excepR_flag <= excepR_flag_s;
    outputs.excepW_flag <= excepW_flag_s;

    outputs.parregEnable<= exception;

    outputs.data    <= data;
    outputs.regCSR  <= regCSR_s;
    outputs.regS1   <= regS1;
    outputs.regS2   <= regS2;
    outputs.regD    <= regD;

    opCode  <= inst_aux(6  downto 0);
    fun3    <= inst_aux(14 downto 12);

    process(inst_aux,opCode,fun3,regS1,regD,I_reset,hazard_stop)
--    process(inst_aux,opCode,fun3,regS1,regD,I_reset)
--    process(inst_aux,opCode,fun3,regS1,regD)
        variable regCSR       : std_logic_vector(11 downto 0);
        variable validOpCSRR  : std_logic;
        variable validOpCSRW  : std_logic;
        variable excep  : std_logic;
        variable excepR_flag  : std_logic;
        variable excepW_flag  : std_logic;
    begin
            needsCSROROp  <= '0';
            needsCSRANDOp <= '0';
            validOpCSRR := '0';
            validOpCSRW := '0';
            regWrite    <= '0';
            excep       := '0';
            excepR_flag := '0';
            excepW_flag := '0';

--            data    <= XLEN_ZERO;
            data    <= std_logic_vector(resize(signed(inst_aux(31 downto 20)), data'length));
--            regCSR  <= X"000";
            regCSR  := inst_aux(31 downto 20);
            regS1   <= inst_aux(19 downto 15);
            regS2   <= inst_aux(24 downto 20);
            regD    <= inst_aux(11 downto 7);
            
            case OPcode is
                when OP_OPIMM     => 
                    regWrite<= '1';
--                    if regD = "00000" then
--                        regWrite <= '0';
--                    end if;
--                    data    <= std_logic_vector(resize(signed(inst_aux(31 downto 20)), data'length));
--                    regS2   <= R0;
                when OP_SYSTEM  =>
--                    needsCSROp <= '1';
--                    regCSR<= inst_aux(31 downto 20);
                    case fun3 is
                        when FUNC_PRIV =>
                        when FUNC_CSRRW =>
                            validOpCSRW := '1';
                            needsCSROROp  <= '1';-- To reduce the number of inputs to the LUTs in CSRs write.
                            needsCSRANDOp <= '1';-- To reduce the number of inputs to the LUTs in CSRs write.
                            if regD /= R0 then
                                validOpCSRR := '1';
                            end if;
                        when FUNC_CSRRS =>
                            validOpCSRR := '1';
                            if regS1 /= R0 then
                                validOpCSRW := '1';
                                needsCSROROp  <= '1';
                            end if;
                        when FUNC_CSRRC =>
                            validOpCSRR := '1';
                            if regS1 /= R0 then
                                validOpCSRW := '1';
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
                            excep := '1';
                    end case;
                when others     =>
                    excep := '1';
            end case;

            if validOpCSRR = '1' then
                if regCSR(9 downto 8) <= inputs.PROCIFace_outputs.PLevel then
--                    case to_integer(unsigned(inputs.RMEMWB_outputs.regCSR)) is
                    case regCSR is
                        when    CSR_TRACECSR0  | CSR_TRACECSR1    | CSR_TRACECSR2    | CSR_TRACECSR3    |
                                CSR_TRACECSR4  | CSR_TRACECSR5    | CSR_TRACECSR6    | CSR_TRACECSR7    |
                                CSR_TRACECSR8  | CSR_TRACECSR9    | CSR_TRACECSR10   | CSR_TRACECSR11   |
                                CSR_TRACECSR12 | CSR_TRACECSR13   | CSR_TRACECSR14   | CSR_TRACECSR15   |
                                CSR_TRACECSR16 | CSR_TRACECSR17   | CSR_TRACECSR18   | CSR_TRACECSR19   |
                                CSR_TRACECSR20 | CSR_TRACECSR21   | CSR_TRACECSR22   | CSR_TRACECSR23   |
                                CSR_TRACECSR24 | CSR_TRACECSR25   | CSR_TRACECSR26   | CSR_TRACECSR27   |
                                CSR_TRACECSR28 | CSR_TRACECSR29   | CSR_TRACECSR30   | CSR_TRACECSR31   |
                                CSR_TRACECSR32 | CSR_TRACECSR33   | CSR_TRACECSR34   | CSR_TRACECSR35   |
                                CSR_TRACECSR36 | CSR_TRACECSR37   | CSR_TRACECSR38   | CSR_TRACECSR39   |
                                CSR_TRACECSR40 | CSR_TRACECSR41   | CSR_TRACECSR42   | CSR_TRACECSR43   |
                                CSR_TRACECSR44 | CSR_TRACECSR45   | CSR_TRACECSR46   | CSR_TRACECSR47   |
                                CSR_TRACECSR48 | CSR_TRACECSR49   | CSR_TRACECSR50   | CSR_TRACECSR51   |
                                CSR_TRACECSR52 | CSR_TRACECSR53   | CSR_TRACECSR54   | CSR_TRACECSR55   |
                                CSR_TRACECSR56 | CSR_TRACECSR57   | CSR_TRACECSR58   | CSR_TRACECSR59   |
                                CSR_TRACECSR60 | CSR_TRACECSR61   | CSR_TRACECSR62   | CSR_TRACECSR63   =>
                        when    CSR_TRACEMEM0  | CSR_TRACEMEM1    | CSR_TRACEMEM2    | CSR_TRACEMEM3    |
                                CSR_TRACEMEM4  | CSR_TRACEMEM5    | CSR_TRACEMEM6    | CSR_TRACEMEM7    |
                                CSR_TRACEMEM8  | CSR_TRACEMEM9    | CSR_TRACEMEM10   | CSR_TRACEMEM11   |
                                CSR_TRACEMEM12 | CSR_TRACEMEM13   | CSR_TRACEMEM14   | CSR_TRACEMEM15   |
                                CSR_TRACEMEM16 | CSR_TRACEMEM17   | CSR_TRACEMEM18   | CSR_TRACEMEM19   |
                                CSR_TRACEMEM20 | CSR_TRACEMEM21   | CSR_TRACEMEM22   | CSR_TRACEMEM23   |
                                CSR_TRACEMEM24 | CSR_TRACEMEM25   | CSR_TRACEMEM26   | CSR_TRACEMEM27   |
                                CSR_TRACEMEM28 | CSR_TRACEMEM29   | CSR_TRACEMEM30   | CSR_TRACEMEM31   |
                                CSR_TRACEMEM32 | CSR_TRACEMEM33   | CSR_TRACEMEM34   | CSR_TRACEMEM35   |
                                CSR_TRACEMEM36 | CSR_TRACEMEM37   | CSR_TRACEMEM38   | CSR_TRACEMEM39   |
                                CSR_TRACEMEM40 | CSR_TRACEMEM41   | CSR_TRACEMEM42   | CSR_TRACEMEM43   |
                                CSR_TRACEMEM44 | CSR_TRACEMEM45   | CSR_TRACEMEM46   | CSR_TRACEMEM47   |
                                CSR_TRACEMEM48 | CSR_TRACEMEM49   | CSR_TRACEMEM50   | CSR_TRACEMEM51   |
                                CSR_TRACEMEM52 | CSR_TRACEMEM53   | CSR_TRACEMEM54   | CSR_TRACEMEM55   |
                                CSR_TRACEMEM56 | CSR_TRACEMEM57   | CSR_TRACEMEM58   | CSR_TRACEMEM59   |
                                CSR_TRACEMEM60 | CSR_TRACEMEM61   | CSR_TRACEMEM62   | CSR_TRACEMEM63   =>
--                        when CSR_CYCLE => -- Only commented all User Mode counters, so the OK/NO_OK test works, since this way it launches an exception while reading, though it really could be read.
--                            if mcounteren(0) = '0' then
--                                excepR_flag := '1';
--                            end if;
--                        when CSR_CYCLEH =>
--                            if mcounteren(0) = '0' then
--                                excepR_flag := '1';
--                            end if;
--                        when CSR_INSTRET =>
--                            if mcounteren(2) = '0' then
--                                excepR_flag := '1';
--                            end if;
--                        when CSR_INSTRETH =>
--                            if mcounteren(2) = '0' then
--                                excepR_flag := '1';
--                            end if;
--                        when    CSR_HPMCOUNTER3 | CSR_HPMCOUNTER4 | CSR_HPMCOUNTER5 | CSR_HPMCOUNTER6 |
--                                CSR_HPMCOUNTER7 | CSR_HPMCOUNTER8 | CSR_HPMCOUNTER9 | CSR_HPMCOUNTER10|
--                                CSR_HPMCOUNTER11| CSR_HPMCOUNTER12| CSR_HPMCOUNTER13| CSR_HPMCOUNTER14|
--                                CSR_HPMCOUNTER15| CSR_HPMCOUNTER16| CSR_HPMCOUNTER17| CSR_HPMCOUNTER18|
--                                CSR_HPMCOUNTER19| CSR_HPMCOUNTER20| CSR_HPMCOUNTER21| CSR_HPMCOUNTER22|
--                                CSR_HPMCOUNTER23| CSR_HPMCOUNTER24| CSR_HPMCOUNTER25| CSR_HPMCOUNTER26|
--                                CSR_HPMCOUNTER27| CSR_HPMCOUNTER28| CSR_HPMCOUNTER29| CSR_HPMCOUNTER30|
--                                CSR_HPMCOUNTER31   =>
--                                    for i in 3 to HPM_NUM_COUNTERS-1 loop
----                                        if to_integer(unsigned(inputs.RMEMWB_outputs.regCSR)) - CSR_CYCLE = i then
--                                        if unsigned(inputs.RMEMWB_outputs.regCSR) - unsigned(CSR_CYCLE) = i then
--                                            if mcounteren(i)='0' then
--                                                excepR_flag := '1';
--                                            end if;
--                                        end if;
--                                    end loop;
--                       when     CSR_HPMCOUNTER3H | CSR_HPMCOUNTER4H | CSR_HPMCOUNTER5H | CSR_HPMCOUNTER6H   |
--                                CSR_HPMCOUNTER7H | CSR_HPMCOUNTER8H | CSR_HPMCOUNTER9H | CSR_HPMCOUNTER10H  |
--                                CSR_HPMCOUNTER11H| CSR_HPMCOUNTER12H| CSR_HPMCOUNTER13H| CSR_HPMCOUNTER14H  |
--                                CSR_HPMCOUNTER15H| CSR_HPMCOUNTER16H| CSR_HPMCOUNTER17H| CSR_HPMCOUNTER18H  |
--                                CSR_HPMCOUNTER19H| CSR_HPMCOUNTER20H| CSR_HPMCOUNTER21H| CSR_HPMCOUNTER22H  |
--                                CSR_HPMCOUNTER23H| CSR_HPMCOUNTER24H| CSR_HPMCOUNTER25H| CSR_HPMCOUNTER26H  |
--                                CSR_HPMCOUNTER27H| CSR_HPMCOUNTER28H| CSR_HPMCOUNTER29H| CSR_HPMCOUNTER30H  |
--                                CSR_HPMCOUNTER31H  =>
--                                    for i in 3 to HPM_NUM_COUNTERS-1 loop
----                                        if to_integer(unsigned(inputs.RMEMWB_outputs.regCSR)) - CSR_CYCLEH = i then
--                                        if unsigned(inputs.RMEMWB_outputs.regCSR) - unsigned(CSR_CYCLEH) = i then
--                                            if mcounteren(i)='0' then
--                                                excepR_flag := '1';
--                                            end if;
--                                        end if;
--                                    end loop;
                        when CSR_MSTATUS =>
                        when CSR_MEPC   =>
                        when CSR_MTVEC  =>
                        when CSR_MCAUSE =>
                        when CSR_MTVAL  =>
--                        when CSR_MISA   => -- Only commented so the OK/NO_OK test works, since this way it launches an exception while reading, though it really could be read.
                        when CSR_MIP    =>
                        when CSR_MIE    =>
--                        when CSR_MVENDORID  => -- Only commented so the OK/NO_OK test works, since this way it launches an exception while reading, though it really could be read.
--                        when CSR_MIMPID     => -- Only commented so the OK/NO_OK test works, since this way it launches an exception while reading, though it really could be read.
--                        when CSR_MHARTID    => -- Only commented so the OK/NO_OK test works, since this way it launches an exception while reading, though it really could be read.
                        when CSR_MCYCLE     =>
                        when CSR_MCYCLEH    =>
                        when CSR_MINSTRET   =>
                        when CSR_MINSTRETH  =>
                        when    CSR_MHPMCOUNTER3 | CSR_MHPMCOUNTER4 | CSR_MHPMCOUNTER5 | CSR_MHPMCOUNTER6 |
                                CSR_MHPMCOUNTER7 | CSR_MHPMCOUNTER8 | CSR_MHPMCOUNTER9 | CSR_MHPMCOUNTER10|
                                CSR_MHPMCOUNTER11| CSR_MHPMCOUNTER12| CSR_MHPMCOUNTER13| CSR_MHPMCOUNTER14|
                                CSR_MHPMCOUNTER15| CSR_MHPMCOUNTER16| CSR_MHPMCOUNTER17| CSR_MHPMCOUNTER18|
                                CSR_MHPMCOUNTER19| CSR_MHPMCOUNTER20| CSR_MHPMCOUNTER21| CSR_MHPMCOUNTER22|
                                CSR_MHPMCOUNTER23| CSR_MHPMCOUNTER24| CSR_MHPMCOUNTER25| CSR_MHPMCOUNTER26|
                                CSR_MHPMCOUNTER27| CSR_MHPMCOUNTER28| CSR_MHPMCOUNTER29| CSR_MHPMCOUNTER30|
                                CSR_MHPMCOUNTER31   =>
                       when     CSR_MHPMCOUNTER3H | CSR_MHPMCOUNTER4H | CSR_MHPMCOUNTER5H | CSR_MHPMCOUNTER6H   |
                                CSR_MHPMCOUNTER7H | CSR_MHPMCOUNTER8H | CSR_MHPMCOUNTER9H | CSR_MHPMCOUNTER10H  |
                                CSR_MHPMCOUNTER11H| CSR_MHPMCOUNTER12H| CSR_MHPMCOUNTER13H| CSR_MHPMCOUNTER14H  |
                                CSR_MHPMCOUNTER15H| CSR_MHPMCOUNTER16H| CSR_MHPMCOUNTER17H| CSR_MHPMCOUNTER18H  |
                                CSR_MHPMCOUNTER19H| CSR_MHPMCOUNTER20H| CSR_MHPMCOUNTER21H| CSR_MHPMCOUNTER22H  |
                                CSR_MHPMCOUNTER23H| CSR_MHPMCOUNTER24H| CSR_MHPMCOUNTER25H| CSR_MHPMCOUNTER26H  |
                                CSR_MHPMCOUNTER27H| CSR_MHPMCOUNTER28H| CSR_MHPMCOUNTER29H| CSR_MHPMCOUNTER30H  |
                                CSR_MHPMCOUNTER31H  =>
                        when CSR_MCOUNTINHIBIT =>
                        when CSR_MCOUNTEREN =>
                        when    CSR_MHPMEVENT3  | CSR_MHPMEVENT4    | CSR_MHPMEVENT5    | CSR_MHPMEVENT6    |
                                CSR_MHPMEVENT7  | CSR_MHPMEVENT8    | CSR_MHPMEVENT9    | CSR_MHPMEVENT10   |
                                CSR_MHPMEVENT11 | CSR_MHPMEVENT12   | CSR_MHPMEVENT13   | CSR_MHPMEVENT14   |
                                CSR_MHPMEVENT15 | CSR_MHPMEVENT16   | CSR_MHPMEVENT17   | CSR_MHPMEVENT18   |
                                CSR_MHPMEVENT19 | CSR_MHPMEVENT20   | CSR_MHPMEVENT21   | CSR_MHPMEVENT22   |
                                CSR_MHPMEVENT23 | CSR_MHPMEVENT24   | CSR_MHPMEVENT25   | CSR_MHPMEVENT26   |
                                CSR_MHPMEVENT27 | CSR_MHPMEVENT28   | CSR_MHPMEVENT29   | CSR_MHPMEVENT30   |
                                CSR_MHPMEVENT31 =>
                        when    CSR_MHPMEVENT3H  | CSR_MHPMEVENT4H    | CSR_MHPMEVENT5H    | CSR_MHPMEVENT6H    |
                                CSR_MHPMEVENT7H  | CSR_MHPMEVENT8H    | CSR_MHPMEVENT9H    | CSR_MHPMEVENT10H   |
                                CSR_MHPMEVENT11H | CSR_MHPMEVENT12H   | CSR_MHPMEVENT13H   | CSR_MHPMEVENT14H   |
                                CSR_MHPMEVENT15H | CSR_MHPMEVENT16H   | CSR_MHPMEVENT17H   | CSR_MHPMEVENT18H   |
                                CSR_MHPMEVENT19H | CSR_MHPMEVENT20H   | CSR_MHPMEVENT21H   | CSR_MHPMEVENT22H   |
                                CSR_MHPMEVENT23H | CSR_MHPMEVENT24H   | CSR_MHPMEVENT25H   | CSR_MHPMEVENT26H   |
                                CSR_MHPMEVENT27H | CSR_MHPMEVENT28H   | CSR_MHPMEVENT29H   | CSR_MHPMEVENT30H   |
                                CSR_MHPMEVENT31H =>
                        when others =>
                            excepR_flag := '1';
                    end case;
                else
                    excepR_flag := '1';
                end if;
            end if;

            -- WRITE --
            if validOpCSRW = '1' then
--            if (ro = '0') then
                if regCSR(11 downto 10) = "11" then
                    excepW_flag := '1';
                elsif regCSR(9 downto 8) <= inputs.PROCIFace_outputs.PLevel then
--                    case to_integer(unsigned(inputs.RMEMWB_outputs.regCSR)) is
                    case regCSR is
                        when    CSR_TRACECSR0  | CSR_TRACECSR1    | CSR_TRACECSR2    | CSR_TRACECSR3    |
                                CSR_TRACECSR4  | CSR_TRACECSR5    | CSR_TRACECSR6    | CSR_TRACECSR7    |
                                CSR_TRACECSR8  | CSR_TRACECSR9    | CSR_TRACECSR10   | CSR_TRACECSR11   |
                                CSR_TRACECSR12 | CSR_TRACECSR13   | CSR_TRACECSR14   | CSR_TRACECSR15   |
                                CSR_TRACECSR16 | CSR_TRACECSR17   | CSR_TRACECSR18   | CSR_TRACECSR19   |
                                CSR_TRACECSR20 | CSR_TRACECSR21   | CSR_TRACECSR22   | CSR_TRACECSR23   |
                                CSR_TRACECSR24 | CSR_TRACECSR25   | CSR_TRACECSR26   | CSR_TRACECSR27   |
                                CSR_TRACECSR28 | CSR_TRACECSR29   | CSR_TRACECSR30   | CSR_TRACECSR31   |
                                CSR_TRACECSR32 | CSR_TRACECSR33   | CSR_TRACECSR34   | CSR_TRACECSR35   |
                                CSR_TRACECSR36 | CSR_TRACECSR37   | CSR_TRACECSR38   | CSR_TRACECSR39   |
                                CSR_TRACECSR40 | CSR_TRACECSR41   | CSR_TRACECSR42   | CSR_TRACECSR43   |
                                CSR_TRACECSR44 | CSR_TRACECSR45   | CSR_TRACECSR46   | CSR_TRACECSR47   |
                                CSR_TRACECSR48 | CSR_TRACECSR49   | CSR_TRACECSR50   | CSR_TRACECSR51   |
                                CSR_TRACECSR52 | CSR_TRACECSR53   | CSR_TRACECSR54   | CSR_TRACECSR55   |
                                CSR_TRACECSR56 | CSR_TRACECSR57   | CSR_TRACECSR58   | CSR_TRACECSR59   |
                                CSR_TRACECSR60 | CSR_TRACECSR61   | CSR_TRACECSR62   | CSR_TRACECSR63   =>
                        when    CSR_TRACEMEM0  | CSR_TRACEMEM1    | CSR_TRACEMEM2    | CSR_TRACEMEM3    |
                                CSR_TRACEMEM4  | CSR_TRACEMEM5    | CSR_TRACEMEM6    | CSR_TRACEMEM7    |
                                CSR_TRACEMEM8  | CSR_TRACEMEM9    | CSR_TRACEMEM10   | CSR_TRACEMEM11   |
                                CSR_TRACEMEM12 | CSR_TRACEMEM13   | CSR_TRACEMEM14   | CSR_TRACEMEM15   |
                                CSR_TRACEMEM16 | CSR_TRACEMEM17   | CSR_TRACEMEM18   | CSR_TRACEMEM19   |
                                CSR_TRACEMEM20 | CSR_TRACEMEM21   | CSR_TRACEMEM22   | CSR_TRACEMEM23   |
                                CSR_TRACEMEM24 | CSR_TRACEMEM25   | CSR_TRACEMEM26   | CSR_TRACEMEM27   |
                                CSR_TRACEMEM28 | CSR_TRACEMEM29   | CSR_TRACEMEM30   | CSR_TRACEMEM31   |
                                CSR_TRACEMEM32 | CSR_TRACEMEM33   | CSR_TRACEMEM34   | CSR_TRACEMEM35   |
                                CSR_TRACEMEM36 | CSR_TRACEMEM37   | CSR_TRACEMEM38   | CSR_TRACEMEM39   |
                                CSR_TRACEMEM40 | CSR_TRACEMEM41   | CSR_TRACEMEM42   | CSR_TRACEMEM43   |
                                CSR_TRACEMEM44 | CSR_TRACEMEM45   | CSR_TRACEMEM46   | CSR_TRACEMEM47   |
                                CSR_TRACEMEM48 | CSR_TRACEMEM49   | CSR_TRACEMEM50   | CSR_TRACEMEM51   |
                                CSR_TRACEMEM52 | CSR_TRACEMEM53   | CSR_TRACEMEM54   | CSR_TRACEMEM55   |
                                CSR_TRACEMEM56 | CSR_TRACEMEM57   | CSR_TRACEMEM58   | CSR_TRACEMEM59   |
                                CSR_TRACEMEM60 | CSR_TRACEMEM61   | CSR_TRACEMEM62   | CSR_TRACEMEM63   =>
                        when CSR_MSTATUS    =>
                        when CSR_MEPC       =>
                        when CSR_MTVEC      =>
                        when CSR_MCAUSE     =>
                        when CSR_MTVAL      =>
--                        when CSR_MISA       => -- Commented as we don't support changes in the ISA at runtime.
                        when CSR_MIP        =>
                        when CSR_MIE        =>
                        when CSR_MCYCLE     =>
                        when CSR_MCYCLEH    =>
                        when CSR_MINSTRET   =>
                        when CSR_MINSTRETH  =>
                        when    CSR_MHPMCOUNTER3 | CSR_MHPMCOUNTER4 | CSR_MHPMCOUNTER5 | CSR_MHPMCOUNTER6 |
                                CSR_MHPMCOUNTER7 | CSR_MHPMCOUNTER8 | CSR_MHPMCOUNTER9 | CSR_MHPMCOUNTER10|
                                CSR_MHPMCOUNTER11| CSR_MHPMCOUNTER12| CSR_MHPMCOUNTER13| CSR_MHPMCOUNTER14|
                                CSR_MHPMCOUNTER15| CSR_MHPMCOUNTER16| CSR_MHPMCOUNTER17| CSR_MHPMCOUNTER18|
                                CSR_MHPMCOUNTER19| CSR_MHPMCOUNTER20| CSR_MHPMCOUNTER21| CSR_MHPMCOUNTER22|
                                CSR_MHPMCOUNTER23| CSR_MHPMCOUNTER24| CSR_MHPMCOUNTER25| CSR_MHPMCOUNTER26|
                                CSR_MHPMCOUNTER27| CSR_MHPMCOUNTER28| CSR_MHPMCOUNTER29| CSR_MHPMCOUNTER30|
                                CSR_MHPMCOUNTER31   =>
                       when     CSR_MHPMCOUNTER3H | CSR_MHPMCOUNTER4H | CSR_MHPMCOUNTER5H | CSR_MHPMCOUNTER6H   |
                                CSR_MHPMCOUNTER7H | CSR_MHPMCOUNTER8H | CSR_MHPMCOUNTER9H | CSR_MHPMCOUNTER10H  |
                                CSR_MHPMCOUNTER11H| CSR_MHPMCOUNTER12H| CSR_MHPMCOUNTER13H| CSR_MHPMCOUNTER14H  |
                                CSR_MHPMCOUNTER15H| CSR_MHPMCOUNTER16H| CSR_MHPMCOUNTER17H| CSR_MHPMCOUNTER18H  |
                                CSR_MHPMCOUNTER19H| CSR_MHPMCOUNTER20H| CSR_MHPMCOUNTER21H| CSR_MHPMCOUNTER22H  |
                                CSR_MHPMCOUNTER23H| CSR_MHPMCOUNTER24H| CSR_MHPMCOUNTER25H| CSR_MHPMCOUNTER26H  |
                                CSR_MHPMCOUNTER27H| CSR_MHPMCOUNTER28H| CSR_MHPMCOUNTER29H| CSR_MHPMCOUNTER30H  |
                                CSR_MHPMCOUNTER31H  =>
                        when CSR_MCOUNTINHIBIT =>
                        when CSR_MCOUNTEREN    =>
                        when    CSR_MHPMEVENT3  | CSR_MHPMEVENT4    | CSR_MHPMEVENT5    | CSR_MHPMEVENT6    |
                                CSR_MHPMEVENT7  | CSR_MHPMEVENT8    | CSR_MHPMEVENT9    | CSR_MHPMEVENT10   |
                                CSR_MHPMEVENT11 | CSR_MHPMEVENT12   | CSR_MHPMEVENT13   | CSR_MHPMEVENT14   |
                                CSR_MHPMEVENT15 | CSR_MHPMEVENT16   | CSR_MHPMEVENT17   | CSR_MHPMEVENT18   |
                                CSR_MHPMEVENT19 | CSR_MHPMEVENT20   | CSR_MHPMEVENT21   | CSR_MHPMEVENT22   |
                                CSR_MHPMEVENT23 | CSR_MHPMEVENT24   | CSR_MHPMEVENT25   | CSR_MHPMEVENT26   |
                                CSR_MHPMEVENT27 | CSR_MHPMEVENT28   | CSR_MHPMEVENT29   | CSR_MHPMEVENT30   |
                                CSR_MHPMEVENT31 =>
                        when    CSR_MHPMEVENT0H                         | CSR_MHPMEVENT2H    | CSR_MHPMEVENT3H    |
                                CSR_MHPMEVENT4H    | CSR_MHPMEVENT5H    | CSR_MHPMEVENT6H    | CSR_MHPMEVENT7H    |
                                CSR_MHPMEVENT8H    | CSR_MHPMEVENT9H    | CSR_MHPMEVENT10H   | CSR_MHPMEVENT11H   |
                                CSR_MHPMEVENT12H   | CSR_MHPMEVENT13H   | CSR_MHPMEVENT14H   | CSR_MHPMEVENT15H   |
                                CSR_MHPMEVENT16H   | CSR_MHPMEVENT17H   | CSR_MHPMEVENT18H   | CSR_MHPMEVENT19H   |
                                CSR_MHPMEVENT20H   | CSR_MHPMEVENT21H   | CSR_MHPMEVENT22H   | CSR_MHPMEVENT23H   |
                                CSR_MHPMEVENT24H   | CSR_MHPMEVENT25H   | CSR_MHPMEVENT26H   | CSR_MHPMEVENT27H   |
                                CSR_MHPMEVENT28H   | CSR_MHPMEVENT29H   | CSR_MHPMEVENT30H   | CSR_MHPMEVENT31H  =>
                        when others =>
                            excepW_flag := '1';
                    end case;
                else
                    excepW_flag := '1';
                end if;
            end if;

            regCSR_s<=regCSR;

            validOpCSRR_s   <=validOpCSRR;
            validOpCSRW_s   <=validOpCSRW;
            exception       <=excep;
--            exception       <=excep or excepR_flag or excepR_flag;
            excepR_flag_s   <=excepR_flag;
            excepW_flag_s   <=excepW_flag;
--            case hazard_stop is
--                when '0' =>
--    --                isCSR       <= '0';
--    --                validOpCSRR <= '0';
--    --                validOpCSRW <= '0';
--    --                regWrite    <= '0';
--    --                exception   <= '0';
--                when '1' =>
--                    isCSR       <= '0';
--                    validOpCSRR <= '0';
--                    validOpCSRW <= '0';
--                    regWrite    <= '0';
--                    exception   <= '0';
--                when others =>
--                    exception <= '1';
--            end case;
--            if I_reset = '1' then
----            inst_aux <= NOP;
--                needsCSROROp  <= '0';
--                needsCSRANDOp <= '0';
--                validOpCSRR <= '0';
--                validOpCSRW <= '0';
--                regWrite    <= '0';
--                exception   <= '0';
--            end if;
    end process;


--    HU:process(opCode)
--    begin
--        case opCode is
--            when OP_SYSTEM =>
----                if (I_fun3 = FUNC_CSRRW and I_regS1 /= R0 and (I_id_ex_regD = I_regS1 or I_ex_mem_regD = I_regS1 or I_mem_wb_regD = I_regS1)) then
--                if (regS1 /= R0 and (inputs.RIDEX_outputs.regD = regS1 or inputs.REXMEM_outputs.regD = regS1 or inputs.RMEMWB_outputs.regD = regS1)) or 
--                    (inputs.RIDEX_outputs.regCSR = regCSR or inputs.REXMEM_outputs.regCSR = regCSR or inputs.RMEMWB_outputs.regCSR = regCSR) then
--                    hazard_stop <= '1'; 
--                end if;
--            when others =>
--                hazard_stop <= '0';
--        end case;
--    end process;

--    hazard_mux:process(hazard_stop)
--    begin
--        case hazard_stop is
--            when '0' =>
----                isCSR       <= '0';
----                validOpCSRR <= '0';
----                validOpCSRW <= '0';
----                regWrite    <= '0';
----                exception   <= '0';
--            when '1' =>
--                isCSR       <= '0';
--                validOpCSRR <= '0';
--                validOpCSRW <= '0';
--                regWrite    <= '0';
--                exception   <= '0';
--            when others =>
--                exception <= '1';
--        end case;
--    end process;

end Behavioral;
