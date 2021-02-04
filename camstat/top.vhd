----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/03/2021 07:28:39 PM
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
    
    -- axis slave
    slv_tdata  : in  std_logic_vector(15 downto 0);
    slv_tdest  : in  std_logic_vector(7 downto 0);
    slv_tlast  : in  std_logic;
    slv_tready : out std_logic;
    slv_tuser  : in  std_logic;
    slv_tvalid : in  std_logic;    
    
    -- axis master
    mst_tdata  : out std_logic_vector(15 downto 0);
    mst_tdest  : out std_logic_vector(7 downto 0);
    mst_tlast  : out std_logic;
    mst_tready : in  std_logic;
    mst_tuser  : out std_logic;
    mst_tvalid : out std_logic;
    
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
    
    -- irq output
    irq : out std_logic
);
end top;

architecture behavioral of top is
--------------------------------------------------------------------------------
component axil_slave is
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
    
    -- irq output
    irq : out std_logic
);
end component;

component counters is
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
end component;

component axis_bridge is
port (
    -- axis slave
    slv_tdata  : in  std_logic_vector(15 downto 0);
    slv_tdest  : in  std_logic_vector(7 downto 0);
    slv_tlast  : in  std_logic;
    slv_tready : out std_logic;
    slv_tuser  : in  std_logic;
    slv_tvalid : in  std_logic;    
    
    -- axis master
    mst_tdata  : out std_logic_vector(15 downto 0);
    mst_tdest  : out std_logic_vector(7 downto 0);
    mst_tlast  : out std_logic;
    mst_tready : in  std_logic;
    mst_tuser  : out std_logic;
    mst_tvalid : out std_logic;
    
    -- sync
    sof : out std_logic;
    eol : out std_logic;
    dot : out std_logic
);
end component;

signal sof : std_logic := '0';
signal eol : std_logic := '0';
signal dot : std_logic := '0';

signal reset : std_logic := '0';

signal lw : std_logic_vector(15 downto 0) := (others => '0');
signal lh : std_logic_vector(15 downto 0) := (others => '0');
signal ly : std_logic_vector(15 downto 0) := (others => '0');

signal lw_done : std_logic := '0';
signal lh_done : std_logic := '0';
signal locked  : std_logic := '0';

signal lyf : std_logic := '0';

signal lyc : std_logic_vector(15 downto 0) := (others => '0');

signal irq_ack_sof : std_logic := '0';
signal irq_ack_eol : std_logic := '0';
signal irq_ack_lyc : std_logic := '0';

signal irq_sof : std_logic := '0';
signal irq_eol : std_logic := '0';
signal irq_lyc : std_logic := '0';
--------------------------------------------------------------------------------
begin
--------------------------------------------------------------------------------
reset <= not resetn;

axil : axil_slave
port map (
    clk   => clk,
    reset => reset,

    -- write channel
    awvalid => awvalid,
    awready => awready,
    awaddr  => awaddr,
    
    wvalid => wvalid,
    wready => wready,
    wdata  => wdata,
    wstrb  => wstrb,
    
    bvalid => bvalid,
    bready => bready,
    bresp  => bresp,
    
    -- read channel
    arvalid => arvalid,
    arready => arready,
    araddr  => araddr,
    
    rvalid => rvalid,
    rready => rready,
    rdata  => rdata,
    rresp  => rresp,
    
    -- registers    
    lw => lw,
    lh => lh,
    ly => ly,
    
    lw_done => lw_done,
    lh_done => lh_done,
    locked  => locked,
    
    lyf => lyf,
    lyc => lyc,
    
    irq_ack_sof => irq_ack_sof,
    irq_ack_eol => irq_ack_eol,
    irq_ack_lyc => irq_ack_lyc,
    
    irq_sof => irq_sof,
    irq_eol => irq_eol,
    irq_lyc => irq_lyc,
    
    -- irq output
    irq => irq
);

cnt : counters
port map (
    clk   => clk,
    reset => reset,

    -- axis
    sof => sof,
    eol => eol,
    dot => dot,
    
    -- counters
    lw => lw,
    lh => lh,
    ly => ly,
    
    lw_done => lw_done,
    lh_done => lh_done,
    locked  => locked,
    
    lyf => lyf,
    
    -- irq
    lyc => lyc,

    irq_ack_sof => irq_ack_sof,
    irq_ack_eol => irq_ack_eol,
    irq_ack_lyc => irq_ack_lyc,
    
    irq_sof => irq_sof,
    irq_eol => irq_eol,
    irq_lyc => irq_lyc
);

axis : axis_bridge
port map (
    -- axis slave
    slv_tdata  => slv_tdata,
    slv_tdest  => slv_tdest,
    slv_tlast  => slv_tlast,
    slv_tready => slv_tready,
    slv_tuser  => slv_tuser,
    slv_tvalid => slv_tvalid,
    
    -- axis master
    mst_tdata  => mst_tdata,
    mst_tdest  => mst_tdest,
    mst_tlast  => mst_tlast,
    mst_tready => mst_tready,
    mst_tuser  => mst_tuser,
    mst_tvalid => mst_tvalid,
    
    -- sync
    sof => sof,
    eol => eol,
    dot => dot 
);
--------------------------------------------------------------------------------
end behavioral;
