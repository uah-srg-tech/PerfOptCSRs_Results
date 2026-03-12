----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 22.07.2024 19:08:40
-- Design Name: 
-- Module Name: GPRs - Behavioral
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
library UNISIM;
use UNISIM.VComponents.all;

library work;
use work.constants.all;
use work.interfaces.all;

entity GPRs is
    port(
        I_clock:    in std_logic;
        I_reset:    in std_logic;
        inputs:     in  I_GPR;
        outputs:    out O_GPR
    );
end GPRs;

architecture Behavioral of GPRs is
    type store_registers is array(0 to 31) of std_logic_vector(XLEN-1 downto 0);
    constant REG_INIT : store_registers := (
        X"00000000", X"00000000", X"00001F00", X"00000000", X"00000000", X"00000000", X"00000000", X"00000000",
        X"00000000", X"00000000", X"00000000", X"00000000", X"00000000", X"00000000", X"00000000", X"00000000",
        X"00000000", X"00000000", X"00000000", X"00000000", X"00000000", X"00000000", X"00000000", X"00000000",
        X"00000000", X"00000000", X"00000000", X"00000000", X"00000000", X"00000000", X"00000000", X"00000000"
    );
    signal regs:        store_registers := REG_INIT;
    signal regS1_value   : std_logic_vector(XLEN-1 downto 0):=XLEN_ZERO;
    signal regS1_valueWB : std_logic_vector(XLEN-1 downto 0):=XLEN_ZERO;
    signal regS1_valueEX : std_logic_vector(XLEN-1 downto 0);

    signal we : std_logic;

    attribute ram_style : string;
--    attribute ram_style of regs : signal is "block";
    attribute ram_style of regs : signal is "distributed";

--    attribute MAX_FANOUT:integer;
----    attribute MAX_FANOUT of regS1_valueWB : signal is 60;
--    attribute MAX_FANOUT of regS1_value : signal is 88;
----    attribute MAX_FANOUT of regS1_value : signal is 33;
    signal dummy: std_logic_vector(XLEN-1 downto 0);
    function gen_init(i : natural) return bit_vector is begin
        if i>=8 and i <= 12 then
            return X"00000004";
--            return X"0000000000000004";
--            return X"00000000000000000000000000000004";
        else
            return X"00000000";
--            return X"0000000000000000";
--            return X"00000000000000000000000000000000";
        end if;
    end function;
begin

