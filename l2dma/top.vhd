----------------------------------------------------------------------------------
-- Company: 
-- Engineer: jcds
-- 
-- Create Date: 09/28/2020 04:02:09 PM
-- Design Name: 
-- Module Name: top - behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: v3
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
    
    -- axil control
    axil_awvalid : in  std_logic;
    axil_awready : out std_logic;
    axil_awaddr  : in  std_logic_vector( 7 downto 0);    
    axil_wvalid  : in  std_logic;
    axil_wready  : out std_logic;
    axil_wdata   : in  std_logic_vector(31 downto 0);
    axil_wstrb   : in  std_logic_vector( 3 downto 0);    
    axil_bvalid  : out std_logic;
    axil_bready  : in  std_logic;
    axil_bresp   : out std_logic_vector( 1 downto 0);    
    axil_arvalid : in  std_logic;
    axil_arready : out std_logic;
    axil_araddr  : in  std_logic_vector( 7 downto 0);    
    axil_rvalid  : out std_logic;
    axil_rready  : in  std_logic;
    axil_rdata   : out std_logic_vector(31 downto 0);
    axil_rresp   : out std_logic_vector( 1 downto 0);
    
    -- stream 0
    axis0_tdata  : in  std_logic_vector(31 downto 0);
    axis0_tdest  : in  std_logic;
    axis0_tid    : in  std_logic;
    axis0_tkeep  : in  std_logic_vector( 3 downto 0);
    axis0_tlast  : in  std_logic;
    axis0_tstrb  : in  std_logic_vector( 3 downto 0);
    axis0_tuser  : in  std_logic;
    axis0_tvalid : in  std_logic;
    axis0_tready : out std_logic;
    
    -- stream 1
    axis1_tdata  : in  std_logic_vector(31 downto 0);
    axis1_tdest  : in  std_logic;
    axis1_tid    : in  std_logic;
    axis1_tkeep  : in  std_logic_vector( 3 downto 0);
    axis1_tlast  : in  std_logic;
    axis1_tstrb  : in  std_logic_vector( 3 downto 0);
    axis1_tuser  : in  std_logic;
    axis1_tvalid : in  std_logic;
    axis1_tready : out std_logic;
    
    -- axi 0
    axi0_awaddr   : out std_logic_vector( 31 downto 0);    
    axi0_awcache  : out std_logic_vector(  3 downto 0);    
    axi0_awlock   : out std_logic_vector(  0 downto 0);
    axi0_awprot   : out std_logic_vector(  2 downto 0);
    axi0_awqos    : out std_logic_vector(  3 downto 0);    
    axi0_awregion : out std_logic_vector(  3 downto 0);    
    axi0_awlen    : out std_logic_vector(  7 downto 0);
    axi0_awsize   : out std_logic_vector(  2 downto 0);
    axi0_awburst  : out std_logic_vector(  1 downto 0);    
    axi0_awvalid  : out std_logic;
    axi0_awready  : in  std_logic;
    axi0_wdata    : out std_logic_vector(127 downto 0);
    axi0_wstrb    : out std_logic_vector( 15 downto 0);
    axi0_wlast    : out std_logic;
    axi0_wvalid   : out std_logic;
    axi0_wready   : in  std_logic;
    axi0_bresp    : in  std_logic_vector(  1 downto 0);
    axi0_bvalid   : in  std_logic;
    axi0_bready   : out std_logic;
    
    -- axi 1
    axi1_awaddr   : out std_logic_vector( 31 downto 0);    
    axi1_awcache  : out std_logic_vector(  3 downto 0);    
    axi1_awlock   : out std_logic_vector(  0 downto 0);
    axi1_awprot   : out std_logic_vector(  2 downto 0);
    axi1_awqos    : out std_logic_vector(  3 downto 0);    
    axi1_awregion : out std_logic_vector(  3 downto 0);    
    axi1_awlen    : out std_logic_vector(  7 downto 0);
    axi1_awsize   : out std_logic_vector(  2 downto 0);
    axi1_awburst  : out std_logic_vector(  1 downto 0);    
    axi1_awvalid  : out std_logic;
    axi1_awready  : in  std_logic;
    axi1_wdata    : out std_logic_vector(127 downto 0);
    axi1_wstrb    : out std_logic_vector( 15 downto 0);
    axi1_wlast    : out std_logic;
    axi1_wvalid   : out std_logic;
    axi1_wready   : in  std_logic;
    axi1_bresp    : in  std_logic_vector(  1 downto 0);
    axi1_bvalid   : in  std_logic;
    axi1_bready   : out std_logic
);
end top;

