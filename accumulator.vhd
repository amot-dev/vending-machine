LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE Ieee.numeric_std.all;


ENTITY accumulator IS
PORT (clock, reset, enable : IN STD_LOGIC;
		Q, D, N					: IN STD_LOGic;
		count						: OUT UNSIGNED(5 DOWNTO 0));
END accumulator;

ARCHITECTURE Behaviour OF accumulator IS

SIGNAL internalCount : UNSIGNED(5 DOWNTO 0);

BEGIN

	PROCESS(clock)
	BEGIN
		IF (rising_edge(clock) AND enable) THEN	-- if enable is set, on rising edge,
			IF Q THEN
				internalCount <= internalCount + 5;	-- for a quarter, increment internal count by 5 (25 cents)
			ELSIF D THEN
				internalCount <= internalCount + 2;	-- for a dime, increment internal count by 2 (10 cents)
			ELSIF N THEN
				internalCount <= internalCount + 1;	-- for a nickel, increment internal count by 1 (5 cents)
			END IF;
		ELSIF (rising_edge(clock) THEN				-- if enable is not set, on rising edge,
			count <= internalCount;					-- output count
		END IF;
	END PROCESS;

	PROCESS(reset)						-- on reset (asserted after count is output for one clock cycle)
	BEGIN
		IF (reset = '1') THEN		-- if reset is true (ie, don't activate when reset changes to false)
			internalCount <= 0;		-- reset internal count
		END IF;
	END PROCESS;
	
END Behaviour;
		