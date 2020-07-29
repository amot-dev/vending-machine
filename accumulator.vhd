LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE Ieee.numeric_std.all;


ENTITY accumulator IS
PORT (clock, reset, enable : IN STD_LOGIC;
		Q, D, N					: IN STD_LOGic;
		count						: OUT UNSIGNED(5 DOWNTO 0));
END accumulator;

ARCHITECTURE Behaviour OF accumulator IS

SIGNAL internalCount : UNSIGNED(5 DOWNTO 0) := (others => '0');

BEGIN

	PROCESS(clock, reset)
	BEGIN
		IF (reset = '1') THEN					 -- if reset is true
			internalCount <= (others => '0'); -- reset internal count
			
		ELSIF rising_edge(clock) THEN
			IF (enable = '1') THEN 							-- if enable is set, on rising edge,
				IF (Q = '1') THEN
					internalCount <= internalCount + 5;	-- for a quarter, increment internal count by 5 (25 cents)
				ELSIF (D = '1') THEN
					internalCount <= internalCount + 2;	-- for a dime, increment internal count by 2 (10 cents)
				ELSIF (N = '1') THEN
					internalCount <= internalCount + 1;	-- for a nickel, increment internal count by 1 (5 cents)
				END IF;
			ELSE 
				count <= internalCount;						-- if enable is not set, output count
			END IF;
		END IF;
	END PROCESS;
	
END Behaviour;
		