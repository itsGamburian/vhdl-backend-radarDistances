----------------------------------------------------------------------------------
-- Company: Senior Design 493
-- Project: Ultrasonic Radar
-- Advisor: Shahnam Mirzaei
-- Author: Hambartzum Gamburian
-- Participants: Hambartzum Gamburian, Giovanni Alonzo, Saba Janamian,
--               Hamed Seyedroudbari, Andrew Zaragoza, Xiaoao Feng
-- Filename: edge_detection.vhd
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

entity edge_detection is
    Port (clk : in STD_LOGIC;
          input : in STD_LOGIC;
          output : out STD_LOGIC);
end edge_detection;

architecture Behavioral of edge_detection is

signal temp: std_logic := '0';

begin

process(clk)
begin
    if(clk'event and clk = '1') then
        temp <= input;
    end if;
end process;
  
output <= input and not temp;

end Behavioral;