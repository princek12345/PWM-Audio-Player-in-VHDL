----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/12/2022 11:20:15 PM
-- Design Name: 
-- Module Name: PWM_wave - Behavioral
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

entity PWM_wave is
  Port ( 
  clk : in std_logic;
  reset : in std_logic;
  count : in std_logic_vector(11 downto 0);
  msg : in std_logic_vector(7 downto 0);
  pwm_out : out std_logic
  
  );
end PWM_wave;

architecture Behavioral of PWM_wave is

begin

    P1: process(clk)
    
    begin 
    
    if (reset='1') then
    
        pwm_out <= '0';
    
    elsif(rising_edge(clk)) then
    
        if(count(7 downto 0) < msg(7 downto 0)) then
            pwm_out <= '1';
        
        else 
            pwm_out <= '0';
        
        end if;
    end if;
    
   end process;

end Behavioral;
