-------------------------------------------------------
--! @file
--! @brief Control status processor's registers
-------------------------------------------------------

--! Use standard libraries
library ieee;
--! Use standard unresolved logic UX01ZWLH
use ieee.std_logic_1164.all;
--! Use signed, unsigned types and arithmetic ops
use ieee.numeric_std.all;

--! Use user-defined work library
library work;
--! Use user-defined constants package
use work.constants.all;
--! Use user-defined IFace package
use work.interfaces.all;

--! @brief Entity in charge of managing the processor's control status registers.
--! @details
--! @note In case a modification of the inputs or outputs of this entity is needed, please modify its record declaration in the IFace.vhd file. In order to see a more detailed description of this entity inputs and outputs, please go to IFace.vhd file.
--! @note The value of constants like XLEN or log2XLEN can be look out in the package constants.vhd of the user-defined library work.
--! With this objective in mind, this entity fullfills 3 different functions:
--! * Allows the R/W atomic access to the CSRs. For this, the read and write happen during the same stage (WB) but on different clock edges. First, on the rising edge the CSRs are read, meanwhile on the falling edge the CSRs are written. It is also possible to set/clear specific bits from the CSRs, for which it is necessary to access the old value of the CSR at the ID stage, but this is only used for modifying its value during the EX stage, the final atomic read and write occurrs at WB. This way, after the read of the old value of the CSRs through the port data goes to the GPRs port, during the falling edge finally the CSR has its new value meanwhile at the same time the destination GPR has the old CSR value.
--! * The second function from this entity is to increment the PMU hardware performance counters. This allows the production of statistics on the performance of the processor, making possible to detect improvements.
--! * And finally, the third function of this module is to support the operation of the exceptions from the CLINT entity, receiving when an exception happens and outputting the value of certain CSRs involved during the treatment of exceptions, such as the MTVEC, STATUS or MEPC CSRs.
--!
--! Now there will be a little more in depth explanation of the specific inner workings of this entity.
--!
--! In the first place, the first functionality present in this file is checking wether any of the R/W access that are going to be done next could create an exception, in which case a flag is rised and the R/W access would not occur. This happens combinationally without a clock edge. During the operation of this module there can be the following exceptions:
--! * Read exceptions
--!  - excepR = "100" --> Prohibited access to that CSR or field inside the CSR.
--!  - excepR = "011" --> Unknown CSRs.
--!  - excepR = "001" --> Not an appropiate priviledge level.
--! * Write exceptions
--!  - excepW = "010" --> Trying to write a read-only CSR.
--!  - excepW = "011" --> Unknown CSRs.
--!  - excepW = "001" --> Not an appropiate priviledge level.
--!
--! Secondly in this file, though also combinationally in regards to clock edge, the read access is performed. This can be done this way a it is on the GPRs where the clock edge is detected and the action of reading really happens. Here, only the data is made available for the other module to use. This way there is no need to have stage bypass of data to sync the atomic R/W access, as the read always is available here and is controlled on the GPRs.
--!
--! Thirdly in this file, but still also combinationally, the value of some CSRs is outputed to the PPL so that in the case of exceptions or interruptions the PPL has the most up to date values and can act accordingly.
--!
--! Fourthly in this file, but first secuential functionality of the module, is the counting proccess of the PMU. First, the events are brought from the RMEMWB inter-stage register. As there can be exceptions produced during the WB stage by the CSRs, as we have seen in the first point of this module, and the flush mechanism is synchrounous with the rising edge clock, it is possible that the events from this register are not fully updated, so some proccessing is done. After this, the counters values are updated in case in the last clock cycle one of them was written and after this, the events are accounted for and in those cases where it is deemed appropiate, the PMU counters are incremented.
--!
--! Fifthly and also secuentially, the write access to the CSRs is performed. This only occurss when in the combinational proccess of exception detection some error was not found. Hence, here the corresponding CSRs are written, wether a single, nominal, write, or some exceptional multi CSR write.
--!
--! Finally in this file, there is the funcionality of outputing the value of some CSR so that it is used in the ID stage to calculate the set/clear value, as explained above. And also, some more needed functionality for the exceptions is found.
--!
entity CSRegs is
    port(
--! @brief Clock input (1 bit)
        I_clock:                in  std_logic;        
--! @brief Reset input (1 bit)
        I_reset:                in  std_logic;

--! @brief Component inputs (CSR_inputs)
--! @details
--! The inputs of this entity is composed of:
--! - CSR_inputs --> I_REGISTERS record
        inputs:                 in  I_CSR;
--! @brief Component outputs (regCSR_value, data, status, PLevel, excep, cause, mtvec, mepc, mip, mie)
--! @details
--! The output of this entity is composed of:
--! - regCSR_value   (XLEN bits)
--! - data   (XLEN bits)
--! - status         (XLEN bits)
--! - PLevel         (privilege_level type = 2 bits)
--! - excep          (3 bits)
--! - cause          (XLEN bits)
--! - mtvec          (XLEN bits)
--! - mepc           (XLEN bits)
--! - mip            (XLEN bits)
--! - mie            (XLEN bits)
--! - tracecsr_index (TRID bits)
--! - tracecsr_write (1 bit)
--! - tracemem_index (TRID bits)
--! - tracemem_write (1 bit)
        outputs:                out O_CSR
    );
end CSRegs;

--! @brief Architecture definition of entity CSRegs. 
architecture behavioral of CSRegs is

    -- Auxiliar signals.
----    signal opCSRmem : std_logic := '0';
--    signal opCSR    : std_logic := '0';
--    signal ro       : std_logic := '0';
--    signal wo       : std_logic := '0';
----    signal wo_mem   : std_logic := '0';
--    signal excepR   : std_logic_vector(2 downto 0) := "000";
--    signal excepW   : std_logic_vector(2 downto 0) := "000";
----    signal triggered_events_reg: hpm_triggered_events_t;
--    signal counters_written     : std_logic_vector(XLEN-1 downto 0) := XLEN_ZERO;
--    signal countersh_written     : std_logic_vector(XLEN-1 downto 0) := XLEN_ZERO;

    -- CSRs implemented:
    constant misa       : std_logic_vector(XLEN-1 downto 0) := X"40000100";
    constant mhartid    : std_logic_vector(XLEN-1 downto 0) := XLEN_ZERO;
    constant mvendorid  : std_logic_vector(XLEN-1 downto 0) := XLEN_ZERO;
    constant mimpid     : std_logic_vector(XLEN-1 downto 0) := X"00000001";
    signal mstatus      : std_logic_vector(XLEN-1 downto 0) := X"00001808";
--    signal mtvec        : std_logic_vector(XLEN-1 downto 0) := X"000002d0";
    signal mtvec        : std_logic_vector(XLEN-1 downto 0) := X"00000400";
--    signal mtvec        : std_logic_vector(XLEN-1 downto 0) := X"00000020";
    signal mtval        : std_logic_vector(XLEN-1 downto 0) := XLEN_ZERO;
    signal mcause       : std_logic_vector(XLEN-1 downto 0) := XLEN_ZERO;
    signal mepc         : std_logic_vector(XLEN-1 downto 0) := XLEN_ZERO;
    signal mip          : std_logic_vector(XLEN-1 downto 0) := X"000f00f0"; --added by angela
    signal mie          : std_logic_vector(XLEN-1 downto 0) := X"00002880"; -- We accept external and timer machine interrupts.
    signal of_signal    : std_logic_vector(XLEN-1 downto 0) := X"00000000";

--    signal PLevel       : priviledge_level;
    ------------------ CUSTOM TRACE CSRS: ------------------
    signal tracecsr     : tracecrs_t := (others => XLEN_ZERO);
    signal tracemem     : tracemem_t := (others => XLEN_ZERO);

    signal tracecsr_index : std_logic_vector(TRID-1 downto 0);
    signal tracecsr_write : std_logic;
    signal tracemem_index : std_logic_vector(TRID-1 downto 0);
    signal tracemem_write : std_logic;

    ------------------ PMU: -------------------------
    -- Counters shadows for writing.
