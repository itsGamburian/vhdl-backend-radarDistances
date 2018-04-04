----------------------------------------------------------------------------------
-- Company: Senior Design 493
-- Project: Ultrasonic Radar
-- Advisor: Shahnam Mirzaei
-- Author: Hambartzum Gamburian
-- Participants: Hambartzum Gamburian, Giovanni Alonzo, Saba Janamian,
--               Hamed Seyedroudbari, Andrew Zaragoza, Xiaoao Feng
-- Filename: sevenSegment.vhd
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity sevenSegment is
    Port ( clk : in STD_LOGIC;
           dataIn : in STD_LOGIC_VECTOR (7 downto 0);
           toSevenSegment : out STD_LOGIC_VECTOR (7 downto 0));
end sevenSegment;

architecture Behavioral of sevenSegment is

  signal led_1, led_2: std_logic_vector(6 downto 0);
  signal led_digit: std_logic := '0';
  signal dataUpper, dataLower : integer;
--  signal first_digit, second_digit, third_digit : integer;

begin

  
  -- toSevenSegment[0] <= led_digit ~~ controls which 7-seg is currently begin driven
  toSevenSegment(0) <= led_digit;
  
  -- toggle led_digit every xxx us
  process(clk)
    variable count: integer := 0;
      -- 100MHz clock = 10ns per count ~ 100 = 1us
  begin
    if(clk'event and clk = '1') then
      count := count + 1;
      if(count <= 100) then
        led_digit <= '0';
      else
        led_digit <= '1';
      end if;
      if(count = 200) then
        count := 0;
      end if;
    end if;
  end process;
  
--  first_digit <= (to_integer(unsigned(dataIn)) mod 100)/ 10;
--  second_digit <= to_integer(unsigned(dataIn)) mod 10;
--  third_digit <= to_integer(unsigned(dataIn)) / 100;
  
    dataUpper <= to_integer(unsigned(dataIn(7 downto 4)));
    dataLower <= to_integer(unsigned(dataIn(3 downto 0)));
  
    led_1(6) <= '1' when (dataUpper = 0 or dataUpper = 2 or dataUpper = 3 or dataUpper = 5 or dataUpper = 6 or dataUpper = 7 or dataUpper = 8 or dataUpper = 9 or dataUpper = 10 or dataUpper = 12 or dataUpper = 14 or dataUpper = 15) else '0'; -- A
    led_1(5) <= '1' when (dataUpper = 0 or dataUpper = 1 or dataUpper = 2 or dataUpper = 3 or dataUpper = 4 or dataUpper = 7 or dataUpper = 8 or dataUpper = 9 or dataUpper = 10 or dataUpper = 13) else '0'; -- B
    led_1(4) <= '1' when (dataUpper = 0 or dataUpper = 1 or dataUpper = 3 or dataUpper = 4 or dataUpper = 5 or dataUpper = 6 or dataUpper = 7 or dataUpper = 8 or dataUpper = 9 or dataUpper = 10 or dataUpper = 11 or dataUpper = 13) else '0'; -- C
    led_1(3) <= '1' when (dataUpper = 0 or dataUpper = 2 or dataUpper = 3 or dataUpper = 5 or dataUpper = 6 or dataUpper = 8 or dataUpper = 11 or dataUpper = 12 or dataUpper = 13 or dataUpper = 14) else '0'; -- D
    led_1(2) <= '1' when (dataUpper = 0 or dataUpper = 2 or dataUpper = 6 or dataUpper = 8 or dataUpper = 10 or dataUpper = 11 or dataUpper = 12 or dataUpper = 13 or dataUpper = 14 or dataUpper = 15) else '0'; -- E
    led_1(1) <= '1' when (dataUpper = 0 or dataUpper = 4 or dataUpper = 5 or dataUpper = 6 or dataUpper = 7 or dataUpper = 8 or dataUpper = 9 or dataUpper = 10 or dataUpper = 11 or dataUpper = 12 or dataUpper = 14 or dataUpper = 15) else '0'; -- F
    led_1(0) <= '1' when (dataUpper = 2 or dataUpper = 3 or dataUpper = 4 or dataUpper = 5 or dataUpper = 6 or dataUpper = 8 or dataUpper = 9 or dataUpper = 10 or dataUpper = 11 or dataUpper = 13 or dataUpper = 14 or dataUpper = 15) else '0'; -- G

    led_2(6) <= '1' when (dataLower = 0 or dataLower = 2 or dataLower = 3 or dataLower = 5 or dataLower = 6 or dataLower = 7 or dataLower = 8 or dataLower = 9 or dataLower = 10 or dataLower = 12 or dataLower = 14 or dataLower = 15) else '0'; -- A
    led_2(5) <= '1' when (dataLower = 0 or dataLower = 1 or dataLower = 2 or dataLower = 3 or dataLower = 4 or dataLower = 7 or dataLower = 8 or dataLower = 9 or dataLower = 10 or dataLower = 13) else '0'; -- B
    led_2(4) <= '1' when (dataLower = 0 or dataLower = 1 or dataLower = 3 or dataLower = 4 or dataLower = 5 or dataLower = 6 or dataLower = 7 or dataLower = 8 or dataLower = 9 or dataLower = 10 or dataLower = 11 or dataLower = 13) else '0'; -- C
    led_2(3) <= '1' when (dataLower = 0 or dataLower = 2 or dataLower = 3 or dataLower = 5 or dataLower = 6 or dataLower = 8 or dataLower = 11 or dataLower = 12 or dataLower = 13 or dataLower = 14) else '0'; -- D
    led_2(2) <= '1' when (dataLower = 0 or dataLower = 2 or dataLower = 6 or dataLower = 8 or dataLower = 10 or dataLower = 11 or dataLower = 12 or dataLower = 13 or dataLower = 14 or dataLower = 15) else '0'; -- E
    led_2(1) <= '1' when (dataLower = 0 or dataLower = 4 or dataLower = 5 or dataLower = 6 or dataLower = 7 or dataLower = 8 or dataLower = 9 or dataLower = 10 or dataLower = 11 or dataLower = 12 or dataLower = 14 or dataLower = 15) else '0'; -- F
    led_2(0) <= '1' when (dataLower = 2 or dataLower = 3 or dataLower = 4 or dataLower = 5 or dataLower = 6 or dataLower = 8 or dataLower = 9 or dataLower = 10 or dataLower = 11 or dataLower = 13 or dataLower = 14 or dataLower = 15) else '0'; -- G


    toSevenSegment(7 downto 1) <= led_1 when led_digit = '1' else led_2;


end Behavioral;