--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   17:11:36 02/22/2015
-- Design Name:   
-- Module Name:   C:/Users/Steven/Documents/School/ECE_428/Lab-2-Xilinx/Lab-2-PMIC/timer_tb.vhd
-- Project Name:  Lab-2-PMIC
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: timer
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY timer_tb IS
END timer_tb;
 
ARCHITECTURE behavior OF timer_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
    COMPONENT timer
		GENERIC
		(
			clk_freq_hz : real; 
			max_time_s : real
		);
		PORT
		(
			done_1x : out std_logic;
			done_2x : out std_logic;
			done_3x : out std_logic;
			reset : IN  std_logic;
			clk : IN  std_logic
		);
	END COMPONENT;
    

	--Inputs
	signal reset : std_logic := '0';
	signal clk : std_logic := '0';

	--Outputs
	signal done_1x : std_logic;
	signal done_2x : std_logic;
	signal done_3x : std_logic;

	-- Clock period definitions
	constant clk_period : time := 100 us;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
	uut: timer 
		GENERIC MAP
		(
			clk_freq_hz => 10000.0,
			max_time_s => 0.5
		)
		PORT MAP
		(
			done_1x => done_1x,
			done_2x => done_2x,
			done_3x => done_3x,
			reset => reset,
			clk => clk
		);

	-- Clock process definitions
	clk_process :process
	begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
	end process;


	-- Stimulus process
	stim_proc: process
	begin
		-- Reset Timer and Watch Time
		reset <= '1';
		wait for 100 ns;	
		reset <= '0';
		wait;
	end process;

END;
