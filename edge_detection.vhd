----------------------------------------------------------------------------------
-- Company: Senior Design 493 - Mirzaei Group
-- Engineer: Hambartzum Gamburian
-- edge_detection
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

entity edge_detection is
    Port ( 
          clk : in STD_LOGIC;
          din : in STD_LOGIC;
          dout : out STD_LOGIC);
end edge_detection;

architecture Behavioral of edge_detection is

signal data_ff: std_logic := '0';

begin

process(clk)
begin
    if(rising_edge(clk)) then
        data_ff <= din;
    end if;
end process;
  
dout <= din and not data_ff;

end Behavioral;