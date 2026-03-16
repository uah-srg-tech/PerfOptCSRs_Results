library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

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
    signal regS1_valueWB : std_logic_vector(3*XLEN-1 downto 0):=XLEN_ZERO&XLEN_ZERO&XLEN_ZERO;
    signal regS1_valueEX : std_logic_vector(XLEN-1 downto 0);

    signal we : std_logic_vector(XLEN/2-1 downto 0);

    attribute extract_reset : string;
    attribute extract_reset of regS1_valueWB: signal is "false";

    signal dummy: std_logic_vector(XLEN-1 downto 0);
    function gen_init(i : natural) return bit_vector is begin
        if i>=8 and i <= 12 then
            return X"00000004";
        else
            return X"00000000";
        end if;
    end function;
begin

    -- Instantiating the GPRs so that it is possible to generate the RLOC structures with the DSPs.
    gprs:for j in XLEN-1 downto 0 generate
        attribute RLOC  :string;
        attribute U_SET  :string;
        attribute U_SET of RAM32X1D_inst : label is "gpr_setJ"& integer'image(j/2);
        attribute RLOC  of RAM32X1D_inst : label is "X0Y0";
    begin
        we(j/2)<=inputs.RMEMWB_outputs.validOpCSRR(j/2) or inputs.RMEMWB_outputs.regWrite(j/2);
        RAM32X1D_inst : RAM32X1D
        generic map (
            INIT => gen_init(j)) -- Initial contents of RAM
        port map (
            DPO => regS1_value(j),  -- Read-only 1-bit data output
            SPO => dummy(j),        -- R/W 1-bit data output
            A0 => inputs.RMEMWB_outputs.regD(0),       -- R/W address[0] input bit
            A1 => inputs.RMEMWB_outputs.regD(1),       -- R/W address[1] input bit
            A2 => inputs.RMEMWB_outputs.regD(2),       -- R/W address[2] input bit
            A3 => inputs.RMEMWB_outputs.regD(3),       -- R/W address[3] input bit
            A4 => inputs.RMEMWB_outputs.regD(4),       -- R/W address[4] input bit
            D => inputs.csrs_outputs.data(j),   -- Write 1-bit data input
            DPRA0 => inputs.REXMEM_outputs.regS1(0),    -- Read-only address[0] input bit
            DPRA1 => inputs.REXMEM_outputs.regS1(1),    -- Read-only address[1] input bit
            DPRA2 => inputs.REXMEM_outputs.regS1(2),    -- Read-only address[2] input bit
            DPRA3 => inputs.REXMEM_outputs.regS1(3),    -- Read-only address[3] input bit
            DPRA4 => inputs.REXMEM_outputs.regS1(4),    -- Read-only address[4] input bit
            WCLK => I_clock,    -- Write clock input
            WE => we(j/2)       -- Write enable input
        );
    end generate;
    process(I_clock)
    begin
        if rising_edge(I_clock) then
            for i in XLEN-1 downto 0 loop
                if inputs.REXMEM_outputs.validOpCSRW = '1' then
                    regS1_valueWB(3*i)  <=regS1_value(i);
                    regS1_valueWB(3*i+1)<=regS1_value(i);
                    regS1_valueWB(3*i+2)<=regS1_value(i);
                else
                    regS1_valueWB(3*i)  <=inputs.REXMEM_outputs.parregEnable(i);
                    regS1_valueWB(3*i+1)<=inputs.REXMEM_outputs.parregEnable(i);
                    regS1_valueWB(3*i+2)<=inputs.REXMEM_outputs.parregEnable(i);
                end if;
            end loop;
        end if;

    end process;
    outputs.regS1_valueWB <= regS1_valueWB;

end Behavioral;