--    signal mcycle_shadow        : std_logic_vector(XLEN downto 0)   := '0' & XLEN_ZERO;
--    signal mcycleh_shadow       : std_logic_vector(XLEN downto 0)   := '0' & XLEN_ZERO;
--    signal minstret_shadow      : std_logic_vector(XLEN downto 0)   := '0' & XLEN_ZERO;
--    signal minstreth_shadow     : std_logic_vector(XLEN downto 0)   := '0' & XLEN_ZERO;
--    signal mhpmcounters_shadow  : hpmcounters_t := (others => '0' & XLEN_ZERO);
--    signal mhpmcountersh_shadow : hpmcountersh_t := (others => '0' & XLEN_ZERO);
    signal mcycle       : std_logic_vector(XLEN downto 0)   := '0' & XLEN_ZERO;
    signal mcycleh      : std_logic_vector(XLEN downto 0)   := '0' & XLEN_ZERO;
    signal minstret     : std_logic_vector(XLEN downto 0)   := '0' & XLEN_ZERO;
    signal minstreth    : std_logic_vector(XLEN downto 0)   := '0' & XLEN_ZERO;
    signal mhpmcounters : hpmcounters_t := (others => '0' & XLEN_ZERO);
    signal mhpmcountersh: hpmcountersh_t := (others => '0' & XLEN_ZERO);

    -- Configuration CSRs
    signal mcounteren:      std_logic_vector(XLEN-1 downto 0) := X"0000000F"; -- Only accessible on user mode the first 4 counters ATM.
    signal mhpmevent:       mhpmevent_t := (std_logic_vector(to_unsigned(HPM_EVENT_CYCLE,XLEN)),
                                            std_logic_vector(to_unsigned(HPM_EVENT_UNDEF,XLEN)),
                                            std_logic_vector(to_unsigned(HPM_EVENT_INSTRET,XLEN)),
                                            std_logic_vector(to_unsigned(HPM_EVENT_EXCEPTION,XLEN)),
                                            std_logic_vector(to_unsigned(HPM_EVENT_EXT_INT,XLEN)),
                                            std_logic_vector(to_unsigned(HPM_EVENT_TIME_INT,XLEN)),
                                            std_logic_vector(to_unsigned(HPM_EVENT_BRANCH,XLEN)),
                                            std_logic_vector(to_unsigned(HPM_EVENT_BRANCH_NT,XLEN)),
                                            std_logic_vector(to_unsigned(HPM_EVENT_UNCOND_JUMP,XLEN)),
                                            std_logic_vector(to_unsigned(HPM_EVENT_HAZARD,XLEN)),
                                            std_logic_vector(to_unsigned(HPM_EVENT_MEM_ACCESS,XLEN)),
                                            std_logic_vector(to_unsigned(HPM_EVENT_LOAD,XLEN)),
                                            std_logic_vector(to_unsigned(HPM_EVENT_STORE,XLEN)),
                                            std_logic_vector(to_unsigned(HPM_EVENT_FETCH,XLEN)),
                                            -- Modify when there are more events.
                                            others => XLEN_ZERO);
    signal mhpmeventh:      mhpmeventh_t := (others => XLEN_ZERO);

--    signal mcountinhibit_shadow       : std_logic_vector(XLEN-1 downto 0) := XLEN_ZERO;
    signal mcountinhibit : std_logic_vector(XLEN-1 downto 0) := XLEN_ZERO;

    signal MINH0,MINH2,MINH7          : std_logic := '0';

--    --Atributos para que el sintetizador no te optimice las señales, para un mejor debug.
--    attribute keep : string;                        --Se declara el atributo "keep" como un tipo string


--    -- Cuidado con los keep que pueden generar bucles combinacionales!!!!

--    attribute keep of mcountinhibit_shadow: signal is "true";   --Se le añade el atributo a la señal que no se quiera optimizar, y se le da un valor de "true"
--    attribute keep of counters_written: signal is "true";   --Se le añade el atributo a la señal que no se quiera optimizar, y se le da un valor de "true"
--    attribute keep of countersh_written: signal is "true";   --Se le añade el atributo a la señal que no se quiera optimizar, y se le da un valor de "true"

--    attribute keep of mepc: signal is "true";
--    attribute keep of mstatus: signal is "true";
--    attribute keep of mtval: signal is "true";
--    attribute keep of mcause: signal is "true";
--    attribute keep of mip: signal is "true";
--    attribute keep of mie: signal is "true";
--    attribute keep of ro: signal is "true";
--    attribute keep of wo: signal is "true";
--    attribute keep of of_signal: signal is "true";

--    attribute keep of tracecsr: signal is "true";
--    attribute keep of tracecsr_index: signal is "true";
--    attribute keep of tracecsr_write: signal is "true";
--    attribute keep of tracemem: signal is "true";
--    attribute keep of tracemem_index: signal is "true";
--    attribute keep of tracemem_write: signal is "true";

--    attribute keep of MINH0: signal is "true";
--    attribute keep of MINH2: signal is "true";
--    attribute keep of MINH7: signal is "true";


begin
    -- Out-of-process signals:          PENSAR PARA METERLO DENTRO DEL PROCESS (HACERLO SINCRONO) por probar, habra mejora???
--    opCSR   <= '1' when inputs.RMEMWB_outputs.ctrl_WB_FU = WB_CSR_ATOMIC else '0';

--    ro      <= '1' when inputs.RMEMWB_outputs.regS1 = R0 else '0';
--    wo      <= '1' when inputs.RMEMWB_outputs.regD = R0 else '0';

--    MINH0 <= mhpmeventh(0)(30);
--    MINH2 <= mhpmeventh(2)(30);
--    MINH7 <= mhpmeventh(7)(30);

    csrs : process(I_clock, I_reset, inputs)
--    csrs : process(I_clock, I_reset, inputs,mstatus,mcause,mip,mepc)
--        variable PLevel : priviledge_level:="11";
        --Atributos para que el sintetizador no te optimice las señales, para un mejor debug.
        attribute keep : string;                        --Se declara el atributo "keep" como un tipo string

        -- PMU counters CSRs
--        variable mcycle       : std_logic_vector(XLEN downto 0)   := '0' & XLEN_ZERO;
--        variable mcycleh      : std_logic_vector(XLEN downto 0)   := '0' & XLEN_ZERO;
--        variable minstret     : std_logic_vector(XLEN downto 0)   := '0' & XLEN_ZERO;
--        variable minstreth    : std_logic_vector(XLEN downto 0)   := '0' & XLEN_ZERO;
--        variable mhpmcounters : hpmcounters_t := (others => '0' & XLEN_ZERO);
--        variable mhpmcountersh: hpmcountersh_t := (others => '0' & XLEN_ZERO);
--        variable of_variable  : std_logic_vector(XLEN-1 downto 0) := X"00000000";
--        variable mhpmeventh_var : mhpmeventh_t := (others => XLEN_ZERO);

        -- Configuration and auxiliar CSRs
--        variable mcountinhibit:   std_logic_vector(XLEN-1 downto 0) := X"0000000D"; -- Counters inhibited, aka, don't count.
--        variable mcountinhibit:   std_logic_vector(XLEN-1 downto 0) := XLEN_ZERO; -- Counters counting.
--        variable triggered_events_reg: hpm_triggered_events_t;

        variable excepR_flag, excepW_flag : std_logic := '0';
        variable csr_input : std_logic_vector(XLEN-1 downto 0) := XLEN_ZERO;
        variable data : std_logic_vector(XLEN-1 downto 0) := XLEN_ZERO;

    -- Cuidado con los keep que pueden generar bucles combinacionales!!!!

