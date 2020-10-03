----------------------------------------------------------------------------------
-- Company: 
-- Engineer: jcds
-- 
-- Create Date: 10/02/2020 08:13:25 PM
-- Design Name: 
-- Module Name: top - behavioral
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

entity top is
port (
    clk    : in std_logic;
    resetn : in std_logic;
    
    -- axil slave
    awvalid : in  std_logic;
    awready : out std_logic;
    awaddr  : in  std_logic_vector( 7 downto 0);    
    wvalid  : in  std_logic;
    wready  : out std_logic;
    wdata   : in  std_logic_vector(31 downto 0);
    wstrb   : in  std_logic_vector( 3 downto 0);    
    bvalid  : out std_logic;
    bready  : in  std_logic;
    bresp   : out std_logic_vector( 1 downto 0);    
    arvalid : in  std_logic;
    arready : out std_logic;
    araddr  : in  std_logic_vector( 7 downto 0);    
    rvalid  : out std_logic;
    rready  : in  std_logic;
    rdata   : out std_logic_vector(31 downto 0);
    rresp   : out std_logic_vector( 1 downto 0);
    
    -- axis slave
    slv_tdata  : in  std_logic_vector(31 downto 0);
    slv_tstrb  : in  std_logic_vector( 3 downto 0);
    slv_tkeep  : in  std_logic_vector( 3 downto 0);
    slv_tlast  : in  std_logic;
    slv_tid    : in  std_logic;
    slv_tdest  : in  std_logic;
    slv_tuser  : in  std_logic;
    slv_tvalid : in  std_logic;
    slv_tready : out std_logic;
    
    -- axis master
    mst_tdata  : out std_logic_vector(31 downto 0);
    mst_tstrb  : out std_logic_vector( 3 downto 0);
    mst_tkeep  : out std_logic_vector( 3 downto 0);
    mst_tlast  : out std_logic;
    mst_tid    : out std_logic;
    mst_tdest  : out std_logic;
    mst_tuser  : out std_logic;
    mst_tvalid : out std_logic;
    mst_tready : in  std_logic
);
end top;

architecture behavioral of top is
--------------------------------------------------------------------------------
signal reset   : std_logic := '0';
signal data_hs : std_logic := '0';
signal sof     : std_logic := '0';
signal eol     : std_logic := '0';
signal embed   : std_logic := '0';
signal start   : std_logic := '0';
signal ready   : std_logic := '0';
signal locked  : std_logic := '0';

signal width  : std_logic_vector(11 downto 0) := (others => '0');
signal height : std_logic_vector(11 downto 0) := (others => '0');
signal meta   : std_logic_vector(31 downto 0) := (others => '0');
--------------------------------------------------------------------------------
begin
--------------------------------------------------------------------------------
reset <= not resetn;

axil : entity work.axil_slave
port map (
    clk   => clk,
    reset => reset,
    
    -- axil slave
    awvalid => awvalid,
    awready => awready,
    awaddr  => awaddr,
    wvalid  => wvalid,
    wready  => wready,
    wdata   => wdata,
    wstrb   => wstrb,
    bvalid  => bvalid,
    bready  => bready,
    bresp   => bresp,
    arvalid => arvalid,
    arready => arready,
    araddr  => araddr,
    rvalid  => rvalid,
    rready  => rready,
    rdata   => rdata,
    rresp   => rresp,
    
    -- control
    start  => start,
    ready  => ready,
    locked => locked,
    width  => width,
    height => height
);

axis : entity work.axis_bridge
port map (
    clk   => clk,
    reset => reset,
    
    -- axis slave
    slv_tdata  => slv_tdata,
    slv_tstrb  => slv_tstrb,
    slv_tkeep  => slv_tkeep,
    slv_tlast  => slv_tlast,
    slv_tid    => slv_tid,
    slv_tdest  => slv_tdest,
    slv_tuser  => slv_tuser,
    slv_tvalid => slv_tvalid,
    slv_tready => slv_tready,
    
    -- axis master
    mst_tdata  => mst_tdata,
    mst_tstrb  => mst_tstrb,
    mst_tkeep  => mst_tkeep,
    mst_tlast  => mst_tlast,
    mst_tid    => mst_tid,
    mst_tdest  => mst_tdest,
    mst_tuser  => mst_tuser,
    mst_tvalid => mst_tvalid,
    mst_tready => mst_tready,
    
    -- axis bridge
    data_hs => data_hs,
    sof     => sof,
    eol     => eol,
    
    -- control
    embed => embed,
    meta  => meta
);

timing : entity work.status
port map (
    clk   => clk,
    reset => reset,
    
    -- axis bridge
    data_hs => data_hs,
    sof     => sof,
    eol     => eol,
    
    -- control
    start  => start,
    ready  => ready,
    locked => locked,
    width  => width,
    height => height,
    embed  => embed,
    meta   => meta
);
--------------------------------------------------------------------------------
end behavioral;