architecture behavioral of top is
--------------------------------------------------------------------------------
signal reset : std_logic := '0';

signal count : std_logic_vector(15 downto 0) := (others => '0');
signal base0 : std_logic_vector(31 downto 0) := (others => '0');
signal base1 : std_logic_vector(31 downto 0) := (others => '0');

signal enable : std_logic := '0';
signal busy   : std_logic := '0';

signal start : std_logic := '0';
signal busy0 : std_logic := '0';
signal busy1 : std_logic := '0';
signal full0 : std_logic := '0';
signal full1 : std_logic := '0';
--------------------------------------------------------------------------------
begin
--------------------------------------------------------------------------------
reset <= not resetn;

busy  <= busy0 or busy1;
start <= enable and (not busy);

control : entity work.axil_slave
port map (
    clk   => clk,
    reset => reset,
    
    -- write channel
    awvalid => axil_awvalid,
    awready => axil_awready,
    awaddr  => axil_awaddr,
    wvalid  => axil_wvalid,
    wready  => axil_wready,
    wdata   => axil_wdata,
    wstrb   => axil_wstrb,
    bvalid  => axil_bvalid,
    bready  => axil_bready,
    bresp   => axil_bresp,
    
    -- read channel
    arvalid => axil_arvalid,
    arready => axil_arready,
    araddr  => axil_araddr,
    rvalid  => axil_rvalid,
    rready  => axil_rready,
    rdata   => axil_rdata,
    rresp   => axil_rresp,
    
    -- control
    start => enable,
    count => count,
    base0 => base0,
    base1 => base1,
    busy  => busy,
    full0 => full0,
    full1 => full1
);

s2mm0 : entity work.s2mm
port map (
    clk   => clk,
    reset => reset,
    
    -- stream
    tdata  => axis0_tdata,
    tdest  => axis0_tdest,
    tid    => axis0_tid,
    tkeep  => axis0_tkeep,
    tlast  => axis0_tlast,
    tstrb  => axis0_tstrb,
    tuser  => axis0_tuser,
    tvalid => axis0_tvalid,
    tready => axis0_tready,
    
    -- write address channel
    awaddr   => axi0_awaddr,
    awcache  => axi0_awcache,
    awlock   => axi0_awlock,
    awprot   => axi0_awprot,
    awqos    => axi0_awqos,
    awregion => axi0_awregion,
    awlen    => axi0_awlen,
    awsize   => axi0_awsize,
    awburst  => axi0_awburst,
    awvalid  => axi0_awvalid,
    awready  => axi0_awready,
    
    -- write data channel
    wdata  => axi0_wdata,
    wstrb  => axi0_wstrb,
    wlast  => axi0_wlast,
    wvalid => axi0_wvalid,
    wready => axi0_wready,
    
    -- write response channel    
    bresp  => axi0_bresp,
    bvalid => axi0_bvalid,
    bready => axi0_bready,
    
    -- control
    start => start,
    count => count,
    base  => base0,
    busy  => busy0,
    full  => full0
);

s2mm1 : entity work.s2mm
port map (
    clk   => clk,
    reset => reset,
    
    -- stream
    tdata  => axis1_tdata,
    tdest  => axis1_tdest,
    tid    => axis1_tid,
    tkeep  => axis1_tkeep,
    tlast  => axis1_tlast,
    tstrb  => axis1_tstrb,
    tuser  => axis1_tuser,
    tvalid => axis1_tvalid,
    tready => axis1_tready,
    
    -- write address channel
    awaddr   => axi1_awaddr,
    awcache  => axi1_awcache,
    awlock   => axi1_awlock,
    awprot   => axi1_awprot,
    awqos    => axi1_awqos,
    awregion => axi1_awregion,
    awlen    => axi1_awlen,
    awsize   => axi1_awsize,
    awburst  => axi1_awburst,
    awvalid  => axi1_awvalid,
    awready  => axi1_awready,
    
    -- write data channel
    wdata  => axi1_wdata,
    wstrb  => axi1_wstrb,
    wlast  => axi1_wlast,
    wvalid => axi1_wvalid,
    wready => axi1_wready,
    
    -- write response channel    
    bresp  => axi1_bresp,
    bvalid => axi1_bvalid,
    bready => axi1_bready,
    
    -- control
    start => start,
    count => count,
    base  => base1,
    busy  => busy1,
    full  => full1
);
--------------------------------------------------------------------------------
end behavioral;