--        attribute keep of PLevel: variable is "true";   --Se le añade el atributo a la señal que no se quiera optimizar, y se le da un valor de "true"
--        attribute keep of mcycle: variable is "true";   --Se le añade el atributo a la señal que no se quiera optimizar, y se le da un valor de "true"
--        attribute keep of mcycleh: variable is "true";   --Se le añade el atributo a la señal que no se quiera optimizar, y se le da un valor de "true"
--        attribute keep of mhpmcounters: variable is "true";   --Se le añade el atributo a la señal que no se quiera optimizar, y se le da un valor de "true"
--        attribute keep of minstret: variable is "true";   --Se le añade el atributo a la señal que no se quiera optimizar, y se le da un valor de "true"
--        attribute keep of mcountinhibit: variable is "true";   --Se le añade el atributo a la señal que no se quiera optimizar, y se le da un valor de "true"
--        attribute keep of triggered_events_reg: variable is "true";   --Se le añade el atributo a la señal que no se quiera optimizar, y se le da un valor de "true"
        attribute keep of excepR_flag: variable is "true";   --Se le añade el atributo a la señal que no se quiera optimizar, y se le da un valor de "true"
--        attribute keep of excepW_flag: variable is "true";   --Se le añade el atributo a la señal que no se quiera optimizar, y se le da un valor de "true"
--        attribute keep of of_variable  : variable is "true";
--        attribute keep of csr_input: variable is "true";   --Se le añade el atributo a la señal que no se quiera optimizar, y se le da un valor de "true"
    begin
--        outputs.data <= XLEN_ZERO;
--        data := XLEN_ZERO;

        excepR_flag := '0';
        excepW_flag := '0';

        CSR_exception_check:
        -- READ --
--        if(opCSR = '1') then
--        if inputs.RMEMWB_outputs.validOpCSRR = '1' or inputs.RMEMWB_outputs.validOpCSRW = '1' then
            if inputs.RMEMWB_outputs.validOpCSRR = '1' then
                if inputs.RMEMWB_outputs.regCSR(9 downto 8) <= inputs.PROCIFace_outputs.PLevel then
--                    case to_integer(unsigned(inputs.RMEMWB_outputs.regCSR)) is
                    case inputs.RMEMWB_outputs.regCSR is
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
	    if inputs.RMEMWB_outputs.validOpCSRW = '1' then
--            if (ro = '0') then
                if inputs.RMEMWB_outputs.regCSR(11 downto 10) = "11" then
                    excepW_flag := '1';
                elsif inputs.RMEMWB_outputs.regCSR(9 downto 8) <= inputs.PROCIFace_outputs.PLevel then
--                    case to_integer(unsigned(inputs.RMEMWB_outputs.regCSR)) is
                    case inputs.RMEMWB_outputs.regCSR is
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
--        end if;

        CSR_read:
--        if rising_edge(I_clock) then
        if inputs.RMEMWB_outputs.validOpCSRR = '1' then
            data := XLEN_ZERO;
            if excepR_flag = '0' then
--                case to_integer(unsigned(inputs.RMEMWB_outputs.regCSR)) is
                case inputs.RMEMWB_outputs.regCSR is
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
                                for i in 0 to TRACE_CSR_NUM-1 loop
--                                    if to_integer(unsigned(inputs.RMEMWB_outputs.regCSR)) - CSR_TRACECSR0 = i then
                                    if unsigned(inputs.RMEMWB_outputs.regCSR) - unsigned(CSR_TRACECSR0) = i then
--                                        outputs.data <= tracecsr(i);
                                        data := tracecsr(i);
                                    end if;
                                end loop;

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
                                for i in 0 to TRACE_MEM_NUM-1 loop
--                                    if to_integer(unsigned(inputs.RMEMWB_outputs.regCSR)) - CSR_TRACEMEM0 = i then
                                    if unsigned(inputs.RMEMWB_outputs.regCSR) - unsigned(CSR_TRACEMEM0) = i then
--                                        outputs.data <= tracemem(i);
                                        data := tracemem(i);
                                    end if;
                                end loop;

                    when CSR_CYCLE =>
                        if mcounteren(0)='1' then
--                            outputs.data <= mcycle(XLEN-1 downto 0);
                            data := mcycle(XLEN-1 downto 0);
                        end if;

                    when CSR_CYCLEH =>
                        if mcounteren(0)='1' then
--                            outputs.data <= mcycleh(XLEN-1 downto 0);
                            data := mcycleh(XLEN-1 downto 0);
                        end if;

                    when CSR_INSTRET =>
                        if mcounteren(2)='1' then
--                            outputs.data <= minstret(XLEN-1 downto 0);
                            data := minstret(XLEN-1 downto 0);
                        end if;

                    when CSR_INSTRETH =>
                        if mcounteren(2)='1' then
--                            outputs.data <= minstreth(XLEN-1 downto 0);
                            data := minstreth(XLEN-1 downto 0);
                        end if;

                    when    CSR_HPMCOUNTER3 | CSR_HPMCOUNTER4 | CSR_HPMCOUNTER5 | CSR_HPMCOUNTER6 |
                            CSR_HPMCOUNTER7 | CSR_HPMCOUNTER8 | CSR_HPMCOUNTER9 | CSR_HPMCOUNTER10|
                            CSR_HPMCOUNTER11| CSR_HPMCOUNTER12| CSR_HPMCOUNTER13| CSR_HPMCOUNTER14|
                            CSR_HPMCOUNTER15| CSR_HPMCOUNTER16| CSR_HPMCOUNTER17| CSR_HPMCOUNTER18|
                            CSR_HPMCOUNTER19| CSR_HPMCOUNTER20| CSR_HPMCOUNTER21| CSR_HPMCOUNTER22|
                            CSR_HPMCOUNTER23| CSR_HPMCOUNTER24| CSR_HPMCOUNTER25| CSR_HPMCOUNTER26|
                            CSR_HPMCOUNTER27| CSR_HPMCOUNTER28| CSR_HPMCOUNTER29| CSR_HPMCOUNTER30|
                            CSR_HPMCOUNTER31   =>
                                for i in 3 to HPM_NUM_COUNTERS-1 loop
--                                    if to_integer(unsigned(inputs.RMEMWB_outputs.regCSR)) - CSR_CYCLE = i then
                                    if unsigned(inputs.RMEMWB_outputs.regCSR) - unsigned(CSR_CYCLE) = i then
                                        if mcounteren(i)='1' then
--                                            outputs.data <= mhpmcounters(i)(XLEN-1 downto 0);
                                            data := mhpmcounters(i)(XLEN-1 downto 0);
                                        end if;
                                    end if;
                                end loop;

                   when     CSR_HPMCOUNTER3H | CSR_HPMCOUNTER4H | CSR_HPMCOUNTER5H | CSR_HPMCOUNTER6H   |
                            CSR_HPMCOUNTER7H | CSR_HPMCOUNTER8H | CSR_HPMCOUNTER9H | CSR_HPMCOUNTER10H  |
                            CSR_HPMCOUNTER11H| CSR_HPMCOUNTER12H| CSR_HPMCOUNTER13H| CSR_HPMCOUNTER14H  |
                            CSR_HPMCOUNTER15H| CSR_HPMCOUNTER16H| CSR_HPMCOUNTER17H| CSR_HPMCOUNTER18H  |
                            CSR_HPMCOUNTER19H| CSR_HPMCOUNTER20H| CSR_HPMCOUNTER21H| CSR_HPMCOUNTER22H  |
                            CSR_HPMCOUNTER23H| CSR_HPMCOUNTER24H| CSR_HPMCOUNTER25H| CSR_HPMCOUNTER26H  |
                            CSR_HPMCOUNTER27H| CSR_HPMCOUNTER28H| CSR_HPMCOUNTER29H| CSR_HPMCOUNTER30H  |
                            CSR_HPMCOUNTER31H  =>
                                for i in 3 to HPM_NUM_COUNTERS-1 loop
