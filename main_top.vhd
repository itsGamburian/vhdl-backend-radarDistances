----------------------------------------------------------------------------------
-- Company: Senior Design 493 - Mirzaei Group
-- Engineer: Hambartzum Gamburian
-- main_top
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

entity main_top is
    Port ( clk : in STD_LOGIC;
           radar1_pwm : in STD_LOGIC;
           radar1_rx : out STD_LOGIC;
           radar2_pwm : in STD_LOGIC;
           radar2_rx : out STD_LOGIC;
           reading_mux : in STD_LOGIC;
           reading_output : out STD_LOGIC_VECTOR(7 downto 0));
end main_top;

architecture Behavioral of main_top is

component ultrasonic_reading is
      Port (CLK : in STD_LOGIC;      
            PWM : in STD_LOGIC;
            READING_CLK : out STD_LOGIC;
            READING : out STD_LOGIC_VECTOR (7 downto 0));
end component;

component averager is
    Port ( clk : in STD_LOGIC;
           input: in STD_LOGIC_VECTOR (7 downto 0);
           output: out STD_LOGIC_VECTOR (7 downto 0));
end component;

signal radar1_reading, radar1_reading_avg, radar2_reading, radar2_reading_avg: STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
signal radar1_reading_clk, radar2_reading_clk : STD_LOGIC;

begin
radar1: ultrasonic_reading port map (CLK => clk, PWM => radar1_pwm, READING_CLK => radar1_reading_clk, READING => radar1_reading);
radar2: ultrasonic_reading port map (CLK => clk, PWM => radar2_pwm, READING_CLK => radar2_reading_clk, READING => radar2_reading);
avg1: averager port map (clk => radar1_reading_clk, input => radar1_reading, output => radar1_reading_avg);
avg2: averager port map (clk => radar2_reading_clk, input => radar2_reading, output => radar2_reading_avg);

reading_output <= radar1_reading_avg when (reading_mux = '0') else radar2_reading_avg;

end Behavioral;