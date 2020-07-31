LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE Ieee.numeric_std.all;


ENTITY freeUnit IS
PORT (clock, enable : IN STD_LOGIC;
		price			  : IN UNSIGNED(5 DOWNTO 0);
		QDN			  : IN STD_LOGic_VECTOR(2 DOWNTO 0);
		totalInserted : OUT UNSIGNED(5 DOWNTO 0);
		change		  : OUT UNSIGNED(5 DOWNTO 0);
		done			  : OUT STD_LOGIC);
END freeUnit;

ARCHITECTURE Behaviour OF freeUnit IS

SIGNAL doneAsserted : STD_LOGIC := '0';-- whether or not done is asserted

BEGIN

	PROCESS(clock)
	BEGIN											-- no reset is needed for this circuit (not even need for a reset input)
		IF (rising_edge(clock) and enable = '1') THEN
			IF (doneAsserted <= '1') THEN	-- unassert done after one clock cycle
				doneAsserted <= '0';
			ELSE
				totalInserted <= "ZZZZZZ";	-- as this unit dispenses products for free, set money-related outputs to floating
				change <= "ZZZZZZ";
				doneAsserted <= '1';			-- dispense product
			END IF;
		END IF;
	END PROCESS;
	
	done <= doneAsserted;

END Behaviour;