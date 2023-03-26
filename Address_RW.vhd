----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/12/2022 11:20:15 PM
-- Design Name: 
-- Module Name: Address_RW - Behavioral
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Address_RW is
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
end Address_RW;

architecture Behavioral of Address_RW is
    
    signal msg_delay : std_logic_vector(7 downto 0);
    
begin

    A1: process(clk,reset)
    
    begin 
    
        if (reset = '1') then 
    
            msg <= "00000000";
            curr_address <= "000" & x"0000";
            msg_play <= '0';
        
        elsif (count = "000000000000" and rising_edge(clk)) then  -- and rising_edge(clk)
        
            if (add_ready = '1') then       -- msg_play == 0
                --add_ready <= '0';
                curr_address <= address_start; 
                msg_delay <= EPROM_data;
                msg_play <= '1';
                
            elsif (curr_address < address_start + length and msg_play = '1') then
         
                curr_address <= curr_address + 1;
                msg <= msg_delay;
                msg_delay <= EPROM_data;
                --msg_play <= '1';
        
            else 
            
               -- msg <= "00000011";
                curr_address <= "000" & x"0000"; -- x"00000"
               -- address_start <= x"00011";
               -- length <= x"00011";
                msg_play <= '0';
                msg <= "00000000";
            
            end if;
            
        else 
            
            --msg <= msg;
            --curr_address <= curr_address;
            --address_start <= address_start;
            --length <= length;
            msg_play <= msg_play;
                
        end if;
        
    end process;    
        
end Behavioral;
