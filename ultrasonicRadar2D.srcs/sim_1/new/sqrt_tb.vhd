library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity sqrt_tb is
--  Port ( );
end sqrt_tb;

architecture Behavioral of sqrt_tb is

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

signal clk, outValid, quotOutValid : STD_LOGIC;
signal data : STD_LOGIC_VECTOR(39 DOWNTO 0) := (others => '0');
signal quotientDumb : STD_LOGIC_VECTOR(31 DOWNTO 0) := (others => '0');
signal quotient : STD_LOGIC_VECTOR(23 DOWNTO 0) := (others => '0');
signal dataOut, dividend : STD_LOGIC_VECTOR(23 DOWNTO 0) := (others => '0');
signal divisor : STD_LOGIC_VECTOR(7 DOWNTO 0) := (others => '0');
signal cp : time := 10ns;

begin

quotient <= quotientDumb(31 downto 8); -- last 8 bits of divider output are trash

sqrt1: squareRoot_40bits port map ( aclk => clk, 
                                    s_axis_cartesian_tvalid => '1', 
                                    s_axis_cartesian_tdata => data, 
                                    m_axis_dout_tvalid => outValid,
                                    m_axis_dout_tdata => dataOut
                                   );

div: divider port map (     aclk => clk,
                            s_axis_divisor_tvalid => '1',
                            s_axis_divisor_tdata => divisor,
                            s_axis_dividend_tvalid => '1',
                            s_axis_dividend_tdata => dividend,
                            m_axis_dout_tvalid => quotOutValid,
                            m_axis_dout_tdata => quotientDumb
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
data <= "1111111111111111111111111111111111111111";--std_logic_vector(to_unsigned(1875, 40));
dividend <= "111111111111111111111111";--std_logic_vector(to_unsigned(86, 24));
divisor <= "11111111"; --std_logic_vector(to_unsigned(10, 8));
wait;
end process;                               


end Behavioral;