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
    idle : in std_logic;
    
    -- aximm state
    addrcycle : out std_logic
);
end aximm_master;

architecture behavioral of aximm_master is
--------------------------------------------------------------------------------
type aximm_state is (aximm_reset, aximm_addr, aximm_data, aximm_wait, aximm_resp);

-- 3840 pixels with 2 bytes per pixel = 7680 bytes
-- 480 transfers of 16 bytes
-- 15 bursts of 32 transfers of 16 bytes
constant burstlength : unsigned(7 downto 0) := x"FF";

signal state      : aximm_state := aximm_reset;
signal next_state : aximm_state := aximm_reset;

signal base_ff  : unsigned(31 downto 0) := (others => '0');
signal count_ff : unsigned( 7 downto 0) := (others => '0');

signal addr_valid : std_logic := '0';
signal data_valid : std_logic := '0';

signal data_hs : std_logic := '0';
signal addr_hs : std_logic := '0';

signal zerocount : std_logic := '0';
signal last      : std_logic := '0';
signal done      : std_logic := '0';
signal strobe : std_logic := '0';
--------------------------------------------------------------------------------
begin
--------------------------------------------------------------------------------
-- write address channel
awaddr   <= std_logic_vector(base_ff);
awcache  <= "0011";
awlock   <= "0";
awprot   <= "010";
awqos    <= "0000";
awregion <= "0000";
awlen    <= std_logic_vector(burstlength);
awsize   <= "100"; -- 16 bytes (maximum supported)
awburst  <= "01";  -- increment
awvalid  <= addr_valid;

-- write data channel
wdata  <= dout;
wstrb  <= x"FFFF";
wlast  <= zerocount;
wvalid <= data_valid;

-- FIFO read
rden <= strobe; --(addr_hs or (data_hs and (not zerocount))) and (not empty); -- normal FIFO (no FWFT)

addr_hs <= addr_valid and awready;
data_hs <= data_valid and wready;

zerocount <= '1' when count_ff = 0 else '0';

aximm_sel : process (state, empty, addr_hs, wready, zerocount, bvalid)
begin
    addr_valid <= '0';
    data_valid <= '0';
    bready     <= '0';
    strobe <= '0';

    case (state) is
    when aximm_reset  =>                                                                      next_state <= aximm_addr;
    when aximm_addr   => addr_valid <= not empty; strobe <= addr_hs; if (addr_hs = '1')                     then next_state <= aximm_data; else next_state <= aximm_addr; end if;    
    when aximm_data   => data_valid <= '1';
        if (wready = '1') then
            if (zerocount = '1') then
                next_state <= aximm_resp;
            elsif (empty = '1') then
                next_state <= aximm_wait;
            else
                next_state <= aximm_data;
                strobe <= '1';
            end if;
        else
            next_state <= aximm_data;
        end if;
    when aximm_wait => if (empty = '0') then strobe <= '1'; next_state <= aximm_data; else next_state <= aximm_wait; end if;
    
    when aximm_resp   => bready     <= '1';       if (bvalid  = '1')                     then next_state <= aximm_addr; else next_state <= aximm_resp; end if;
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
        elsif (addr_hs = '1') then count_ff <= burstlength;
        elsif (data_hs = '1') then count_ff <= count_ff - 1;
        end if;
    end if;
end process;
--------------------------------------------------------------------------------
end behavioral;



--type aximm_state is (aximm_reset, aximm_idle, aximm_addr, aximm_data, aximm_resp);

---- 3840 pixels with 2 bytes per pixel = 7680 bytes
---- 480 transfers of 16 bytes
---- 15 bursts of 32 transfers of 16 bytes
--constant burstlength : unsigned(7 downto 0) := x"00"; --x"1F";

--signal state      : aximm_state := aximm_reset;
--signal next_state : aximm_state := aximm_reset;

--signal base_ff  : unsigned(31 downto 0) := (others => '0');
--signal count_ff : unsigned( 7 downto 0) := (others => '0');

--signal addr_valid : std_logic := '0';
--signal data_valid : std_logic := '0';

--signal data_hs : std_logic := '0';
--signal addr_hs : std_logic := '0';

--signal zerocount : std_logic := '0';
--signal last      : std_logic := '0';
--signal done      : std_logic := '0';


---- write address channel
--awaddr   <= std_logic_vector(base_ff);
--awcache  <= "0000";
--awlock   <= "0";
--awprot   <= "000";
--awqos    <= "0000";
--awregion <= "0000";
--awlen    <= std_logic_vector(burstlength);
--awsize   <= "100";                         -- 16 bytes (maximum supported)
--awburst  <= "00"; --"01";                          -- increment
--awvalid  <= addr_valid;

---- write data channel
--wdata  <= dout;
--wstrb  <= x"FFFF";
--wlast  <= zerocount;
--wvalid <= data_valid;

---- FIFO read
--rden <= addr_hs or (data_hs and (not zerocount)); -- normal FIFO (no FWFT)

--addr_hs <= addr_valid and awready;
--data_hs <= data_valid and wready;

--zerocount <= '1' when count_ff = 0 else '0';

--last <= wready and zerocount;
--done <= empty and idle;

--aximm_sel : process (state, start, empty, addr_hs, last, bvalid, done)
--begin
--    addr_valid <= '0';
--    data_valid <= '0';
--    bready     <= '0';

--    case (state) is
--    when aximm_reset  =>                                                  next_state <= aximm_idle;
--    when aximm_idle   =>                          if (start   = '1') then next_state <= aximm_addr;                                                   else next_state <= aximm_idle; end if;
--    when aximm_addr   => addr_valid <= not empty; if (addr_hs = '1') then next_state <= aximm_data;                                                   else next_state <= aximm_addr; end if;    
--    when aximm_data   => data_valid <= '1';       if (last    = '1') then next_state <= aximm_resp;                                                   else next_state <= aximm_data; end if;
--    when aximm_resp   => bready     <= '1';       if (bvalid  = '0') then next_state <= aximm_resp; elsif (done = '1') then next_state <= aximm_idle; else next_state <= aximm_addr; end if;
--    end case;
--end process;



--base_fsm : process (clk)
--begin
--    if (rising_edge(clk)) then
--        if    (reset   = '1') then base_ff <= x"00000000";
--        elsif (start   = '1') then base_ff <= unsigned(base);
--        elsif (addr_hs = '1') then base_ff <= base_ff + (16 * (burstlength + 1));
--        end if;
--    end if;
--end process;

--count_fsm : process (clk)
--begin
--    if (rising_edge(clk)) then
--        if    (reset   = '1') then count_ff <= x"00";
--        elsif (addr_hs = '1') then count_ff <= burstlength;
--        elsif (data_hs = '1') then count_ff <= count_ff - 1; -- use rden instead??
--        end if;
--    end if;
--end process;