----    regWrite    <= inputs.RMEMWB_outputs.ctrl_WB(1);
----    atomicCSR   <= '1' when inputs.RMEMWB_outputs.ctrl_WB = WB_CSR_ATOMIC else '0';
--    we<=inputs.RMEMWB_outputs.validOpCSRR or inputs.RMEMWB_outputs.regWrite;
----    we<=inputs.CSRs_outputs.gpr_we;
--    gprs:for j in XLEN-1 downto 0 generate
--        attribute RLOC  :string;
--        attribute U_SET  :string;
----        attribute BEL  :string;
--        attribute U_SET of RAM32X1D_inst : label is "gpr_setJ"& integer'image(j/2);
--        attribute RLOC  of RAM32X1D_inst : label is "X0Y0";
--    begin
--        RAM32X1D_inst : RAM32X1D
----        RAM32X1D_inst : RAM64X1D
----        RAM32X1D_inst : RAM128X1D
--        generic map (
--            INIT => gen_init(j)) -- Initial contents of RAM
----            INIT => X"00000000") -- Initial contents of RAM
----            INIT => X"00000004") -- Initial contents of RAM
--        port map (
----            DPO => outputs.regS1_valueWB(j),     -- Read-only 1-bit data output
--            DPO => regS1_value(j),     -- Read-only 1-bit data output
--            SPO => dummy(j),     -- R/W 1-bit data output
--            A0 => inputs.RMEMWB_outputs.regD(0),       -- R/W address[0] input bit
--            A1 => inputs.RMEMWB_outputs.regD(1),       -- R/W address[1] input bit
--            A2 => inputs.RMEMWB_outputs.regD(2),       -- R/W address[2] input bit
--            A3 => inputs.RMEMWB_outputs.regD(3),       -- R/W address[3] input bit
--            A4 => inputs.RMEMWB_outputs.regD(4),       -- R/W address[4] input bit
----            A(5) => '0',
----            A(6) => '0',
----            A0 => inputs.CSRs_outputs.regD(0),       -- R/W address[0] input bit
----            A1 => inputs.CSRs_outputs.regD(1),       -- R/W address[1] input bit
----            A2 => inputs.CSRs_outputs.regD(2),       -- R/W address[2] input bit
----            A3 => inputs.CSRs_outputs.regD(3),       -- R/W address[3] input bit
----            A4 => inputs.CSRs_outputs.regD(4),       -- R/W address[4] input bit
--            D => inputs.csrs_outputs.data(j),         -- Write 1-bit data input
----            DPRA0 => inputs.RMEMWB_outputs.regS1(0), -- Read-only address[0] input bit
----            DPRA1 => inputs.RMEMWB_outputs.regS1(1), -- Read-only address[1] input bit
----            DPRA2 => inputs.RMEMWB_outputs.regS1(2), -- Read-only address[2] input bit
----            DPRA3 => inputs.RMEMWB_outputs.regS1(3), -- Read-only address[3] input bit
----            DPRA4 => inputs.RMEMWB_outputs.regS1(4), -- Read-only address[4] input bit
--            DPRA0 => inputs.REXMEM_outputs.regS1(0), -- Read-only address[0] input bit
--            DPRA1 => inputs.REXMEM_outputs.regS1(1), -- Read-only address[1] input bit
--            DPRA2 => inputs.REXMEM_outputs.regS1(2), -- Read-only address[2] input bit
--            DPRA3 => inputs.REXMEM_outputs.regS1(3), -- Read-only address[3] input bit
--            DPRA4 => inputs.REXMEM_outputs.regS1(4), -- Read-only address[4] input bit
----            DPRA(5) => '0',
----            DPRA(6) => '0',
--            WCLK => I_clock,   -- Write clock input
--            WE => we       -- Write enable input
--        );
--    end generate;
--    process(I_clock)
--    begin
--        if rising_edge(I_clock) then        -- This delays the output from the GPRs one cycle which delays its arrival to the CSRs in case the written value would inmediately be read 
--            regS1_valueWB <= regS1_value;   -- and written to CSRs. In behavioral simulation this is not needed as the arrival is inmediate, but it worsens the timing quite significantly,
--        end if;                             -- and therefore it is included in the final design. Nonetheless, in a real CPU there would be a forwarding unit which would solve this issue.
--    end process;
--    outputs.regS1_valueWB <= regS1_valueWB;
----    outputs.regS1_valueWB <= regS1_value;
--    process(I_clock, I_reset)
--    process(I_clock,inputs)
    process(I_clock)
    begin
--        if falling_edge(I_clock) then
        if rising_edge(I_clock) then
            if inputs.RMEMWB_outputs.validOpCSRR = '1' then
--                if inputs.RMEMWB_outputs.regD /= R0 then -- Con esto las instrucciones de CSRs de solo escritura funcionan.
                    regs(to_integer(unsigned(inputs.RMEMWB_outputs.regD))) <= inputs.csrs_outputs.data;
                    regS1_valueWB <= inputs.csrs_outputs.data;
--                end if;
            elsif inputs.RMEMWB_outputs.regWrite = '1' then
--                if inputs.RMEMWB_outputs.regD /= R0 then -- El tratamiento de excepciones hay que hacerlo en el durante la etapa de decodificación y no durante la escritura del registro.
                    regs(to_integer(unsigned(inputs.RMEMWB_outputs.regD))) <= inputs.RMEMWB_outputs.data;
                    regS1_valueWB <= inputs.RMEMWB_outputs.data;
--                end if;
            end if;
--            if inputs.RMEMWB_outputs.regWrite = '1' then--FROMHERE
--                    regs(to_integer(unsigned(inputs.RMEMWB_outputs.regD))) <= inputs.RMEMWB_outputs.data;
--                    outputs.regS1_valueWB <= inputs.RMEMWB_outputs.data;
----                    outputs.regS2_value <= inputs.RMEMWB_outputs.data;
--            end if;--TOHERE
--            else
--            regS1_valueWB <= regs(to_integer(unsigned(inputs.RMEMWB_outputs.regS1)));
            regS1_valueWB <= regs(to_integer(unsigned(inputs.REXMEM_outputs.regS1)));
