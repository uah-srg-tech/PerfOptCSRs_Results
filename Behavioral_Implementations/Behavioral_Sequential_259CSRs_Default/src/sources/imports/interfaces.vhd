----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 22.07.2024 19:38:15
-- Design Name: 
-- Module Name: interfaces - Behavioral
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

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
        needsCSRANDOp  : std_logic;
        validOpCSRR : std_logic;
        validOpCSRW : std_logic; 
        parregEnable: std_logic;
--        parregEnable: std_logic_vector(XLEN-1 downto 0);
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
        parregEnable: std_logic;
--        parregEnable: std_logic_vector(XLEN-1 downto 0);
        regWrite    : std_logic;
        regCSR      : std_logic_vector(11 downto 0);
        data        : std_logic_vector(XLEN-1 downto 0);
        regS1       : std_logic_vector(log2XLEN-1 downto 0);
        regS2       : std_logic_vector(log2XLEN-1 downto 0);
        regD        : std_logic_vector(log2XLEN-1 downto 0);
    end record;

    type O_RMEMWB is record
        inst        : std_logic_vector(XLEN-1 downto 0);
        needsCSROROp  : std_logic;
--        needsCSROROp  : std_logic_vector(XLEN-1 downto 0);
        needsCSRANDOp : std_logic;
--        needsCSRANDOp : std_logic_vector(XLEN-1 downto 0);
        validOpCSRR : std_logic;
        validOpCSRW : std_logic; 
        parregEnable: std_logic;
--        parregEnable: std_logic_vector(XLEN-1 downto 0);
        regWrite    : std_logic;
        regCSR      : std_logic_vector(11 downto 0);
        data        : std_logic_vector(XLEN-1 downto 0);
        regS1       : std_logic_vector(log2XLEN-1 downto 0);
        regS2       : std_logic_vector(log2XLEN-1 downto 0);
        regD        : std_logic_vector(log2XLEN-1 downto 0);
    end record;

    type O_GPR is record
        regS1_valueWB: std_logic_vector(XLEN-1 downto 0);
        regS1_valueEX: std_logic_vector(XLEN-1 downto 0);
        regS2_value: std_logic_vector(XLEN-1 downto 0);
    end record;

    type special_array is array (0 to 258) of std_logic_vector(XLEN-1 downto 0);
--    type special_array is array (0 to 259) of std_logic_vector(XLEN-1 downto 0);
--    type special_array is array (259 downto 0) of std_logic_vector(XLEN-1 downto 0);
    type O_CSR is record
        data: std_logic_vector(XLEN-1 downto 0);
        exception   : std_logic;
        special: special_array;
        plevel: priviledge_level;
    end record;

    type O_PROCIF is record
--        parregEnable: std_logic;
        PLevel  : priviledge_level;
        special : special_array;
    end record;

    -- START of inputs

    type I_DEC is record
--        isCSR       : std_logic;
--        validOpCSRR : std_logic;
--        validOpCSRW : std_logic;
--        parregEnable: std_logic;
        inst        : std_logic_vector(XLEN-1 downto 0);
--        regWrite    : std_logic;
--        OPCode      : std_logic_vector(6 downto 0);
--        fun3        : std_logic_vector(2 downto 0);
--        data        : std_logic_vector(XLEN-1 downto 0);
--        regCSR      : std_logic_vector(11 downto 0);
--        regS1       : std_logic_vector(log2XLEN-1 downto 0);
--        regS2       : std_logic_vector(log2XLEN-1 downto 0);
--        regD        : std_logic_vector(log2XLEN-1 downto 0);
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