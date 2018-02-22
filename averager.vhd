----------------------------------------------------------------------------------
-- Company: Senior Design 493 - Mirzaei Group
-- Engineer: Hambartzum Gamburian
-- averager
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity averager is
    Port ( clk : in STD_LOGIC;
           input: in STD_LOGIC_VECTOR (7 downto 0);
           output: out STD_LOGIC_VECTOR (7 downto 0));
end averager;

architecture Behavioral of averager is
signal o0,o1,o2,o3,o4,o5,o6,o7,o8,o9,o10,o11,o12,o13,o14,o15 : std_logic_vector(7 downto 0) := (others => '0');
signal in_data, avg : std_logic_vector(7 downto 0);
signal sum: std_logic_vector(11 downto 0);
signal count : integer := 0;

begin
in_data <= input;
process (clk)
begin
--if (rst = '1') then
--    o0 <= "00000000";
--    o1 <= "00000000";
--    o2 <= "00000000";
--    o3 <= "00000000";
--    o4 <= "00000000";
--    o5 <= "00000000";
--    o6 <= "00000000";
--    o7 <= "00000000";
--    o8 <= "00000000";
--    o9 <= "00000000";
--    o10 <= "00000000";
--    o11 <= "00000000";
--    o12 <= "00000000";
--    o13 <= "00000000";
--    o14 <= "00000000";
--    o15 <= "00000000";
--    count <= 0;
if (clk'event and clk = '1') then
    o0 <= in_data;
    o1 <= o0;
    o2 <= o1;
    o3 <= o2;
    o4 <= o3;
    o5 <= o4;
    o6 <= o5;
    o7 <= o6;
    o8 <= o7;
    o9 <= o8;
    o10 <= o9;
    o11 <= o10;
    o12 <= o11;
    o13 <= o12;
    o14 <= o13;
    o15 <= o14;
    count <= count +1;
    
    if (count = 15) then 
        sum <= std_logic_vector(unsigned("0000" & o0)+unsigned("0000" & o1)+unsigned("0000" & o2)+unsigned("0000" & o3)+unsigned("0000" & o4)+unsigned("0000" & o5)+unsigned("0000" & o6)+unsigned("0000" & o7)+unsigned("0000" & o8)+unsigned("0000" & o9)+unsigned("0000" & o10)+unsigned("0000" & o11)+unsigned("0000" & o12)+unsigned("0000" & o13)+unsigned("0000" & o14)+unsigned("0000" & o15));
        count <= 0;
    end if;
end if;

avg <= sum(11 downto 4);
output<= avg;

end process;
end Behavioral;