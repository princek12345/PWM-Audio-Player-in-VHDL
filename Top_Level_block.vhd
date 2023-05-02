----------------------------------------------------------------------------------
-- Name : Princekumar B. Kothadiya
-- UID  : 2209688
-- EE119a : HW-(6)
--	PWM Audio Player : Top_Level_block
-- 
----------------------------------------------------------------------------
-- Description :
--
--	It is the Top level block combining all individual blocks.
-- The overall sytem has been divided into following blocks:
--		1) Switch_IP block	: taking input from switch and giving address values
--		2) Address_RW block	: computing address and getting data from EPROM
--		3) Counter block		: running binary counter of 12-bit 
--		4) PWM_wave block		: generating final output PWM pulses from data and counter

-- 
-- Objective :
--		Generate the output PWM pulses based on the MSG signal stored in the EPROM as per selection from 4 different switches.

--	Provided info :
--			start address and length for correspoding switches
--			System clock : 32 MHz
--			EPROM : 8-bit msg for particular address 
--			delay of EPROM : 120 ns
-----------------------------------------------------------------------------
-- Logic :
--
-- The system has a 32 MHz clock input, which is divided by 4096 via a 12-bit up counter to generate an approximately 8 kHz audio signal. 
--	A single sample of the PWM takes 256 system clocks. Therefore there are 16 periods of PWM output per 128 us (which is taked as approximately 125 us).
--	The lower 8-bit of counter is compared with msg signal to generate the same pulse 16 times (which will get smoother while taking average).
--	Also, Address is being update at the one counter cycle to account for 8 kHz of sample rate (4096 clocks per cycle).
--	Also, The message from EPROM will take 120 ns on each cycle so, it can be stored internally for next counter cycle when previous is going on..	
-----------------------------------------------------------------------------
--Port Description :
--
-- I/P :- (1) 	: system clock (32 MHz)
--			(2-5) : Switch input (Switch-1 to Switch-4)
--			 (6)	: 8-bit data from EPROM 

-- O/P :- (1) 	: PWM pulses as per data
--			 (2)	: Current address to the EPROM for data
-----------------------------------------------------------------------------
-- Note :- change the parameter for fitting this on CPLD : XC9572 ::
--- Optimize Density
--- Input limit : 15
--- Pterm limit : 15
-----------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Top_Level_block is
  Port ( 
    clk 				: in std_logic;		-- Sytem clock : (32 MHz)
    SW1 				: in std_logic;		-- Switch - 1 : input
    SW2 				: in std_logic;		-- Switch - 2 : input
    SW3 				: in std_logic;		-- Switch - 3 : input
    SW4 				: in std_logic;		-- Switch - 4 : input
	 EPROM_data 	: in std_logic_vector(7 downto 0); 		-- 8-bit data from EPROM
	 pwm_out 		: out std_logic;								-- final output as pulse width
    curr_address 	: buffer std_logic_vector(18 downto 0) -- current address given to the EPROM for data	
    
  );
end Top_Level_block;

architecture Behavioral of Top_Level_block is	
	
--		declaring internal signals
    signal count 				: std_logic_vector(11 downto 0); -- counter value : 12 bit
    signal msg 				: std_logic_vector(7 downto 0);	-- final 8-bit MSG data given to the PWM block
    signal address_start 	: std_logic_vector(18 downto 0); -- start address (18-bit)
    signal address_end	 	: std_logic_vector(18 downto 0); -- end address (18-bit)    
    signal msg_play 			: std_logic;							-- Handshaking signal : to check about MSG playing
    signal add_ready 		: std_logic;							-- Handshaking signal : to check valid address availability

component counter_12bit
  Port ( 
		clk 		: in std_logic;			-- system clock : 32 MHz
    count 		: buffer std_logic_vector(11 downto 0) := x"000"	-- counter value : 12 bit 
      );  
end component;

component PWM_wave
  Port ( 
  count 		: in std_logic_vector(7 downto 0);	-- passing lower 8-bit of counter
  msg 		: in std_logic_vector(7 downto 0);	-- passing 8-bit EPROM msg data
  pwm_out 	: out std_logic							-- final output as pulse width
  );  
end component;

component Switch_IP
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
end component;

component Address_RW 
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
end component;

begin

Counter : counter_12bit port map(

   clk 	=> clk,
   count => count
); 

PWM : PWM_wave port map(

	count 	=> count(7 downto 0),		-- mapping lower 8-bit of count value
	msg 		=> msg,
	pwm_out 	=> pwm_out
);

SW : Switch_IP port map(
    
	SW1 				=> SW1,
   SW2 				=> SW2,
   SW3 				=> SW3,
   SW4 				=> SW4,
   address_start 	=> address_start,
   address_end 	=> address_end,  
   msg_play 		=> msg_play,
   add_ready 		=> add_ready
);

ADD: Address_RW port map(

   clk 				=> clk,
   address_start 	=> address_start,
   address_end 	=> address_end,
   EPROM_data 		=> EPROM_data,
   curr_address 	=> curr_address,
   msg 				=> msg,
   count 			=> count,
   msg_play 		=> msg_play,
   add_ready 		=> add_ready
  );
  
end Behavioral;
