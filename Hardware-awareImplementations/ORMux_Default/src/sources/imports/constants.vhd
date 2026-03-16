-------------------------------------------------------
--! @file
--! @brief Constants declaration package
-------------------------------------------------------

--! Use standard libraries
library ieee;
--! Use standard unresolved logic UX01ZWLH
use ieee.std_logic_1164.all;
--! Use signed, unsigned types and arithmetic ops
use ieee.numeric_std.all;

--! @brief In this package with the definitions of constants and types used.
package constants is

-------------------------------------------------------------------
---------------   Constants for unpriviledge spec   ---------------
-------------------------------------------------------------------

-- Numerical constants --
constant XLEN:      integer := 32;
constant log2XLEN:  integer := 5;
constant XLEN_ZERO: std_logic_vector(XLEN-1 downto 0) := X"00000000";

constant TRID:      integer := 6;
constant TCRSMEL:   integer := 3;

-- Indexes of pipeline stages --
constant NO_STAGE                           : std_logic_vector(2 downto 0) := "000";
constant STAGE_IF                           : std_logic_vector(2 downto 0) := "001";
constant STAGE_ID                           : std_logic_vector(2 downto 0) := "010";
constant STAGE_EX                           : std_logic_vector(2 downto 0) := "011";
constant STAGE_MEM                          : std_logic_vector(2 downto 0) := "100";
constant STAGE_WB                           : std_logic_vector(2 downto 0) := "101";

-- Trace selector constants --
constant ZERO:          std_logic := '0';
constant PREVIOUS_T:    std_logic := '1';
constant NEW_T:         std_logic_vector(1 downto 0) := "10";

-- Default NOP operation
constant NOP:   std_logic_vector(XLEN-1 downto 0) := X"00000013";

-- Operation codes --
constant OP_OP:     std_logic_vector(6 downto 0) := "0110011";
constant OP_OPIMM:  std_logic_vector(6 downto 0) := "0010011";
constant OP_LOAD:   std_logic_vector(6 downto 0) := "0000011";
constant OP_STORE:  std_logic_vector(6 downto 0) := "0100011";
constant OP_JAL:    std_logic_vector(6 downto 0) := "1101111";
constant OP_JALR:   std_logic_vector(6 downto 0) := "1100111";
constant OP_BRANCH: std_logic_vector(6 downto 0) := "1100011";
constant OP_SYSTEM: std_logic_vector(6 downto 0) := "1110011";
constant OP_LUI:    std_logic_vector(6 downto 0) := "0110111";
constant OP_AUIPC:  std_logic_vector(6 downto 0) := "0010111";
constant OP_TRAZA:  std_logic_vector(6 downto 0) := "0001011";    --custom0
--constant OP_TRAZA:  std_logic_vector(6 downto 0) := "0101011";  --custom1
--constant OP_TRAZA:  std_logic_vector(6 downto 0) := "1011011";  --custom2/Reserved_128bits
--constant OP_TRAZA:  std_logic_vector(6 downto 0) := "1111011";  --custom3/Reserved_128bits

-- Three  bit functions --
constant FUNC_BEQ:  std_logic_vector(2 downto 0) := "000";
constant FUNC_BNE:  std_logic_vector(2 downto 0) := "001";
constant FUNC_BLT:  std_logic_vector(2 downto 0) := "100";
constant FUNC_BGE:  std_logic_vector(2 downto 0) := "101";
constant FUNC_BLTU: std_logic_vector(2 downto 0) := "110";
constant FUNC_BGEU: std_logic_vector(2 downto 0) := "111";

constant FUNC_LB:   std_logic_vector(2 downto 0) := "000";
constant FUNC_LH:   std_logic_vector(2 downto 0) := "001";
constant FUNC_LW:   std_logic_vector(2 downto 0) := "010";
constant FUNC_LBU:  std_logic_vector(2 downto 0) := "100";
constant FUNC_LHU:  std_logic_vector(2 downto 0) := "101";

constant FUNC_SB:   std_logic_vector(2 downto 0) := "000";
constant FUNC_SH:   std_logic_vector(2 downto 0) := "001";
constant FUNC_SW:   std_logic_vector(2 downto 0) := "010";

constant FUNC_ADDI:         std_logic_vector(2 downto 0) := "000";
constant FUNC_SLLI:         std_logic_vector(2 downto 0) := "001";
constant FUNC_SLTI:         std_logic_vector(2 downto 0) := "010";
constant FUNC_SLTIU:        std_logic_vector(2 downto 0) := "011";
constant FUNC_XORI:         std_logic_vector(2 downto 0) := "100";
constant FUNC_SRLI_SRAI:    std_logic_vector(2 downto 0) := "101";
constant FUNC_ORI:          std_logic_vector(2 downto 0) := "110";
constant FUNC_ANDI:         std_logic_vector(2 downto 0) := "111";

constant FUNC_ADD_SUB:  std_logic_vector(2 downto 0) := "000";
constant FUNC_SLL:      std_logic_vector(2 downto 0) := "001";
constant FUNC_SLT:      std_logic_vector(2 downto 0) := "010";
constant FUNC_SLTU:     std_logic_vector(2 downto 0) := "011";
constant FUNC_XOR:      std_logic_vector(2 downto 0) := "100";
constant FUNC_SRL_SRA:  std_logic_vector(2 downto 0) := "101";
constant FUNC_OR:       std_logic_vector(2 downto 0) := "110";
constant FUNC_AND:      std_logic_vector(2 downto 0) := "111";

constant FUNC_PRIV:     std_logic_vector(2 downto 0) := "000";
constant FUNC_CSRRW:    std_logic_vector(2 downto 0) := "001";
constant FUNC_CSRRS:    std_logic_vector(2 downto 0) := "010";
constant FUNC_CSRRC:    std_logic_vector(2 downto 0) := "011";
constant FUNC_CSRRWI:   std_logic_vector(2 downto 0) := "101";
constant FUNC_CSRRSI:   std_logic_vector(2 downto 0) := "110";
constant FUNC_CSRRCI:   std_logic_vector(2 downto 0) := "111";

constant IMM_ECALL:    std_logic_vector(11 downto 0) :="000000000000";
constant IMM_SRET:     std_logic_vector(11 downto 0) :="000100000010";
constant IMM_MRET:     std_logic_vector(11 downto 0) :="001100000010";

constant INST_PRIV_NONE:    std_logic_vector(2 downto 0) :="000";
constant INST_PRIV_SRET:    std_logic_vector(2 downto 0) :="001";
constant INST_PRIV_MRET:    std_logic_vector(2 downto 0) :="010";
constant INST_PRIV_WFI:     std_logic_vector(2 downto 0) :="011";
constant INST_PRIV_SFENCE:  std_logic_vector(2 downto 0) :="100";
constant INST_PRIV_ECALL:   std_logic_vector(2 downto 0) :="101";

constant INSTRUCTION_MRET:  std_logic_vector(XLEN-1 downto 0):= x"30200073";
constant INSTRUCTION_ECALL: std_logic_vector(XLEN-1 downto 0):= x"00000073";

