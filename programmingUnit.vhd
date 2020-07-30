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

SIGNAL doneWait 		  	 :	STD_LOGIC := '0';			-- signal to indicate that the circuit is done and waiting for the data
SIGNAL doneWaitCounter 	 : INTEGER := 2;				-- number of clock cycles left until data is ready
SIGNAL doneAsserted 		 : STD_LOGIC := '0'; 		-- used to check if done is asserted

SIGNAL enableAccumulator : STD_LOGIC;					-- enables or disables the accumulator
SIGNAL accumulatorOut 	 : UNSIGNED(5 DOWNTO 0);	-- output from the accumulator



BEGIN

	PROCESS(clock, reset)
	BEGIN
		IF (reset = '1') THEN					-- if a reset signal is sent, return done but do not enable writing to SRAM
			doneAsserted <= '1';					-- reset does not need enable to be on, because as long as writeEnable is 0, the programming unit does nothing
			writeEnable <= '0';
			
		ELSIF (rising_edge(clock) AND enable = '1') THEN
			IF (doneAsserted = '1') THEN		-- if done has been asserted
				doneWaitCounter <= 2;			-- reset all relevant signals
				doneWait <= '0';
				doneAsserted <= '0';
			ELSIF (doneWait = '1') THEN		-- if the circuit is done and waiting for the data
				IF (doneWaitCounter = 1) THEN
					doneAsserted <= '1';			-- assert done on first clock cycle after accumulator is done
					data <= accumulatorOut;		-- transfer accumulator to data
				END IF;
				doneWaitCounter <= doneWaitCounter - 1; -- decrement the counter
			ELSIF (set = '1') THEN 				-- if set is asserted
				enableAccumulator <= '0';		-- assume the accumulator needs to be turned off
				data <= accumulatorOut;			-- transfer accumulator to data
				writeEnable <= '1';				-- enable writing to SRAM
				doneWait <= '1';					-- prepare to wait until all outputs are in sync
			ELSIF (doneWait = '0') THEN		-- if the circuit has not already finished, enable accumulator
				enableAccumulator <= '1';
			END IF;
		END IF;
	END PROCESS;
	
	done <= doneAsserted;
	address <= product;
	
	
	
	accumulator_0 : accumulator PORT MAP(clock => clock, reset => reset,
													 enable => enableAccumulator, count => accumulatorOut,
													 Q => QDN(2), D => QDN(1), N => QDN(0));

END Behaviour;
