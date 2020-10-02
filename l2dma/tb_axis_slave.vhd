----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/28/2020 04:09:49 PM
-- Design Name: 
-- Module Name: tb_axis_slave - behavioral
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

entity tb_axis_slave is
port (
    reset : in  std_logic;

    start : in  std_logic;
    count : in  std_logic_vector(11 downto 0);
    idle  : out std_logic;
    wren  : out std_logic;
    din   : out std_logic_vector(31 downto 0)
);
end tb_axis_slave;

architecture behavioral of tb_axis_slave is
--------------------------------------------------------------------------------
signal clk     : std_logic := '0';
signal tuser   : std_logic := '0';
signal tlast   : std_logic := '0';
signal tvalid  : std_logic := '0';
signal tready : std_logic := '0';
signal tdata : std_logic_vector(31 downto 0);


--signal start   : std_logic := '0';
--signal count   : std_logic_vector(11 downto 0) := (others => '0');
--signal idle    : std_logic := '0';
--signal capture : std_logic := '0';
--------------------------------------------------------------------------------
begin
--------------------------------------------------------------------------------
clk_proc : process
begin
    clk <= '0';
    wait for 5 ns;
    clk <= '1';
    wait for 5 ns;
end process;

cam_proc : process
begin
    -- line 0
    wait until rising_edge(clk); -- 0
    tvalid <= '1'; tuser <= '1'; tlast <= '0'; tdata <= x"00000000";
    wait until rising_edge(clk); -- 1
    tvalid <= '1'; tuser <= '0'; tlast <= '0'; tdata <= x"00000001";
    wait until rising_edge(clk); -- 2
    tvalid <= '1'; tuser <= '0'; tlast <= '0'; tdata <= x"00000002";
    wait until rising_edge(clk); -- 3
    tvalid <= '1'; tuser <= '0'; tlast <= '0'; tdata <= x"00000003";
    wait until rising_edge(clk); -- 4
    tvalid <= '1'; tuser <= '0'; tlast <= '0'; tdata <= x"00000004";
    wait until rising_edge(clk); -- 5
    tvalid <= '1'; tuser <= '0'; tlast <= '0'; tdata <= x"00000005";
    wait until rising_edge(clk); -- 6
    tvalid <= '1'; tuser <= '0'; tlast <= '0'; tdata <= x"00000006";
    wait until rising_edge(clk); -- 7
    tvalid <= '1'; tuser <= '0'; tlast <= '1'; tdata <= x"00000007";

    -- line 1
    wait until rising_edge(clk); -- 0
    tvalid <= '1'; tuser <= '0'; tlast <= '0'; tdata <= x"00000008";
    wait until rising_edge(clk); -- 1
    tvalid <= '1'; tuser <= '0'; tlast <= '0'; tdata <= x"00000009";
    wait until rising_edge(clk); -- 2
    tvalid <= '1'; tuser <= '0'; tlast <= '0'; tdata <= x"0000000A";
    wait until rising_edge(clk); -- 3
    tvalid <= '1'; tuser <= '0'; tlast <= '0'; tdata <= x"0000000B";
    wait until rising_edge(clk);
    tvalid <= '0'; tuser <= '0'; tlast <= '0'; tdata <= x"FFFFFFFF";
    wait until rising_edge(clk); -- 4
    tvalid <= '1'; tuser <= '0'; tlast <= '0'; tdata <= x"0000000C";
    wait until rising_edge(clk); -- 5
    tvalid <= '1'; tuser <= '0'; tlast <= '0'; tdata <= x"0000000D";
    wait until rising_edge(clk); -- 6
    tvalid <= '1'; tuser <= '0'; tlast <= '0'; tdata <= x"0000000E";
    wait until rising_edge(clk); -- 7
    tvalid <= '1'; tuser <= '0'; tlast <= '1'; tdata <= x"0000000F";
    
    -- line 2
    wait until rising_edge(clk); -- 0
    tvalid <= '1'; tuser <= '0'; tlast <= '0'; tdata <= x"00000010";
    wait until rising_edge(clk); -- 1
    tvalid <= '1'; tuser <= '0'; tlast <= '0'; tdata <= x"00000011";
    wait until rising_edge(clk); -- 2
    tvalid <= '1'; tuser <= '0'; tlast <= '0'; tdata <= x"00000012";
    wait until rising_edge(clk); -- 3
    tvalid <= '1'; tuser <= '0'; tlast <= '0'; tdata <= x"00000013";
    wait until rising_edge(clk); -- 4
    tvalid <= '1'; tuser <= '0'; tlast <= '0'; tdata <= x"00000014";
    wait until rising_edge(clk); -- 5
    tvalid <= '1'; tuser <= '0'; tlast <= '0'; tdata <= x"00000015";
    wait until rising_edge(clk); -- 6
    tvalid <= '1'; tuser <= '0'; tlast <= '0'; tdata <= x"00000016";
    wait until rising_edge(clk); -- 7
    tvalid <= '1'; tuser <= '0'; tlast <= '1'; tdata <= x"00000017";
    
    -- line 3
    wait until rising_edge(clk); -- 0
    tvalid <= '1'; tuser <= '0'; tlast <= '0'; tdata <= x"00000018";
    wait until rising_edge(clk); -- 1
    tvalid <= '1'; tuser <= '0'; tlast <= '0'; tdata <= x"00000019";
    wait until rising_edge(clk); -- 2
    tvalid <= '1'; tuser <= '0'; tlast <= '0'; tdata <= x"0000001A";
    wait until rising_edge(clk); -- 3
    tvalid <= '1'; tuser <= '0'; tlast <= '0'; tdata <= x"0000001B";
    wait until rising_edge(clk); -- 4
    tvalid <= '1'; tuser <= '0'; tlast <= '0'; tdata <= x"0000001C";
    wait until rising_edge(clk); -- 5
    tvalid <= '1'; tuser <= '0'; tlast <= '0'; tdata <= x"0000001D";
    wait until rising_edge(clk); -- 6
    tvalid <= '1'; tuser <= '0'; tlast <= '0'; tdata <= x"0000001E";
    wait until rising_edge(clk); -- 7
    tvalid <= '1'; tuser <= '0'; tlast <= '1'; tdata <= x"0000001F";
end process;

dut : entity work.axis_slave
port map (
    clk   => clk,
    reset => reset,
    
    -- stream
    tdata  => tdata,
    tdest  => '0',
    tid    => '0',
    tkeep  => "0000",
    tlast  => tlast,
    tstrb  => "0000",
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
end behavioral;
