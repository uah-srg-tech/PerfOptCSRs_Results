library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

library work;
use work.constants.all;
use work.interfaces.all;

use work.toplevel_tb_env.all;

entity toplevel is
    port (
        clk         : in  std_logic;
        rst         : in  std_logic;
        -- If executing simulations, uncomment all lines where O_result
        -- appears, including line 185, otherwise leave commented when 
        -- testing on board, to achieve maximum speed.
--        O_result        : out std_logic_vector(XLEN-1 downto 0); 
        O_ok            : out std_logic;
        O_nook          : out std_logic;
        O_heartbeat     : out std_logic;
        O_exception     : out std_logic
    );
end entity toplevel;

architecture structural of toplevel is
    signal I_inst: std_logic_vector(XLEN-1 downto 0);
    signal inst_aux: std_logic_vector(19 downto 0);
    
    signal inst_mem:    tbmem_t := INST_TB;
    signal tb_addr: integer range 0 to 20479;
    signal address : unsigned (11 downto 0):=x"fff";
    signal out_address : unsigned (10 downto 0):="111"&x"fe";
    signal ok:std_logic:='0';
    signal hbeat : std_logic:='0';
    signal hbeat_inc : std_logic:='0';
    signal hbeat_cnt:unsigned (24 downto 0):="0000000000000000000000000";
    signal test:std_logic:='0';
    signal lock,clk_aux:std_logic:='0';

    type state_type is (st0,st1,st2,st3,st4,st5);
    signal state, next_state : state_type;

    signal out_aux  : std_logic_vector(XLEN-1 downto 0);
    signal exc_aux  : std_logic;
    signal ok_aux   : std_logic:='1';
    signal I_clock,clk_ILA   : std_logic;
    signal I_reset   : std_logic;

    signal DEC_outputs      : O_DEC;
    signal RIDEX_outputs    : O_RIDEX;
    signal REXMEM_outputs   : O_REXMEM;
    signal RMEMWB_outputs   : O_RMEMWB;
    signal GPRs_outputs     : O_GPR;
    signal CSRs_outputs     : O_CSR;
    signal PROCIFace_outputs: O_PROCIF;

    signal DEC_inputs       : I_DEC     := (I_inst,RIDEX_outputs,REXMEM_outputs,RMEMWB_outputs);
    signal RIDEX_inputs     : I_RIDEX   := (DEC_outputs=>DEC_outputs);
    signal REXMEM_inputs    : I_REXMEM  := (RIDEX_outputs=>RIDEX_outputs);
    signal RMEMWB_inputs    : I_RMEMWB  := (PROCIFace_outputs,REXMEM_outputs);
    signal GPRs_inputs      : I_GPR     := (RIDEX_outputs,REXMEM_outputs,RMEMWB_outputs,CSRs_outputs);
    signal PROCIFace_inputs : I_PROCIF  := (REXMEM_outputs,CSRs_outputs);
    signal CSRs_inputs      : I_CSR     := (DEC_outputs,RIDEX_outputs,REXMEM_outputs,RMEMWB_outputs,GPRs_outputs,PROCIFace_outputs);
    
    attribute IOB:string;
    attribute IOB of O_ok:signal is "true";
    attribute IOB of O_nook:signal is "true";
    attribute IOB of O_exception:signal is "true";
    attribute IOB of O_heartbeat:signal is "true";
    attribute dont_touch:string;
    attribute dont_touch of out_aux:signal is "true";

    COMPONENT clk_wiz_2
    PORT(
        clk_in1 : IN std_logic;
        reset   : IN std_logic;
        clk_out1: OUT std_logic;
        locked  : OUT std_logic
    );
    END COMPONENT;