--                                    if to_integer(unsigned(inputs.RMEMWB_outputs.regCSR)) - CSR_CYCLEH = i then
                                    if unsigned(inputs.RMEMWB_outputs.regCSR) - unsigned(CSR_CYCLEH) = i then
                                        if mcounteren(i)='1' then
--                                            outputs.data <= mhpmcountersh(i)(XLEN-1 downto 0);
                                            data := mhpmcountersh(i)(XLEN-1 downto 0);
                                        end if;
                                    end if;
                                end loop;

                    when CSR_MSTATUS     =>
--                        outputs.data <= mstatus;
                        data := mstatus;

                    when CSR_MEPC        =>
--                        outputs.data <= mepc;
                        data := mepc;

                    when CSR_MTVEC       =>
--                        outputs.data <= mtvec;
                        data := mtvec;

                    when CSR_MCAUSE      =>
--                        outputs.data <= mcause;
                        data := mcause;

                    when CSR_MTVAL       =>
--                        outputs.data <= mtval;
                        data := mtval;

                    when CSR_MISA        =>
--                        outputs.data <= misa;
                        data := misa;

                    when CSR_MIP         =>
--                        outputs.data <= mip;
                        data := mip;

                    when CSR_MIE         =>
--                        outputs.data <= mie;
                        data := mie;

                    when CSR_MVENDORID   =>
--                        outputs.data <= mvendorid;
                        data := mvendorid;

                    when CSR_MIMPID      =>
--                        outputs.data <= mimpid;
                        data := mimpid;

                    when CSR_MHARTID     =>
--                        outputs.data <= mhartid;
                        data := mhartid;

                    when CSR_MCYCLE      =>
--                        outputs.data <= mcycle(XLEN-1 downto 0);
                        data := mcycle(XLEN-1 downto 0);

                    when CSR_MCYCLEH     =>
--                        outputs.data <= mcycleh(XLEN-1 downto 0);
                        data := mcycleh(XLEN-1 downto 0);

                    when CSR_MINSTRET    =>
--                        outputs.data <= minstret(XLEN-1 downto 0);
                        data := minstret(XLEN-1 downto 0);

                    when CSR_MINSTRETH   =>
--                        outputs.data <= minstreth(XLEN-1 downto 0);
                        data := minstreth(XLEN-1 downto 0);

                    when    CSR_MHPMCOUNTER3 | CSR_MHPMCOUNTER4 | CSR_MHPMCOUNTER5 | CSR_MHPMCOUNTER6 |
                            CSR_MHPMCOUNTER7 | CSR_MHPMCOUNTER8 | CSR_MHPMCOUNTER9 | CSR_MHPMCOUNTER10|
                            CSR_MHPMCOUNTER11| CSR_MHPMCOUNTER12| CSR_MHPMCOUNTER13| CSR_MHPMCOUNTER14|
                            CSR_MHPMCOUNTER15| CSR_MHPMCOUNTER16| CSR_MHPMCOUNTER17| CSR_MHPMCOUNTER18|
                            CSR_MHPMCOUNTER19| CSR_MHPMCOUNTER20| CSR_MHPMCOUNTER21| CSR_MHPMCOUNTER22|
                            CSR_MHPMCOUNTER23| CSR_MHPMCOUNTER24| CSR_MHPMCOUNTER25| CSR_MHPMCOUNTER26|
                            CSR_MHPMCOUNTER27| CSR_MHPMCOUNTER28| CSR_MHPMCOUNTER29| CSR_MHPMCOUNTER30|
                            CSR_MHPMCOUNTER31   =>
                                for i in 3 to HPM_NUM_COUNTERS-1 loop
--                                    if to_integer(unsigned(inputs.RMEMWB_outputs.regCSR)) - (CSR_MCYCLE) = i then
                                    if unsigned(inputs.RMEMWB_outputs.regCSR) - unsigned(CSR_MCYCLE) = i then
--                                        outputs.data <= mhpmcounters(i)(XLEN-1 downto 0);
                                        data := mhpmcounters(i)(XLEN-1 downto 0);
                                    end if;
                                end loop;

                   when     CSR_MHPMCOUNTER3H | CSR_MHPMCOUNTER4H | CSR_MHPMCOUNTER5H | CSR_MHPMCOUNTER6H   |
                            CSR_MHPMCOUNTER7H | CSR_MHPMCOUNTER8H | CSR_MHPMCOUNTER9H | CSR_MHPMCOUNTER10H  |
                            CSR_MHPMCOUNTER11H| CSR_MHPMCOUNTER12H| CSR_MHPMCOUNTER13H| CSR_MHPMCOUNTER14H  |
                            CSR_MHPMCOUNTER15H| CSR_MHPMCOUNTER16H| CSR_MHPMCOUNTER17H| CSR_MHPMCOUNTER18H  |
                            CSR_MHPMCOUNTER19H| CSR_MHPMCOUNTER20H| CSR_MHPMCOUNTER21H| CSR_MHPMCOUNTER22H  |
                            CSR_MHPMCOUNTER23H| CSR_MHPMCOUNTER24H| CSR_MHPMCOUNTER25H| CSR_MHPMCOUNTER26H  |
                            CSR_MHPMCOUNTER27H| CSR_MHPMCOUNTER28H| CSR_MHPMCOUNTER29H| CSR_MHPMCOUNTER30H  |
                            CSR_MHPMCOUNTER31H  =>
                                for i in 3 to HPM_NUM_COUNTERS-1 loop
--                                    if to_integer(unsigned(inputs.RMEMWB_outputs.regCSR)) - (CSR_MCYCLEH) = i then
                                    if unsigned(inputs.RMEMWB_outputs.regCSR) - unsigned(CSR_MCYCLEH) = i then
--                                        outputs.data <= mhpmcountersh(i)(XLEN-1 downto 0);
                                        data := mhpmcountersh(i)(XLEN-1 downto 0);
                                    end if;
                                end loop;

                    when CSR_MCOUNTINHIBIT =>
--                        outputs.data <= mcountinhibit;
                        data := mcountinhibit;

                    when CSR_MCOUNTEREN    =>
--                        outputs.data <= mcounteren;
                        data := mcounteren;

                    when    CSR_MHPMEVENT3  | CSR_MHPMEVENT4    | CSR_MHPMEVENT5    | CSR_MHPMEVENT6    |
                            CSR_MHPMEVENT7  | CSR_MHPMEVENT8    | CSR_MHPMEVENT9    | CSR_MHPMEVENT10   |
                            CSR_MHPMEVENT11 | CSR_MHPMEVENT12   | CSR_MHPMEVENT13   | CSR_MHPMEVENT14   |
                            CSR_MHPMEVENT15 | CSR_MHPMEVENT16   | CSR_MHPMEVENT17   | CSR_MHPMEVENT18   |
                            CSR_MHPMEVENT19 | CSR_MHPMEVENT20   | CSR_MHPMEVENT21   | CSR_MHPMEVENT22   |
                            CSR_MHPMEVENT23 | CSR_MHPMEVENT24   | CSR_MHPMEVENT25   | CSR_MHPMEVENT26   |
                            CSR_MHPMEVENT27 | CSR_MHPMEVENT28   | CSR_MHPMEVENT29   | CSR_MHPMEVENT30   |
                            CSR_MHPMEVENT31 =>
                                for i in 3 to HPM_NUM_COUNTERS-1 loop
--                                    if to_integer(unsigned(inputs.RMEMWB_outputs.regCSR)) - (CSR_MCOUNTINHIBIT) = i then
                                    if unsigned(inputs.RMEMWB_outputs.regCSR) - unsigned(CSR_MCOUNTINHIBIT) = i then
