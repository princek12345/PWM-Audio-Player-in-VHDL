----------------------------------------------------------------------------------
-- Name : Princekumar B. Kothadiya
-- UID  : 2209688
-- EE119a : HW-(6)
--	PWM Audio Player : counter block
-- 
----------------------------------------------------------------------------
-- Description :
--
--	Binary count is counting value from 0 to 4095.
-- It is synchronous counter with global clock of 32 MHz. 
-- It is connected to Address_RW and PWM_wave block.

-----------------------------------------------------------------------------
-- Logic :
--
--    Increasing count value by 1 at each rising edge of the clock.
-----------------------------------------------------------------------------
--Port Description :
--
-- I/P :- (1) : system clock (32 MHz)	

-- O/P :- (1) : counter value (11 downto 0)
--						-> Given to the PWM_wave block for PWM output generation with comparing 8-bit value from EPROM data.
--						-> Given to the Address_RW block for comparing with 000000000000 to go to the next address line. 
-----------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.std_logic_unsigned.ALL;

entity counter_12bit is
  Port ( 

    clk 		: in std_logic;			-- system clock : 32 MHz
    count 	: buffer std_logic_vector(11 downto 0) := x"000"	-- counter value : 12 bit :- initializing with zeros
   
   ); 
end counter_12bit;

architecture DataFlow of counter_12bit is

begin

    C1: process(clk)					-- process on clock
    
    begin
    
		if (rising_edge(clk)) then 	-- updating on rising edge of clock  
			count <= count + 1;
		end if;
    
    end process;

end DataFlow;
