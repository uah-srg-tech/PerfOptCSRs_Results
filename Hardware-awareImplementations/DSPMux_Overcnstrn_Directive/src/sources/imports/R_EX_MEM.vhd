----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 22.07.2024 19:08:40
-- Design Name: 
-- Module Name: R_EX_MEM - Behavioral
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

entity R_EX_MEM is
    Port (
        I_clock : in STD_LOGIC;
        I_reset : in std_logic;
        inputs  : in I_REXMEM;
        outputs : out O_REXMEM
--        I_address_EX: in std_logic_vector(XLEN-1 downto 0);
--        O_adress_MEM : out std_logic_vector(XLEN-1 downto 0)
    );
end R_EX_MEM;

architecture Behavioral of R_EX_MEM is
    signal inst         : std_logic_vector(XLEN-1 downto 0);
    signal needsCSROROp : std_logic;
    signal needsCSRANDOp: std_logic;
    signal validOpCSRR  : std_logic;
    signal validOpCSRW  : std_logic;
--    signal validOpCSRW  : std_logic_vector(XLEN/2-1 downto 0);
--    signal parregEnable : std_logic;
--    signal parregEnable : std_logic_vector(XLEN/2-1 downto 0);
    signal parregEnable : std_logic_vector(XLEN-1 downto 0);
--    signal regWrite     : std_logic;
    signal regWrite     : std_logic_vector(XLEN/4-1 downto 0);
    signal regCSR : std_logic_vector(11 downto 0);
    signal data   : std_logic_vector(XLEN-1 downto 0);
--    signal regS1  : std_logic_vector(4*log2XLEN-1 downto 0);
    signal regS1  : std_logic_vector(log2XLEN-1 downto 0);
    signal regS2  : std_logic_vector(log2XLEN-1 downto 0);
    signal regD   : std_logic_vector(log2XLEN-1 downto 0);

--    attribute MAX_FANOUT:integer;
--    attribute MAX_FANOUT of parregEnable : signal is 20;
--    attribute KEEP : string;
--    attribute KEEP of parregEnable: signal is "true";
--    attribute DONT_TOUCH:string;
--    attribute DONT_TOUCH of validOpCSRW : signal is "true";
--    attribute DONT_TOUCH of regS1 : signal is "true";
begin
--    process (I_clock, I_reset)
    process (I_clock)
    begin
        if rising_edge(I_clock) then
--        if I_reset = '1' then
--            inst        <= (others => '0');
--            needsCSROROp  <= '0';
--            needsCSRANDOp <= '0';
--            validOpCSRR <= '0';
--            validOpCSRW <= '0';
----            validOpCSRW <= (others=>'0');
----            parregEnable<= '0';
--            parregEnable<= (others=>'0');
--            regWrite    <= '0';
--            regCSR      <= (others => '0');
--            data        <= (others => '0');
--            regS1       <= (others => '0');
--            regS2       <= (others => '0');
--            regD        <= (others => '0');
----        elsif rising_edge(I_clock) then
--        else
            inst        <= inputs.RIDEX_outputs.inst;
            needsCSROROp  <= inputs.RIDEX_outputs.needsCSROROp;
            needsCSRANDOp <= inputs.RIDEX_outputs.needsCSRANDOp;
            validOpCSRR <= inputs.RIDEX_outputs.validOpCSRR;
            validOpCSRW <= inputs.RIDEX_outputs.validOpCSRW;
--            validOpCSRW <= (others=>inputs.RIDEX_outputs.validOpCSRW);
            parregEnable<= (others=>inputs.RIDEX_outputs.parregEnable);
--            parregEnable<= inputs.RIDEX_outputs.parregEnable);
--            regWrite    <= inputs.RIDEX_outputs.regWrite;
            regWrite    <= (others=>inputs.RIDEX_outputs.regWrite);
            regCSR      <= inputs.RIDEX_outputs.regCSR;
            data        <= inputs.RIDEX_outputs.data;
--            data        <= not (inputs.RIDEX_outputs.data and (XLEN-1 downto 0 =>inputs.RIDEX_outputs.regWrite));
            regS1       <= inputs.RIDEX_outputs.regS1;
            regS2       <= inputs.RIDEX_outputs.regS2;
            regD        <= inputs.RIDEX_outputs.regD;
--            for i in log2XLEN-1 downto 0 loop
--                regS1(4*i)  <=inputs.RIDEX_outputs.regS1(i);
--                regS1(4*i+1)<=inputs.RIDEX_outputs.regS1(i);
--                regS1(4*i+2)<=inputs.RIDEX_outputs.regS1(i);
--                regS1(4*i+3)<=inputs.RIDEX_outputs.regS1(i);

----                regD(4*i)  <=inputs.RIDEX_outputs.regD(i);
----                regD(4*i+1)<=inputs.RIDEX_outputs.regD(i);
----                regD(4*i+2)<=inputs.RIDEX_outputs.regD(i);
----                regD(4*i+3)<=inputs.RIDEX_outputs.regD(i);
--            end loop;
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
    outputs.regCSR      <= regCSR;
    outputs.data        <= data;
    outputs.regS1       <= regS1;
    outputs.regS2       <= regS2;
    outputs.regD        <= regD;

end Behavioral;