-- Registers --
constant R0:    std_logic_vector(4 downto 0) := "00000";
constant R1:    std_logic_vector(4 downto 0) := "00001";
constant R2:    std_logic_vector(4 downto 0) := "00010";
constant R3:    std_logic_vector(4 downto 0) := "00011";
constant R4:    std_logic_vector(4 downto 0) := "00100";
constant R5:    std_logic_vector(4 downto 0) := "00101";
constant R6:    std_logic_vector(4 downto 0) := "00110";
constant R7:    std_logic_vector(4 downto 0) := "00111";
constant R8:    std_logic_vector(4 downto 0) := "01000";
constant R9:    std_logic_vector(4 downto 0) := "01001";
constant R10:   std_logic_vector(4 downto 0) := "01010";
constant R11:   std_logic_vector(4 downto 0) := "01011";
constant R12:   std_logic_vector(4 downto 0) := "01100";
constant R13:   std_logic_vector(4 downto 0) := "01101";
constant R14:   std_logic_vector(4 downto 0) := "01110";
constant R15:   std_logic_vector(4 downto 0) := "01111";
constant R16:   std_logic_vector(4 downto 0) := "10000";
constant R17:   std_logic_vector(4 downto 0) := "10001";
constant R18:   std_logic_vector(4 downto 0) := "10010";
constant R19:   std_logic_vector(4 downto 0) := "10011";
constant R20:   std_logic_vector(4 downto 0) := "10100";
constant R21:   std_logic_vector(4 downto 0) := "10101";
constant R22:   std_logic_vector(4 downto 0) := "10110";
constant R23:   std_logic_vector(4 downto 0) := "10111";
constant R24:   std_logic_vector(4 downto 0) := "11000";
constant R25:   std_logic_vector(4 downto 0) := "11001";
constant R26:   std_logic_vector(4 downto 0) := "11010";
constant R27:   std_logic_vector(4 downto 0) := "11011";
constant R28:   std_logic_vector(4 downto 0) := "11100";
constant R29:   std_logic_vector(4 downto 0) := "11101";
constant R30:   std_logic_vector(4 downto 0) := "11110";
constant R31:   std_logic_vector(4 downto 0) := "11111";

-- ALU operations --
constant ALU_ADD:   std_logic_vector(3 downto 0) := "0000";
constant ALU_ADDU:  std_logic_vector(3 downto 0) := "0001"; --Does not exist in the specification
constant ALU_SUB:   std_logic_vector(3 downto 0) := "0010";
constant ALU_SUBU:  std_logic_vector(3 downto 0) := "0011"; --Does not exist in the specification
constant ALU_AND:   std_logic_vector(3 downto 0) := "0100";
constant ALU_OR:    std_logic_vector(3 downto 0) := "0101";
constant ALU_XOR:   std_logic_vector(3 downto 0) := "0110";
constant ALU_SLT:   std_logic_vector(3 downto 0) := "0111";
constant ALU_SLTU:  std_logic_vector(3 downto 0) := "1000";
constant ALU_SLL:   std_logic_vector(3 downto 0) := "1001";
constant ALU_SRL:   std_logic_vector(3 downto 0) := "1010";
constant ALU_SRA:   std_logic_vector(3 downto 0) := "1011";

-- Pipeline control list options --
constant MEM_R_FORMAT:  std_logic_vector(1 downto 0) := "0X";
constant MEM_L:         std_logic_vector(1 downto 0) := "10";
constant MEM_S:         std_logic_vector(1 downto 0) := "11";
constant MEM_JUMP:      std_logic_vector(1 downto 0) := "0X";

constant WB_S:          std_logic_vector(1 downto 0) := "00";
constant WB_BRANCH:     std_logic_vector(1 downto 0) := "00";
constant WB_CSR_ATOMIC: std_logic_vector(1 downto 0) := "01";
constant WB_R_FORMAT:   std_logic_vector(1 downto 0) := "10";
constant WB_L:          std_logic_vector(1 downto 0) := "11";

constant RSMEL_NOP:     std_logic_vector(TCRSMEL-1 downto 0) := "000";
constant RSMEL_PC:      std_logic_vector(TCRSMEL-1 downto 0) := "100";
constant RSMEL_GPR:     std_logic_vector(TCRSMEL-1 downto 0) := "010";
constant RSMEL_FPR:     std_logic_vector(TCRSMEL-1 downto 0) := "110";
constant RSMEL_SHW:     std_logic_vector(TCRSMEL-1 downto 0) := "001";
constant RSMEL_CSR:     std_logic_vector(TCRSMEL-1 downto 0) := "011";

-- Store and load codification options --
constant F_ZERO:    std_logic_vector(4 downto 0) := "00000";
constant F_B:       std_logic_vector(4 downto 0) := "10000";
constant F_BU:      std_logic_vector(4 downto 0) := "01000";
constant F_H:       std_logic_vector(4 downto 0) := "00100";
constant F_HU:      std_logic_vector(4 downto 0) := "00010";
constant F_W:       std_logic_vector(4 downto 0) := "00001";

-- Register and memory operations --
constant LEER:      std_logic := '0';
constant ESCRIBIR:  std_logic := '1';

-- System RESET signal values --
constant RESET:     std_logic := '1';
constant NO_RESET:  std_logic := '0';

-- Multiplexer selection values for ALU inputs --
constant INMEDIATO: std_logic := '0';
constant REGISTRO:  std_logic := '1';

constant SEL_1_ZERO:        std_logic_vector(1 downto 0) := "00";
constant SEL_1_REGISTRO:    std_logic_vector(1 downto 0) := "01";
constant SEL_1_PC:          std_logic_vector(1 downto 0) := "10";

constant SEL_2_REGISTRO:    std_logic_vector(1 downto 0) := "00";
constant SEL_2_PC_NEXT:     std_logic_vector(1 downto 0) := "01";
constant SEL_2_INMEDIATO:   std_logic_vector(1 downto 0) := "10";
constant SEL_2_NOT_REG:     std_logic_vector(1 downto 0) := "11";




-------------------------------------------------------------------
-----------------   Constants and types for HPM   -----------------
-------------------------------------------------------------------

constant HPM_NUM_COUNTERS   : natural   := 14;  -- According to the spec ALL counters have to be implemented even though they may be zeroed... Should we change this??

constant HPM_EVENT_NOEVENT      : natural   := 0;   -- No event.
constant HPM_EVENT_CYCLE        : natural   := 1;   -- Active cycle.
constant HPM_EVENT_UNDEF        : natural   := 2;   -- Former timer event, now undefined.
constant HPM_EVENT_INSTRET      : natural   := 3;   -- Instruction retired.
constant HPM_EVENT_EXCEPTION    : natural   := 4;   -- Exception detected.
constant HPM_EVENT_EXT_INT      : natural   := 5;   -- Exernal interruption detected.
constant HPM_EVENT_TIME_INT     : natural   := 6;   -- Time interruption detected.
constant HPM_EVENT_BRANCH       : natural   := 7;   -- Branch conditional jump.
constant HPM_EVENT_BRANCH_NT    : natural   := 8;   -- Branch conditional jump not taken.
constant HPM_EVENT_UNCOND_JUMP  : natural   := 9;   -- Unconditional jump.
constant HPM_EVENT_HAZARD       : natural   := 10;  -- Hazard cycle.
constant HPM_EVENT_MEM_ACCESS   : natural   := 11;  -- Data memory access.
constant HPM_EVENT_LOAD         : natural   := 12;  -- Load instruction.
constant HPM_EVENT_STORE        : natural   := 13;  -- Store instruction.
constant HPM_EVENT_FETCH        : natural   := 14;  -- Fetch ocurrences


