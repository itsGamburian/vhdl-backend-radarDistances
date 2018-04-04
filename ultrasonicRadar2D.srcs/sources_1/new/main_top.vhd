----------------------------------------------------------------------------------
-- Company: Senior Design 493
-- Project: Ultrasonic Radar
-- Advisor: Shahnam Mirzaei
-- Author: Hambartzum Gamburian
-- Participants: Hambartzum Gamburian, Giovanni Alonzo, Saba Janamian,
--               Hamed Seyedroudbari, Andrew Zaragoza, Xiaoao Feng
-- Filename: main_top.vhd
----------------------------------------------------------------------------------

-- main input "clk" is 100 MHz
-- radar1_reading_clk, radar2_reading_clk are 13,605 Hz ~ 13.6 kHz


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
           uart_reset : in STD_LOGIC;
           switches : in STD_LOGIC_VECTOR(7 downto 0);        
           tx_X_output : out STD_LOGIC;
           tx_Y_output : out STD_LOGIC;
           SEV_SEG : out STD_LOGIC_VECTOR(7 downto 0);
           LEDs : out STD_LOGIC_VECTOR(7 downto 0));
end main_top;

architecture Behavioral of main_top is

constant distance3 : std_logic_vector(7 downto 0) := std_logic_vector(to_unsigned(20, 8));

component ultrasonic_reading is
      Port (CLK : in STD_LOGIC;      
            PWM : in STD_LOGIC;
            READING_CLK : out STD_LOGIC;
            READING : out STD_LOGIC_VECTOR (7 downto 0));
end component;

component clkDivider is
    Generic (inputFrequency_Hz : integer;
             outputFrequency_Hz : integer);
    Port ( clk : in STD_LOGIC;
           frequency : out STD_LOGIC_VECTOR(7 downto 0);
           clkDivided : out STD_LOGIC);
end component;

component sevenSegment is
    Port ( clk : in STD_LOGIC;
           dataIn : in STD_LOGIC_VECTOR (7 downto 0);
           toSevenSegment : out STD_LOGIC_VECTOR (7 downto 0));
end component;



component uart is
  generic (
    HARDWIRED     : boolean := true;  -- Baud rate hardwired to constant value 
    BAUD_RATE     : integer := 19200; --19200; -- Default (or hardwired) baud rate 
    CLOCK_FREQ    : integer := 100E6); -- Clock rate
    port ( 
        rxd_i     : in std_logic;
        txd_o     : out std_logic;
 
        irq_o     : out std_logic;
 
        data_i    : in std_logic_vector(7 downto 0);
        data_o    : out std_logic_vector(7 downto 0);
 
        addr_i    : in std_logic_vector(1 downto 0);
        wr_i      : in std_logic;
        rd_i      : in std_logic;
        ce_i      : in std_logic;
 
        clk_i     : in std_logic;
        reset_i   : in std_logic);
end component;


signal sevenSegmentOutput, currentClockFrequency : STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
signal radar1_reading, radar1_reading_fromSensor, radar2_reading, radar2_reading_fromSensor : STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
signal radar1_reading_clk, radar2_reading_clk, tx_X_output_sig, tx_Y_output_sig : STD_LOGIC;

signal selected_clk, selected_clk_times_8, clkDivided5_2Hz, clkDivided5_16Hz : STD_LOGIC := '0';
signal frequency1, frequency2 : STD_LOGIC_VECTOR(7 downto 0) := (others => '0');


signal unused_rx_X_i, unused_interrupt_X, unused_rx_Y_i, unused_interrupt_Y, clkDivided_2Hz, clkDivided_16Hz, maxCount_2Hz, maxCount_16Hz : STD_LOGIC := '0';
signal unused_X_rxData, unused_Y_rxData : STD_LOGIC_VECTOR(7 downto 0) := (others => '0');

begin

radar1: ultrasonic_reading port map (CLK => clk, PWM => radar1_pwm, READING_CLK => radar1_reading_clk, READING => radar1_reading_fromSensor);
radar2: ultrasonic_reading port map (CLK => clk, PWM => radar2_pwm, READING_CLK => radar2_reading_clk, READING => radar2_reading_fromSensor);
sevenSeg: sevenSegment port map (clk => clk, dataIn => sevenSegmentOutput, toSevenSegment => SEV_SEG);

clk5_1: clkDivider generic map (inputFrequency_Hz => 13605, outputFrequency_Hz => 10)
                   port map (clk => radar1_reading_clk, frequency => frequency1, clkDivided => clkDivided5_2Hz);
clk5_2: clkDivider generic map (inputFrequency_Hz => 13605, outputFrequency_Hz => 80)
                   port map (clk => radar1_reading_clk, frequency => frequency2, clkDivided => clkDivided5_16Hz);      
                                                                            

tx_X_output <= tx_X_output_sig;
tx_Y_output <= tx_Y_output_sig;


selected_clk <= clkDivided5_2Hz;
selected_clk_times_8 <= clkDivided5_16Hz;


sevenSegmentOutput <= radar1_reading when (switches(7) = '0') else radar2_reading;
        
LEDs <= currentClockFrequency;



process(selected_clk)
begin
    if (selected_clk'event and selected_clk = '1') then
        radar1_reading <= radar1_reading_fromSensor;
        radar2_reading <= radar2_reading_fromSensor;
    end if;
end process;

uart_X: uart generic map (HARDWIRED => true, 
                         BAUD_RATE => 19200,  
                         CLOCK_FREQ => 100E6)
            port map (  rxd_i => unused_rx_X_i,
                        txd_o => tx_X_output_sig,
                 
                        irq_o => unused_interrupt_X,
                 
                        data_i => radar1_reading,
                        data_o => unused_X_rxData,
                 
                        addr_i => "00",
                        wr_i => selected_clk_times_8,
                        rd_i => '0',
                        ce_i => '1',
                 
                        clk_i => clk,
                        reset_i => uart_reset
                      );

uart_Y: uart generic map (HARDWIRED => true, 
                         BAUD_RATE => 19200,  
                         CLOCK_FREQ => 100E6)
            port map (  rxd_i => unused_rx_Y_i,
                        txd_o => tx_Y_output_sig,
                 
                        irq_o => unused_interrupt_Y,
                 
                        data_i => radar2_reading,
                        data_o => unused_Y_rxData,
                 
                        addr_i => "00",
                        wr_i => selected_clk_times_8,
                        rd_i => '0',
                        ce_i => '1',
                 
                        clk_i => clk,
                        reset_i => uart_reset
                      );                                                    
                   
end Behavioral;