--                                        outputs.data <= mhpmevent(i)(XLEN-1 downto 0);
                                        data := mhpmevent(i)(XLEN-1 downto 0);
                                    end if;
                                end loop;

                    when    CSR_MHPMEVENT0H                         | CSR_MHPMEVENT2H    | CSR_MHPMEVENT3H    |
                            CSR_MHPMEVENT4H    | CSR_MHPMEVENT5H    | CSR_MHPMEVENT6H    | CSR_MHPMEVENT7H    |
                            CSR_MHPMEVENT8H    | CSR_MHPMEVENT9H    | CSR_MHPMEVENT10H   | CSR_MHPMEVENT11H   |
                            CSR_MHPMEVENT12H   | CSR_MHPMEVENT13H   | CSR_MHPMEVENT14H   | CSR_MHPMEVENT15H   |
                            CSR_MHPMEVENT16H   | CSR_MHPMEVENT17H   | CSR_MHPMEVENT18H   | CSR_MHPMEVENT19H   |
                            CSR_MHPMEVENT20H   | CSR_MHPMEVENT21H   | CSR_MHPMEVENT22H   | CSR_MHPMEVENT23H   |
                            CSR_MHPMEVENT24H   | CSR_MHPMEVENT25H   | CSR_MHPMEVENT26H   | CSR_MHPMEVENT27H   |
                            CSR_MHPMEVENT28H   | CSR_MHPMEVENT29H   | CSR_MHPMEVENT30H   | CSR_MHPMEVENT31H  =>
                                for i in 0 to HPM_NUM_COUNTERS-1 loop
--                                    if to_integer(unsigned(inputs.RMEMWB_outputs.regCSR)) - (CSR_MHPMEVENT0H) = i then
                                    if unsigned(inputs.RMEMWB_outputs.regCSR) - unsigned(CSR_MHPMEVENT0H) = i then
--                                        outputs.data <= mhpmeventh(i)(XLEN-1 downto 0);
                                        data := mhpmeventh(i)(XLEN-1 downto 0);
                                    end if;
                                end loop;

                    when others =>
                end case;
            end if;
        else
--            outputs.data <= XLEN_ZERO;
            data := XLEN_ZERO;
        end if;
--        end if;
        outputs.data<=data;


        if_mstatus_read:
        -- This outputs the value of mstatus so that the CLINT and PLIC always has the most update value.
--        if inputs.PPL_outputs.stop_ID = '0' then
            outputs.special(128) <= mstatus;
--            outputs.plevel <= PLevel;
            outputs.special(132) <= mepc;
--        end if;


--COUNT;
--        if_count:
--        if(rising_edge(I_clock)) then
--            -- Update of auxiliar signals and variables.
----            triggered_events_reg := inputs.CSR_inputs.RMEMWB_outputs.triggered_events(HPM_NUM_EVENTS-1 downto 2) &(inputs.CSR_inputs.RMEMWB_outputs.triggered_events(2) and not inputs.CSR_inputs.PPL_outputs.flush_MEMWB) & inputs.CSR_inputs.RMEMWB_outputs.triggered_events(1 downto 0);
----            triggered_events_reg := (inputs.CSR_inputs.RMEMWB_outputs.triggered_events(2) and not (inputs.CSR_inputs.PPL_outputs.flush_MEMWB or inputs.CSR_inputs.PPL_outputs.stop_MEM)) & inputs.CSR_inputs.RMEMWB_outputs.triggered_events(1 downto 0);
--            triggered_events_reg := inputs.PPL_outputs.triggered_events;
----            triggered_events_reg := inputs.CSR_inputs.RMEMWB_outputs.triggered_events;

--            -- Update of counters if written on the previous cycle.
--            if counters_written (0) = '1' then
--                mcycle  := mcycle_shadow;
--            elsif counters_written (2) = '1' then
--                minstret    := minstret_shadow;
--            else
--                for i in 3 to HPM_NUM_COUNTERS-1 loop
--                    if counters_written(i) = '1' then
--                        mhpmcounters(i)    := mhpmcounters_shadow(i);
--                    end if;
--                end loop;
--            end if;
--            if countersh_written (0) = '1' then
--                mcycleh := mcycleh_shadow;
--            elsif countersh_written (2) = '1' then
--                minstreth   := minstreth_shadow;
--            else
--                for i in 3 to HPM_NUM_COUNTERS-1 loop
--                    if countersh_written(i) = '1' then
--                        mhpmcountersh(i)   := mhpmcountersh_shadow(i);
--                    end if;
--                end loop;
--            end if;
--            for i in 0 to HPM_NUM_COUNTERS-1 loop
--                of_variable(i) := of_signal(i);
--            end loop;

--            -- Counters increment
--            if mcountinhibit(0) = '0' then
--                if (PLevel = MACHINE_MODE and mhpmeventh(0)(HPM_EVENTH_MINH_INDEX) = '0') or (PLevel = USER_MODE and mhpmeventh(0)(HPM_EVENTH_UINH_INDEX) = '0') then
--                            -- (MACHINE_MODE and MINH = '0') or (USER_MODE and UINH = '0')
--                    if triggered_events_reg(0) = '1' then
--                        mcycle := std_logic_vector(unsigned(mcycle) + 1);
--                        if (mcycle(XLEN) = '1') then
--                            mcycleh := std_logic_vector(unsigned(mcycleh) + 1);
--                            mcycle(XLEN) := '0';
--                            if (mcycleh(XLEN) = '1') then                           -- si el bit 32 == 1
--                                if (mhpmeventh(0)(HPM_EVENTH_OF_INDEX) = '0') then
--                                    -- ponemos la se?l of a 1 si el OF estaba a 0
--                                    of_variable(0) := '1';
--        --                            of_signal(0) <= '1';
--                                end if;
--                                -- ponemos a 1 el bit OF
--                                mhpmeventh_var(0)(HPM_EVENTH_OF_INDEX) := '1';
--                                mcycleh(XLEN) := '0';
--                            end if;
--                        end if;
--                    end if;
--                end if;
--            end if;
--            if mcountinhibit(2) = '0' then
--                if (PLevel = MACHINE_MODE and mhpmeventh(2)(HPM_EVENTH_MINH_INDEX) = '0') or (PLevel = USER_MODE and mhpmeventh(2)(HPM_EVENTH_UINH_INDEX) = '0') then
--                            -- (MACHINE_MODE and MINH = '0') or (USER_MODE and UINH = '0')
--                    if triggered_events_reg(2) = '1' then
--                        minstret := std_logic_vector(unsigned(minstret) + 1);
--                        if (minstret(XLEN) = '1') then
--                            minstreth := std_logic_vector(unsigned(minstreth) + 1);
--                            minstret(XLEN) := '0';
--                            if (minstreth(XLEN) = '1') then                           -- si el bit 32 == 1
--                                if (mhpmeventh(2)(HPM_EVENTH_OF_INDEX) = '0') then
--                                    -- ponemos la se?l of a 1 si el OF estaba a 0
--                                    of_variable(2) := '1';
--        --                            of_signal(2) <= '1';
--                                end if;
--                                -- ponemos a 1 el bit OF
--                                mhpmeventh_var(2)(HPM_EVENTH_OF_INDEX) := '1';
--                                minstreth(XLEN) := '0';
--                            end if;
--                        end if;
--                    end if;
--                end if;
--            end if;

