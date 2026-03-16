library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library work;
use work.constants.all;

package interfaces is

    type O_DEC is record
        inst        : std_logic_vector(XLEN-1 downto 0);
        needsCSROROp  : std_logic;
        needsCSRANDOp : std_logic;
        validOpCSRR : std_logic;
        validOpCSRW : std_logic; 
        parregEnable: std_logic;
        regWrite    : std_logic;
        exception   : std_logic;
        data        : std_logic_vector(XLEN-1 downto 0);
        regCSR      : std_logic_vector(11 downto 0);
        regS1       : std_logic_vector(log2XLEN-1 downto 0);
        regS2       : std_logic_vector(log2XLEN-1 downto 0);
        regD        : std_logic_vector(log2XLEN-1 downto 0);
    end record;

    type O_RIDEX is record
        inst        : std_logic_vector(XLEN-1 downto 0);
        needsCSROROp  : std_logic;
        needsCSRANDOp : std_logic;
        validOpCSRR : std_logic;
        validOpCSRW : std_logic; 
        parregEnable: std_logic;
        regWrite    : std_logic;
        data        : std_logic_vector(XLEN-1 downto 0);
        regCSR      : std_logic_vector(11 downto 0);
        regS1       : std_logic_vector(log2XLEN-1 downto 0);
        regS2       : std_logic_vector(log2XLEN-1 downto 0);
        regD        : std_logic_vector(log2XLEN-1 downto 0);
    end record;

    type O_REXMEM is record
        inst        : std_logic_vector(XLEN-1 downto 0);
        needsCSROROp  : std_logic;
        needsCSRANDOp : std_logic;
        validOpCSRR : std_logic;
        validOpCSRW : std_logic; 
        parregEnable: std_logic_vector(XLEN-1 downto 0);
        regWrite    : std_logic_vector(XLEN/4-1 downto 0);
        regCSR      : std_logic_vector(11 downto 0);
        data        : std_logic_vector(XLEN-1 downto 0);
        regS1       : std_logic_vector(log2XLEN-1 downto 0);
        regS2       : std_logic_vector(log2XLEN-1 downto 0);
        regD        : std_logic_vector(log2XLEN-1 downto 0);
    end record;

    type O_RMEMWB is record
        inst        : std_logic_vector(XLEN-1 downto 0);
        needsCSROROp  : std_logic_vector(XLEN-1 downto 0);
        needsCSRANDOp : std_logic_vector(XLEN-1 downto 0);
        validOpCSRR : std_logic_vector(XLEN/2-1 downto 0);
        validOpCSRW : std_logic; 
        parregEnable: std_logic_vector(XLEN-1 downto 0);
        regWrite    : std_logic_vector(XLEN/2-1 downto 0);
        regCSR      : std_logic_vector(11 downto 0);
        data        : std_logic_vector(XLEN-1 downto 0);
        regS1       : std_logic_vector(log2XLEN-1 downto 0);
        regS2       : std_logic_vector(log2XLEN-1 downto 0);
        regD        : std_logic_vector(log2XLEN-1 downto 0);
    end record;

    type O_GPR is record
        regS1_valueWB: std_logic_vector(3*XLEN-1 downto 0);
        regS1_valueEX: std_logic_vector(XLEN-1 downto 0);
        regS2_value: std_logic_vector(XLEN-1 downto 0);
    end record;

    type special_array is array (0 to 259) of std_logic_vector(XLEN-1 downto 0);
    type O_CSR is record
        data: std_logic_vector(XLEN-1 downto 0);
        exception   : std_logic;
        special: special_array;
    end record;

    type O_PROCIF is record
        PLevel  : priviledge_level;
        special: special_array;
    end record;

    -- START of inputs

    type I_DEC is record
        inst        : std_logic_vector(XLEN-1 downto 0);
        RIDEX_outputs   : O_RIDEX;
        REXMEM_outputs  : O_REXMEM;
        RMEMWB_outputs  : O_RMEMWB;
    end record;

    type I_RIDEX is record
        DEC_outputs:    O_DEC;
    end record;

    type I_REXMEM is record
        RIDEX_outputs:    O_RIDEX;
    end record;

    type I_RMEMWB is record
        PROCIFace_outputs   : O_PROCIF;
        REXMEM_outputs      : O_REXMEM;
    end record;

    type I_GPR is record
        RIDEX_outputs   : O_RIDEX;
        REXMEM_outputs  : O_REXMEM;
        RMEMWB_outputs  : O_RMEMWB;
        CSRs_outputs    : O_CSR;
    end record;

    type I_CSR is record
        DEC_outputs         : O_DEC;
        RIDEX_outputs       : O_RIDEX;
        REXMEM_outputs      : O_REXMEM;
        RMEMWB_outputs      : O_RMEMWB;
        GPRs_outputs        : O_GPR;
        PROCIFace_outputs   : O_PROCIF;
    end record;

    type I_PROCIF is record
        REXMEM_outputs  : O_REXMEM;
        CSRs_outputs    : O_CSR;
    end record;

end interfaces;