constant HPM_NUM_EVENTS     : natural	:= 14;

type hpm_triggered_events_t is array (HPM_NUM_EVENTS-1 downto 0) of std_logic;

type mhpmevent_t is array (0 to HPM_NUM_COUNTERS-1) of std_logic_vector(XLEN-1 downto 0);
type mhpmeventh_t is array (0 to HPM_NUM_COUNTERS-1) of std_logic_vector(XLEN-1 downto 0);

type hpmcounters_t is array (3 to HPM_NUM_COUNTERS-1) of std_logic_vector(XLEN downto 0);
type hpmcountersh_t is array (3 to HPM_NUM_COUNTERS-1) of std_logic_vector(XLEN downto 0);
--type mhpmcounters_t is array (HPM_NUM_COUNTERS-1 downto 3) of std_logic_vector(XLEN downto 0);
--type mhpmcountersh_t is array (HPM_NUM_COUNTERS-1 downto 3) of std_logic_vector(XLEN-1 downto 0);

type counters_carry_t is array (HPM_NUM_COUNTERS-1 downto 0) of std_logic;




-------------------------------------------------------------------
------------------------   Defined types   ------------------------
-------------------------------------------------------------------

type states_uc_t is (INIT, PENDING_INST1);

type states_trap_handler is (INIT, EMPTYING, READY, HANDLING, RECOVERING);

subtype csr_exception_cause is std_logic_vector(XLEN-1 downto 0); -- Upper bit is the interrupt bit

subtype priviledge_level is std_logic_vector(1 downto 0);

subtype csr_address is std_logic_vector(11 downto 0);

-- List of 16 possible exceptions
subtype except_list_type is std_logic_vector(15 downto 0);

-- Matrix that indicates the exception list for each pipeline stage
--! @bug Intentar modificar el 5 a STAGE_WB y el 1 a STAGE_IF
type except_stage_type is array (to_integer(unsigned(STAGE_WB)) downto to_integer(unsigned(STAGE_IF))) of except_list_type;

type exception_code is array (27 downto 0) of std_logic_vector(XLEN-1 downto 0);

-- Matrix that indicates the PC value for each pipeline stage

type PC_stage is array (to_integer(unsigned(STAGE_WB)) downto to_integer(unsigned(STAGE_IF))) of std_logic_vector(XLEN-1 downto 0);




-------------------------------------------------------------------
----------------   Constants for priviledge spec   ----------------
-------------------------------------------------------------------

--constant CSR_CAUSE_SOFTWARE_INT   : csr_exception_cause := b"100000";
--constant CSR_CAUSE_TIMER_INT      : csr_exception_cause := b"100001";
--constant CSR_CAUSE_IRQ_BASE       : csr_exception_cause := b"110000";

-- Address values of CSRs to be specified in the inmmediate field of instruccions --
-- CUSTOM CONFIGURATION TRACE REGISTERS (BEGIN) --
constant TRACE_CSR_NUM : integer := 64;
type tracecrs_t is array (0 to TRACE_CSR_NUM-1) of std_logic_vector(XLEN-1 downto 0);

