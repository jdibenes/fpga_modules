----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/03/2021 05:41:23 PM
-- Design Name: 
-- Module Name: axil_slave - behavioral
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

entity axil_slave is
port (
    clk   : in std_logic;
    reset : in std_logic;

    -- write channel
    awvalid : in  std_logic;
    awready : out std_logic;
    awaddr  : in  std_logic_vector(3 downto 0);
    
    wvalid : in  std_logic;
    wready : out std_logic;
    wdata  : in  std_logic_vector(31 downto 0);
    wstrb  : in  std_logic_vector(3 downto 0);
    
    bvalid : out std_logic;
    bready : in  std_logic;
    bresp  : out std_logic_vector(1 downto 0);
    
    -- read channel
    arvalid : in  std_logic;
    arready : out std_logic;
    araddr  : in  std_logic_vector(3 downto 0);
    
    rvalid : out std_logic;
    rready : in  std_logic;
    rdata  : out std_logic_vector(31 downto 0);
    rresp  : out std_logic_vector(1 downto 0);
    
    -- registers    
    lw : in std_logic_vector(15 downto 0);
    lh : in std_logic_vector(15 downto 0);
    ly : in std_logic_vector(15 downto 0);
    
    lw_done : in std_logic;
    lh_done : in std_logic;
    locked  : in std_logic;
    
    lyf : in  std_logic;
    lyc : out std_logic_vector(15 downto 0);
    
    irq_ack_sof : out std_logic;
    irq_ack_eol : out std_logic;
    irq_ack_lyc : out std_logic;
    
    irq_sof : in std_logic;
    irq_eol : in std_logic;
    irq_lyc : in std_logic;
    
    irq : out std_logic
);
end axil_slave;

-- Memory Map ------------------------------------------------------------------
-- 0x00 CAMSTAT_CNT
-- 0: locked (R)
-- 1: lw done (R)
-- 2: lh done (R)
-- 3: ly match (R)
-- 4: sof irq (R)
-- 5: eol irq (R)
-- 6: lyc irq (R)
-- 7: sof irq enable (R/W)
-- 8: eol irq enable (R/W)
-- 9: lyc irq enable (R/W)

-- 0x04 CAMSTAT_LY
--  0-15: lyc (R/W)
-- 31-16: ly (R)

-- 0x08 CAMSTAT_WH
--  0-15: lw (R)
-- 31-16: lh (R)

architecture behavioral of axil_slave is
-- write channel ---------------------------------------------------------------
type axiw_state is (axiw_reset, axiw_addr, axiw_data, axiw_resp);

signal wstate      : axiw_state := axiw_reset;
signal wstate_next : axiw_state := axiw_reset;

signal hs_waddr : std_logic := '0';
signal hs_wdata : std_logic := '0';

signal waddr : std_logic_vector(3 downto 0) := (others => '0');

-- read channel ----------------------------------------------------------------
type axir_state is (axir_reset, axir_addr, axir_data);

signal rstate      : axir_state := axir_reset;
signal rstate_next : axir_state := axir_reset;

signal hs_raddr : std_logic := '0';

-- registers -------------------------------------------------------------------
signal ff_lyc : std_logic_vector(15 downto 0) := (others => '0');

signal ff_en_sof : std_logic := '0';
signal ff_en_eol : std_logic := '0';
signal ff_en_lyc : std_logic := '0';
--------------------------------------------------------------------------------
begin
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

-- registers -------------------------------------------------------------------
lyc <= ff_lyc;
    
irq_ack_sof <= '1' when hs_wdata = '1' and waddr = x"0" and wdata(4) = '1' else '0';
irq_ack_eol <= '1' when hs_wdata = '1' and waddr = x"0" and wdata(5) = '1' else '0';
irq_ack_lyc <= '1' when hs_wdata = '1' and waddr = x"0" and wdata(6) = '1' else '0';

irq <= (irq_sof and ff_en_sof) or (irq_eol and ff_en_eol) or (irq_lyc and ff_en_lyc);

wdata_reg : process(clk)
begin
    if (rising_edge(clk)) then
        if (reset = '1') then
            ff_en_sof <= '0';
            ff_en_eol <= '0';
            ff_en_lyc <= '0';
            ff_lyc    <= (others => '0');
        elsif (hs_wdata = '1') then
            case (waddr) is
            when x"0"   => 
                ff_en_sof <= wdata(7);
                ff_en_eol <= wdata(8);
                ff_en_lyc <= wdata(9);
            when x"4"   =>
                ff_lyc    <= wdata(15 downto 0);
            when others =>
            end case;
        end if;
    end if;
end process;

rdata_reg : process(clk)
begin
    if (rising_edge(clk)) then
        if (hs_raddr = '1') then
            case (araddr) is
            when x"0"   => rdata <= (9 => ff_en_lyc, 8 => ff_en_eol, 7 => ff_en_sof, 6 => irq_lyc, 5 => irq_eol, 4 => irq_sof, 3 => lyf, 2 => lh_done, 1 => lw_done, 0 => locked, others => '0');
            when x"4"   => rdata <= ly & ff_lyc;
            when x"8"   => rdata <= lh & lw;
            when others => rdata <= (others => '1');
            end case;
        end if;
    end if;
end process;
--------------------------------------------------------------------------------
end behavioral;
