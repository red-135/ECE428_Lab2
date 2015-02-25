----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:03:29 02/22/2015 
-- Design Name: 
-- Module Name:    timer - Behavioral 
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

entity timer is
	generic
	(
		clk_freq_hz : real; 
		max_time_s : real
	);
	
	port
	(
		clk : in std_logic;
		reset : in std_logic;
		done_1x : out std_logic;
		done_2x : out std_logic;
		done_3x : out std_logic
	);
end timer;

architecture behavioral of timer is
	constant limit : integer := integer(clk_freq_hz * max_time_s);
	shared variable countup : integer := 0;
begin
	process(reset, clk)
	begin
		if (reset = '1') then
			countup := 0;
		elsif rising_edge(clk) then
			countup := countup + 1;
		end if;
		
		if(countup >= 1*limit) then
			done_1x <= '1';
		else
			done_1x <= '0';
		end if;
		
		if(countup >= 2*limit) then
			done_2x <= '1';
		else
			done_2x <= '0';
		end if;
		
		if(countup >= 3*limit) then
			done_3x <= '1';
		else
			done_3x <= '0';
		end if;
		
	end process;
end behavioral;