constant CSR_TRACECSR0      : integer := 16#800#;
--constant CSR_TRACECSR0      : std_logic_vector(11 downto 0) := (X"800");
constant CSR_TRACECSR1      : integer := 16#801#;
--constant CSR_TRACECSR1      : std_logic_vector(11 downto 0) := (X"801");
constant CSR_TRACECSR2      : integer := 16#802#;
--constant CSR_TRACECSR2      : std_logic_vector(11 downto 0) := (X"802");
constant CSR_TRACECSR3      : integer := 16#803#;
--constant CSR_TRACECSR3      : std_logic_vector(11 downto 0) := (X"803");
constant CSR_TRACECSR4      : integer := 16#804#;
--constant CSR_TRACECSR4      : std_logic_vector(11 downto 0) := (X"804");
constant CSR_TRACECSR5      : integer := 16#805#;
--constant CSR_TRACECSR5      : std_logic_vector(11 downto 0) := (X"805");
constant CSR_TRACECSR6      : integer := 16#806#;
--constant CSR_TRACECSR6      : std_logic_vector(11 downto 0) := (X"806");
constant CSR_TRACECSR7      : integer := 16#807#;
--constant CSR_TRACECSR7      : std_logic_vector(11 downto 0) := (X"807");
constant CSR_TRACECSR8      : integer := 16#808#;
--constant CSR_TRACECSR8      : std_logic_vector(11 downto 0) := (X"808");
constant CSR_TRACECSR9      : integer := 16#809#;
--constant CSR_TRACECSR9      : std_logic_vector(11 downto 0) := (X"809");
constant CSR_TRACECSR10     : integer := 16#80A#;
--constant CSR_TRACECSR10     : std_logic_vector(11 downto 0) := (X"80A");
constant CSR_TRACECSR11     : integer := 16#80B#;
--constant CSR_TRACECSR11     : std_logic_vector(11 downto 0) := (X"80B");
constant CSR_TRACECSR12     : integer := 16#80C#;
--constant CSR_TRACECSR12     : std_logic_vector(11 downto 0) := (X"80C");
constant CSR_TRACECSR13     : integer := 16#80D#;
--constant CSR_TRACECSR13     : std_logic_vector(11 downto 0) := (X"80D");
constant CSR_TRACECSR14     : integer := 16#80E#;
--constant CSR_TRACECSR14     : std_logic_vector(11 downto 0) := (X"80E");
constant CSR_TRACECSR15     : integer := 16#80F#;
--constant CSR_TRACECSR15     : std_logic_vector(11 downto 0) := (X"80F");
constant CSR_TRACECSR16     : integer := 16#810#;
--constant CSR_TRACECSR16     : std_logic_vector(11 downto 0) := (X"810");
constant CSR_TRACECSR17     : integer := 16#811#;
--constant CSR_TRACECSR17     : std_logic_vector(11 downto 0) := (X"811");
constant CSR_TRACECSR18     : integer := 16#812#;
--constant CSR_TRACECSR18     : std_logic_vector(11 downto 0) := (X"812");
constant CSR_TRACECSR19     : integer := 16#813#;
--constant CSR_TRACECSR19     : std_logic_vector(11 downto 0) := (X"813");
constant CSR_TRACECSR20     : integer := 16#814#;
--constant CSR_TRACECSR20     : std_logic_vector(11 downto 0) := (X"814");
constant CSR_TRACECSR21     : integer := 16#815#;
--constant CSR_TRACECSR21     : std_logic_vector(11 downto 0) := (X"815");
constant CSR_TRACECSR22     : integer := 16#816#;
--constant CSR_TRACECSR22     : std_logic_vector(11 downto 0) := (X"816");
constant CSR_TRACECSR23     : integer := 16#817#;
--constant CSR_TRACECSR23     : std_logic_vector(11 downto 0) := (X"817");
constant CSR_TRACECSR24     : integer := 16#818#;
--constant CSR_TRACECSR24     : std_logic_vector(11 downto 0) := (X"818");
constant CSR_TRACECSR25     : integer := 16#819#;
--constant CSR_TRACECSR25     : std_logic_vector(11 downto 0) := (X"819");
constant CSR_TRACECSR26     : integer := 16#81A#;
--constant CSR_TRACECSR26     : std_logic_vector(11 downto 0) := (X"81A");
constant CSR_TRACECSR27     : integer := 16#81B#;
--constant CSR_TRACECSR27     : std_logic_vector(11 downto 0) := (X"81B");
constant CSR_TRACECSR28     : integer := 16#81C#;
--constant CSR_TRACECSR28     : std_logic_vector(11 downto 0) := (X"81C");
constant CSR_TRACECSR29     : integer := 16#81D#;
--constant CSR_TRACECSR29     : std_logic_vector(11 downto 0) := (X"81D");
constant CSR_TRACECSR30     : integer := 16#81E#;
--constant CSR_TRACECSR30     : std_logic_vector(11 downto 0) := (X"81E");
constant CSR_TRACECSR31     : integer := 16#81F#;
--constant CSR_TRACECSR31     : std_logic_vector(11 downto 0) := (X"81F");
constant CSR_TRACECSR32     : integer := 16#820#;
--constant CSR_TRACECSR32     : std_logic_vector(11 downto 0) := (X"820");
constant CSR_TRACECSR33     : integer := 16#821#;
--constant CSR_TRACECSR33     : std_logic_vector(11 downto 0) := (X"821");
constant CSR_TRACECSR34     : integer := 16#822#;
--constant CSR_TRACECSR34     : std_logic_vector(11 downto 0) := (X"822");
constant CSR_TRACECSR35     : integer := 16#823#;
--constant CSR_TRACECSR35     : std_logic_vector(11 downto 0) := (X"823");
constant CSR_TRACECSR36     : integer := 16#824#;
--constant CSR_TRACECSR36     : std_logic_vector(11 downto 0) := (X"824");
constant CSR_TRACECSR37     : integer := 16#825#;
--constant CSR_TRACECSR37     : std_logic_vector(11 downto 0) := (X"825");
constant CSR_TRACECSR38     : integer := 16#826#;
--constant CSR_TRACECSR38     : std_logic_vector(11 downto 0) := (X"826");
constant CSR_TRACECSR39     : integer := 16#827#;
--constant CSR_TRACECSR39     : std_logic_vector(11 downto 0) := (X"827");
constant CSR_TRACECSR40     : integer := 16#828#;
--constant CSR_TRACECSR40     : std_logic_vector(11 downto 0) := (X"828");
constant CSR_TRACECSR41     : integer := 16#829#;
--constant CSR_TRACECSR41     : std_logic_vector(11 downto 0) := (X"829");
constant CSR_TRACECSR42     : integer := 16#82A#;
--constant CSR_TRACECSR42     : std_logic_vector(11 downto 0) := (X"82A");
constant CSR_TRACECSR43     : integer := 16#82B#;
--constant CSR_TRACECSR43     : std_logic_vector(11 downto 0) := (X"82B");
constant CSR_TRACECSR44     : integer := 16#82C#;
--constant CSR_TRACECSR44     : std_logic_vector(11 downto 0) := (X"82C");
constant CSR_TRACECSR45     : integer := 16#82D#;
--constant CSR_TRACECSR45     : std_logic_vector(11 downto 0) := (X"82D");
constant CSR_TRACECSR46     : integer := 16#82E#;
--constant CSR_TRACECSR46     : std_logic_vector(11 downto 0) := (X"82E");
constant CSR_TRACECSR47     : integer := 16#82F#;
--constant CSR_TRACECSR47     : std_logic_vector(11 downto 0) := (X"82F");
constant CSR_TRACECSR48     : integer := 16#830#;
--constant CSR_TRACECSR48     : std_logic_vector(11 downto 0) := (X"830");
constant CSR_TRACECSR49     : integer := 16#831#;
--constant CSR_TRACECSR49     : std_logic_vector(11 downto 0) := (X"831");
constant CSR_TRACECSR50     : integer := 16#832#;
--constant CSR_TRACECSR50     : std_logic_vector(11 downto 0) := (X"832");
constant CSR_TRACECSR51     : integer := 16#833#;
--constant CSR_TRACECSR51     : std_logic_vector(11 downto 0) := (X"833");
constant CSR_TRACECSR52     : integer := 16#834#;
--constant CSR_TRACECSR52     : std_logic_vector(11 downto 0) := (X"834");
constant CSR_TRACECSR53     : integer := 16#835#;
--constant CSR_TRACECSR53     : std_logic_vector(11 downto 0) := (X"835");
constant CSR_TRACECSR54     : integer := 16#836#;
--constant CSR_TRACECSR54     : std_logic_vector(11 downto 0) := (X"836");
constant CSR_TRACECSR55     : integer := 16#837#;
--constant CSR_TRACECSR55     : std_logic_vector(11 downto 0) := (X"837");
constant CSR_TRACECSR56     : integer := 16#838#;
--constant CSR_TRACECSR56     : std_logic_vector(11 downto 0) := (X"838");
constant CSR_TRACECSR57     : integer := 16#839#;
--constant CSR_TRACECSR57     : std_logic_vector(11 downto 0) := (X"839");
constant CSR_TRACECSR58     : integer := 16#83A#;
--constant CSR_TRACECSR58     : std_logic_vector(11 downto 0) := (X"83A");
constant CSR_TRACECSR59     : integer := 16#83B#;
--constant CSR_TRACECSR59     : std_logic_vector(11 downto 0) := (X"83B");
constant CSR_TRACECSR60     : integer := 16#83C#;
--constant CSR_TRACECSR60     : std_logic_vector(11 downto 0) := (X"83C");
constant CSR_TRACECSR61     : integer := 16#83D#;
--constant CSR_TRACECSR61     : std_logic_vector(11 downto 0) := (X"83D");
constant CSR_TRACECSR62     : integer := 16#83E#;
--constant CSR_TRACECSR62     : std_logic_vector(11 downto 0) := (X"83E");
constant CSR_TRACECSR63     : integer := 16#83F#;
--constant CSR_TRACECSR63     : std_logic_vector(11 downto 0) := (X"83F");

constant TRACE_MEM_NUM : integer := 64;
type tracemem_t is array (0 to TRACE_MEM_NUM-1) of std_logic_vector(XLEN-1 downto 0);

