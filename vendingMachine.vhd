LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE Ieee.numeric_std.all;


ENTITY vendingMachine IS
PORT (clock, reset, hardReset, start, set : IN STD_LOGIC;
		funct 										: IN STD_LOGIC_VECTOR(1 DOWNTO 0);
		prod 											: IN STD_LOGIC_VECTOR(1 DOWNTO 0);
		Q, D, N										: IN STD_LOGic;
		change0, change1, change2				: OUT UNSIGNED(3 DOWNTO 0);
		runTotal0, runTotal1, runTotal2		: OUT UNSIGNED(3 DOWNTO 0);
		total0, total1, total2					: OUT UNSIGNED(3 DOWNTO 0));
END vendingMachine;

ARCHITECTURE Behaviour OF vendingMachine IS

COMPONENT SRAM IS
PORT (address : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
		clock	  : IN STD_LOGIC  := '1';
		data	  : IN STD_LOGIC_VECTOR (5 DOWNTO 0);
		rden	  : IN STD_LOGIC  := '1';
		wren	  : IN STD_LOGIC ;
		q		  : OUT STD_LOGIC_VECTOR (5 DOWNTO 0));
END COMPONENT;

COMPONENT toBCD IS
PORT (binaryIn : IN UNSIGNED(7 DOWNTO 0);
		decimal0	: OUT UNSIGNED(3 DOWNTO 0);
		decimal1	: OUT UNSIGNED(3 DOWNTO 0);
		decimal2	: OUT UNSIGNED(3 DOWNTO 0));
END COMPONENT;

COMPONENT programmingUnit IS
PORT (clock, reset, set, enable : IN STD_LOGIC;
		product						  : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
		QDN							  : IN STD_LOGic_VECTOR(2 DOWNTO 0);
		writeEnable					  : OUT STD_LOGIC;
		address						  : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
		data				           : OUT UNSIGNED(5 DOWNTO 0);
		done							  : OUT STD_LOGIC);
END COMPONENT;

COMPONENT vendingUnit IS
PORT (clock, reset, enable : IN STD_LOGIC;
		price						: IN UNSIGNED(5 DOWNTO 0);
		QDN						: IN STD_LOGic_VECTOR(2 DOWNTO 0);
		totalInserted,change	: OUT UNSIGNED(5 DOWNTO 0);
		done						: OUT STD_LOGIC);
END COMPONENT;

COMPONENT freeUnit IS
PORT (clock, enable : IN STD_LOGIC;
		price			  : IN UNSIGNED(5 DOWNTO 0);
		QDN			  : IN STD_LOGic_VECTOR(2 DOWNTO 0);
		totalInserted : OUT UNSIGNED(5 DOWNTO 0);
		change		  : OUT UNSIGNED(5 DOWNTO 0);
		done			  : OUT STD_LOGIC);
END COMPONENT;

SIGNAL state : STD_LOGIC_VECTOR(2 DOWNTO 0) := "000";	-- the current state of the FSM (0 - Idle, 1 - Programming, 2 - Display, 3 - Vending,  4 - Free, 5 - Hard Reset)
SIGNAL programmingEnable, vendingEnable, freeEnable : STD_LOGIC := '0';	-- enables for the various components
SIGNAL allDone : STD_LOGIC := '0';							-- whether or not the current process is finished

SIGNAL currentPrice 			 : UNSIGNED(5 DOWNTO 0);				-- contains the system price (a quarter is 5) of the currently selected product
SIGNAL currentPriceSTD  	 : STD_LOGIC_VECTOR(5 DOWNTO 0);		-- used for conversion from sram

SIGNAL currentPriceReal 	 : UNSIGNED(8 DOWNTO 0);				-- stores the real price (a quarter is 25) of *various things*
SIGNAL changeOutReal			 : UNSIGNED(8 DOWNTO 0);				-- must be 8 DOWNTO 0 because 5*(6-bit num) -> 9-bit num
SIGNAL totalInsertedOutReal : UNSIGNED(8 DOWNTO 0);				-- of course, since we only represent values up to 255, we can trim off the msb after the fact

-- programming unit
SIGNAL dataOut : UNSIGNED(5 DOWNTO 0);
SIGNAL addressOut : STD_LOGIC_VECTOR(1 DOWNTO 0);
SIGNAL writeEnableOut : STD_LOGIC := '0';
SIGNAL programmingDone : STD_LOGIC := '0';
 
-- display unit
SIGNAL displayOut0, displayOut1, displayOut2 : UNSIGNED(3 DOWNTO 0);

-- vending unit
SIGNAL totalInsertedOut, changeOut : UNSIGNED(5 DOWNTO 0);
SIGNAL vendingDone : STD_LOGIC := '0';
SIGNAL changeOut0, changeOut1, changeOut2 		: UNSIGNED(3 DOWNTO 0);
SIGNAL runTotalOut0, runTotalOut1, runTotalOut2 : UNSIGNED(3 DOWNTO 0);

-- free unit
SIGNAL totalInsertedFree, changeFree : UNSIGNED(5 DOWNTO 0);
SIGNAL freeDone : STD_LOGIC := '0';