--            for i in 3 to HPM_NUM_COUNTERS-1 loop
--                if triggered_events_reg(to_integer(unsigned(mhpmevent(i)))-1)='1' then
--                    if mcountinhibit(i)='0' then                                             -- si el contador no est? inhibido
--                        if (PLevel = MACHINE_MODE and mhpmeventh(i)(HPM_EVENTH_MINH_INDEX) = '0') or (PLevel = USER_MODE and mhpmeventh(i)(HPM_EVENTH_UINH_INDEX) = '0') then
--                        -- (MACHINE_MODE and MINH = '0') or (USER_MODE and UINH = '0')
--                            mhpmcounters(i) := std_logic_vector(unsigned(mhpmcounters(i)) + 1);
--                            if (mhpmcounters(i)(XLEN) = '1') then                                -- si el bit 32 == 1
--                                mhpmcountersh(i):= std_logic_vector(unsigned(mhpmcountersh(i)) + 1);
--                                mhpmcounters(i)(XLEN) := '0';
--                                if (mhpmcountersh(i)(XLEN) = '1') then                           -- si el bit 32 == 1
--                                    if (mhpmeventh(i)(HPM_EVENTH_OF_INDEX) = '0') then
--                                        -- ponemos la se?l of a 1 si el OF estaba a 0
--                                        of_variable(i) := '1';
--    --                                    of_signal(i) <= '1';
--                                    end if;
--                                    -- ponemos a 1 el bit OF
--                                    mhpmeventh_var(i)(HPM_EVENTH_OF_INDEX) := '1';
--    --                                mhpmeventh(i)(HPM_EVENTH_OF_INDEX) <= '1';
--                                    mhpmcountersh(i)(XLEN) := '0';
--                                end if;
--                            end if;
--                        end if;
--                    end if;
--                end if;
--            end loop;

--            -- Update counter inhibition CSR after counter increment so that the last instruction is also counted.
--            if mcountinhibit_shadow /= mcountinhibit then
--                mcountinhibit := mcountinhibit_shadow;
--            end if;

--        end if;



        if_write: 
--        if(falling_edge(I_clock)) then
        if(rising_edge(I_clock)) then

        input_calculation:
        if inputs.RMEMWB_outputs.needsCSROROp = '1' then
--        if inputs.REXMEM_outputs.needsCSROROp = '1' then
            if inputs.RMEMWB_outputs.needsCSRANDOp = '1' then
--            if inputs.REXMEM_outputs.needsCSRANDOp = '1' then
                csr_input:=inputs.GPRs_outputs.regS1_valueWB;
            else
                csr_input:=inputs.GPRs_outputs.regS1_valueWB or data;
            end if;
        else
            if inputs.RMEMWB_outputs.needsCSRANDOp = '1' then
--            if inputs.REXMEM_outputs.needsCSRANDOp = '1' then
                csr_input:=inputs.GPRs_outputs.regS1_valueWB and data;
            else
                csr_input:=data;
            end if;
        end if;

--            PLevel := inputs.CSR_inputs.PPL_Outputs.PLevel;
--            counters_written <= XLEN_ZERO;
--            countersh_written <= XLEN_ZERO;

--            for i in 0 to HPM_NUM_COUNTERS-1 loop
--                of_signal(i) <= of_variable(i);
--                mhpmeventh(i)(HPM_EVENTH_OF_INDEX) <= mhpmeventh_var(i)(HPM_EVENTH_OF_INDEX);
--            end loop;

            -- Always write mepc register from PPL.
--            mepc    <= inputs.CSR_inputs.PPL_Outputs.mepc;

            -- Exceptions
--            if inputs.REXMEM_outputs.parregEnable(0) = '1' then
--            if inputs.REXMEM_outputs.parregEnable = '1' then
            if inputs.RMEMWB_outputs.parregEnable = '1' then
--            if inputs.PROCIFace_outputs.parregEnable = '1' then
--            if(unsigned(inputs.PPL_outputs.cause) /= 0) then

                mstatus <= inputs.PROCIFace_outputs.special(128);
                mtval   <= inputs.PROCIFace_outputs.special(134);
                mepc    <= inputs.PROCIFace_outputs.special(132);
                mcause  <= inputs.PROCIFace_outputs.special(133);

                mtvec       <= inputs.PROCIFace_outputs.special(130);
                mie         <= inputs.PROCIFace_outputs.special(129);
                mip         <= inputs.PROCIFace_outputs.special(135);
                mcounteren  <= inputs.PROCIFace_outputs.special(131);
                in_traces: for i in 0 to 63 loop
--                begin
                    tracecsr(i)<=inputs.PROCIFace_outputs.special(i)   ;
                    tracemem(i)<=inputs.PROCIFace_outputs.special(i+64);
                end loop;

                mcycle      <= '0'&inputs.PROCIFace_outputs.special(136);
                minstret    <= '0'&inputs.PROCIFace_outputs.special(137);
                mcycleh     <= '0'&inputs.PROCIFace_outputs.special(167);
                minstreth   <= '0'&inputs.PROCIFace_outputs.special(168);
                in_cnts: for i in 3 to HPM_NUM_COUNTERS-1 loop
--                begin
                    mhpmcounters (i)<='0'&inputs.PROCIFace_outputs.special(i+138-3)   ;
                    mhpmcountersh(i)<='0'&inputs.PROCIFace_outputs.special(i+169-3);
                end loop;
                mcountinhibit  <= inputs.PROCIFace_outputs.special(198);
                mhpmeventh(0)  <= inputs.PROCIFace_outputs.special(228);
                mhpmeventh(2)  <= inputs.PROCIFace_outputs.special(229);
                in_events: for i in 3 to HPM_NUM_COUNTERS-1 loop
--                begin
                    mhpmevent (i)<=inputs.PROCIFace_outputs.special(i+199-3)   ;
                    mhpmeventh(i)<=inputs.PROCIFace_outputs.special(i+230-3);
                end loop;
                
--                PLevel  <= inputs.PROCIFace_outputs.PLevel;

            -- MRET return.
--            elsif(inputs.PPL_Outputs.Priv_Instruction_CSR = INST_PRIV_MRET) then

--                mstatus <= inputs.PPL_Outputs.status;
--                PLevel  <= inputs.PPL_Outputs.PLevel;

            -- Nominal CSR write.
            elsif inputs.RMEMWB_outputs.validOpCSRW = '1' then
                    if excepW_flag = '0' then
--                        case to_integer(unsigned(inputs.RMEMWB_outputs.regCSR)) is
                        case inputs.RMEMWB_outputs.regCSR is
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
                                        for i in 0 to TRACE_CSR_NUM-1 loop
--                                            if to_integer(unsigned(inputs.RMEMWB_outputs.regCSR)) - (CSR_TRACECSR0) = i then
                                            if unsigned(inputs.RMEMWB_outputs.regCSR) - unsigned(CSR_TRACECSR0) = i then
                                                tracecsr(i) <= csr_input;
                                            end if;
                                        end loop;

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
                                        for i in 0 to TRACE_MEM_NUM-1 loop
--                                            if to_integer(unsigned(inputs.RMEMWB_outputs.regCSR)) - (CSR_TRACEMEM0) = i then
                                            if unsigned(inputs.RMEMWB_outputs.regCSR) - unsigned(CSR_TRACEMEM0) = i then
                                                tracemem(i) <= csr_input;
                                            end if;
                                        end loop;

                            when CSR_MSTATUS    =>
                                mstatus         <= csr_input;

                            when CSR_MEPC       =>
                                mepc            <= csr_input;

                            when CSR_MTVEC      =>
                                mtvec           <= csr_input;

                            when CSR_MCAUSE     =>
                                mcause          <= csr_input;

                            when CSR_MTVAL      =>
                                mtval           <= csr_input;

                            when CSR_MISA       => -- Commented as we don't support changes in the ISA at runtime.
--                                misa        <= inputs.CSR_csr_input;

                            --added by angela
                            when CSR_MIP        =>
                                mip             <= csr_input;

                            when CSR_MIE        =>
                                mie             <= csr_input;

                            when CSR_MCYCLE     =>
--                                mcycle_shadow   <= '0'& csr_input;
--                                counters_written(0) <= '1';
                                mcycle      <= '0'& csr_input;

                            when CSR_MCYCLEH    =>
--                                mcycleh_shadow  <= '0'& csr_input;
--                                countersh_written(0) <= '1';
                                mcycleh     <= '0'& csr_input;

                            when CSR_MINSTRET   =>
--                                minstret_shadow <= '0'& csr_input;
--                                counters_written(2) <= '1';
                                minstret    <= '0'& csr_input;

                            when CSR_MINSTRETH  =>
