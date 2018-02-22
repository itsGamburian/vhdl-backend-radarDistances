----------------------------------------------------------------------------------
-- Company: Senior Design 493 - Mirzaei Group
-- Engineer: Hambartzum Gamburian
-- triangleCalculate
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity triangleCalculate is
    Port ( clk : in STD_LOGIC;
           distance1FromRadar : in STD_LOGIC_VECTOR(7 downto 0);
           distance2FromRadar : in STD_LOGIC_VECTOR(7 downto 0);
           distance3 : in STD_LOGIC_VECTOR(7 downto 0);
           x : out STD_LOGIC_VECTOR(12 downto 0);
           y : out STD_LOGIC_VECTOR(12 downto 0));
end triangleCalculate;

architecture Behavioral of triangleCalculate is

component squareRoot_26bits is
  Port (
    aclk : IN STD_LOGIC;
    s_axis_cartesian_tvalid : IN STD_LOGIC;
    s_axis_cartesian_tdata : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    m_axis_dout_tvalid : OUT STD_LOGIC;
    m_axis_dout_tdata : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
  );
end component;

component squareRoot_40bits is
  Port (
    aclk : IN STD_LOGIC;
    s_axis_cartesian_tvalid : IN STD_LOGIC;
    s_axis_cartesian_tdata : IN STD_LOGIC_VECTOR(39 DOWNTO 0);
    m_axis_dout_tvalid : OUT STD_LOGIC;
    m_axis_dout_tdata : OUT STD_LOGIC_VECTOR(23 DOWNTO 0)
  );
end component;

component divider is
  Port (
    aclk : IN STD_LOGIC;
    s_axis_divisor_tvalid : IN STD_LOGIC;
    s_axis_divisor_tdata : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    s_axis_dividend_tvalid : IN STD_LOGIC;
    s_axis_dividend_tdata : IN STD_LOGIC_VECTOR(23 DOWNTO 0);
    m_axis_dout_tvalid : OUT STD_LOGIC;
    m_axis_dout_tdata : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
  );
end component;

signal sqrt1OutValid, sqrt2OutValid, dividerOutValid : STD_LOGIC := '0';
signal sTemp, s, term1, term2, term3 : unsigned(9 downto 0) := (others => '0');
signal b4SquareRoot : unsigned(39 downto 0) := (others => '0');
signal b4SquareRoot_std : std_logic_vector(39 downto 0) := (others => '0');
signal tempArea, areaTimes2_std : std_logic_vector(23 downto 0) := (others => '0');
signal area : unsigned(19 downto 0) := (others => '0');

signal areaTimes2 : unsigned(20 downto 0) := (others => '0');
signal finalX_sqrtOutput : std_logic_vector(15 downto 0) := (others => '0');
signal finalY_dividerOut : std_logic_vector(31 downto 0) := (others => '0');
signal finalX, finalY : unsigned(12 downto 0) := (others => '0');
signal distance1FromRadarSquared, ySquared, xb4SquareRoot: unsigned(25 downto 0) := (others => '0');
signal xb4SquareRoot_std : std_logic_vector(31 downto 0);

begin

process(clk)
begin    
    if (clk'event and clk = '1') then
        sTemp <= ("00" & unsigned(distance1FromRadar)) + ("00" & unsigned(distance2FromRadar)) + ("00" & unsigned(distance3));
        s <= '0' & sTemp(9 downto 1); 
        term1 <= s - unsigned(distance1FromRadar);
        term2 <= s - unsigned(distance2FromRadar);
        term3 <= s - unsigned(distance3);
        b4SquareRoot <= s * term1 * term2 * term3;
        --tempArea <= tempArea;
        area <= unsigned(tempArea(23 downto 4));
        areaTimes2 <= area(19 downto 0) & '0';
        finalY <= unsigned(finalY_dividerOut(31 downto 19));
        --finalY_dividerOut <= finalY_dividerOut;
        distance1FromRadarSquared <= "0000000000" & (unsigned(distance1FromRadar) * unsigned(distance1FromRadar));
        ySquared <= finalY * finalY;
        xb4SquareRoot <= distance1FromRadarSquared - ySquared;
        --finalX <= finalX;
        finalX <= unsigned(finalX_sqrtOutput(15 downto 3));
    end if;
end process;

xb4SquareRoot_std <= "000000" & std_logic_vector(xb4SquareRoot);
areaTimes2_std <= "000" & std_logic_vector(areaTimes2);
b4SquareRoot_std <= std_logic_vector(b4SquareRoot);
x <= std_logic_vector(finalX);
y <= std_logic_vector(finalY);



sqrt1: squareRoot_40bits port map ( aclk => clk, 
                                    s_axis_cartesian_tvalid => '1', 
                                    s_axis_cartesian_tdata => b4SquareRoot_std,
                                    m_axis_dout_tvalid => sqrt1OutValid,
                                    m_axis_dout_tdata => tempArea
                                   );

sqrt2: squareRoot_26bits port map ( aclk => clk, 
                                    s_axis_cartesian_tvalid => '1', 
                                    s_axis_cartesian_tdata => xb4SquareRoot_std,
                                    m_axis_dout_tvalid => sqrt2OutValid,
                                    m_axis_dout_tdata => finalX_sqrtOutput
                                  );                             
                    
div: divider port map (     aclk => clk,
                            s_axis_divisor_tvalid => '1',
                            s_axis_divisor_tdata => distance3,
                            s_axis_dividend_tvalid => '1',
                            s_axis_dividend_tdata => areaTimes2_std,
                            m_axis_dout_tvalid => dividerOutValid,
                            m_axis_dout_tdata => finalY_dividerOut
                      );    

end Behavioral;