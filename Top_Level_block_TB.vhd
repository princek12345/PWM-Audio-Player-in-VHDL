library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Top_Level_block_TB is
end Top_Level_block_TB;

architecture TB_ARCHITECTURE of Top_Level_block_TB is
    constant CLK_PERIOD: integer  := 32;    -- System clock in ns
    constant MSG_DATA_1 : integer := 10;    -- PWM data values for each message
    constant MSG_DATA_2 : integer := 63;  
    constant MSG_DATA_3 : integer := 127;  
    constant MSG_DATA_4 : integer := 128; 
    
    -- UUT component declaration
    component Top_Level_block
        port(
            clk : in std_logic;
            reset : in std_logic;
            SW1 : in std_logic;
            SW2 : in std_logic;
            SW3 : in std_logic;
            SW4 : in std_logic;
    
    ----
            EPROM_data : in std_logic_vector(7 downto 0);
            --count : buffer std_logic_vector(11 downto 0);
            curr_address : buffer std_logic_vector(18 downto 0);
    
--     msg : buffer std_logic_vector(7 downto 0);
--     address_start : buffer std_logic_vector(19 downto 0);
--     length : buffer std_logic_vector(19 downto 0);    
--     msg_play : buffer std_logic;
-- --    add_ready : buffer std_logic;
    
            pwm_out : out std_logic
);
    end component;

    -- Stimulus signals mapping to UUT port inports
    signal clk:       std_logic;
    signal reset:     std_logic;
    signal sw4:       std_logic;
    signal sw3:       std_logic;
    signal sw2:       std_logic;
    signal sw1:       std_logic;
    signal epromData: std_logic_vector(7 downto 0);
   -- signal count    : std_logic_vector(11 downto 0);
    signal curr_address:std_logic_vector(18 downto 0);
   -- signal msg : std_logic_vector(7 downto 0);
   -- signal address_start : std_logic_vector(19 downto 0);
   -- signal length : std_logic_vector(19 downto 0);    
   -- signal msg_play : std_logic;
 --   signal add_ready : std_logic;

    -- Observed signals mapp
    --signal epromAddr:   std_logic_vector(19 downto 0);
    signal pwmOut:      std_logic;
    
    -- End of simulation flag to stop clock generation
    signal END_SIM:     boolean := false;

begin
    -- Port map for the UUT
    UUT : Top_Level_block
        port map  (
            clk     => clk,
            reset  => reset,
            SW4   => sw4,
            SW3   => sw3,
            SW2   => sw2,
            SW1   => sw1,
            EPROM_data => epromData,
           -- count => count,
            curr_address => curr_address,
           -- msg => msg,
           -- address_start => address_start,
           -- length => length,    
           -- msg_play => msg_play,
   --         add_ready => add_ready,
            --AudioAddr => epromAddr,
            pwm_out    => pwmOut
        );
    
    -- Stimulus process
    process
    begin
        
        reset   <= '0';
        -- Initialize with all switches not pressed
        sw4       <= '0';
        sw3       <= '0';
        sw2       <= '0';
        sw1       <= '0';
        -- and the data input to the dummy input for Message 1
        epromData <= std_logic_vector(to_unsigned(MSG_DATA_1, 8));
        
        --wait for 20 ns;
      --  msg <= "00000000";
        --        curr_address <= x"00000"; -- x"00000"
          --      address_start <= x"00000";
            --    length <= x"00000";
              --  msg_play <= '0';
                --add_ready <= '0';
        
        
        -- Wait for 5 clocks
        wait for 160 ns;
        
        reset <= '1';
        
        wait for 64 ns;
        
        reset <= '0';
        
        wait for 32 ns;
        
--        -- Press switch 4; play Message 1
        sw4       <= '1';
--        -- Wait some clocks, then release
       wait for 96 ns;
        sw4       <= '0';
        wait for 2 ms;
        sw1 <= '1';
        
        epromData <= std_logic_vector(to_unsigned(MSG_DATA_4, 8));
        
        wait for 60 ns;
      --  sw1 <= '0';
        
        
--        -- Let Message 1 play to end (~ 4 s)
        wait for 4 sec;
        
--        epromData <= std_logic_vector(to_unsigned(MSG_DATA_2, 8));
        
--        -- Press switch 3; play Message 2
--        sw3       <= '1';
--        wait for 96 ns;
--        sw3       <= '0';
--        -- Let Message 2 play to end (~ 8 s)
--        wait for 8 sec;
        
--        epromData <= std_logic_vector(to_unsigned(MSG_DATA_3, 8));
        
--        -- Press switch 2; play Message 3
--        sw2       <= '1';
--        wait for 96 ns;
--        sw2       <= '0';
--        -- Let Message 3 play to end (~ 18 s)
--        wait for 18 sec;
        
--        epromData <= std_logic_vector(to_unsigned(MSG_DATA_4, 8));
        
--        -- Press switch 1; play Message 4
--        sw1       <= '1';
--        wait for 96 ns;
--        sw1       <= '0';
--        -- Let Message 4 play to end (~ 2 s)
--        wait for 2 sec;
        
        -- Set end-of-simulation flag
        END_SIM <= true;
    --end of the stimulus process
    end process;
        
    -- Process to generate a 32 MHz clock (period of 30 ns)
    -- Stops clock generation if `END_SIM` is active.
    CLOCK_clk : process
    begin
        if END_SIM = FALSE then
            CLK <= '0';
            wait for 15 ns;
        else
            wait;
        end if;

        if END_SIM = FALSE then
            CLK <= '1';
            wait for 15 ns;
        else
            wait;
        end if;
    end process;

end TB_ARCHITECTURE;