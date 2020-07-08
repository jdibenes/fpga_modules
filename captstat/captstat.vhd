----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06/30/2020 06:25:02 PM
-- Design Name: 
-- Module Name: captstat - Behavioral
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

entity captstat is
port (
    clk    : in std_logic;
    resetn : in std_logic;

    awvalid : in std_logic;
    awready : out std_logic;
    awaddr  : in std_logic_vector(31 downto 0);
    
    wvalid : in std_logic;
    wready : out std_logic;
    wdata  : in std_logic_vector(31 downto 0);
    wstrb  : in std_logic_vector(3 downto 0);
    
    bvalid : out std_logic;
    bready : in std_logic;
    bresp  : out std_logic_vector(1 downto 0);
    
    arvalid : in std_logic;
    arready : out std_logic;
    araddr  : in std_logic_vector(31 downto 0);
    
    rvalid : out std_logic;
    rready : in std_logic;
    rdata  : out std_logic_vector(31 downto 0);
    rresp  : out std_logic_vector(1 downto 0);
    
    tvalid : in std_logic;
    tready : in std_logic;
    tlast  : in std_logic;
    tuser  : in std_logic_vector(0 downto 0);
    
    irq : out std_logic
);
end captstat;

architecture Behavioral of captstat is
-- reset -----------------------------------------------------------------------
signal reset : std_logic := '1';

-- write channel ---------------------------------------------------------------
type axiw_state is (axiw_reset, axiw_addr, axiw_data, axiw_resp);

signal wstate      : axiw_state := axiw_reset;
signal wstate_next : axiw_state := axiw_reset;

signal hs_waddr : std_logic := '0';
signal hs_wdata : std_logic := '0';

signal waddr : std_logic_vector(31 downto 0);

signal woffs : std_logic_vector(3 downto 0) := x"0";

-- read channel ----------------------------------------------------------------
type axir_state is (axir_reset, axir_addr, axir_data);

signal rstate      : axir_state := axir_reset;
signal rstate_next : axir_state := axir_reset;

signal hs_raddr : std_logic := '0';

signal roffs : std_logic_vector(3 downto 0) := x"0";

-- stream channel --------------------------------------------------------------
signal hs_d : std_logic := '0';

signal set_sof : std_logic := '0';
signal set_eol : std_logic := '0';
signal set_ly  : std_logic := '0';
signal set_lx  : std_logic := '0';

-- registers -------------------------------------------------------------------
signal lx : unsigned(15 downto 0) := x"0000";
signal ly : unsigned(15 downto 0) := x"0000";

signal en_sof : std_logic := '0';
signal en_eol : std_logic := '0';
signal en_lx  : std_logic := '0';
signal en_ly  : std_logic := '0';

signal cmp_lx : unsigned(15 downto 0) := x"0000";
signal cmp_ly : unsigned(15 downto 0) := x"0000";

signal ack_sof : std_logic := '0';
signal ack_eol : std_logic := '0';
signal ack_lx  : std_logic := '0';
signal ack_ly  : std_logic := '0';

signal irq_sof : std_logic := '0';
signal irq_eol : std_logic := '0';
signal irq_lx  : std_logic := '0';
signal irq_ly  : std_logic := '0';
begin
-- reset -----------------------------------------------------------------------
reset <= not resetn;

-- write channel fsm -----------------------------------------------------------
wsel : process(wstate, awvalid, wvalid, bready)
begin
    awready <= '0'; hs_waddr <= '0'; wstate_next <= wstate;
    wready  <= '0'; hs_wdata <= '0';
    bvalid  <= '0';
    
    case (wstate) is
    when axiw_addr => awready <= '1'; if (awvalid = '1') then hs_waddr <= '1'; wstate_next <= axiw_data; end if;
    when axiw_data => wready  <= '1'; if (wvalid  = '1') then hs_wdata <= '1'; wstate_next <= axiw_resp; end if;
    when axiw_resp => bvalid  <= '1'; if (bready  = '1') then                  wstate_next <= axiw_addr; end if;
    when others    =>                                                          wstate_next <= axiw_addr;
    end case;
end process;

bresp <= "00";

wfsm : process(clk)
begin
    if (rising_edge(clk)) then
        if (reset = '1') then wstate <= axiw_reset; else wstate <= wstate_next; end if;
    end if;
end process;

waddr_reg : process(clk)
begin
    if (rising_edge(clk)) then
        if (hs_waddr = '1') then waddr <= awaddr; end if;
    end if;
end process;

-- read channel fsm ------------------------------------------------------------
rsel : process(rstate, arvalid, rready)
begin
    arready <= '0'; hs_raddr <= '0'; rstate_next <= rstate;
    rvalid  <= '0';
    
    case (rstate) is
    when axir_addr => arready <= '1'; if (arvalid = '1') then hs_raddr <= '1'; rstate_next <= axir_data; end if;
    when axir_data => rvalid  <= '1'; if (rready  = '1') then                  rstate_next <= axir_addr; end if;
    when others    =>                                                          rstate_next <= axir_addr;
    end case;