--                                minstreth_shadow<= '0'& csr_input;
--                                countersh_written(2) <= '1';
                                minstreth   <= '0'& csr_input;

                            when    CSR_MHPMCOUNTER3 | CSR_MHPMCOUNTER4 | CSR_MHPMCOUNTER5 | CSR_MHPMCOUNTER6 |
                                    CSR_MHPMCOUNTER7 | CSR_MHPMCOUNTER8 | CSR_MHPMCOUNTER9 | CSR_MHPMCOUNTER10|
                                    CSR_MHPMCOUNTER11| CSR_MHPMCOUNTER12| CSR_MHPMCOUNTER13| CSR_MHPMCOUNTER14|
                                    CSR_MHPMCOUNTER15| CSR_MHPMCOUNTER16| CSR_MHPMCOUNTER17| CSR_MHPMCOUNTER18|
                                    CSR_MHPMCOUNTER19| CSR_MHPMCOUNTER20| CSR_MHPMCOUNTER21| CSR_MHPMCOUNTER22|
                                    CSR_MHPMCOUNTER23| CSR_MHPMCOUNTER24| CSR_MHPMCOUNTER25| CSR_MHPMCOUNTER26|
                                    CSR_MHPMCOUNTER27| CSR_MHPMCOUNTER28| CSR_MHPMCOUNTER29| CSR_MHPMCOUNTER30|
                                    CSR_MHPMCOUNTER31   =>
                                        for i in 3 to HPM_NUM_COUNTERS-1 loop
--                                            if to_integer(unsigned(inputs.RMEMWB_outputs.regCSR)) - (CSR_MCYCLE) = i then
                                            if unsigned(inputs.RMEMWB_outputs.regCSR) - unsigned(CSR_MCYCLE) = i then
--                                                mhpmcounters_shadow(i) <= '0'& csr_input;
--                                                counters_written(i) <= '1';
                                                mhpmcounters(i) <= '0'& csr_input;
                                            end if;
                                        end loop;

                           when     CSR_MHPMCOUNTER3H | CSR_MHPMCOUNTER4H | CSR_MHPMCOUNTER5H | CSR_MHPMCOUNTER6H   |
                                    CSR_MHPMCOUNTER7H | CSR_MHPMCOUNTER8H | CSR_MHPMCOUNTER9H | CSR_MHPMCOUNTER10H  |
                                    CSR_MHPMCOUNTER11H| CSR_MHPMCOUNTER12H| CSR_MHPMCOUNTER13H| CSR_MHPMCOUNTER14H  |
                                    CSR_MHPMCOUNTER15H| CSR_MHPMCOUNTER16H| CSR_MHPMCOUNTER17H| CSR_MHPMCOUNTER18H  |
                                    CSR_MHPMCOUNTER19H| CSR_MHPMCOUNTER20H| CSR_MHPMCOUNTER21H| CSR_MHPMCOUNTER22H  |
                                    CSR_MHPMCOUNTER23H| CSR_MHPMCOUNTER24H| CSR_MHPMCOUNTER25H| CSR_MHPMCOUNTER26H  |
                                    CSR_MHPMCOUNTER27H| CSR_MHPMCOUNTER28H| CSR_MHPMCOUNTER29H| CSR_MHPMCOUNTER30H  |
                                    CSR_MHPMCOUNTER31H  =>
                                        for i in 3 to HPM_NUM_COUNTERS-1 loop
--                                            if to_integer(unsigned(inputs.RMEMWB_outputs.regCSR)) - (CSR_MCYCLEH) = i then
                                            if unsigned(inputs.RMEMWB_outputs.regCSR) - unsigned(CSR_MCYCLEH) = i then
--                                                mhpmcountersh_shadow(i) <= '0'& csr_input;
--                                                countersh_written(i) <= '1';
                                                mhpmcountersh(i) <= '0'& csr_input;
                                            end if;
                                        end loop;

                            when CSR_MCOUNTINHIBIT =>
--                                mcountinhibit_shadow <= csr_input;
                                mcountinhibit <= csr_input;

                            when CSR_MCOUNTEREN =>
                                mcounteren <= csr_input;

                            when    CSR_MHPMEVENT3  | CSR_MHPMEVENT4    | CSR_MHPMEVENT5    | CSR_MHPMEVENT6    |
                                    CSR_MHPMEVENT7  | CSR_MHPMEVENT8    | CSR_MHPMEVENT9    | CSR_MHPMEVENT10   |
                                    CSR_MHPMEVENT11 | CSR_MHPMEVENT12   | CSR_MHPMEVENT13   | CSR_MHPMEVENT14   |
                                    CSR_MHPMEVENT15 | CSR_MHPMEVENT16   | CSR_MHPMEVENT17   | CSR_MHPMEVENT18   |
                                    CSR_MHPMEVENT19 | CSR_MHPMEVENT20   | CSR_MHPMEVENT21   | CSR_MHPMEVENT22   |
                                    CSR_MHPMEVENT23 | CSR_MHPMEVENT24   | CSR_MHPMEVENT25   | CSR_MHPMEVENT26   |
                                    CSR_MHPMEVENT27 | CSR_MHPMEVENT28   | CSR_MHPMEVENT29   | CSR_MHPMEVENT30   |
                                    CSR_MHPMEVENT31 =>
                                        for i in 3 to HPM_NUM_COUNTERS-1 loop
--                                            if to_integer(unsigned(inputs.RMEMWB_outputs.regCSR)) - (CSR_MCOUNTINHIBIT) = i then
                                            if unsigned(inputs.RMEMWB_outputs.regCSR) - unsigned(CSR_MCOUNTINHIBIT) = i then
                                                mhpmevent(i) <= csr_input;
                                            end if;
                                        end loop;

                            when    CSR_MHPMEVENT0H                         | CSR_MHPMEVENT2H    | CSR_MHPMEVENT3H    |
                                    CSR_MHPMEVENT4H    | CSR_MHPMEVENT5H    | CSR_MHPMEVENT6H    | CSR_MHPMEVENT7H    |
                                    CSR_MHPMEVENT8H    | CSR_MHPMEVENT9H    | CSR_MHPMEVENT10H   | CSR_MHPMEVENT11H   |
                                    CSR_MHPMEVENT12H   | CSR_MHPMEVENT13H   | CSR_MHPMEVENT14H   | CSR_MHPMEVENT15H   |
                                    CSR_MHPMEVENT16H   | CSR_MHPMEVENT17H   | CSR_MHPMEVENT18H   | CSR_MHPMEVENT19H   |
                                    CSR_MHPMEVENT20H   | CSR_MHPMEVENT21H   | CSR_MHPMEVENT22H   | CSR_MHPMEVENT23H   |
                                    CSR_MHPMEVENT24H   | CSR_MHPMEVENT25H   | CSR_MHPMEVENT26H   | CSR_MHPMEVENT27H   |
                                    CSR_MHPMEVENT28H   | CSR_MHPMEVENT29H   | CSR_MHPMEVENT30H   | CSR_MHPMEVENT31H  =>
                                        for i in 0 to HPM_NUM_COUNTERS-1 loop
--                                            if to_integer(unsigned(inputs.RMEMWB_outputs.regCSR)) - (CSR_MHPMEVENT0H) = i then
                                            if unsigned(inputs.RMEMWB_outputs.regCSR) - unsigned(CSR_MHPMEVENT0H) = i then
                                                mhpmeventh(i) <= csr_input;
                                                of_signal(i) <= '0';
                                            end if;
                                        end loop;

                            when others => 
                        end case;
                    end if;
--                end if;
            end if;
        end if;

