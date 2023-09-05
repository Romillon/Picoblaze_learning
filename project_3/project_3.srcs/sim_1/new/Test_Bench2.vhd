----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05.09.2023 15:00:18
-- Design Name: 
-- Module Name: Test_Bench2 - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Test_Bench2 is
--  Port ( );
end Test_Bench2;

architecture Behavioral of Test_Bench2 is

    component main is
        Port ( clk   : in STD_LOGIC;
               sw    : in STD_LOGIC_VECTOR (15 downto 0);
               leds  : out STD_LOGIC_VECTOR (15 downto 0);
               segs7 : out STD_LOGIC_VECTOR (6 downto 0);
               an    : out std_logic_vector(3 downto 0)
               );
    end component;

constant clk_period : time := 20ns;

signal               clk_tb   : STD_LOGIC:='0';
signal               sw_tb    : STD_LOGIC_VECTOR (15 downto 0);
signal               leds_tb  : STD_LOGIC_VECTOR (15 downto 0);
signal               segs7_tb : STD_LOGIC_VECTOR (6 downto 0);
signal               an_tb    : std_logic_vector(3 downto 0);

begin

    TTT : main       --Thing_To_Test
        port map (
            clk => clk_tb,
            sw => sw_tb,
            leds => leds_tb,
            segs7 => segs7_tb,
            an => an_tb
        );
    
    process         --clock generation
        begin    
        clk_tb <= not clk_tb;
    
        wait for clk_period/2;
      end process;




    process
        begin
        sw_tb<="0000000000000000";
        wait for clk_period;
        sw_tb<="0000000000000001";
        wait for clk_period;
        sw_tb<="0000000000000010";
        wait for clk_period;
        sw_tb<="0000000000000100";
        wait for clk_period;
        sw_tb<="0000000000001000";
        wait for clk_period;
        sw_tb<="0000000000010000";
        wait for clk_period;
    end process ;


end architecture;
