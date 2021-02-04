----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/03/2021 01:01:44 PM
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
end axis_bridge;

architecture behavioral of axis_bridge is
--------------------------------------------------------------------------------
signal hs_d : std_logic := '0';
--------------------------------------------------------------------------------
begin
--------------------------------------------------------------------------------
mst_tdata  <= slv_tdata;
mst_tdest  <= slv_tdest;
mst_tlast  <= slv_tlast;
slv_tready <= mst_tready;
mst_tuser  <= slv_tuser;
mst_tvalid <= slv_tvalid;

hs_d <= slv_tvalid and mst_tready;

sof <= slv_tuser and hs_d;
eol <= slv_tlast and hs_d;
dot <= hs_d;
--------------------------------------------------------------------------------
end behavioral;
