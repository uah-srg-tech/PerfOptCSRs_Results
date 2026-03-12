----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 22.07.2024 19:08:40
-- Design Name: 
-- Module Name: R_MEM_WB - Behavioral
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

entity R_MEM_WB is
    Port (
        I_clock : in STD_LOGIC;
        I_reset : in std_logic;
        inputs  : in I_RMEMWB;
        outputs : out O_RMEMWB
--        I_address_MEM: in std_logic_vector(XLEN-1 downto 0);
--        O_adress_WB : out std_logic_vector(XLEN-1 downto 0)
    );
end R_MEM_WB;

architecture Behavioral of R_MEM_WB is
    signal inst         : std_logic_vector(XLEN-1 downto 0);
    signal needsCSROROp : std_logic;
--    signal needsCSROROp : std_logic_vector(XLEN-1 downto 0);
    signal needsCSRANDOp: std_logic;
--    signal needsCSRANDOp: std_logic_vector(XLEN-1 downto 0);
    signal validOpCSRR  : std_logic;
    signal validOpCSRW  : std_logic;
    signal parregEnable : std_logic;
--    signal parregEnable : std_logic_vector(XLEN-1 downto 0);
    signal regWrite     : std_logic;
    signal regCSR       : std_logic_vector(11 downto 0);
    signal data         : std_logic_vector(XLEN-1 downto 0);
    signal regS1        : std_logic_vector(log2XLEN-1 downto 0);
    signal regS2        : std_logic_vector(log2XLEN-1 downto 0);
    signal regD         : std_logic_vector(log2XLEN-1 downto 0);

----    attribute KEEP : string;
----    attribute KEEP of needsCSROROp : signal is "true";
----    attribute KEEP of needsCSRANDOp: signal is "true";
----    attribute KEEP of parregEnable: signal is "true";
----    attribute MAX_FANOUT:integer;
----    attribute MAX_FANOUT of regS1 : signal is 6;
----    attribute MAX_FANOUT of regD : signal is 6;
------    attribute MAX_FANOUT of needsCSROROp : signal is 87;
------    attribute MAX_FANOUT of needsCSRANDOp: signal is 87;
----    attribute MAX_FANOUT of parregEnable : signal is 87;
----    attribute MAX_FANOUT of needsCSROROp : signal is 60;
----    attribute MAX_FANOUT of needsCSRANDOp: signal is 60;
----    attribute MAX_FANOUT of parregEnable : signal is 60;
----    attribute MAX_FANOUT of needsCSROROp : signal is 50;
----    attribute MAX_FANOUT of needsCSRANDOp: signal is 50;
----    attribute MAX_FANOUT of parregEnable : signal is 50;
----    attribute MAX_FANOUT of needsCSROROp : signal is 33;
----    attribute MAX_FANOUT of needsCSRANDOp: signal is 33;
----    attribute MAX_FANOUT of parregEnable : signal is 33;
----    attribute MAX_FANOUT of needsCSROROp : signal is 10;
----    attribute MAX_FANOUT of needsCSRANDOp: signal is 10;
----    attribute MAX_FANOUT of parregEnable : signal is 10;
--    attribute extract_reset : string;
--    attribute extract_reset of data: signal is "false";
begin
    process (I_clock, I_reset)
--    process (I_clock)
    begin
        if rising_edge(I_clock) then
--        if I_reset = '1' then
--            inst        <= (others => '0');
----            needsCSROp  <= '0';
--            needsCSROROp  <= (others=>'0');
--            needsCSRANDOp <= (others=>'0');
--            validOpCSRR <= '0';
--            validOpCSRW <= '0';
----            parregEnable<= '0';
--            parregEnable<= (others=>'0');
--            regWrite    <= '0';
--            regCSR      <= (others => '0');
--            data        <= (others => '0');
--            regS1       <= (others => '0');
--            regS2       <= (others => '0');
--            regD        <= (others => '0');
--        elsif rising_edge(I_clock) then
--        else
            inst        <= inputs.REXMEM_outputs.inst;
            needsCSROROp  <= inputs.REXMEM_outputs.needsCSROROp;
--            needsCSROROp  <= (others=>inputs.REXMEM_outputs.needsCSROROp);
            needsCSRANDOp <= inputs.REXMEM_outputs.needsCSRANDOp;
--            needsCSRANDOp <= (others=>inputs.REXMEM_outputs.needsCSRANDOp);
            validOpCSRR <= inputs.REXMEM_outputs.validOpCSRR;
            validOpCSRW <= inputs.REXMEM_outputs.validOpCSRW;
            parregEnable<= inputs.REXMEM_outputs.parregEnable;
--            parregEnable<= (others=>inputs.REXMEM_outputs.parregEnable);
            regWrite    <= inputs.REXMEM_outputs.regWrite;
            regCSR      <= inputs.REXMEM_outputs.regCSR;
            if inputs.REXMEM_outputs.needsCSROROp = '1' then
                if inputs.REXMEM_outputs.needsCSRANDOp = '1' then
                    data<=inputs.GPRs_outputs.regS1_valueWB;
                else
--                    data<=inputs.GPRs_outputs.regS1_valueEX or inputs.RIDEX_outputs.data;
                    data<=inputs.GPRs_outputs.regS1_valueEX or inputs.CSRs_outputs.valueToSetClear;
                end if;
            else
                if inputs.REXMEM_outputs.needsCSRANDOp = '1' then
                    data<=inputs.GPRs_outputs.regS1_valueEX and inputs.CSRs_outputs.valueToSetClear;
                else
                    data<=inputs.REXMEM_outputs.data;
                end if;
            end if;
--            data        <= inputs.REXMEM_outputs.data;
--            data        <= not (inputs.REXMEM_outputs.data and (XLEN-1 downto 0 =>inputs.REXMEM_outputs.regWrite));
            regS1       <= inputs.REXMEM_outputs.regS1;
            regS2       <= inputs.REXMEM_outputs.regS2;
            regD        <= inputs.REXMEM_outputs.regD;
        end if;
--        end if;
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