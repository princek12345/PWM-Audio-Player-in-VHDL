----------------------------------------------------------------------------------
-- Name : Princekumar B. Kothadiya
-- UID  : 2209688
-- EE119a : HW-(6)
--	PWM Audio Player : Switch_IP block
-- 
----------------------------------------------------------------------------
-- Description :
--
--	It is main input block of the sytem.
-- It senses the switch pressed as input and gives correspoding start and end address.
--	It also uses some handshaking signal to determine the valid switch pressed.
--	It also generates handshaking signal to provide information about new valid address.	
-- 
-----------------------------------------------------------------------------
-- Logic :
--
-- If previous msg is still playing then don't consider any switch input if pressed.
-- It provides the valid start address and end address corresponding to the switch pressed.
--	It also gives the signal that switch is pressed and new address is available.
-- 
-----------------------------------------------------------------------------
-- Port Description :
--
-- I/P :- (1-4)			: All Switches (SW1 to SW4)
--									-> User input
--
-- O/P :- (1-2) 			: Start address and End address
--									-> Given to the Address_RW block
--	Handshaking signals 	:-
--				(1) : msg_play :: (as input)
--							-> ('1' if previous msg is playing :: don't cosider any switch input)
--							-> ('0' if no msg is playing :: consider switch input) 
--		   				->  It is updated by Address_RW block
--
--				(2) : add_ready :: (as output)
--							-> ('1' if valid address is available :: when NO MSG IS PLAYING AND SWITCH IS PRESSED)
--							-> ('0' if MSG IS PLAYING :: consider switch input) 
--		   				->  It is given to the Address_RW block
-----------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.std_logic_unsigned.ALL;

entity Switch_IP is
  Port ( 
    SW1 				: in std_logic;		-- Switch - 1 : input
    SW2 				: in std_logic;		-- Switch - 2 : input
    SW3 				: in std_logic;		-- Switch - 3 : input
    SW4 				: in std_logic;		-- Switch - 4 : input
	 msg_play 		: in std_logic;		-- Handshaking signal : to check about MSG playing
    address_start : buffer std_logic_vector(18 downto 0);	-- Start Address of corresponding EPROM data 
    address_end 	: buffer std_logic_vector(18 downto 0);   -- Start Address of EPROM data 
    add_ready 		: out std_logic		 -- Handshaking signal : to check valid address availability
    
  );
end Switch_IP;

architecture Behavioral of Switch_IP is

begin

    S1: process(SW1,SW2,SW3,SW4,msg_play)		-- process doesn't depends on clock (Asynchronous) because Switches are user input			
    
    begin
                
            if (SW1 = '1' and msg_play='0') then 		-- If no msg is playing and Switch-1 is pressed : Valid Switch input
                
					 address_start <= "111" & x"C000";		-- Update the Address Start as per Switch-1 MSG : 7C000 (hex)
                address_end 	<= "111" & x"ffff";		-- Update the Address End as per Switch-1 MSG	: 47FFF (hex) 
                add_ready 		<= '1';						-- Handshaking signal : Valid Switch input
                
            elsif (SW2 = '1' and msg_play='0') then 	-- If no msg is playing and Switch-2 is pressed : Valid Switch input
                
					 address_start <= "101" & x"8000";		-- Update the Address Start as per Switch-2 MSG : 58000 (hex)
                address_end 	<= "111"& x"Bfff";		-- Update the Address End as per Switch-2 MSG	: 7BFFF (hex)
                add_ready 		<= '1';
        
            elsif (SW3 = '1' and msg_play='0') then 	-- If no msg is playing and Switch-3 is pressed : Valid Switch input
                
					 address_start <= "100" & x"8000";		-- Update the Address Start as per Switch-3 MSG : 48000 (hex)
                address_end 	<= "101" & x"7fff";		-- Update the Address End as per Switch-3 MSG	: 57FFF (hex)
                add_ready 		<= '1';
                
            elsif (SW4 = '1' and msg_play='0') then 	-- If no msg is playing and Switch-4 is pressed : Valid Switch input
                
					 address_start <= "100" & x"0000";		-- Update the Address Start as per Switch-4 MSG : 40000 (hex)
                address_end 	<= "100" & x"7fff";  	-- Update the Address End as per Switch-4 MSG	: 47FFF (hex)
                add_ready 		<= '1'; 
                
            elsif (msg_play='0') then						-- If none of the Switch is pressed and no msg is playing
                
					 address_start <= address_start;			-- Don't update the Address Start
                address_end 	<= address_end;			-- Don't update the Address End	
						
				else													-- If MSG IS PLAYING
					add_ready <= '0';								-- Update the handshaking signal add_ready to '0' 
                
				end if;

    end process;
    
end Behavioral;
