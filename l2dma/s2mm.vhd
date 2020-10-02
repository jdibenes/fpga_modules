----------------------------------------------------------------------------------
-- Company: 
-- Engineer: jcds
-- 
-- Create Date: 09/29/2020 02:06:59 PM
-- Design Name: 
-- Module Name: s2mm - behavioral
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

entity s2mm is
port (
    clk   : in std_logic;
    reset : in std_logic;
    
    -- stream
    tdata  : in  std_logic_vector(31 downto 0);
    tdest  : in  std_logic;
    tid    : in  std_logic;
    tkeep  : in  std_logic_vector( 3 downto 0);
    tlast  : in  std_logic;
    tstrb  : in  std_logic_vector( 3 downto 0);
    tuser  : in  std_logic;
    tvalid : in  std_logic;
    tready : out std_logic;
    
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
    
    -- control
    start : in std_logic;
    count : in std_logic_vector(11 downto 0);
    base  : in std_logic_vector(31 downto 0);
    busy  : out std_logic;
    full  : out std_logic
);
end s2mm;

architecture behavioral of s2mm is
--------------------------------------------------------------------------------
component fifo_generator_0 is
PORT (
    clk         : IN  STD_LOGIC;
    srst        : IN  STD_LOGIC;
    din         : IN  STD_LOGIC_VECTOR( 31 DOWNTO 0);
    wr_en       : IN  STD_LOGIC;
    rd_en       : IN  STD_LOGIC;
    dout        : OUT STD_LOGIC_VECTOR(127 DOWNTO 0);
    full        : OUT STD_LOGIC;
    empty       : OUT STD_LOGIC;
    prog_empty  : OUT STD_LOGIC;
    wr_rst_busy : OUT STD_LOGIC;
    rd_rst_busy : OUT STD_LOGIC
);
end component;

signal din      : std_logic_vector( 31 downto 0) := (others => '0');
signal dout_big : std_logic_vector(127 downto 0) := (others => '0');
signal dout     : std_logic_vector(127 downto 0) := (others => '0');

signal wren   : std_logic := '0';
signal wbusy  : std_logic := '0';
signal rden   : std_logic := '0';
signal empty  : std_logic := '0';
--signal packet : std_logic := '0';
signal rbusy  : std_logic := '0';
signal addrcycle : std_logic := '0';

signal idle : std_logic := '0';
begin
--------------------------------------------------------------------------------
busy <= wbusy or rbusy or (not idle) or (not empty); --or (not addrcycle);

axis : entity work.axis_slave
port map (
    clk   => clk,
    reset => reset,
    
    -- stream
    tdata  => tdata,
    tdest  => tdest,
    tid    => tid,
    tkeep  => tkeep,
    tlast  => tlast,
    tstrb  => tstrb,
    tuser  => tuser,
    tvalid => tvalid,
    tready => tready,
    
    -- FIFO write
    wren => wren,
    din  => din,
    
    -- control
    start => start,
    count => count,
    
    -- axis state
    idle => idle 
);

s2mm_fifo : fifo_generator_0
port map (
    clk  => clk,
    srst => reset,
    
    -- FIFO write
    din         => din,
    wr_en       => wren,
    full        => full, -- use for dbg
    wr_rst_busy => wbusy,
    
    -- FIFO read
    rd_en       => rden,
    dout        => dout_big,
    empty       => empty, -- use for dbg
    prog_empty  => open,--packet,
    rd_rst_busy => rbusy 
);

dout(127 downto 96) <= dout_big( 31 downto  0);
dout( 95 downto 64) <= dout_big( 63 downto 32);
dout( 63 downto 32) <= dout_big( 95 downto 64);
dout( 31 downto  0) <= dout_big(127 downto 96);

aximm : entity work.aximm_master
port map (
    clk   => clk,
    reset => reset,
    
    -- write address channel
    awaddr   => awaddr,
    awcache  => awcache,
    awlock   => awlock,
    awprot   => awprot,
    awqos    => awqos,
    awregion => awregion,
    awlen    => awlen,
    awsize   => awsize,
    awburst  => awburst,
    awvalid  => awvalid,
    awready  => awready,
    
    -- write data channel
    wdata  => wdata,
    wstrb  => wstrb,
    wlast  => wlast,
    wvalid => wvalid,
    wready => wready,
    
    -- write response channel    
    bresp  => bresp,
    bvalid => bvalid,
    bready => bready,

    -- FIFO read
    dout  => dout,
    rden  => rden,
    empty => empty,--packet,
    
    -- control
    start => start,
    base  => base,
    
    -- axis state
    idle => idle,
    
    -- aximm state
    addrcycle => addrcycle
);
--------------------------------------------------------------------------------
end behavioral;
