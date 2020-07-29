LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE Ieee.numeric_std.all;


ENTITY programmingUnit IS
PORT (clock, reset, set, enable : IN STD_LOGIC;
		product						  : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
		QDN							  : IN STD_LOGic_VECTOR(2 DOWNTO 0);
		writeEnable					  : OUT STD_LOGIC;
		address						  : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
		data				           : OUT UNSIGNED(5 DOWNTO 0);
		done							  : OUT STD_LOGIC);
END programmingUnit;

ARCHITECTURE Behaviour OF programmingUnit IS

COMPONENT accumulator IS
PORT (clock, reset, enable : IN STD_LOGIC;
		Q, D, N					: IN STD_LOGic;
		count						: OUT UNSIGNED(5 DOWNTO 0));
END COMPONENT;

SIGNAL setAsserted : STD_LOGIC := '0';				-- whether or not set has been asserted
SIGNAL doneWait :	STD_LOGIC := '0';					-- signal to indicate that the circuit is done and waiting for the data
SIGNAL doneWaitCounter : INTEGER := 2;				-- number of clock cycles left until data is ready

SIGNAL enableAccumulator : STD_LOGIC;				-- enables or disables the accumulator
SIGNAL accumulatorOut : UNSIGNED(5 DOWNTO 0);	-- output from the accumulator

BEGIN

	PROCESS(clock)
	BEGIN
		IF (rising_edge(clock)) THEN
			IF (doneWait = '1') THEN			-- if the circuit is done and waiting for the data
				IF (doneWaitCounter = 0) THEN
					done <= '1';					-- if clock cycles left until data is ready is 0, assert done
					doneWaitCounter <= 2;		-- reset counter
				ELSE
					doneWaitCounter <= doneWaitCounter - 1;	-- else, decrement the counter
				END IF;
			
			ELSIF (set = '1' OR setAsserted = '1') THEN -- else if set is (or has been) asserted
				setAsserted <= '1';				-- set setAsserted to 1
				enableAccumulator <= '0';		-- assume the accumulator needs to be turned off
				
				writeEnable <= '1';
				address <= product;
				data <= accumulatorOut;
				doneWait <= '1';
			ELSE
				enableAccumulator <= enable;
			END IF;
		END IF;
	END PROCESS;
	
	PROCESS(reset)
	BEGIN
		IF (reset = '1') THEN
			-- do something idk what yet
		END IF;
	END PROCESS;
	
	accumulator_0 : accumulator PORT MAP(clock => clock, reset => reset,
													 enable => enableAccumulator, count => accumulatorOut,
													 Q => QDN(2), D => QDN(1), N => QDN(0));

END Behaviour;