--SET_CLEAR;
--        -- Here all readable CSRs are outputed to the CSRs parent (REGISTERS), so that they can be used for set/clear instructions during the EX stage.  WARNING: TEST THIS, IT MAY HAVE BEEN COPIED WRONG AND IT SHOULD BE ID STAGE NO MEM_WB.
--        if    inputs.ID_outputs.regCSR = CSR_MSTATUS     then
--            outputs.regCSR_value <= mstatus;
--        elsif inputs.ID_outputs.regCSR = CSR_MTVAL       then
--            outputs.regCSR_value <= mtval;
--        elsif inputs.ID_outputs.regCSR = CSR_MTVEC       then
--            outputs.regCSR_value <= mtvec;
--        elsif inputs.ID_outputs.regCSR = CSR_MEPC        then
--            outputs.regCSR_value <= mepc;
--        elsif inputs.ID_outputs.regCSR = CSR_MCAUSE      then
--            outputs.regCSR_value <= mcause;
--        elsif inputs.ID_outputs.regCSR = CSR_MISA        then
--            outputs.regCSR_value <= misa;
--        elsif inputs.ID_outputs.regCSR = CSR_MIP         then
--            outputs.regCSR_value <= mip;
--        elsif inputs.ID_outputs.regCSR = CSR_MIE         then
--            outputs.regCSR_value <= mie;
--        elsif inputs.ID_outputs.regCSR = CSR_MCYCLE      then
--            outputs.regCSR_value <= mcycle(XLEN-1 downto 0);
--        elsif inputs.ID_outputs.regCSR = CSR_MCYCLEH     then
--            outputs.regCSR_value <= mcycleh(XLEN-1 downto 0);
--        elsif inputs.ID_outputs.regCSR = CSR_MINSTRET    then
--            outputs.regCSR_value <= minstret(XLEN-1 downto 0);
--        elsif inputs.ID_outputs.regCSR = CSR_MINSTRETH   then
--            outputs.regCSR_value <= minstreth(XLEN-1 downto 0);
--        elsif inputs.ID_outputs.regCSR >= CSR_MHPMCOUNTER3 and inputs.ID_outputs.regCSR <= CSR_MHPMCOUNTER31 then
--            for i in 3 to HPM_NUM_COUNTERS-1 loop
--                if unsigned(inputs.ID_outputs.regCSR) - unsigned(CSR_MCYCLE) = i then
--                    outputs.regCSR_value <= mhpmcounters(i)(XLEN-1 downto 0);
--                end if;
--            end loop;
--        elsif inputs.ID_outputs.regCSR >= CSR_MHPMCOUNTER3H and inputs.ID_outputs.regCSR <= CSR_MHPMCOUNTER31H then
--            for i in 3 to HPM_NUM_COUNTERS-1 loop
--                if unsigned(inputs.ID_outputs.regCSR) - unsigned(CSR_MCYCLEH) = i then
--                    outputs.regCSR_value <= mhpmcountersh(i)(XLEN-1 downto 0);
--                end if;
--            end loop;
--        elsif inputs.ID_outputs.regCSR >= CSR_MHPMEVENT3 and inputs.ID_outputs.regCSR <= CSR_MHPMEVENT31 then
--            for i in 3 to HPM_NUM_COUNTERS-1 loop
--                if unsigned(inputs.ID_outputs.regCSR) - unsigned(CSR_MCOUNTINHIBIT) = i then
--                    outputs.regCSR_value <= mhpmevent(i);
--                end if;
--            end loop;
--        elsif inputs.ID_outputs.regCSR >= CSR_MHPMEVENT3H and inputs.ID_outputs.regCSR <= CSR_MHPMEVENT31H then
--            for i in 3 to HPM_NUM_COUNTERS-1 loop
--                if unsigned(inputs.ID_outputs.regCSR) - unsigned(CSR_MHPMEVENT0H) = i then
--                    outputs.regCSR_value <= mhpmeventh(i);
--                end if;
--            end loop;
--        else
--            outputs.regCSR_value <= (others => '0');
--        end if;

        outputs.exception <= excepR_flag or excepW_flag;

--        -- Reset condition
--        if_reset:
--        if (I_reset = RESET) then
--            -- At reset, we get the priviledge mode and status from the PPL.
--            mstatus <= inputs.PPL_Outputs.status;
--            PLevel  <= inputs.PPL_Outputs.PLevel;

--            triggered_events_reg := "00000000000000";
--            mcycle := '0'& XLEN_ZERO;
--        end if;

        outputs.special(136) <= mcycle   (XLEN-1 downto 0);
        outputs.special(137) <= minstret (XLEN-1 downto 0);
        outputs.special(167) <= mcycleh  (XLEN-1 downto 0);
        outputs.special(168) <= minstreth(XLEN-1 downto 0);
        out_cnts: for i in 3 to HPM_NUM_COUNTERS-1 loop
            outputs.special(i+138-3)  <= mhpmcounters(i) (XLEN-1 downto 0);
            outputs.special(i+169-3)  <= mhpmcountersh(i)(XLEN-1 downto 0);
        end loop;
        outputs.special(198) <= mcountinhibit;
    end process;

--    -- Process that generates of_general from of_signal
--    CSR_of_signal: process(of_signal)
--    begin
--        outputs.of_general <= '0';
--        for i in 0 to HPM_NUM_COUNTERS-1 loop
--            if (of_signal(i) = '1') then
--                outputs.of_general <= '1';
--            end if;
--        end loop;
--    end process;

--    CSR_tracecsr: process(inputs.RMEMWB_outputs.regCSR)
--    begin
--        tracecsr_write <= '0';
--        tracecsr_index <= "000000";
--            if (opCSR = '1') then
--                if (ro = '0' or wo = '1') then
--                    for i in 0 to TRACE_CSR_NUM-1 loop
--                        if inputs.RMEMWB_outputs.regCSR = tracecsr(i)(11 downto 0) then
--                            tracecsr_index <= std_logic_vector(to_unsigned(i, outputs.tracecsr_index'length));
--                            tracecsr_write <= '1';
--                            exit;
--                        end if;
--                    end loop;
--                end if;
--            end if;
--        outputs.tracecsr_index <= tracecsr_index;
--        outputs.tracecsr_write <= tracecsr_write;
--    end process;

--    CSR_tracemem: process(inputs.RMEMWB_outputs.regCSR)
--    begin
--        tracemem_write <= '0';
--        tracemem_index <= "000000";
--        for i in 0 to TRACE_MEM_NUM-1 loop
--            if inputs.REXMEM_outputs.result = tracemem(i) then
--                tracemem_index <= std_logic_vector(to_unsigned(i, outputs.tracemem_index'length));
--                tracemem_write <= '1';
--                exit;
--            end if;
--        end loop;
--        outputs.tracemem_index <= tracemem_index;
--        outputs.tracemem_write <= tracemem_write;
--    end process;
  
    out_traces: for i in 0 to 63 generate
    begin
        outputs.special(i)      <= tracecsr(i);
        outputs.special(i+64)   <= tracemem(i);
    end generate;

    outputs.special(128) <= mstatus;

    outputs.special(133) <= mcause;
    outputs.special(130) <= mtvec;
    outputs.special(129) <= mie;
    outputs.special(135) <= mip;

    outputs.special(131) <= mcounteren;

    outputs.special(132) <= mepc;
    outputs.special(134) <= mtval;

--    outputs.special(136) <= mcycle;
--    outputs.special(137) <= minstret;
--    outputs.special(167) <= mcycleh;
--    outputs.special(168) <= minstreth;
--    out_cnts: for i in 0 to 28 generate
--    begin
--        outputs.special(i+138)  <= mhpmcounters(i);
--        outputs.special(i+169)  <= mhpmcountersh(i);
--    end generate;

--    outputs.special(198) <= mcountinhibit;
    outputs.special(228) <= mhpmeventh(0);
    outputs.special(229) <= mhpmeventh(2);
    out_events: for i in 3 to HPM_NUM_COUNTERS-1 generate
    begin
        outputs.special(i+199-3) <= mhpmevent(i);
        outputs.special(i+230-3) <= mhpmeventh(i);
    end generate;

end behavioral;
