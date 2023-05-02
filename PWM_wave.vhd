----------------------------------------------------------------------------------
-- Name : Princekumar B. Kothadiya
-- UID  : 2209688
-- EE119a : HW-(6)
--	PWM Audio Player : PWM_wave block
-- 
----------------------------------------------------------------------------
-- Description :
--
--	It is generating PWM wave as output.
-- It is using lower 8-bit counter value (to oversample by 16 times) to compare with with EPROM msg data and generating pulses.
--	This will result into 16 pulses, all of equal width for each sample.
-- 
-- It takes EPROM msg data as input from Address_RW block and lower 8-bit of count value from counter block.

-----------------------------------------------------------------------------
-- Logic :
--
-- If lower 8-bit count value is less then msg 8-bit 	: 	Pulse -> HIGH
-- Otherwise 														:	Pulse -> LOW		
-- 
-----------------------------------------------------------------------------
--Port Description :
--
-- I/P :- (1) : lower 8-bit of count value -> from Counter block
--			 (2) : 8-bit EPROM msg data -> from Address_RW_block

-- O/P :- (1) : PWM output as Pulse -> Final output as music
-----------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity PWM_wave is
  Port ( 
  count 		: in std_logic_vector(7 downto 0);	-- passing lower 8-bit of counter
  msg 		: in std_logic_vector(7 downto 0);	-- passing 8-bit EPROM msg data
  pwm_out 	: out std_logic							-- final output as pulse width
  
  );
end PWM_wave;

architecture DataFlow of PWM_wave is

begin

 	P1: process(count,msg)		-- process on count and msg (Looks like asynchronous without clk but count value is updating on rising edge of the clock so overall -> Synchronous)   
    begin 
          
        if(count < msg) then	-- comparing lower 8-bit of count value with msg   
				pwm_out <= '1';	-- PWM output -> HIGH pulse       
        else          
				pwm_out <= '0';	-- PWM output -> LOW pulse      
        end if;
    
   end process;

end DataFlow;
