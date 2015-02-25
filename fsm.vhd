----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:37:18 02/22/2015 
-- Design Name: 
-- Module Name:    fsm - Behavioral 
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
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity fsm is
	port
	(
		clk : in std_logic;
		reset : in std_logic;
		onoff : in std_logic;
		low_battery : in std_logic;
		low_power : in std_logic;
		timer_1x : in std_logic;
		timer_2x : in std_logic;
		timer_3x : in std_logic;
		timer_4x : in std_logic;
		timer_5x : in std_logic;
		
		en_33v : out std_logic;
		en_25v : out std_logic;
		en_12v : out std_logic;
		ready : out std_logic;
		timer_reset : out std_logic
	);
end fsm;

architecture behavioral of fsm is
	type state_type is 
	(
		soff, son, slb, slp,
		sen_33v, sen_25v, sen_12v, 
		sdis_33v, sdis_25v, sdis_12v,
		sen_33v_lp, sen_25v_lp, sen_12v_lp, 
		sdis_33v_lp, sdis_25v_lp, sdis_12v_lp, 
		slp_to_sdis_12v_lp, slp_to_sen_33v_lp,
		son_to_sdis_12v, son_to_sdis_25v_lp
	);
	
	signal current_state, next_state : state_type;
	
	signal timer_reset_internal : std_logic;
	
