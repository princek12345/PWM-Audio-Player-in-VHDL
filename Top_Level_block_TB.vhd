----------------------------------------------------------------------------------
-- Name : Princekumar B. Kothadiya
-- UID  : 2209688
-- EE119a : HW-(6)
--	PWM Audio Player : Test Bench
-- 
----------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.std_logic_unsigned.ALL;

entity Top_Level_block_TB is
end Top_Level_block_TB;

architecture TB_ARCHITECTURE of Top_Level_block_TB is
    constant clk_period: integer  := 32;    -- System clock in ns
    
	 
	 -- UUT component declaration
    component Top_Level_block
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
    end component;

    -- signals declaration
	 signal clk				:	std_logic;
    signal sw4				:  std_logic;
    signal sw3				:  std_logic;
    signal sw2				:  std_logic;
    signal sw1				:  std_logic;
    signal epromData		:  std_logic_vector(7 downto 0);
    signal curr_address	:	std_logic_vector(18 downto 0);
    signal pwmOut			:  std_logic;
    
    -- End of simulation flag
    signal END_SIM:     boolean := false;

begin
    -- Port map for the UUT
    UUT : Top_Level_block
        port map  (
            clk   		 => clk,
            SW4   		 => sw4,
            SW3   		 => sw3,
            SW2  			 => sw2,
            SW1 			 => sw1,
            EPROM_data	 => epromData,
            curr_address => curr_address,
            pwm_out   	 => pwmOut
        );
    
    process
    
	 begin
       -- Initialize switches as zero
        sw4       <= '0';
        sw3       <= '0';
        sw2       <= '0';
        sw1       <= '0';
        
		  epromData <= std_logic_vector(to_unsigned(24, 8));	-- taking fixed data value as EPROM data
        
        wait for 160 ns;
		  
----------------------------------------------------------		  
		  -- case : one switch pressed
        sw1    <= '1'; 		-- SW-1 pressed for 1 ms
		  wait for 1 ms;
		  sw1    <= '0';
        wait for 5 sec;		-- wait for 5 sec to complete the MSG
		  
---------------------------------------------------------	  
		  -- case : one switch pressed in between
        sw2    <= '1'; 		-- SW-2 pressed for 1 ms
		  wait for 1 ms;
		  sw2    <= '0';
        wait for 100 ms;	-- wait for 100 ms
		  sw3		<= '1';	   --	SW-3 pressed in middle of the previous sound
		  wait for 3 ms;
		  sw3 	<= '0';
		  
-------------------------------------------------------		  
		  -- case : two switch pressed together
        sw3    <= '1'; 		-- SW-3 and SW-4 pressed at same time
		  sw4		<= '1';
		  wait for 1 ms;
		  sw3    <= '0';
		  sw4		<= '0';
        wait for 10 sec;	-- wait for 10 sec
		  
--------------------------------------------------------		  
		  -- case : one switch kept on pressing
        sw3    <= '1'; 		-- SW-3 and SW-4 pressed at same time
		  wait for 1 ms;
		  sw3    <= '0';
		  wait for 1 sec;	-- wait for 1 sec
		  sw4		<= '1';
		  
		  --- SW4 is pressed all time..
		  
		  wait for 5 sec;
        -- Set end-of-simulation flag
        END_SIM <= true;
    
	 end process;
        
    --- 32 MHz clock 
	 CLOCK_clk : process
    begin
        if END_SIM = FALSE then	-- END_SIM = TRUE is limit for completion of simulation...
            CLK <= '0';				-- clk is 0 for 15 ns
            wait for 15 ns;
        else
            wait;
        end if;

        if END_SIM = FALSE then
            CLK <= '1';				-- clk is 1 for 15 ns
            wait for 15 ns;
        else
            wait;
        end if;
    end process;

end TB_ARCHITECTURE;