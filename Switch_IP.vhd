----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/12/2022 11:20:15 PM
-- Design Name: 
-- Module Name: Switch_IP - Behavioral
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

entity Switch_IP is
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
end Switch_IP;

architecture Behavioral of Switch_IP is

begin

    S1: process(clk,reset,SW1,SW2,SW3,SW4,msg_play)
    
    begin
    
        if (reset = '1') then
        
            address_start <= "000" & x"0000";
            length <= "000" & x"0000";
            add_ready <= '0';
        end if;
        
        if (msg_play='0') then
            
            if (SW1 = '1') then 
                address_start <= "111" & x"C000";
                length <= "100" & x"4000";
                add_ready <= '1';
                
            elsif (SW2 = '1') then 
                address_start <= "011" & x"8000";
                length <= "010"& x"4000";
                add_ready <= '1';
        
            elsif (SW3 = '1') then 
                address_start <= "100" & x"8000";
                length <= "001" & x"0000";
                add_ready <= '1';
                
            elsif (SW4 = '1') then 
                address_start <= "100" & x"0000";
                length <= "000" & x"0020";
                add_ready <= '1'; 
                
            else 
                address_start <= address_start;
                length <= length;
                --add_ready <= '0';   
                
            end if;
            
        else
        
            add_ready <= '0';
                
        end if;

    end process;
    
end Behavioral;
