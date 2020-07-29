LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE Ieee.numeric_std.all;


ENTITY freeUnit IS
PORT (clock, reset, enable : IN STD_LOGIC;
		product					: IN STD_LOGIC_VECTOR(1 DOWNTO 0);
		QDN						: IN STD_LOGic_VECTOR(2 DOWNTO 0);
		totalInserted			: OUT UNSIGNED(5 DOWNTO 0);
		change					: OUT UNSIGNED(5 DOWNTO 0);
		done						: OUT STD_LOGIC);
END freeUnit;

ARCHITECTURE Behaviour OF freeUnit IS

BEGIN

	PROCESS(clock)
	BEGIN
		IF rising_edge(clock) THEN
			totalInsterted <= "ZZZZZZ";	-- as this unit dispenses products for free, set money-related outputs to floating
			change <= "ZZZZZZ";
			done <= '1';						-- dispense product
		END IF;
	END PROCESS;

END Behaviour;