constant CSR_TRACEMEM0      : integer := 16#840#;
--constant CSR_TRACEMEM0      : std_logic_vector(11 downto 0) := X"840";
constant CSR_TRACEMEM1      : integer := 16#841#;
--constant CSR_TRACEMEM1      : std_logic_vector(11 downto 0) := X"841";
constant CSR_TRACEMEM2      : integer := 16#842#;
--constant CSR_TRACEMEM2      : std_logic_vector(11 downto 0) := X"842";
constant CSR_TRACEMEM3      : integer := 16#843#;
--constant CSR_TRACEMEM3      : std_logic_vector(11 downto 0) := X"843";
constant CSR_TRACEMEM4      : integer := 16#844#;
--constant CSR_TRACEMEM4      : std_logic_vector(11 downto 0) := X"844";
constant CSR_TRACEMEM5      : integer := 16#845#;
--constant CSR_TRACEMEM5      : std_logic_vector(11 downto 0) := X"845";
constant CSR_TRACEMEM6      : integer := 16#846#;
--constant CSR_TRACEMEM6      : std_logic_vector(11 downto 0) := X"846";
constant CSR_TRACEMEM7      : integer := 16#847#;
--constant CSR_TRACEMEM7      : std_logic_vector(11 downto 0) := X"847";
constant CSR_TRACEMEM8      : integer := 16#848#;
--constant CSR_TRACEMEM8      : std_logic_vector(11 downto 0) := X"848";
constant CSR_TRACEMEM9      : integer := 16#849#;
--constant CSR_TRACEMEM9      : std_logic_vector(11 downto 0) := X"849";
constant CSR_TRACEMEM10     : integer := 16#84A#;
--constant CSR_TRACEMEM10     : std_logic_vector(11 downto 0) := X"84A";
constant CSR_TRACEMEM11     : integer := 16#84B#;
--constant CSR_TRACEMEM11     : std_logic_vector(11 downto 0) := X"84B";
constant CSR_TRACEMEM12     : integer := 16#84C#;
--constant CSR_TRACEMEM12     : std_logic_vector(11 downto 0) := X"84C";
constant CSR_TRACEMEM13     : integer := 16#84D#;
--constant CSR_TRACEMEM13     : std_logic_vector(11 downto 0) := X"84D";
constant CSR_TRACEMEM14     : integer := 16#84E#;
--constant CSR_TRACEMEM14     : std_logic_vector(11 downto 0) := X"84E";
constant CSR_TRACEMEM15     : integer := 16#84F#;
--constant CSR_TRACEMEM15     : std_logic_vector(11 downto 0) := X"84F";
constant CSR_TRACEMEM16     : integer := 16#850#;
--constant CSR_TRACEMEM16     : std_logic_vector(11 downto 0) := X"850";
constant CSR_TRACEMEM17     : integer := 16#851#;
--constant CSR_TRACEMEM17     : std_logic_vector(11 downto 0) := X"851";
constant CSR_TRACEMEM18     : integer := 16#852#;
--constant CSR_TRACEMEM18     : std_logic_vector(11 downto 0) := X"852";
constant CSR_TRACEMEM19     : integer := 16#853#;
--constant CSR_TRACEMEM19     : std_logic_vector(11 downto 0) := X"853";
constant CSR_TRACEMEM20     : integer := 16#854#;
--constant CSR_TRACEMEM20     : std_logic_vector(11 downto 0) := X"854";
constant CSR_TRACEMEM21     : integer := 16#855#;
--constant CSR_TRACEMEM21     : std_logic_vector(11 downto 0) := X"855";
constant CSR_TRACEMEM22     : integer := 16#856#;
--constant CSR_TRACEMEM22     : std_logic_vector(11 downto 0) := X"856";
constant CSR_TRACEMEM23     : integer := 16#857#;
--constant CSR_TRACEMEM23     : std_logic_vector(11 downto 0) := X"857";
constant CSR_TRACEMEM24     : integer := 16#858#;
--constant CSR_TRACEMEM24     : std_logic_vector(11 downto 0) := X"858";
constant CSR_TRACEMEM25     : integer := 16#859#;
--constant CSR_TRACEMEM25     : std_logic_vector(11 downto 0) := X"859";
constant CSR_TRACEMEM26     : integer := 16#85A#;
--constant CSR_TRACEMEM26     : std_logic_vector(11 downto 0) := X"85A";
constant CSR_TRACEMEM27     : integer := 16#85B#;
--constant CSR_TRACEMEM27     : std_logic_vector(11 downto 0) := X"85B";
constant CSR_TRACEMEM28     : integer := 16#85C#;
--constant CSR_TRACEMEM28     : std_logic_vector(11 downto 0) := X"85C";
constant CSR_TRACEMEM29     : integer := 16#85D#;
--constant CSR_TRACEMEM29     : std_logic_vector(11 downto 0) := X"85D";
constant CSR_TRACEMEM30     : integer := 16#85E#;
--constant CSR_TRACEMEM30     : std_logic_vector(11 downto 0) := X"85E";
constant CSR_TRACEMEM31     : integer := 16#85F#;
--constant CSR_TRACEMEM31     : std_logic_vector(11 downto 0) := X"85F";
constant CSR_TRACEMEM32     : integer := 16#860#;
--constant CSR_TRACEMEM32     : std_logic_vector(11 downto 0) := X"860";
constant CSR_TRACEMEM33     : integer := 16#861#;
--constant CSR_TRACEMEM33     : std_logic_vector(11 downto 0) := X"861";
constant CSR_TRACEMEM34     : integer := 16#862#;
--constant CSR_TRACEMEM34     : std_logic_vector(11 downto 0) := X"862";
constant CSR_TRACEMEM35     : integer := 16#863#;
--constant CSR_TRACEMEM35     : std_logic_vector(11 downto 0) := X"863";
constant CSR_TRACEMEM36     : integer := 16#864#;
--constant CSR_TRACEMEM36     : std_logic_vector(11 downto 0) := X"864";
constant CSR_TRACEMEM37     : integer := 16#865#;
--constant CSR_TRACEMEM37     : std_logic_vector(11 downto 0) := X"865";
constant CSR_TRACEMEM38     : integer := 16#866#;
--constant CSR_TRACEMEM38     : std_logic_vector(11 downto 0) := X"866";
constant CSR_TRACEMEM39     : integer := 16#867#;
--constant CSR_TRACEMEM39     : std_logic_vector(11 downto 0) := X"867";
constant CSR_TRACEMEM40     : integer := 16#868#;
--constant CSR_TRACEMEM40     : std_logic_vector(11 downto 0) := X"868";
constant CSR_TRACEMEM41     : integer := 16#869#;
--constant CSR_TRACEMEM41     : std_logic_vector(11 downto 0) := X"869";
constant CSR_TRACEMEM42     : integer := 16#86A#;
--constant CSR_TRACEMEM42     : std_logic_vector(11 downto 0) := X"86A";
constant CSR_TRACEMEM43     : integer := 16#86B#;
--constant CSR_TRACEMEM43     : std_logic_vector(11 downto 0) := X"86B";
constant CSR_TRACEMEM44     : integer := 16#86C#;
--constant CSR_TRACEMEM44     : std_logic_vector(11 downto 0) := X"86C";
constant CSR_TRACEMEM45     : integer := 16#86D#;
--constant CSR_TRACEMEM45     : std_logic_vector(11 downto 0) := X"86D";
constant CSR_TRACEMEM46     : integer := 16#86E#;
--constant CSR_TRACEMEM46     : std_logic_vector(11 downto 0) := X"86E";
constant CSR_TRACEMEM47     : integer := 16#86F#;
--constant CSR_TRACEMEM47     : std_logic_vector(11 downto 0) := X"86F";
constant CSR_TRACEMEM48     : integer := 16#870#;
--constant CSR_TRACEMEM48     : std_logic_vector(11 downto 0) := X"870";
constant CSR_TRACEMEM49     : integer := 16#871#;
--constant CSR_TRACEMEM49     : std_logic_vector(11 downto 0) := X"871";
constant CSR_TRACEMEM50     : integer := 16#872#;
--constant CSR_TRACEMEM50     : std_logic_vector(11 downto 0) := X"872";
constant CSR_TRACEMEM51     : integer := 16#873#;
--constant CSR_TRACEMEM51     : std_logic_vector(11 downto 0) := X"873";
constant CSR_TRACEMEM52     : integer := 16#874#;
--constant CSR_TRACEMEM52     : std_logic_vector(11 downto 0) := X"874";
constant CSR_TRACEMEM53     : integer := 16#875#;
--constant CSR_TRACEMEM53     : std_logic_vector(11 downto 0) := X"875";
constant CSR_TRACEMEM54     : integer := 16#876#;
--constant CSR_TRACEMEM54     : std_logic_vector(11 downto 0) := X"876";
constant CSR_TRACEMEM55     : integer := 16#877#;
--constant CSR_TRACEMEM55     : std_logic_vector(11 downto 0) := X"877";
constant CSR_TRACEMEM56     : integer := 16#878#;
--constant CSR_TRACEMEM56     : std_logic_vector(11 downto 0) := X"878";
constant CSR_TRACEMEM57     : integer := 16#879#;
--constant CSR_TRACEMEM57     : std_logic_vector(11 downto 0) := X"879";
constant CSR_TRACEMEM58     : integer := 16#87A#;
--constant CSR_TRACEMEM58     : std_logic_vector(11 downto 0) := X"87A";
constant CSR_TRACEMEM59     : integer := 16#87B#;
--constant CSR_TRACEMEM59     : std_logic_vector(11 downto 0) := X"87B";
constant CSR_TRACEMEM60     : integer := 16#87C#;
--constant CSR_TRACEMEM60     : std_logic_vector(11 downto 0) := X"87C";
constant CSR_TRACEMEM61     : integer := 16#87D#;
--constant CSR_TRACEMEM61     : std_logic_vector(11 downto 0) := X"87D";
constant CSR_TRACEMEM62     : integer := 16#87E#;
--constant CSR_TRACEMEM62     : std_logic_vector(11 downto 0) := X"87E";
constant CSR_TRACEMEM63     : integer := 16#87F#;
--constant CSR_TRACEMEM63     : std_logic_vector(11 downto 0) := X"87F";
-- CUSTOM CONFIGURATION TRACE REGISTERS (END) --

