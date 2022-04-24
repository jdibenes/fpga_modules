----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/20/2019 05:59:34 PM
-- Design Name: 
-- Module Name: axi_mm - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

entity axi_mm is
port (
    clk    : in std_logic;
    resetn : in std_logic;
    
    araddr   : out std_logic_vector(31 downto 0);
    arlen    : out std_logic_vector( 7 downto 0);
    arsize   : out std_logic_vector( 2 downto 0);
    arburst  : out std_logic_vector( 1 downto 0);
    arlock   : out std_logic_vector( 1 downto 0);
    arcache  : out std_logic_vector( 3 downto 0);
    arprot   : out std_logic_vector( 2 downto 0);
    arqos    : out std_logic_vector( 3 downto 0);
    arregion : out std_logic_vector( 3 downto 0);
    arvalid  : out std_logic;
    arready  : in  std_logic;
    
    rdata  : in  std_logic_vector(127 downto 0);
    rresp  : in  std_logic_vector(  1 downto 0);
    rlast  : in  std_logic;
    rvalid : in  std_logic;
    rready : out std_logic;
    
    base_addr : in std_logic_vector(31 downto 0);
    start     : in std_logic;
    continue  : in std_logic;
    data_out  : out std_logic_vector(31 downto 0)
);
end axi_mm;

architecture Behavioral of axi_mm is
COMPONENT fifo_generator_0
PORT (
    clk : IN STD_LOGIC;
    srst : IN STD_LOGIC;
    din : IN STD_LOGIC_VECTOR(127 DOWNTO 0);
    wr_en : IN STD_LOGIC;
    rd_en : IN STD_LOGIC;
    dout : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    full : OUT STD_LOGIC;
    empty : OUT STD_LOGIC;
    prog_full : OUT STD_LOGIC;
    wr_rst_busy : OUT STD_LOGIC;
    rd_rst_busy : OUT STD_LOGIC
);
END COMPONENT;

type axi_rstate is (axi_reset, axi_wait, axi_raddr, axi_rdata);

signal state      : axi_rstate := axi_reset;
signal next_state : axi_rstate := axi_reset;
signal last_state : axi_rstate := axi_reset;

signal reset : std_logic := '1';

signal a_hs : std_logic := '0';
signal d_hs : std_logic := '0';

signal addr_valid : std_logic := '0';
signal addr_ready : std_logic := '0';
signal read_ready : std_logic := '0';

signal addr        : unsigned(31 downto 0) := (others => '0');
signal burst_count : unsigned( 8 downto 0) := (others => '0');

signal fifo_ready  : std_logic := '0';
signal fifo_full   : std_logic := '0';
signal wr_rst_busy : std_logic := '0';
signal rd_rst_busy : std_logic := '0';
signal burst_done  : std_logic := '0';

signal bigtosmall : std_logic_vector(127 downto 0);

begin
arlen    <= "11111111"; -- 256 units
arsize   <= "100";      -- 16 bytes (128 bits)
arburst  <= "01";       -- increment
arlock   <= "00";       -- normal access
arcache  <= "0011";     -- modifiable, bufferable
arprot   <= "010";      -- unprivileged, non-secure, data
arqos    <= "0000";     -- default
arregion <= "0000";     -- ? (unused)

reset <= not resetn;

fifo_ready <= not (wr_rst_busy or rd_rst_busy or fifo_full);
burst_done <= rvalid and rlast;
last_state <= axi_raddr when burst_count < 300 else axi_wait;
addr_ready <= fifo_ready and arready;

araddr  <= std_logic_vector(addr);
arvalid <= addr_valid;
rready  <= read_ready;

a_hs <= addr_valid and arready;
d_hs <= read_ready and rvalid;

axi_next : process (state, start, addr_ready, burst_done)
begin
addr_valid <= '0';
read_ready <= '0';

case (state) is
when axi_wait  =>                           if (start      = '1') then next_state <= axi_raddr;  else next_state <= axi_wait;  end if;
when axi_raddr => addr_valid <= fifo_ready; if (addr_ready = '1') then next_state <= axi_rdata;  else next_state <= axi_raddr; end if;
when axi_rdata => read_ready <= '1';        if (burst_done = '1') then next_state <= last_state; else next_state <= axi_rdata; end if;
when others    =>                                                      next_state <= axi_wait;
end case;
end process;

axi_addr_cnt : process (clk)
begin
    if (rising_edge(clk)) then
        if    (start = '1') then addr <= unsigned(base_addr); burst_count <= (others => '0');
        elsif (a_hs  = '1') then addr <= addr + (256 * 16);   burst_count <= burst_count + 1;
        end if;
    end if;
end process;

axi_fsm : process (clk)
begin
    if (rising_edge(clk)) then
        if (reset = '1') then state <= axi_reset; else state <= next_state; end if;
    end if;
end process;

bigtosmall(127 downto 96) <= rdata( 31 downto  0);
bigtosmall( 95 downto 64) <= rdata( 63 downto 32);
bigtosmall( 63 downto 32) <= rdata( 95 downto 64);
bigtosmall( 31 downto  0) <= rdata(127 downto 96);

video_fifo : fifo_generator_0
port map (
    clk         => clk,
    srst        => start,
    din         => bigtosmall,
    wr_en       => d_hs,
    rd_en       => continue,
    dout        => data_out,
    full        => open,
    empty       => open,
    prog_full   => fifo_full,
    wr_rst_busy => wr_rst_busy,
    rd_rst_busy => rd_rst_busy
);
end Behavioral;
