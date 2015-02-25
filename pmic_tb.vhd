--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   19:19:30 02/22/2015
-- Design Name:   
-- Module Name:   C:/Users/Steven/Documents/School/ECE_428/Lab-2-Xilinx/Lab-2-PMIC/pmic_tb.vhd
-- Project Name:  Lab-2-PMIC
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: pmic
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
 
ENTITY pmic_tb IS
END pmic_tb;
 
ARCHITECTURE behavior OF pmic_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
    COMPONENT pmic
		PORT 
		(
			clk_ext : IN  std_logic;
			reset : IN  std_logic;
			onoff : IN  std_logic;
			low_battery : IN  std_logic;
			low_power : IN std_logic;
			en_33v : OUT  std_logic;
			en_25v : OUT  std_logic;
			en_12v : OUT  std_logic;
			ready : OUT  std_logic
		);
    END COMPONENT;
    

	--Inputs
	signal clk : std_logic := '0';
	signal reset : std_logic := '1';
	signal onoff : std_logic := '0';
	signal low_battery : std_logic := '0';
	signal low_power : std_logic := '0';

 	--Outputs
   signal en_33v : std_logic;
   signal en_25v : std_logic;
   signal en_12v : std_logic;
   signal ready : std_logic;

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
	uut: pmic 
		PORT MAP (
			clk_ext => clk,
			reset => reset,
			onoff => onoff,
			low_battery => low_battery,
			low_power => low_power,
			en_33v => en_33v,
			en_25v => en_25v,
			en_12v => en_12v,
			ready => ready
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
		-- Reset Circuit
		reset <= '1';
		wait for 1000 ms;	
		reset <= '0';

		-- Test Full Power Start-Up
		low_power <= '0';
		onoff <= '1';
		wait for 5000 ms;
		onoff <= '0';
		wait for 5000 ms;
		
		-- Test Low Power Start-Up
		low_power <= '1';
		onoff <= '1';
		wait for 5000 ms;
		onoff <= '0';
		wait for 5000 ms;
		
		-- Test Low Power to Full Power Start-Up and Back
		low_power <= '1';
		onoff <= '1';
		wait for 5000 ms;
		low_power <= '0';
		wait for 5000 ms;
		low_power <= '1';
		onoff <= '0';
		wait for 5000 ms;

		wait;
	end process;

END;
