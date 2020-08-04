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

SIGNAL doneAsserted 		 : STD_LOGIC := '0'; 		-- used to check if done is asserted
SIGNAL enableAccumulator : STD_LOGIC;					-- enables or disables the accumulator
SIGNAL accumulatorOut 	 : UNSIGNED(5 DOWNTO 0);	-- output from the accumulator

BEGIN

	PROCESS(clock, reset)
	BEGIN
		IF (reset = '1') THEN					-- if a reset signal is sent, return done but do not enable writing to SRAM
			doneAsserted <= '1';					-- reset does not need enable to be on, because as long as writeEnable is 0, the programming unit does nothing	
		ELSIF (rising_edge(clock) AND enable = '1') THEN
			IF (doneAsserted = '1') THEN		-- if done has been asserted
				doneAsserted <= '0';				-- unassert it (ensures done is only asserted for one clock cycle)
				writeEnable <= '0';				-- disable writing
			ELSIF (set = '1') THEN 				-- if set is asserted
				enableAccumulator <= '0';		-- assume the accumulator needs to be turned off
				data <= accumulatorOut;			-- transfer accumulator to data
				writeEnable <= '1';				-- enable writing to SRAM
				doneAsserted <= '1';				-- assert done
			ELSIF (doneAsserted = '0') THEN	-- if the circuit has not already finished, enable accumulator
				enableAccumulator <= '1';
			END IF;
		ELSIF rising_edge(clock) THEN
			IF (doneAsserted = '1') THEN		-- be able to unassert done even if enable is 0
				doneAsserted <= '0';
				writeEnable <= '0';
			END IF;
		END IF;
	END PROCESS;
	
	done <= doneAsserted;
	address <= product;
	
	accumulator_0 : accumulator PORT MAP(clock => clock, reset => reset,
													 enable => enableAccumulator, count => accumulatorOut,
													 Q => QDN(2), D => QDN(1), N => QDN(0));

END Behaviour;
