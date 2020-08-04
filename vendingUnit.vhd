LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE Ieee.numeric_std.all;


ENTITY vendingUnit IS
PORT (clock, reset, enable : IN STD_LOGIC;
		price						: IN UNSIGNED(5 DOWNTO 0);
		QDN						: IN STD_LOGic_VECTOR(2 DOWNTO 0);
		totalInserted,change	: OUT UNSIGNED(5 DOWNTO 0);
		done						: OUT STD_LOGIC);
END vendingUnit;

ARCHITECTURE Behaviour OF vendingUnit IS

COMPONENT accumulator IS
PORT (clock, reset, enable : IN STD_LOGIC;
		Q, D, N					: IN STD_LOGic;
		count						: OUT UNSIGNED(5 DOWNTO 0));
END COMPONENT;

SIGNAL doneAsserted	 : STD_LOGIC := '0';				-- whether or not done is asserted
SIGNAL accumulatorOut : UNSIGNED(5 DOWNTO 0);		-- output from the accumulator

BEGIN

	PROCESS(clock)
	BEGIN															-- there is no reset involved because the only reset this machine needs is resetting the accumulator
		IF (rising_edge(clock) and enable = '1' and price /= "000000") THEN	-- machine only works when inputs are synced
			IF (accumulatorOut >= price) THEN			-- if the user has inserted enough or more than enough money
				change <= accumulatorOut - price;		-- get change value
				IF (QDN = "000") THEN
					doneAsserted <= '1';						-- if the user has stopped inserting money, assert done
				END IF;
			ELSE
				change <= (others => '0');					-- return change as 0 if not enough money has been inserted yet
			END IF;
		ELSIF rising_edge(clock) THEN
			IF (doneAsserted <= '1') THEN					-- unassert done when enable is 0
				doneAsserted <= '0';
			END IF;
		END IF;
	END PROCESS;
	
	totalInserted <= accumulatorOut;						-- constantly output how much has been inserted
	done <= doneAsserted;
	
	accumulator_1 : accumulator PORT MAP(clock => clock, reset => reset,
													 enable => enable, count => accumulatorOut,
													 Q => QDN(2), D => QDN(1), N => QDN(0));

END Behaviour;