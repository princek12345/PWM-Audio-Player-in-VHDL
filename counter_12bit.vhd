----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/12/2022 11:20:15 PM
-- Design Name: 
-- Module Name: counter_12bit - Behavioral
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
use IEEE.NUMERIC_STD.ALL;
use IEEE.std_logic_unsigned.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity counter_12bit is
  Port ( 

    clk : in std_logic;
    reset : in std_logic;
    count : buffer std_logic_vector(11 downto 0)
   
   ); 
end counter_12bit;

architecture Behavioral of counter_12bit is

begin

    C1: process(clk, reset)
    
    begin
    
    if (reset='1') then
    
        count <= "000000000000"; 
    
    elsif (rising_edge(clk)) then 
    
        count <= count + 1;
    
    end if;
    
    end process;

end Behavioral;
