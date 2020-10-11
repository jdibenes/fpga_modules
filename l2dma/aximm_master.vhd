----------------------------------------------------------------------------------
-- Company: 
-- Engineer: jcds
-- 
-- Create Date: 09/27/2020 03:04:32 PM
-- Design Name: 
-- Module Name: aximm_master - behavioral
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

entity aximm_master is
port (
    clk   : in std_logic;
    reset : in std_logic;
    
    -- write address channel
    awaddr   : out std_logic_vector(31 downto 0);    
    awcache  : out std_logic_vector( 3 downto 0);    
    awlock   : out std_logic_vector( 0 downto 0);
    awprot   : out std_logic_vector( 2 downto 0);
    awqos    : out std_logic_vector( 3 downto 0);    
    awregion : out std_logic_vector( 3 downto 0);    
    awlen    : out std_logic_vector( 7 downto 0);
    awsize   : out std_logic_vector( 2 downto 0);
    awburst  : out std_logic_vector( 1 downto 0);    
    awvalid  : out std_logic;
    awready  : in  std_logic;
    
    -- write data channel
    wdata  : out std_logic_vector(127 downto 0);
    wstrb  : out std_logic_vector( 15 downto 0);
    wlast  : out std_logic;
    wvalid : out std_logic;
    wready : in  std_logic;
    
    -- write response channel    
    bresp  : in  std_logic_vector(1 downto 0);
    bvalid : in  std_logic;
    bready : out std_logic;
    
    -- FIFO read
    dout  : in  std_logic_vector(127 downto 0);
    rden  : out std_logic;
    empty : in  std_logic;
    
    -- control
    start : in std_logic;
    base  : in std_logic_vector(31 downto 0);

    -- axis state
    axisidle : in std_logic;
    
    -- aximm state
    aximmidle : out std_logic
);
end aximm_master;

architecture behavioral of aximm_master is
--------------------------------------------------------------------------------
type aximm_state is (aximm_reset, aximm_addr, aximm_data, aximm_wait, aximm_fill, aximm_resp);

signal state      : aximm_state := aximm_reset;
signal next_state : aximm_state := aximm_reset;

signal base_ff  : unsigned(31 downto 0) := (others => '0');
signal count_ff : unsigned( 7 downto 0) := (others => '0');

signal addrvalid : std_logic := '0';
signal datavalid : std_logic := '0';

signal data_hs : std_logic := '0';
signal addr_hs : std_logic := '0';

signal zerocount : std_logic := '0';
--------------------------------------------------------------------------------
begin
--------------------------------------------------------------------------------
-- write address channel
awaddr   <= std_logic_vector(base_ff);
awcache  <= "0011"; -- modifiable, bufferable
awlock   <= "0";
awprot   <= "010";  -- non secure
awqos    <= "0000";
awregion <= "0000";
awlen    <= x"FF";  -- 256 transfers
awsize   <= "100";  -- 16 bytes (maximum supported)
awburst  <= "01";   -- increment
awvalid  <= addrvalid;

-- write data channel
wdata  <= dout;
wstrb  <= x"FFFF";
wlast  <= zerocount;
wvalid <= datavalid;

addr_hs <= addrvalid and awready;
data_hs <= datavalid and wready;

zerocount <= '1' when count_ff = 0 else '0';

aximm_sel : process (state, empty, addr_hs, wready, zerocount, bvalid, axisidle)
begin
    next_state <= state;
    aximmidle  <= '0';
    addrvalid  <= '0';
    rden       <= '0';
    datavalid  <= '0';
    bready     <= '0';
    
    case (state) is
    when aximm_reset =>                                                                                                                                                next_state <= aximm_addr;
    when aximm_addr  => aximmidle <= '1'; addrvalid <= not empty; rden <= addr_hs;                                    if (addr_hs = '1')                          then next_state <= aximm_data; end if;    
    when aximm_data  =>                   datavalid <= '1';       rden <= wready and (not zerocount) and (not empty); if (wready = '1') then if (zerocount = '1') then next_state <= aximm_resp; elsif (empty = '1')    then next_state <= aximm_wait; end if; end if;        
    when aximm_wait  =>                                           rden <= not empty;                                  if (empty = '0')                            then next_state <= aximm_data; elsif (axisidle = '1') then next_state <= aximm_fill; end if;    
    when aximm_fill  =>                   datavalid <= '1';                                                           if (wready = '1' and zerocount = '1')       then next_state <= aximm_resp; end if;    
    when aximm_resp  =>                   bready    <= '1';                                                           if (bvalid  = '1')                          then next_state <= aximm_addr; end if;
    end case;
end process;

aximm_fsm : process(clk)
begin
    if (rising_edge(clk)) then
        if (reset = '1') then state <= aximm_reset; else state <= next_state; end if;
    end if;
end process;

base_fsm : process (clk)
begin
    if (rising_edge(clk)) then
        if    (reset   = '1') then base_ff <= x"00000000";
        elsif (start   = '1') then base_ff <= unsigned(base);
        elsif (addr_hs = '1') then base_ff <= base_ff + (16 * 256);
        end if;
    end if;
end process;

count_fsm : process (clk)
begin
    if (rising_edge(clk)) then
        if    (reset   = '1') then count_ff <= x"00";
        elsif (addr_hs = '1') then count_ff <= x"FF";
        elsif (data_hs = '1') then count_ff <= count_ff - 1;
        end if;
    end if;
end process;
--------------------------------------------------------------------------------
end behavioral;
