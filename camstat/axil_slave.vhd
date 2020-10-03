----------------------------------------------------------------------------------
-- Company: 
-- Engineer: jcds
-- 
-- Create Date: 10/02/2020 08:21:22 PM
-- Design Name: 
-- Module Name: axil_slave - behavioral
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

entity axil_slave is
port (
    clk   : in std_logic;
    reset : in std_logic;
    
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
    
    -- control
    start  : out std_logic;
    ready  : in  std_logic;
    locked : in  std_logic;
    width  : in  std_logic_vector(11 downto 0);
    height : in  std_logic_vector(11 downto 0)
);
end axil_slave;

architecture behavioral of axil_slave is
--------------------------------------------------------------------------------
type axiw_state is (axiw_reset, axiw_addr, axiw_data, axiw_resp);
type axir_state is (axir_reset, axir_addr, axir_data);

signal wstate      : axiw_state := axiw_reset;
signal wstate_next : axiw_state := axiw_reset;
signal rstate      : axir_state := axir_reset;
signal rstate_next : axir_state := axir_reset;

signal waddr_hs : std_logic := '0';
signal wdata_hs : std_logic := '0';
signal raddr_hs : std_logic := '0';

signal waddr : std_logic_vector(7 downto 0) := (others => '0');
--------------------------------------------------------------------------------
begin
--------------------------------------------------------------------------------
bresp <= "00";
rresp <= "00";

wsel : process(wstate, awvalid, wvalid, bready)
begin
    awready <= '0'; waddr_hs <= '0'; wstate_next <= wstate;
    wready  <= '0'; wdata_hs <= '0';
    bvalid  <= '0';
    
    case (wstate) is
    when axiw_addr => awready <= '1'; if (awvalid = '1') then waddr_hs <= '1'; wstate_next <= axiw_data; end if;
    when axiw_data => wready  <= '1'; if (wvalid  = '1') then wdata_hs <= '1'; wstate_next <= axiw_resp; end if;
    when axiw_resp => bvalid  <= '1'; if (bready  = '1') then                  wstate_next <= axiw_addr; end if;
    when others    =>                                                          wstate_next <= axiw_addr;
    end case;
end process;

wfsm : process(clk)
begin
    if (rising_edge(clk)) then
        if (reset = '1') then wstate <= axiw_reset; else wstate <= wstate_next; end if;
    end if;
end process;

waddr_reg : process(clk)
begin
    if (rising_edge(clk)) then
        if (waddr_hs = '1') then waddr <= awaddr; end if;
    end if;
end process;

rsel : process(rstate, arvalid, rready)
begin
    arready <= '0'; raddr_hs <= '0'; rstate_next <= rstate;
    rvalid  <= '0';
    
    case (rstate) is
    when axir_addr => arready <= '1'; if (arvalid = '1') then raddr_hs <= '1'; rstate_next <= axir_data; end if;
    when axir_data => rvalid  <= '1'; if (rready  = '1') then                  rstate_next <= axir_addr; end if;
    when others    =>                                                          rstate_next <= axir_addr;
    end case;
end process;

rfsm : process(clk)
begin
    if (rising_edge(clk)) then
        if (reset = '1') then rstate <= axir_reset; else rstate <= rstate_next; end if;
    end if;
end process;

start <= '1' when unsigned(waddr) = 0 and wdata(0) = '1' and wdata_hs = '1' else '0';

rdata_reg : process(clk)
begin
    if (rising_edge(clk)) then
        if (raddr_hs = '1') then
            case (araddr) is
            when x"0"   => rdata <= (0 => not ready, 1 => locked, others => '0');
            when x"4"   => rdata(11 downto  0) <= width;
                           rdata(15 downto 12) <= (others => '0');
                           rdata(27 downto 16) <= height;
                           rdata(31 downto 28) <= (others => '0');
            when others => rdata <= (others => '1');
            end case;
        end if;
    end if;
end process;
--------------------------------------------------------------------------------
end behavioral;