constant CSR_CYCLE          : integer := 16#c00#;
constant CSR_TIME           : integer := 16#c01#;
constant CSR_INSTRET        : integer := 16#c02#;
constant CSR_HPMCOUNTER3    : integer := 16#c03#;
constant CSR_HPMCOUNTER4    : integer := 16#c04#;
constant CSR_HPMCOUNTER5    : integer := 16#c05#;
constant CSR_HPMCOUNTER6    : integer := 16#c06#;
constant CSR_HPMCOUNTER7    : integer := 16#c07#;
constant CSR_HPMCOUNTER8    : integer := 16#c08#;
constant CSR_HPMCOUNTER9    : integer := 16#c09#;
constant CSR_HPMCOUNTER10   : integer := 16#c0A#;
constant CSR_HPMCOUNTER11   : integer := 16#c0B#;
constant CSR_HPMCOUNTER12   : integer := 16#c0C#;
constant CSR_HPMCOUNTER13   : integer := 16#c0D#;
constant CSR_HPMCOUNTER14   : integer := 16#c0E#;
constant CSR_HPMCOUNTER15   : integer := 16#c0F#;
constant CSR_HPMCOUNTER16   : integer := 16#c10#;
constant CSR_HPMCOUNTER17   : integer := 16#c11#;
constant CSR_HPMCOUNTER18   : integer := 16#c12#;
constant CSR_HPMCOUNTER19   : integer := 16#c13#;
constant CSR_HPMCOUNTER20   : integer := 16#c14#;
constant CSR_HPMCOUNTER21   : integer := 16#c15#;
constant CSR_HPMCOUNTER22   : integer := 16#c16#;
constant CSR_HPMCOUNTER23   : integer := 16#c17#;
constant CSR_HPMCOUNTER24   : integer := 16#c18#;
constant CSR_HPMCOUNTER25   : integer := 16#c19#;
constant CSR_HPMCOUNTER26   : integer := 16#c1A#;
constant CSR_HPMCOUNTER27   : integer := 16#c1B#;
constant CSR_HPMCOUNTER28   : integer := 16#c1C#;
constant CSR_HPMCOUNTER29   : integer := 16#c1D#;
constant CSR_HPMCOUNTER30   : integer := 16#c1E#;
constant CSR_HPMCOUNTER31   : integer := 16#c1F#;
constant CSR_CYCLEH         : integer := 16#c80#;
constant CSR_TIMEH          : integer := 16#c81#;
constant CSR_INSTRETH       : integer := 16#c82#;
constant CSR_HPMCOUNTER3H   : integer := 16#c83#;
constant CSR_HPMCOUNTER4H   : integer := 16#c84#;
constant CSR_HPMCOUNTER5H   : integer := 16#c85#;
constant CSR_HPMCOUNTER6H   : integer := 16#c86#;
constant CSR_HPMCOUNTER7H   : integer := 16#c87#;
constant CSR_HPMCOUNTER8H   : integer := 16#c88#;
constant CSR_HPMCOUNTER9H   : integer := 16#c89#;
constant CSR_HPMCOUNTER10H  : integer := 16#c8A#;
constant CSR_HPMCOUNTER11H  : integer := 16#c8B#;
constant CSR_HPMCOUNTER12H  : integer := 16#c8C#;
constant CSR_HPMCOUNTER13H  : integer := 16#c8D#;
constant CSR_HPMCOUNTER14H  : integer := 16#c8E#;
constant CSR_HPMCOUNTER15H  : integer := 16#c8F#;
constant CSR_HPMCOUNTER16H  : integer := 16#c90#;
constant CSR_HPMCOUNTER17H  : integer := 16#c91#;
constant CSR_HPMCOUNTER18H  : integer := 16#c92#;
constant CSR_HPMCOUNTER19H  : integer := 16#c93#;
constant CSR_HPMCOUNTER20H  : integer := 16#c94#;
constant CSR_HPMCOUNTER21H  : integer := 16#c95#;
constant CSR_HPMCOUNTER22H  : integer := 16#c96#;
constant CSR_HPMCOUNTER23H  : integer := 16#c97#;
constant CSR_HPMCOUNTER24H  : integer := 16#c98#;
constant CSR_HPMCOUNTER25H  : integer := 16#c99#;
constant CSR_HPMCOUNTER26H  : integer := 16#c9A#;
constant CSR_HPMCOUNTER27H  : integer := 16#c9B#;
constant CSR_HPMCOUNTER28H  : integer := 16#c9C#;
constant CSR_HPMCOUNTER29H  : integer := 16#c9D#;
constant CSR_HPMCOUNTER30H  : integer := 16#c9E#;
constant CSR_HPMCOUNTER31H  : integer := 16#c9F#;

constant CSR_MVENDORID   : integer := 16#f11#;
constant CSR_MARCHID     : integer := 16#f12#;
constant CSR_MIMPID      : integer := 16#f13#;
constant CSR_MHARTID     : integer := 16#f14#;