--            outputs.regS2_value <= regs(to_integer(unsigned(inputs.RIDEX_outputs.regS2)));
--            end if;
--            if inputs.RMEMWB_outputs.validOpCSRR = '1' then
--                    regs(to_integer(unsigned(inputs.RMEMWB_outputs.regD))) <= inputs.csrs_outputs.data;
----                    regS1_value <= inputs.csrs_outputs.data;
----                    outputs.regS2_value <= inputs.csrs_outputs.data;
--            end if;
----            else
----            regS1_value <= regs(to_integer(unsigned(inputs.RMEMWB_outputs.regS1))); 
----            for j in XLEN-1 downto 0 loop
--                if inputs.RMEMWB_outputs.validOpCSRW = '1' then
----                    regS1_valueWB(j) <= regs(to_integer(unsigned(inputs.REXMEM_outputs.regS1)))(j); -- Provisionalmente, lo leo con la direccion de EXMEM para que se guarde en el FF en MEMWB y llegue a tiempo.
--                    regS1_valueWB <= regs(to_integer(unsigned(inputs.REXMEM_outputs.regS1))); -- Provisionalmente, lo leo con la direccion de EXMEM para que se guarde en el FF en MEMWB y llegue a tiempo.
--                else
----                    regS1_valueWB(j) <= inputs.RMEMWB_outputs.parregEnable(j);
--                    regS1_valueWB <= inputs.RMEMWB_outputs.parregEnable;
--                end if;
----            end loop;
----            outputs.regS2_value <= regs(to_integer(unsigned(inputs.RIDEX_outputs.regS2)));
----            end if;
----            outputs.regS1_value <= regs(to_integer(unsigned(inputs.RIDEX_outputs.regS1)));
----            outputs.regS2_value <= regs(to_integer(unsigned(inputs.RIDEX_outputs.regS2)));
        end if;
--        if rising_edge(I_clock) then
--            outputs.regS1_value <= regs(to_integer(unsigned(inputs.REXMEM_outputs.regS1)));
--            outputs.regS1_value <= regs(to_integer(unsigned(inputs.RMEMWB_outputs.regS1)));
--            outputs.regS2_value <= regs(to_integer(unsigned(inputs.RIDEX_outputs.regS2)));
--        end if;


--        -- This should be in the reset trap routine. This way GPRs can be implemented as BRAMs.
--        if I_reset = RESET then
--            regs<=REG_INIT;
--        end if;
    end process;
    outputs.regS1_valueWB <= regS1_valueWB;
--                outputs.regS1_value <= regs(to_integer(unsigned(inputs.RMEMWB_outputs.regS1)));


--    process(I_clock)
--    begin
--        if falling_edge(I_clock) then
----        if rising_edge(I_clock) then
----            if inputs.RMEMWB_outputs.validOpCSRR = '1' then
------                if inputs.RMEMWB_outputs.regD /= R0 then -- Con esto las instrucciones de CSRs de solo escritura funcionan.
----                    regs(to_integer(unsigned(inputs.RMEMWB_outputs.regD))) <= inputs.csrs_outputs.data;
------                end if;
----            elsif inputs.RMEMWB_outputs.regWrite = '1' then
------                if inputs.RMEMWB_outputs.regD /= R0 then -- El tratamiento de excepciones hay que hacerlo en el durante la etapa de decodificación y no durante la escritura del registro.
----                    regs(to_integer(unsigned(inputs.RMEMWB_outputs.regD))) <= inputs.RMEMWB_outputs.data;
------                end if;
----            end if;
----            if inputs.RMEMWB_outputs.regWrite = '1' then
----                    regs(to_integer(unsigned(inputs.RMEMWB_outputs.regD))) <= inputs.RMEMWB_outputs.data;
----            end if;
--            if inputs.RMEMWB_outputs.validOpCSRR = '1' then
--                    regs(to_integer(unsigned(inputs.RMEMWB_outputs.regD))) <= inputs.csrs_outputs.data;
--            end if;
----            outputs.regS1_value <= regs(to_integer(unsigned(inputs.RIDEX_outputs.regS1)));
--            outputs.regS2_value <= regs(to_integer(unsigned(inputs.RIDEX_outputs.regS2)));
--        end if;

----        -- This should be in the reset trap routine. This way GPRs can be implemented as BRAMs.
----        if I_reset = RESET then
----            regs<=REG_INIT;
----        end if;
--    end process;


end Behavioral;
