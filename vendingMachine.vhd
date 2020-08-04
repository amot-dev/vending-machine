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

SIGNAL currentPrice : UNSIGNED(5 DOWNTO 0);				-- contains the price of the currently selected product
SIGNAL currentPriceSTD : STD_LOGIC_VECTOR(5 DOWNTO 0);-- used for conversion from sram

-- outputs from programming unit
SIGNAL dataOut : UNSIGNED(5 DOWNTO 0);
SIGNAL addressOut : STD_LOGIC_VECTOR(1 DOWNTO 0);
SIGNAL writeEnableOut : STD_LOGIC := '0';
SIGNAL programmingDone : STD_LOGIC := '0';

-- outputs from vending unit
SIGNAL totalInsertedOut, changeOut : UNSIGNED(5 DOWNTO 0);
SIGNAL vendingDone : STD_LOGIC := '0';

--outputs from free unit
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
			ELSIF (state = "001") THEN
				programmingEnable <= '1';	-- in programming state, enable programming
			ELSIF (state = "010") THEN
				-- do display stuff
			ELSIF (state = "011") THEN
				vendingEnable <= '1';
			ELSIF (state = "100") THEN
				-- do free stuff
			END IF;
		END IF;
	END PROCESS;
	
	allDone <= '1' when (programmingDone = '1' AND state = "001") OR (vendingDone = '1' AND state = "010") OR (freeDone = '1' AND state = "100") else
				  '0';
				  
	currentPrice <= unsigned(currentPriceSTD);	-- convert current price from STD_LOGIC_VECTOR to UNSIGNED
	
	SRAM_0 : SRAM PORT MAP(clock => clock, address => prod, wren => writeEnableOut,
								  data => std_logic_vector(dataOut), q => currentPriceSTD);
	
	programmingUnit_0 : programmingUnit PORT MAP(clock => clock, reset => reset, set => set, enable => programmingEnable,
																product => prod, QDN => std_logic_vector'(Q & D & N), writeEnable => writeEnableOut,
																address => addressOut, data => dataOut, done => programmingDone);
	
	vendingUnit_0 : vendingUnit PORT MAP(clock => clock, reset => reset, enable => vendingEnable,
													 price => currentPrice, QDN => std_logic_vector'(Q & D & N),
													 totalInserted => totalInsertedOut, change => changeOut, done => vendingDone);
	
	freeUnit_0 : freeUnit PORT MAP(clock => clock, enable => freeEnable,
											 price => currentPrice, QDN => std_logic_vector'(Q & D & N),
											 totalInserted => totalInsertedFree, change => changeFree, done => freeDone);

END Behaviour;