BEGIN

	PROCESS(clock) IS												-- this process is only for switching states
	BEGIN
		IF (reset = '1') THEN									-- on soft reset, reset is passed to all components
			state <= "000";										-- in addition, the VMC state is set to idle
		ELSIF rising_edge(clock) THEN
			IF (hardReset = '1') THEN
				-- do hard reset stuff
			ELSIF (allDone = '1') THEN							-- if the current process is done, set state to idle
				state <= "000";
			ELSIF (start = '1' AND state = "000") THEN	-- if the VMC is in the idle state and start is asserted
				IF (funct = "00") THEN							-- change state based on funct
					state <= "001";
				ELSIF (funct = "01") THEN
					state <= "010";
				ELSIF (funct = "10") THEN
					state <= "011";
				ELSIF (funct = "11") THEN
					state <= "100";
				END IF;
			END IF;
		END IF;
	END PROCESS;
	
	PROCESS(clock) IS
	BEGIN
		IF rising_edge(clock) THEN
			IF (state = "000") THEN			-- in idle state, ensure nothing is enabled
				programmingEnable <= '0';
				vendingEnable <= '0';
				freeEnable <= '0';
				
				change0 <= "0000";			-- set all outputs to 0
				change1 <= "0000";
				change2 <= "0000";
				runTotal0 <= "0000";
				runTotal1 <= "0000";
				runTotal2 <= "0000";
				total0 <= "0000";
				total1 <= "0000";
				total2 <= "0000";
			ELSIF (state = "001") THEN
				programmingEnable <= '1';	-- in programming state, enable programming
													-- since the outputs are not modified by the programming state, they are all still 0
			ELSIF (state = "010") THEN
				total0 <= displayOut0;		-- in display state, output price of the currently selected product
				total1 <= displayOut1;
				total2 <= displayOut2;
			ELSIF (state = "011") THEN
				vendingEnable <= '1';		-- in vending state, enable vending
				
				change0 <= changeOut0;		-- connect all outputs to vending unit
				change1 <= changeOut1;
				change2 <= changeOut2;
				runTotal0 <= runTotalOut0;
				runTotal1 <= runTotalOut1;
				runTotal2 <= runTotalOut2;
				total0 <= displayOut0;
				total1 <= displayOut1;
				total2 <= displayOut2;
			ELSIF (state = "100") THEN
				freeEnable <= '1';			-- in free state, enable free vending
				
				change0 <= "ZZZZ";			-- connect all outputs to free unit
				change1 <= "ZZZZ";			-- (the 'Z's output are likely not safe in the BCD, so they're set manually here)
				change2 <= "ZZZZ";
				runTotal0 <= "ZZZZ";
				runTotal1 <= "ZZZZ";
				runTotal2 <= "ZZZZ";
				total0 <= "ZZZZ";
				total1 <= "ZZZZ";
				total2 <= "ZZZZ";
			END IF;
		END IF;
	END PROCESS;
	
	-- set the allDone signal based on whether the unit running is done or not
	allDone <= '1' when (programmingDone = '1' AND state = "001") OR (vendingDone = '1' AND state = "010") OR (freeDone = '1' AND state = "100") else
				  '0';
	
	currentPrice <= unsigned(currentPriceSTD);	-- convert currentPrice from STD_LOGIC_VECTOR to UNSIGNED
	
	currentPriceReal <= "101"*(currentPrice);
	changeOutReal <= "101"*(changeOut);
	totalInsertedOutReal <= "101"*(totalInsertedOut);
	
	-- SRAM unit
	SRAM_0 : SRAM PORT MAP(clock => clock, address => prod, wren => writeEnableOut,
								  data => std_logic_vector(dataOut), q => currentPriceSTD);
	
	-- BCD unit for display
	toBCD_0 : toBCD PORT MAP(binaryIn => currentPriceReal(7 DOWNTO 0),
									 decimal0 => displayOut0, decimal1 => displayOut1, decimal2 => displayOut2);
	-- BCD units for vending
	toBCD_1 : toBCD PORT MAP(binaryIn => changeOutReal(7 DOWNTO 0),
									 decimal0 => changeOut0, decimal1 => changeOut1, decimal2 => changeOut2);
									 
	toBCD_2 : toBCD PORT MAP(binaryIn => totalInsertedOutReal(7 DOWNTO 0),
									 decimal0 => runTotalOut0, decimal1 => runTotalOut1, decimal2 => runTotalOut2);
	
	-- Programming unit
	programmingUnit_0 : programmingUnit PORT MAP(clock => clock, reset => reset, set => set, enable => programmingEnable,
																product => prod, QDN => std_logic_vector'(Q & D & N), writeEnable => writeEnableOut,
																address => addressOut, data => dataOut, done => programmingDone);
	-- Vending unit
	vendingUnit_0 : vendingUnit PORT MAP(clock => clock, reset => reset, enable => vendingEnable,
													 price => currentPrice, QDN => std_logic_vector'(Q & D & N),
													 totalInserted => totalInsertedOut, change => changeOut, done => vendingDone);
	-- Free unit
	freeUnit_0 : freeUnit PORT MAP(clock => clock, enable => freeEnable,
											 price => currentPrice, QDN => std_logic_vector'(Q & D & N),
											 totalInserted => totalInsertedFree, change => changeFree, done => freeDone);

END Behaviour;