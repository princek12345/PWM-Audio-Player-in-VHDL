----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/13/2022 01:49:29 AM
-- Design Name: 
-- Module Name: Top_Level_block - Behavioral
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

entity Top_Level_block is
  Port ( 
    clk : in std_logic;
    reset : in std_logic;
    SW1 : in std_logic;
    SW2 : in std_logic;
    SW3 : in std_logic;
    SW4 : in std_logic;
    
    ----
    EPROM_data : in std_logic_vector(7 downto 0);
    --count : buffer std_logic_vector(11 downto 0);
    curr_address : buffer std_logic_vector(18 downto 0);
    
--     msg : buffer std_logic_vector(7 downto 0);
--     address_start : buffer std_logic_vector(18 downto 0);
--     length : buffer std_logic_vector(18 downto 0);    
--     msg_play : buffer std_logic;
-- --    add_ready : buffer std_logic;
    
    pwm_out : out std_logic
  
  );
end Top_Level_block;

architecture Behavioral of Top_Level_block is

    signal count : std_logic_vector(11 downto 0);
    signal msg : std_logic_vector(7 downto 0);
    signal address_start : std_logic_vector(18 downto 0);
    signal length : std_logic_vector(18 downto 0);    
    signal msg_play : std_logic;
    signal add_ready : std_logic;
    --signal EPROM_data : std_logic_vector(7 downto 0);
 --   signal curr_address : std_logic_vector(19 downto 0);

component counter_12bit
  Port ( 

    clk : in std_logic;
    reset : in std_logic;
    count : buffer std_logic_vector(11 downto 0)
   
   );  
end component;

component PWM_wave
  Port ( 
  clk : in std_logic;
  reset : in std_logic;
  count : in std_logic_vector(11 downto 0);
  msg : in std_logic_vector(7 downto 0);
  pwm_out : out std_logic
  
  );  
end component;

component Switch_IP
  Port ( 
    clk : in std_logic;
    reset : in std_logic;
    SW1 : in std_logic;
    SW2 : in std_logic;
    SW3 : in std_logic;
    SW4 : in std_logic;
    address_start : buffer std_logic_vector(18 downto 0);
    length : buffer std_logic_vector(18 downto 0);
    
    msg_play : in std_logic;
    add_ready : out std_logic
    
  );
end component;

component Address_RW 
  Port ( 
    clk : in std_logic;
    reset : in std_logic;
    address_start : in std_logic_vector(18 downto 0);
    length : in std_logic_vector(18 downto 0);
    EPROM_data : in std_logic_vector(7 downto 0);
    
    curr_address : buffer std_logic_vector(18 downto 0);
    msg : out std_logic_vector(7 downto 0);
    
    count : in std_logic_vector(11 downto 0);
    msg_play : buffer std_logic;
    add_ready : in std_logic
  
  );
end component;


begin

Counter : counter_12bit port map(

    clk => clk,
    reset => reset,
    count => count
); 

PWM : PWM_wave port map(

  clk => clk,
  reset => reset,
  count => count,
  msg => msg,
  pwm_out => pwm_out
);

SW : Switch_IP port map(
    
    clk => clk,
    reset => reset,
    SW1 => SW1,
    SW2 => SW2,
    SW3 => SW3,
    SW4 => SW4,
    address_start => address_start,
    length => length,
    
    msg_play => msg_play,
    add_ready => add_ready
);

ADD: Address_RW port map(

    clk => clk,
    reset => reset,
    address_start => address_start,
    length => length,
    EPROM_data => EPROM_data,
    
    curr_address => curr_address,
    msg => msg,
    
    count => count,
    msg_play => msg_play,
    add_ready => add_ready
  );
  
end Behavioral;
