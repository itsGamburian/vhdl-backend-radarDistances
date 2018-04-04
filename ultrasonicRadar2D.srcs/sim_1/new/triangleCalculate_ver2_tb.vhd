----------------------------------------------------------------------------------
-- Company: Senior Design 493 - Mirzaei Group
-- Engineer: Hambartzum Gamburian
-- triangleCalculate_tb
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity triangleCalculate_ver2_tb is
--  Port ( );
end triangleCalculate_ver2_tb;

architecture Behavioral of triangleCalculate_ver2_tb is

component triangleCalculate_ver2 is
    Port ( clk : in STD_LOGIC;
           distance1FromRadar : in STD_LOGIC_VECTOR(7 downto 0);
           distance2FromRadar : in STD_LOGIC_VECTOR(7 downto 0);
           distance3 : in STD_LOGIC_VECTOR(7 downto 0);
           triangleSidesNotProportional : out STD_LOGIC;
           x : out STD_LOGIC_VECTOR(7 downto 0);
           y : out STD_LOGIC_VECTOR(7 downto 0));
end component;

signal clk, triangleSidesNotProportional : STD_LOGIC := '0';
signal distance1FromRadar, distance2FromRadar, distance3 : STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
signal x, y : STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
signal cp : time := 73.5us;

begin

tri: triangleCalculate_ver2 port map ( clk => clk,
                                  distance1FromRadar => distance1FromRadar,
                                  distance2FromRadar => distance2FromRadar,
                                  distance3 => distance3,
                                  triangleSidesNotProportional => triangleSidesNotProportional,
                                  x => x,
                                  y => y
                                 );



process
begin
clk <= '0';
wait for cp / 2;
clk <= '1';
wait for cp / 2;
end process;

process
begin
distance1FromRadar <= std_logic_vector(to_unsigned(10, 8));
distance2FromRadar <= std_logic_vector(to_unsigned(10, 8));
distance3 <= std_logic_vector(to_unsigned(10, 8));
wait for cp;
distance1FromRadar <= std_logic_vector(to_unsigned(70, 8));
distance2FromRadar <= std_logic_vector(to_unsigned(70, 8));
distance3 <= std_logic_vector(to_unsigned(10, 8));
wait for cp;
distance1FromRadar <= std_logic_vector(to_unsigned(240, 8));
distance2FromRadar <= std_logic_vector(to_unsigned(240, 8));
distance3 <= std_logic_vector(to_unsigned(240, 8));
wait for cp;
distance1FromRadar <= std_logic_vector(to_unsigned(240, 8));
distance2FromRadar <= std_logic_vector(to_unsigned(240, 8));
distance3 <= std_logic_vector(to_unsigned(10, 8));
wait;
end process;

end Behavioral;