end process;

rresp <= "00";

rfsm : process(clk)
begin
    if (rising_edge(clk)) then
        if (reset = '1') then rstate <= axir_reset; else rstate <= rstate_next; end if;
    end if;
end process;

-- memory map ------------------------------------------------------------------
-- 0x0 CAPTSTAT_CNT
--  0: set_sof (R)
--  1: set_eol (R)
--  2: set_lx  (R)
--  3: set_ly  (R)
--  4: en_sof  (R/W)
--  5: en_eol  (R/W)
--  6: en_lx   (R/W)
--  7: en_ly   (R/W)
--  8: irq_sof (R) write '1' to clear
--  9: irq_eol (R) write '1' to clear
-- 10: irq_lx  (R) write '1' to clear
-- 11: irq_ly  (R) write '1' to clear

-- 0x4 CAPTSTAT_CMP
-- 15- 0: cmp_lx (R/W)
-- 31-16: cmp_ly (R/W)

-- 0x8 CAPTSTAT_STAT
-- 15- 0: lx (R)
-- 31-16: ly (R)

woffs <= waddr(3 downto 0);

ack_sof <= '1' when (woffs = x"0" and hs_wdata = '1' and wdata( 8) = '1') else '0';
ack_eol <= '1' when (woffs = x"0" and hs_wdata = '1' and wdata( 9) = '1') else '0';
ack_lx  <= '1' when (woffs = x"0" and hs_wdata = '1' and wdata(10) = '1') else '0';
ack_ly  <= '1' when (woffs = x"0" and hs_wdata = '1' and wdata(11) = '1') else '0';

wdata_reg : process(clk)
begin
    if (rising_edge(clk)) then
        if (reset = '1') then
            en_sof <= '0';
            en_eol <= '0';
            en_lx  <= '0';
            en_ly  <= '0';
            
            cmp_lx <= x"0000";
            cmp_ly <= x"0000";
        elsif (hs_wdata = '1') then
            case (woffs) is
            when x"0" =>
                en_sof <= wdata(4);
                en_eol <= wdata(5);
                en_lx  <= wdata(6);
                en_ly  <= wdata(7);
            when x"4" =>
                cmp_lx <= unsigned(wdata(15 downto  0));
                cmp_ly <= unsigned(wdata(31 downto 16));
            when others =>
            end case;
        end if;
    end if;
end process;

roffs <= araddr(3 downto 0);

rdata_reg : process(clk)
begin
    if (rising_edge(clk)) then
        if (hs_raddr = '1') then
            case (roffs) is
            when x"0" =>
                rdata <= ( 0 => set_sof,
                           1 => set_eol,
                           2 => set_lx,
                           3 => set_ly,
                           4 => en_sof,
                           5 => en_eol,
                           6 => en_lx,
                           7 => en_ly,
                           8 => irq_sof,
                           9 => irq_eol,
                          10 => irq_lx,
                          11 => irq_ly,
                          others => '0');
            when x"4" =>
                rdata(15 downto  0) <= std_logic_vector(cmp_lx);
                rdata(31 downto 16) <= std_logic_vector(cmp_ly);
            when x"8" =>
                rdata(15 downto  0) <= std_logic_vector(lx);
                rdata(31 downto 16) <= std_logic_vector(ly);
            when others =>
                rdata <= x"FFFFFFFF";
            end case;
        end if;
    end if;
end process;

-- interrupts ------------------------------------------------------------------
irq_fsm : process(clk)
begin
    if (rising_edge(clk)) then
        if (reset = '1') then
            irq_sof <= '0';
            irq_eol <= '0';
            irq_lx  <= '0';
            irq_ly  <= '0';
        else
            irq_sof <= (not ack_sof) and (set_sof or irq_sof);
            irq_eol <= (not ack_eol) and (set_eol or irq_eol);
            irq_lx  <= (not ack_lx)  and (set_lx  or irq_lx);
            irq_ly  <= (not ack_ly)  and (set_ly  or irq_ly);
        end if;
    end if;
end process;

irq <= (irq_sof and en_sof) or 
       (irq_eol and en_eol) or
       (irq_lx  and en_lx)  or
       (irq_ly  and en_ly);

-- stream interface ------------------------------------------------------------
hs_d <= tvalid and tready;

set_sof <= hs_d and tuser(0);
set_eol <= hs_d and tlast;
set_lx  <= '1' when lx = cmp_lx else '0';
set_ly  <= '1' when ly = cmp_ly else '0';

l_fsm : process(clk)
begin
    if (rising_edge(clk)) then
        if (reset = '1') then                         ly <= x"0000"; lx <= x"0000";
        elsif (set_sof = '1' and set_eol = '1') then  ly <= x"0000"; lx <= x"0000";
        elsif (set_sof = '1') then                    ly <= x"0000";
        elsif (set_eol = '1') then                    ly <= ly + 1;  lx <= x"0000";
        elsif (hs_d = '1') then                                      lx <= lx + 1;
        end if;
    end if;
end process;
end Behavioral;
