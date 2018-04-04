----------------------------------------------------------------------------------
-- Company: Senior Design 493
-- Project: Ultrasonic Radar
-- Advisor: Shahnam Mirzaei
-- Author: Hambartzum Gamburian
-- Participants: Hambartzum Gamburian, Giovanni Alonzo, Saba Janamian,
--               Hamed Seyedroudbari, Andrew Zaragoza, Xiaoao Feng
-- Filename: ultrasonic_reading.vhd
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ultrasonic_reading is
      Port (CLK : in STD_LOGIC;      
            PWM : in STD_LOGIC;
            READING_CLK : out STD_LOGIC;
            READING : out STD_LOGIC_VECTOR (7 downto 0));
end ultrasonic_reading;

architecture Behavioral of ultrasonic_reading is

component edge_detection is
    Port (clk : in STD_LOGIC;
          input : in STD_LOGIC;
          output : out STD_LOGIC);
end component;

signal pwm_clock: std_logic := '0';
signal reading_reg: std_logic_vector(8 downto 0) := (others => '0');
signal pwm_start, pwm_stop : std_logic := '0';
signal pwm_count_inc : std_logic := '0';
signal PWM_not : std_logic;

constant pwm_period : integer := 14700;

begin
  
PWM_not <= not PWM;

PWM_pos: edge_detection port map(clk => pwm_clock, input => PWM, output => pwm_start);
PWM_neg: edge_detection port map(clk => pwm_clock, input => PWM_not, output => pwm_stop);

READING <= reading_reg(8 downto 1);
READING_CLK <= pwm_clock;

--Input clock is 10ns period
--14700 * 10ns = 147us
--However, divide by 2 for better resolution

-- so pwm_clock period is 73.5 microseconds (us, E-6) and the frequency of that  is 1 / 73.5us = 13,605 Hz or 13.6 kHz
process(CLK)
    variable count: integer := 1;
    begin
    if(CLK'event and CLK = '1') then
        count := count + 1;
        if(count = pwm_period/(4)) then
            count := 1;
            pwm_clock <= not pwm_clock;
        end if;
    end if;
end process;

--control when pwm counter increments based on start and stop asserts
--process(pwm_clock)
--begin
--    if(pwm_clock'event and pwm_clock = '1') then
--        if(pwm_start = '1') then
--            pwm_count_inc <= '1';
--        elsif(pwm_stop = '1') then
--            pwm_count_inc <= '0';
--        else
--            pwm_count_inc <= pwm_count_inc;
--        end if;
--    end if;
--end process;

--increment counter and put in register
process(pwm_clock)
    variable pwm_width: integer := 0;
    begin
    if(pwm_clock'event and pwm_clock = '1') then
        if(PWM = '1') then
            pwm_width := pwm_width + 1;
        elsif(PWM = '0' and pwm_stop = '0') then
            pwm_width := 0;
        else
            pwm_width := pwm_width;
        end if;
        
        if(pwm_stop = '1') then
            reading_reg <= std_logic_vector(to_unsigned(pwm_width,9));
        end if;
    end if;
end process;
  
end Behavioral;