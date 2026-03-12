----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 22.07.2024 19:08:40
-- Design Name: 
-- Module Name: R_ID_EX - Behavioral
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
use work.interfaces.all;

entity R_ID_EX is
    Port (
        I_clock : in STD_LOGIC;
        I_reset : in std_logic;
        inputs  : in I_RIDEX;
        outputs : out O_RIDEX
--        I_address_ID: in std_logic_vector(XLEN-1 downto 0);
--        O_adress_EX : out std_logic_vector(XLEN-1 downto 0)
    );
end R_ID_EX;

architecture Behavioral of R_ID_EX is
    signal inst         : std_logic_vector(XLEN-1 downto 0);
    signal needsCSROROp   : std_logic;
    signal needsCSRANDOp  : std_logic;
    signal validOpCSRR  : std_logic;
    signal validOpCSRW  : std_logic;
    signal parregEnable : std_logic;
--    signal parregEnable : std_logic_vector(XLEN-1 downto 0);
    signal regWrite     : std_logic;
    signal excepR_flag : std_logic;
    signal excepW_flag : std_logic;
    signal data         : std_logic_vector(XLEN-1 downto 0);
    signal regCSR       : std_logic_vector(11 downto 0);
    signal regS1        : std_logic_vector(log2XLEN-1 downto 0);
    signal regS2        : std_logic_vector(log2XLEN-1 downto 0);
    signal regD         : std_logic_vector(log2XLEN-1 downto 0);

--    attribute KEEP : string;
--    attribute KEEP of parregEnable: signal is "true";
begin
    process (I_clock, I_reset)
    begin
        if I_reset = '1' then
            inst        <= (others => '0');
            needsCSROROp  <= '0';
            needsCSRANDOp <= '0';
            validOpCSRR <= '0';
            validOpCSRW <= '0';
            parregEnable<= '0';
--            parregEnable<=(others => '0');
            regWrite    <= '0';
            excepR_flag <= '0';
            excepW_flag <= '0';
            data        <= (others => '0');
            regCSR      <= (others => '0');
            regS1       <= (others => '0');
            regS2       <= (others => '0');
            regD        <= (others => '0');
        elsif rising_edge(I_clock) then
            inst        <= inputs.DEC_outputs.inst;
            needsCSROROp  <= inputs.DEC_outputs.needsCSROROp;
            needsCSRANDOp <= inputs.DEC_outputs.needsCSRANDOp;
            validOpCSRR <= inputs.DEC_outputs.validOpCSRR;
            validOpCSRW <= inputs.DEC_outputs.validOpCSRW;
            parregEnable<= inputs.DEC_outputs.parregEnable;
--            parregEnable<= (others=>inputs.DEC_outputs.parregEnable);
            regWrite    <= inputs.DEC_outputs.regWrite;
            excepR_flag    <= inputs.DEC_outputs.excepR_flag;
            excepW_flag    <= inputs.DEC_outputs.excepW_flag;
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
    outputs.excepR_flag <= excepR_flag;
    outputs.excepW_flag <= excepW_flag;
    outputs.data        <= data;
    outputs.regCSR      <= regCSR;
    outputs.regS1       <= regS1;
    outputs.regS2       <= regS2;
    outputs.regD        <= regD;

end Behavioral;
