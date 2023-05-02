----------------------------------------------------------------------------------
-- Name : Princekumar B. Kothadiya
-- UID  : 2209688
-- EE119a : HW-(6)
--	PWM Audio Player : Address_RW block
-- 
----------------------------------------------------------------------------
-- Description :
--
--	This block update the address and communicate with EPROM to get the data corresponds to current address and provide it to generate PWM output.
-- It takes the input from Switch_IP block : start address and end address.
--	
-- It updates the current address starting from start address to end address	by every counter cycle (when count value is all zeros) and reads the 8-bit input on every 125 us.
--	
--	It also takes the input MSG data from EPROM for current address and adjust the delay of 120 ns (for reading from EPROM) by delaying the output 8-bit data by one counter cycle (125 us).
-- 
--	It also uses some handshaking signal to determine the valid address is available on start and end address or not.
--	It also generates handshaking signal to provide the information about MSG is currently being played or it's over.	
-- 
-----------------------------------------------------------------------------
-- Logic :
--
-- It compares the counter value on rising edge of the clock and wait for count value (12 bit) being all zeros.
--	Then, It checks for any new valid address is available or not,
--		If YES, 	-> update the current address with address start and update the handshaking signal to tell that MSG playing is started.
--		If NO, 	-> check for msg_play signal :
--						If MSG is being played :
--									-> Increase the current address by 1 
--									->	Provide the internally stored data from EPROM to the output (125 us of delay !)
--									-> Do this till current address being equal to end address.
--
--						If current address becomes the equal to the end address :
--									-> Update the handshaking signal (MSG is fully played)
--									-> Update the output data to be all zeros (8-bit).
----------------------------------------------------------------------------------

-- Port Description :
--
-- I/P :- (1) 	: system clock (32 MHz)	
--			(2-3)	: Start address and End address
--			 (4)	: 8-bit data from EPROM
--			 (5)	: 12-bit count value			
--
-- O/P :- (1) 	: Current address to the EPROM 
--			 (2)	: 8-bit MSG data to the PWM_wave block
--
--	Handshaking signals 	:-
--				(1) : msg_play  :: (as buffer)
--							-> ('1' if previous msg is playing :: Increase the current address by 1)
--							-> ('0' if NO msg is playing ) 
--							-> It is given to the Switch_IP block	   				
--	
--				(2) : add_ready :: (as input)
--							-> ('1' if valid address is available :: Update the current address as start address)
--							-> Only checking for '1' case here in this block... 
--		   				-> It is updated by Switch_IP block
---------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.std_logic_unsigned.ALL;

entity Address_RW is
  Port ( 
	 clk 				: in std_logic;								 -- system clock : 32 MHz
    address_start : in std_logic_vector(18 downto 0);		 -- start address (18-bit)
    address_end 	: in std_logic_vector(18 downto 0);		 -- end address (18-bit)
    EPROM_data 	: in std_logic_vector(7 downto 0);		 -- 8-bit data from EPROM
    count 			: in std_logic_vector(11 downto 0);		 -- count value from counter block
    add_ready 		: in std_logic; 								 -- Handshaking signal : to check valid address availability
	 msg 				: out std_logic_vector(7 downto 0);		 -- final 8-bit MSG data given to the PWM block
    curr_address 	: buffer std_logic_vector(18 downto 0); -- current address given to the EPROM for data	
    msg_play 		: buffer std_logic							 -- Handshaking signal : to check about MSG playing
	  
  );
end Address_RW;

architecture Behavioral of Address_RW is
    
    signal msg_delay : std_logic_vector(7 downto 0);		-- Internal signal : for storing the MSG from EPROM and to adjust the delay of data reading from EPROM (120 ns)
    
begin

    A1: process(clk)													-- process on sytem clock (to make synchronous) (Although we could use the count instead of clock but that will increase the design complexity as 8-bit check vs 1-bit check difference)  
    begin 
            
        if (rising_edge(clk) and count = "000000000000") then  --  checking for count value of all zeros (12-bit) on rising edge of the clock
        
            if (add_ready = '1') then 								-- Address is valid
				
                curr_address 	<= address_start; 				-- update the current address 	
                msg_delay 		<= EPROM_data;						-- store corresponding data from EPROM internally (this takes 120 ns delay)
                msg_play 		<= '1';								-- update the handshaking signal that MSG IS CURRENTLY BEING PLAYED NOW...
                
            elsif (curr_address /= address_end and msg_play = '1') then		-- If address is not valid -> check for msg play 
         
                curr_address 	<= curr_address + 1;				-- increase the current address by 1
                msg 				<= msg_delay;						-- Give the final output 8-bit as internally stored data corresponds to previous address
                msg_delay 		<= EPROM_data;						-- store EPROM data (8-bit) internally for updated current address (with delay = 120 ns) 
                
            else 													-- If current address becomes the end address 
            
                msg_play 		<= '0';						-- MSG is OVER.. -> update the handshaking signal
                msg 				<= "00000000";				-- give the final output as all zeros (8-bit)
            
            end if;
           
        end if;
        
    end process;    
        
end Behavioral;
