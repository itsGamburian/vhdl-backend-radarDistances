----------------------------------------------------------------------------------
-- Company: Senior Design 493
-- Project: Ultrasonic Radar
-- Advisor: Shahnam Mirzaei
-- Author: Hambartzum Gamburian
-- Participants: Hambartzum Gamburian, Giovanni Alonzo, Saba Janamian,
--               Hamed Seyedroudbari, Andrew Zaragoza, Xiaoao Feng
-- Filename: clkDivider.vhd
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

entity clkDivider is
    Generic (inputFrequency_Hz : integer;
             outputFrequency_Hz : integer);
    Port ( clk : in STD_LOGIC;
           frequency : out STD_LOGIC_VECTOR(7 downto 0);
           clkDivided : out STD_LOGIC);
end clkDivider;

architecture Behavioral of clkDivider is

signal tmp : STD_LOGIC := '0';
signal max : integer := (((inputFrequency_Hz / 2) - 1) / outputFrequency_Hz); 
signal count : integer := 0;

begin
process(clk)
begin
    if (clk = '1' and clk'event) then
        if (count = max) then
            frequency <= std_logic_vector(to_unsigned(outputFrequency_Hz, 8));
            tmp <= not tmp;
            count <= 0;
        else
            count <= count + 1;
        end if;
    end if;
end process;

clkDivided <= tmp;

end Behavioral;