constant CSR_MSTATUS     : integer := 16#300#;
constant CSR_MISA        : integer := 16#301#;
constant CSR_MTDELEG     : integer := 16#302#;
constant CSR_MIE         : integer := 16#304#;
constant CSR_MTVEC       : integer := 16#305#;
constant CSR_MCOUNTEREN  : integer := 16#306#;

constant CSR_MSCRATCH    : integer := 16#340#;
constant CSR_MEPC        : integer := 16#341#;
constant CSR_MCAUSE      : integer := 16#342#;
--constant CSR_MBADADDR    : integer := x"343#;
constant CSR_MIP         : integer := 16#344#;
constant CSR_MTVAL       : integer := 16#343#;

--constant CSR_MTIMECMP    : integer := to_integer(unsigned'( x"321";       -- ESTO ESTA MAL, MTIMECMP NO ES UN CSR.
--constant CSR_MTIME          : integer := 16#701#;       -- ESTO ESTA MAL, MTIME NO ES EXACTAMENTE UN CSR Y SI LO FUERA ESA NO ES SU DIRECCION ESTANDAR.
constant CSR_MCYCLE         : integer := 16#B00#;
constant CSR_MINSTRET       : integer := 16#B02#;
constant CSR_MHPMCOUNTER3   : integer := 16#B03#;
constant CSR_MHPMCOUNTER4   : integer := 16#B04#;
constant CSR_MHPMCOUNTER5   : integer := 16#B05#;
constant CSR_MHPMCOUNTER6   : integer := 16#B06#;
constant CSR_MHPMCOUNTER7   : integer := 16#B07#;
constant CSR_MHPMCOUNTER8   : integer := 16#B08#;
constant CSR_MHPMCOUNTER9   : integer := 16#B09#;
constant CSR_MHPMCOUNTER10  : integer := 16#B0A#;
constant CSR_MHPMCOUNTER11  : integer := 16#B0B#;
constant CSR_MHPMCOUNTER12  : integer := 16#B0C#;
constant CSR_MHPMCOUNTER13  : integer := 16#B0D#;
constant CSR_MHPMCOUNTER14  : integer := 16#B0E#;
constant CSR_MHPMCOUNTER15  : integer := 16#B0F#;
constant CSR_MHPMCOUNTER16  : integer := 16#B10#;
constant CSR_MHPMCOUNTER17  : integer := 16#B11#;
constant CSR_MHPMCOUNTER18  : integer := 16#B12#;
constant CSR_MHPMCOUNTER19  : integer := 16#B13#;
constant CSR_MHPMCOUNTER20  : integer := 16#B14#;
constant CSR_MHPMCOUNTER21  : integer := 16#B15#;
constant CSR_MHPMCOUNTER22  : integer := 16#B16#;
constant CSR_MHPMCOUNTER23  : integer := 16#B17#;
constant CSR_MHPMCOUNTER24  : integer := 16#B18#;
constant CSR_MHPMCOUNTER25  : integer := 16#B19#;
constant CSR_MHPMCOUNTER26  : integer := 16#B1A#;
constant CSR_MHPMCOUNTER27  : integer := 16#B1B#;
constant CSR_MHPMCOUNTER28  : integer := 16#B1C#;
constant CSR_MHPMCOUNTER29  : integer := 16#B1D#;
constant CSR_MHPMCOUNTER30  : integer := 16#B1E#;
constant CSR_MHPMCOUNTER31  : integer := 16#B1F#;
constant CSR_MCYCLEH        : integer := 16#B80#;
constant CSR_MINSTRETH      : integer := 16#B82#;
constant CSR_MHPMCOUNTER3H  : integer := 16#B83#;
constant CSR_MHPMCOUNTER4H  : integer := 16#B84#;
constant CSR_MHPMCOUNTER5H  : integer := 16#B85#;
constant CSR_MHPMCOUNTER6H  : integer := 16#B86#;
constant CSR_MHPMCOUNTER7H  : integer := 16#B87#;
constant CSR_MHPMCOUNTER8H  : integer := 16#B88#;
constant CSR_MHPMCOUNTER9H  : integer := 16#B89#;
constant CSR_MHPMCOUNTER10H : integer := 16#B8A#;
constant CSR_MHPMCOUNTER11H : integer := 16#B8B#;
constant CSR_MHPMCOUNTER12H : integer := 16#B8C#;
constant CSR_MHPMCOUNTER13H : integer := 16#B8D#;
constant CSR_MHPMCOUNTER14H : integer := 16#B8E#;
constant CSR_MHPMCOUNTER15H : integer := 16#B8F#;
constant CSR_MHPMCOUNTER16H : integer := 16#B90#;
constant CSR_MHPMCOUNTER17H : integer := 16#B91#;
constant CSR_MHPMCOUNTER18H : integer := 16#B92#;
constant CSR_MHPMCOUNTER19H : integer := 16#B93#;
constant CSR_MHPMCOUNTER20H : integer := 16#B94#;
constant CSR_MHPMCOUNTER21H : integer := 16#B95#;
constant CSR_MHPMCOUNTER22H : integer := 16#B96#;
constant CSR_MHPMCOUNTER23H : integer := 16#B97#;
constant CSR_MHPMCOUNTER24H : integer := 16#B98#;
constant CSR_MHPMCOUNTER25H : integer := 16#B99#;
constant CSR_MHPMCOUNTER26H : integer := 16#B9A#;
constant CSR_MHPMCOUNTER27H : integer := 16#B9B#;
constant CSR_MHPMCOUNTER28H : integer := 16#B9C#;
constant CSR_MHPMCOUNTER29H : integer := 16#B9D#;
constant CSR_MHPMCOUNTER30H : integer := 16#B9E#;
constant CSR_MHPMCOUNTER31H : integer := 16#B9F#;


constant CSR_MCOUNTINHIBIT  : integer := 16#320#;
constant CSR_MHPMEVENT3     : integer := 16#323#;
constant CSR_MHPMEVENT4     : integer := 16#324#;
constant CSR_MHPMEVENT5     : integer := 16#325#;
constant CSR_MHPMEVENT6     : integer := 16#326#;
constant CSR_MHPMEVENT7     : integer := 16#327#;
constant CSR_MHPMEVENT8     : integer := 16#328#;
constant CSR_MHPMEVENT9     : integer := 16#329#;
constant CSR_MHPMEVENT10    : integer := 16#32A#;
constant CSR_MHPMEVENT11    : integer := 16#32B#;
constant CSR_MHPMEVENT12    : integer := 16#32C#;
constant CSR_MHPMEVENT13    : integer := 16#32D#;
constant CSR_MHPMEVENT14    : integer := 16#32E#;
constant CSR_MHPMEVENT15    : integer := 16#32F#;
constant CSR_MHPMEVENT16    : integer := 16#330#;
constant CSR_MHPMEVENT17    : integer := 16#331#;
constant CSR_MHPMEVENT18    : integer := 16#332#;
constant CSR_MHPMEVENT19    : integer := 16#333#;
constant CSR_MHPMEVENT20    : integer := 16#334#;
constant CSR_MHPMEVENT21    : integer := 16#335#;
constant CSR_MHPMEVENT22    : integer := 16#336#;
constant CSR_MHPMEVENT23    : integer := 16#337#;
constant CSR_MHPMEVENT24    : integer := 16#338#;
constant CSR_MHPMEVENT25    : integer := 16#339#;
constant CSR_MHPMEVENT26    : integer := 16#33A#;
constant CSR_MHPMEVENT27    : integer := 16#33B#;
constant CSR_MHPMEVENT28    : integer := 16#33C#;
constant CSR_MHPMEVENT29    : integer := 16#33D#;
constant CSR_MHPMEVENT30    : integer := 16#33E#;
constant CSR_MHPMEVENT31    : integer := 16#33F#;

constant CSR_MHPMEVENT0H  : integer := 16#720#;
--constant CSR_MHPMEVENT1H  : integer := 16#721#;
constant CSR_MHPMEVENT2H  : integer := 16#722#;
constant CSR_MHPMEVENT3H  : integer := 16#723#;
constant CSR_MHPMEVENT4H  : integer := 16#724#;
constant CSR_MHPMEVENT5H  : integer := 16#725#;
constant CSR_MHPMEVENT6H  : integer := 16#726#;
constant CSR_MHPMEVENT7H  : integer := 16#727#;
constant CSR_MHPMEVENT8H  : integer := 16#728#;
constant CSR_MHPMEVENT9H  : integer := 16#729#;
constant CSR_MHPMEVENT10H : integer := 16#72A#;
constant CSR_MHPMEVENT11H : integer := 16#72B#;
constant CSR_MHPMEVENT12H : integer := 16#72C#;
constant CSR_MHPMEVENT13H : integer := 16#72D#;
constant CSR_MHPMEVENT14H : integer := 16#72E#;
constant CSR_MHPMEVENT15H : integer := 16#72F#;
constant CSR_MHPMEVENT16H : integer := 16#730#;
constant CSR_MHPMEVENT17H : integer := 16#731#;
constant CSR_MHPMEVENT18H : integer := 16#732#;
constant CSR_MHPMEVENT19H : integer := 16#733#;
constant CSR_MHPMEVENT20H : integer := 16#734#;
constant CSR_MHPMEVENT21H : integer := 16#735#;
constant CSR_MHPMEVENT22H : integer := 16#736#;
constant CSR_MHPMEVENT23H : integer := 16#737#;
constant CSR_MHPMEVENT24H : integer := 16#738#;
constant CSR_MHPMEVENT25H : integer := 16#739#;
constant CSR_MHPMEVENT26H : integer := 16#73A#;
constant CSR_MHPMEVENT27H : integer := 16#73B#;
constant CSR_MHPMEVENT28H : integer := 16#73C#;
constant CSR_MHPMEVENT29H : integer := 16#73D#;
constant CSR_MHPMEVENT30H : integer := 16#73E#;
constant CSR_MHPMEVENT31H : integer := 16#73F#;


constant CSR_TEST        : integer := 16#bf0#;

constant USER_MODE       : priviledge_level  := "00";
constant SUPERVISOR_MODE : priviledge_level  := "01";
constant MACHINE_MODE    : priviledge_level  := "11";


-- Indexes of relevant bits in status register --
constant CSR_STATUS_MIE_INDEX               : natural := 3;
constant CSR_STATUS_MPIE_INDEX              : natural := 7;
constant CSR_STATUS_MPP1_INDEX              : natural := 11;
constant CSR_STATUS_MPP2_INDEX              : natural := 12;
constant CSR_MIP_LCOFIP_INDEX               : natural := 13;
constant CSR_MIP_MEIP_INDEX                 : natural := 11;--añadido por angela
constant CSR_MIP_MTIP_INDEX                 : natural := 7;
constant CSR_MIE_LCOFIE_INDEX               : natural := 13;
constant CSR_MIE_MEIE_INDEX                 : natural := 11;--añadido por angela
constant CSR_MIE_MTIE_INDEX                 : natural := 7;

constant HPM_EVENTH_OF_INDEX                : natural := 31;  -- OF status and int disable that is set when counter overflows.
constant HPM_EVENTH_MINH_INDEX              : natural := 30;  -- If set, counting of events in M-mode is inhibited.
constant HPM_EVENTH_SINH_INDEX              : natural := 29;  -- If set, counting of events in S/HS-mode is inhibited.
constant HPM_EVENTH_UINH_INDEX              : natural := 28;  -- If set, counting of events in U-mode is inhibited.
constant HPM_EVENTH_VSINH_INDEX             : natural := 27;  -- If set, counting of events in VS-mode is inhibited.
constant HPM_EVENTH_VUINH_INDEX             : natural := 26;  -- If set, counting of events in VU-mode is inhibited.
constant HPM_EVENTH_RESERVED_INDEX          : natural := 25;  -- Reserved, value=0.
constant HPM_EVENTH_RESERVED2_INDEX         : natural := 24;  -- Reserved, value=0.

-- Priority associated to each exception (higher value means higher priority) --
constant EXCEP_BREAKPOINT                   : natural := 15;
constant EXCEP_INST_PAGE_FAULT              : natural := 14;
constant EXCEP_INSTR_ACCESS_FAULT           : natural := 13;
constant EXCEP_ILLEGAL_INSTR                : natural := 12;
constant EXCEP_INSTR_ADDRESS_MISALIGN       : natural := 11;
constant EXCEP_ENV_CALL_M_MODE              : natural := 10;
constant EXCEP_ENV_CALL_S_MODE              : natural := 9;
constant EXCEP_ENV_CALL_U_MODE              : natural := 8;
constant EXCEP_STORE_AMO_ADDRESS_MISALIGN   : natural := 7;
constant EXCEP_LOAD_ADDRESS_MISALIGN        : natural := 6;
constant EXCEP_STORE_AMO_PAGE_FAULT         : natural := 5;
constant EXCEP_LOAD_PAGE_FAULT              : natural := 4;
constant EXCEP_STORE_AMO_ACCESS_FAULT       : natural := 3;
constant EXCEP_LOAD_ACCESS_FAULT            : natural := 2;
constant EXCEP_RESERVED                     : natural := 1;
constant EXCEP_RESERVED_FUTURE              : natural := 0;


-- Possible mcause values especifing the codes of exceptions in order of priority
constant mcause_values : exception_code     := (
                                                x"8000000b",--añadido por angela hasta x"80000000"
                                                x"8000000a",
                                                x"80000009",
                                                x"80000008",
                                                x"80000007",
                                                x"80000006",
                                                x"80000005",
                                                x"80000004",
                                                x"80000003",
                                                x"80000002",
                                                x"80000001",
                                                x"80000000",
                                                x"00000003",
                                                x"0000000c",
                                                x"00000001",
                                                x"00000002",
                                                x"00000000",
                                                x"0000000b",
                                                x"00000009",
                                                x"00000008",
                                                x"00000006",
                                                x"00000004",
                                                x"0000000f",
                                                x"0000000d",
                                                x"00000007",
                                                x"00000005",
                                                x"0000000a",
                                                x"0000000e" );

--! TODO: Este valor hay que modificarlo: NO ESTA HECHO EL TRATAMIENTO DE LA INTERRUPCION RESET. Ahora mismo esto no vale para nada. Se le pone un valor absurdo para remarcar su inutilidad.
constant PC_RESET : std_logic_vector(XLEN-1 downto 0) := x"00100fff";

--Interrupts
constant ext_irq_sources:   integer :=2;
constant irq_sources:       integer :=3;

end constants;