----------------------------------------------------------------------------------
-- Company: 
-- Engineer: jcds
-- 
-- Create Date: 10/02/2020 05:28:23 PM
-- Design Name: 
-- Module Name: axis_bridge - behavioral
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

entity axis_bridge is
port (
    clk   : in std_logic;
    reset : in std_logic;
    
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
    mst_tready : in  std_logic;
    
    -- axis bridge
    data_hs : out std_logic;
    sof     : out std_logic;
    eol     : out std_logic;
    
    -- control
    embed : in std_logic;
    meta  : in std_logic_vector(31 downto 0)
);
end axis_bridge;

architecture behavioral of axis_bridge is
--------------------------------------------------------------------------------
signal hs : std_logic := '0';
--------------------------------------------------------------------------------
begin
--------------------------------------------------------------------------------
-- bridge
mst_tdata  <= slv_tdata when embed = '0' else meta;
mst_tstrb  <= slv_tstrb;
mst_tkeep  <= slv_tkeep;
mst_tlast  <= slv_tlast;
mst_tid    <= slv_tid;
mst_tdest  <= slv_tdest;
mst_tuser  <= slv_tuser;
mst_tvalid <= slv_tvalid;
slv_tready <= mst_tready;

hs <= slv_tvalid and mst_tready;

data_hs <= hs;
sof     <= hs and slv_tuser;
eol     <= hs and slv_tlast;
--------------------------------------------------------------------------------
end behavioral;
