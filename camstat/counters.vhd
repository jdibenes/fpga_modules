----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/03/2021 01:34:53 PM
-- Design Name: 
-- Module Name: counters - behavioral
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
--library UNISIM;
--use UNISIM.VComponents.all;

entity counters is
port (
    clk   : in std_logic;
    reset : in std_logic;

    -- axis
    sof : in std_logic;
    eol : in std_logic;
    dot : in std_logic;
    
    -- counters
    lw : out std_logic_vector(15 downto 0);
    lh : out std_logic_vector(15 downto 0);
    ly : out std_logic_vector(15 downto 0);
    
    lw_done : out std_logic;
    lh_done : out std_logic;
    locked  : out std_logic;
    
    lyf : out std_logic;
    
    -- irq
    lyc : in std_logic_vector(15 downto 0);

    irq_ack_sof : in std_logic;
    irq_ack_eol : in std_logic;
    irq_ack_lyc : in std_logic;
    
    irq_sof : out std_logic;
    irq_eol : out std_logic;
    irq_lyc : out std_logic
);
end counters;

architecture behavioral of counters is
--------------------------------------------------------------------------------
type fsmlw_state is (fsmlw_reset, fsmlw_count, fsmlw_done);
type fsmlh_state is (fsmlh_reset, fsmlh_count, fsmlh_done);
type fsmly_state is (fsmly_reset, fsmly_count);

signal lw_state : fsmlw_state := fsmlw_reset;
signal lw_next  : fsmlw_state := fsmlw_reset;
signal lh_state : fsmlh_state := fsmlh_reset;
signal lh_next  : fsmlh_state := fsmlh_reset;
signal ly_state : fsmly_state := fsmly_reset;
signal ly_next  : fsmly_state := fsmly_reset;

signal eol_1 : std_logic := '0';
signal dot_1 : std_logic := '0';

signal ff_sof : std_logic := '0';
signal ff_lh  : unsigned(15 downto 0) := (others => '0');
signal ff_lw  : unsigned(15 downto 0) := (others => '0');
signal ff_ly  : unsigned(15 downto 0) := (others => '0');
signal ff_lyc : unsigned(15 downto 0) := (others => '0');
signal ff_lyp : std_logic := '0';

signal lw_en : std_logic := '0';
signal lh_en : std_logic := '0';
signal ly_en : std_logic := '0';

signal lym : std_logic := '0';
signal lyt : std_logic := '0';

signal irq_ff_sof : std_logic := '0';
signal irq_ff_eol : std_logic := '0';
signal irq_ff_lyc : std_logic := '0';
--------------------------------------------------------------------------------
begin
--------------------------------------------------------------------------------
sync_delay : process (clk)
begin
    if (rising_edge(clk)) then
        eol_1 <= eol;
        dot_1 <= dot;
    end if;
end process;

-- lw counter ------------------------------------------------------------------
sellw : process (sof, eol_1, dot_1)
begin
    lw_next <= lw_state;
    lw_en   <= '0';
    lw_done <= '0';

    case (lw_state) is
    when fsmlw_reset =>                   if (sof   = '1') then lw_next <= fsmlw_count; end if;
    when fsmlw_count => lw_en   <= dot_1; if (eol_1 = '1') then lw_next <= fsmlw_done;  end if;
    when fsmlw_done  => lw_done <= '1';
    end case;
end process;

fsmlw : process (clk)
begin
    if (rising_edge(clk)) then
        if (reset = '1') then lw_state <= fsmlw_reset; else lw_state <= lw_next; end if;
    end if;
end process;

cntlw : process (clk)
begin
    if (rising_edge(clk)) then
        if    (reset = '1') then ff_lw <= (others => '0');
        elsif (lw_en = '1') then ff_lw <= ff_lw + 1;
        end if;
    end if;
end process;

lw <= std_logic_vector(ff_lw);

-- lh counter ------------------------------------------------------------------
sellh : process (sof, eol_1)
begin
    lh_next <= lh_state;
    lh_en   <= '0';
    lh_done <= '0';

    case (lh_state) is
    when fsmlh_reset =>                   if (sof = '1') then lh_next <= fsmlh_count; end if;
    when fsmlh_count => lh_en   <= eol_1; if (sof = '1') then lh_next <= fsmlh_done;  end if;
    when fsmlh_done  => lh_done <= '1';
    end case;
end process;

fsmlh : process (clk)
begin
    if (rising_edge(clk)) then
        if (reset = '1') then lh_state <= fsmlh_reset; else lh_state <= lh_next; end if;
    end if;
end process;

cntlh : process (clk)
begin
    if (rising_edge(clk)) then
        if    (reset = '1') then ff_lh <= (others => '0');
        elsif (lh_en = '1') then ff_lh <= ff_lh + 1;
        end if;
    end if;
end process;

lh <= std_logic_vector(ff_lh);

-- ly counter ------------------------------------------------------------------
selly : process (sof, eol_1)
begin
    ly_next <= ly_state;
    ly_en   <= '0';

    case (ly_state) is
    when fsmly_reset =>                 if (sof = '1') then ly_next <= fsmly_count; end if;
    when fsmly_count => ly_en <= eol_1;
    end case;
end process;

fsmly : process (clk)
begin
    if (rising_edge(clk)) then
        if (reset = '1') then ly_state <= fsmly_reset; else ly_state <= ly_next; end if;
    end if;
end process;

cntly : process (clk)
begin
    if (rising_edge(clk)) then
        if    (reset = '1') then ff_ly <= (others => '0');
        elsif (sof   = '1') then ff_ly <= (others => '0');
        elsif (ly_en = '1') then ff_ly <= ff_ly + 1;
        end if;
    end if;
end process;

ly <= std_logic_vector(ff_ly);

-- ly compare ------------------------------------------------------------------
sof_check : process (clk)
begin
    if (rising_edge(clk)) then
        if    (reset = '1') then ff_sof <= '0';
        elsif (sof   = '1') then ff_sof <= '1';
        end if;
    end if;
end process;

lyc_latch : process (clk)
begin
    if (rising_edge(clk)) then
        if    (reset = '1') then ff_lyc <= (others => '0'); 
        elsif (ly_en = '1') then ff_lyc <= unsigned(lyc);
        end if;
    end if;
end process;

lym_delay: process (clk)
begin
    if (rising_edge(clk)) then
        if   (reset = '1') then ff_lyp <= '0';
        else                    ff_lyp <= lym;
        end if;
    end if;
end process;

locked <= ff_sof;

lym <= '1' when ff_ly = unsigned(ff_lyc) else '0';
lyf <= lym;
lyt <= (not ff_lyp) and lym;

-- IRQ -------------------------------------------------------------------------
irq_set : process (clk)
begin
    if (rising_edge(clk)) then
        irq_ff_sof <= (sof or irq_ff_sof) and (not irq_ack_sof) and (not reset);
        irq_ff_eol <= (eol or irq_ff_eol) and (not irq_ack_eol) and (not reset);
        irq_ff_lyc <= (lyt or irq_ff_lyc) and (not irq_ack_lyc) and (not reset);
    end if;
end process;

irq_sof <= irq_ff_sof;
irq_eol <= irq_ff_eol;
irq_lyc <= irq_ff_lyc;
--------------------------------------------------------------------------------
end behavioral;