begin

    DEC_inputs      <= (I_inst,RIDEX_outputs,REXMEM_outputs,RMEMWB_outputs);
    RIDEX_inputs    <= (DEC_outputs=>DEC_outputs);
    REXMEM_inputs   <= (RIDEX_outputs=>RIDEX_outputs);
    RMEMWB_inputs   <= (PROCIFace_outputs,REXMEM_outputs);
    GPRs_inputs     <= (RIDEX_outputs,REXMEM_outputs,RMEMWB_outputs,CSRs_outputs);
    PROCIFace_inputs<= (REXMEM_outputs,CSRs_outputs);
    CSRs_inputs     <= (DEC_outputs,RIDEX_outputs,REXMEM_outputs,RMEMWB_outputs,GPRs_outputs,PROCIFace_outputs);

    -- Decode stage
    dec_inst : entity work.decode
    port map (
        I_clock => I_clock,
        I_reset => I_reset,
        inputs  => DEC_inputs,
        outputs => DEC_outputs
    );

    -- ID/EX Register
    id_ex_register_inst : entity work.R_ID_EX
    port map (
        I_clock => I_clock,
        I_reset => I_reset,
        inputs  => RIDEX_inputs,
        outputs => RIDEX_outputs
    );

    -- EX/MEM Register
    ex_mem_register_inst : entity work.R_EX_MEM
    port map (
        I_clock => I_clock,
        I_reset => I_reset,
        inputs  => REXMEM_inputs,
        outputs => REXMEM_outputs
    );

    -- MEM/WB Register
    mem_wb_register_inst : entity work.R_MEM_WB
    port map (
        I_clock => I_clock,
        I_reset => I_reset,
        inputs  => RMEMWB_inputs,
        outputs => RMEMWB_outputs
    );

    gprs_inst : entity work.GPRs
    port map (
        I_clock => I_clock,
        I_reset => I_reset,
        inputs  => GPRs_inputs,
        outputs => GPRs_outputs
    );

    procIFace_inst : entity work.procIFace
    port map (
        I_clock => I_clock,
--        I_reset => I_reset,
        inputs  => procIFace_inputs,
        outputs => procIFace_outputs
    );

    csrs_inst : entity work.CSRs
    port map (
        I_clock => I_clock,
        I_reset => I_reset,
        inputs  => CSRs_inputs,
        outputs => CSRs_outputs
    );
    process (I_clock)
    begin
    if rising_edge(I_clock) then
    out_aux    <= CSRs_outputs.data;
    exc_aux <= CSRs_outputs.exception;
        if state=st5 and test='1' then
            if out_address=unsigned(out_aux(10 downto 0)) then
                ok_aux  <='1' and (ok_aux or I_reset);
                hbeat_inc<='1';
            else
                ok_aux <= '0';
                hbeat_inc <= '0';
            end if;
        end if;
    end if;
    end process;
    
    process(I_clock)
    begin
        if rising_edge(I_clock) then
            if hbeat_inc = '1' then
                hbeat_cnt <= hbeat_cnt+1;
                if hbeat_cnt(24) = '1' then
                    hbeat   <= not hbeat;
                    hbeat_cnt(24)<='0';
                end if;
            end if;
        end if;
    end process;
    
    
    process (I_clock,I_reset)
    begin
    if rising_edge(I_clock) then
--    O_result    <= out_aux;
    O_exception <= exc_aux;
    O_ok        <= ok_aux;
    O_nook      <= not ok_aux;
    O_heartbeat <= hbeat;
    end if;
    if I_reset='1' then
        O_ok        <= '0';
        O_nook      <= '1';
        O_heartbeat <= '0';
    end if;
    end process;

    process(I_clock)
    begin
        if rising_edge(I_clock) then
            if I_reset = '1' then
                address <= x"fff";
                out_address <= "111"& x"fe";
                test <= '0';
            else
                if state = st2 then -- Needs to be done one cycle earlier.
                    address <= address + 1;
                end if;
                if state = st5 then
                    test <= '1';
                    out_address <= out_address + 1;
                end if;
            end if;
        end if;
    end process;

    
    SYNC_PROC: process (I_clock)
    begin
        if rising_edge (I_clock) then
            if (I_reset = '1') then
                state <= st0;
            else
                state <= next_state;
            end if;
        end if;
    end process;
    NEXT_STATE_DECODE: process (state)
    begin
        case (state) is
            when st0 =>
                next_state <= st1;
                inst_aux    <= x"00013";
            when st1 =>
                next_state <= st2;
                inst_aux    <= x"00F93";
            when st2 =>
                next_state <= st3;
                inst_aux    <= x"00013";
            when st3 =>
                next_state <= st4;
                inst_aux    <= x"F9073";
            when st4 =>
                next_state <= st5;
                inst_aux    <= x"00013";
            when st5 =>
                next_state <= st1;
                inst_aux    <= x"02FF3";--TODO set/reset on-board.
            when others =>
                next_state <= st1;
                inst_aux    <= x"00013";
        end case;
    end process;

    process(address,inst_aux, state)
    begin
            if state = st1 then
                I_inst(31 downto 20)<= std_logic_vector(address);
                I_inst(31)          <='0';
            else
                I_inst(31 downto 20)<= std_logic_vector(address);
            end if;
            I_inst (19 downto 0)    <= inst_aux;
    end process;

    clk_wiz_5051: clk_wiz_2
    PORT map(
        clk_in1 => clk, 
        reset   => rst,
        clk_out1=> clk_aux,
        locked  => lock
    );

    I_clock<=clk_aux;
    I_reset<= not lock;

end architecture structural;