begin

	--- ========================================================================
	--- NEXT STATE AND TIMER RESET TRANSITIONS
	--- ========================================================================
	
	-- timer_reset_internal is used so that timer_reset can be type out
	-- This leads to fewer validations complaints from Xilinx
	timer_reset <= timer_reset_internal;
	
	process(clk, reset)
	begin
		if (reset = '1') then
			current_state <= soff;
			timer_reset_internal <= '0';
		elsif rising_edge(clk) then
			if (current_state /= next_state) then
				timer_reset_internal <= '1';
			else
				timer_reset_internal <= '0';
			end if;
			current_state <= next_state;
		end if;
	end process;
	
	--- ========================================================================
	--- NEXT STATE LOGIC
	--- ========================================================================
	
	process(current_state, onoff, low_battery, low_power, timer_1x, timer_2x, timer_3x, timer_4x, timer_5x)
	begin
		case current_state is
			
			-- -----------------------------------------------------------------
			-- Terminal States
			-- -----------------------------------------------------------------
			when soff =>
				if (onoff = '1' and low_battery = '0' and low_power = '0') then
					next_state <= sen_33v;
				elsif (onoff = '1' and low_battery = '0' and low_power = '1') then
					next_state <= sen_12v_lp;
				elsif (onoff = '1' and low_battery = '1') then
					next_state <= soff;
				else
					next_state <= soff;
				end if;
				
			when son =>
				if (onoff = '1' and low_battery = '1') then
					next_state <= slb;
				elsif (onoff = '1' and low_power = '1') then
					next_state <= son_to_sdis_25v_lp;
				elsif (onoff = '0' and low_battery = '0') then
					next_state <= son_to_sdis_12v;
				else
					next_state <= son;
				end if;
				
			when slb =>
				next_state <= sdis_12v;
				
			when slp =>
				if (onoff = '1' and low_power = '0') then
					next_state <= slp_to_sen_33v_lp;
				elsif (onoff = '0' and timer_1x = '1') then
					next_state <= slp_to_sdis_12v_lp;
				else
					next_state <= slp;
				end if;
			
			-- -----------------------------------------------------------------
			-- Transition States (Not Low Power)
			-- -----------------------------------------------------------------
			
			when sen_33v =>
				if (timer_1x = '1') then
					next_state <= sen_25v;
				else
					next_state <= sen_33v;
				end if;
				
			when sen_25v =>
				if (timer_2x = '1') then
					next_state <= sen_12v;
				else
					next_state <= sen_25v;
				end if;
				
			when sen_12v =>
				next_state <= son;
			
			when sdis_33v =>
				next_state <= soff;
				
			when sdis_25v =>
				if (timer_5x = '1') then
					next_state <= sdis_33v;
				else
					next_state <= sdis_25v;
				end if;
				
			when sdis_12v =>
				if (timer_4x = '1') then
					next_state <= sdis_25v;
				else
					next_state <= sdis_12v;
				end if;
			
			-- -----------------------------------------------------------------
			-- Transition States (Low Power)
			-- -----------------------------------------------------------------
			
			when sen_33v_lp =>
				if (timer_1x = '1') then
					next_state <= sen_25v_lp;
				else
					next_state <= sen_33v_lp;
				end if;
				
			when sen_25v_lp =>
				next_state <= son;
				
			when sen_12v_lp =>
				next_state <= slp;
				
			when sdis_33v_lp =>
				next_state <= slp;
				
			when sdis_25v_lp =>
				if (timer_5x = '1') then
					next_state <= sen_33v_lp;
				else
					next_state <= sen_25v_lp;
				end if;
				
			when sdis_12v_lp =>
				next_state <= soff;
			
			-- -----------------------------------------------------------------
			-- Timer Reset States
			-- -----------------------------------------------------------------
			
			when slp_to_sdis_12v_lp =>
				if (onoff = '1') then
					next_state <= slp;
				elsif (onoff ='0' and timer_3x = '1') then
					next_state <= soff;
				else
					next_state <= slp_to_sdis_12v_lp;
				end if;
				
			when slp_to_sen_33v_lp =>
				if (low_power = '1') then
					next_state <= slp;
				elsif (low_power = '0' and timer_3x = '1') then
					next_state <= sen_33v_lp;
				else
					next_state <= slp_to_sen_33v_lp;
				end if;
				
			when son_to_sdis_12v =>
				if (onoff = '1') then
					next_state <= son;
				elsif (onoff = '0' and timer_3x = '1') then
					next_state <= sdis_12v;
				else
					next_state <= son_to_sdis_12v;
				end if;
				
			when son_to_sdis_25v_lp =>
				if (low_power = '0') then
					next_state <= son;
				elsif (low_power = '1' and timer_4x = '1') then
					next_state <= sdis_25v_lp;
				else
					next_state <= son_to_sdis_25v_lp;
				end if;
				
		end case;
	end process;
	
	--- ========================================================================
	--- NEXT OUTPUT LOGIC
	--- ========================================================================
	
	process(current_state, onoff, low_battery,timer_1x, timer_2x, timer_3x, timer_4x, timer_5x)
	begin
		case current_state is
			-- -----------------------------------------------------------------
			-- Terminal States
			-- -----------------------------------------------------------------
			when soff =>
				en_33v <= '0';
				en_25v <= '0';
				en_12v <= '0';
				ready <= '0';
			when son =>
				en_33v <= '1';
				en_25v <= '1';
				en_12v <= '1';
				ready <= '1';
			when slb =>
				en_33v <= '1';
				en_25v <= '1';
				en_12v <= '1';
				ready <= '0';
			when slp =>
				en_33v <= '0';
				en_25v <= '0';
				en_12v <= '1';
				ready <= '1';
			-- -----------------------------------------------------------------
			-- Transition States (Not Low Power)
			-- -----------------------------------------------------------------
			when sen_33v =>
				en_33v <= '1';
				en_25v <= '0';
				en_12v <= '0';
				ready <= '0';
			when sen_25v =>
				en_33v <= '1';
				en_25v <= '1';
				en_12v <= '0';
				ready <= '0';
			when sen_12v =>
				en_33v <= '1';
				en_25v <= '1';
				en_12v <= '1';
				ready <= '0';
			when sdis_33v =>
				en_33v <= '0';
				en_25v <= '0';
				en_12v <= '0';
				ready <= '0';
			when sdis_25v =>
				en_33v <= '1';
				en_25v <= '0';
				en_12v <= '0';
				ready <= '0';
			when sdis_12v =>
				en_33v <= '1';
				en_25v <= '1';
				en_12v <= '0';
				ready <= '0';
			-- -----------------------------------------------------------------
			-- Transition States (Low Power)
			-- -----------------------------------------------------------------
			when sen_33v_lp =>
				en_33v <= '1';
				en_25v <= '0';
				en_12v <= '1';
				ready <= '0';
			when sen_25v_lp =>
				en_33v <= '1';
				en_25v <= '1';
				en_12v <= '1';
				ready <= '1';
			when sen_12v_lp =>
				en_33v <= '0';
				en_25v <= '0';
				en_12v <= '1';
				ready <= '0';
			when sdis_33v_lp =>
				en_33v <= '0';
				en_25v <= '0';
				en_12v <= '1';
				ready <= '0';
			when sdis_25v_lp =>
				en_33v <= '1';
				en_25v <= '0';
				en_12v <= '1';
				ready <= '0';
			when sdis_12v_lp =>
				en_33v <= '0';
				en_25v <= '0';
				en_12v <= '0';
				ready <= '0';
			-- -----------------------------------------------------------------
			-- Timer Reset States
			-- -----------------------------------------------------------------
			when slp_to_sdis_12v_lp =>
				en_33v <= '0';
				en_25v <= '0';
				en_12v <= '1';
				ready <= '1';
			when slp_to_sen_33v_lp =>
				en_33v <= '0';
				en_25v <= '0';
				en_12v <= '1';
				ready <= '1';
			when son_to_sdis_12v =>
				en_33v <= '1';
				en_25v <= '1';
				en_12v <= '1';
				ready <= '1';
			when son_to_sdis_25v_lp =>
				en_33v <= '1';
				en_25v <= '1';
				en_12v <= '1';
				ready <= '1';
		end case;
	end process;
				
end behavioral;

