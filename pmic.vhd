----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    18:46:10 02/22/2015 
-- Design Name: 
-- Module Name:    pmic - structural 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
package PMIC_PACK is
	constant CLK_TIME_HZ : real := 50000.0;
end PMIC_PACK;

use WORK.PMIC_PACK.ALL;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity pmic is
		port
		(
			clk: in std_logic;
			reset: in std_logic;
			onoff: in std_logic;
			low_battery: in std_logic;
			low_power: in std_logic;
			
			en_33v: out std_logic;
			en_25v: out std_logic;
			en_12v: out std_logic;
			ready: out std_logic
		);
end pmic;

architecture structural of pmic is
	
	--- ========================================================================
	--- COMPONENT DECLARATION - FSM
	--- ========================================================================
	
	component fsm
		port
		(
			clk: in std_logic;
			reset: in std_logic;
			onoff: in std_logic;
			low_battery: in std_logic;
			low_power: in std_logic;
			timer_1x: in std_logic;
			timer_2x: in std_logic;
			timer_3x: in std_logic;

			en_33v: out std_logic;
			en_25v: out std_logic;
			en_12v: out std_logic;
			ready: out std_logic;
			timer_reset: out std_logic
		);
	end component;

	--- ========================================================================
	--- COMPONENT DECLARATION - TIMER
	--- ========================================================================
	
	component timer
		generic	
		(
			clk_freq_hz : real; 
			max_time_s : real
		);
		port
		(
			done_1x : out std_logic;
			done_2x : out std_logic;
			done_3x : out std_logic;
			reset : in  std_logic;
			clk : in  std_logic
		);
	end component;
	
	--- ========================================================================
	--- SIGNAL DECLARATION
	--- ========================================================================

	signal timer_1x: std_logic;
	signal timer_2x: std_logic;
	signal timer_3x: std_logic;
	signal timer_reset: std_logic;
	signal timer_reset_fsm: std_logic;
	
begin

	--- ========================================================================
	--- PORT MAP - FSM
	--- ========================================================================
	
	F1: fsm 
		port map
		(
			clk => clk,
			reset => reset,
			onoff => onoff,
			low_battery => low_battery,
			low_power => low_power,
			timer_1x => timer_1x,
			timer_2x => timer_2x,
			timer_3x => timer_3x,
			en_33v => en_33v,
			en_25v => en_25v,
			en_12v => en_12v,
			ready => ready,
			timer_reset => timer_reset_fsm
		);
	
	--- ========================================================================
	--- PORT MAP - TIMER
	--- ========================================================================
	
	T1: timer	
		generic map
		(
			clk_freq_hz => CLK_TIME_HZ,
			max_time_s => 0.5
		)
		port map 
		(
			done_1x => timer_1x,
			done_2x => timer_2x,
			done_3x => timer_3x,
			clk => clk,
			reset => timer_reset
		);
	
	--- ========================================================================
	--- RESET LOGIC
	--- ========================================================================
	timer_reset <= timer_reset_fsm or reset;

end structural;

