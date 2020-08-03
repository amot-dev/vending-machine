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
	PORT
	(
		address		: IN STD_LOGIC_VECTOR (1 DOWNTO 0);
		clock		: IN STD_LOGIC  := '1';
		data		: IN STD_LOGIC_VECTOR (5 DOWNTO 0);
		rden		: IN STD_LOGIC  := '1';
		wren		: IN STD_LOGIC ;
		q		: OUT STD_LOGIC_VECTOR (5 DOWNTO 0)
	);
END COMPONENT;

COMPONENT toBCD IS
PORT (binaryIn 	  : IN UNSIGNED(7 DOWNTO 0);
		decimal0		  : OUT UNSIGNED(3 DOWNTO 0);
		decimal1		  : OUT UNSIGNED(3 DOWNTO 0);
		decimal2		  : OUT UNSIGNED(3 DOWNTO 0));
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
SIGNAL allDone : STD_LOGIC;									-- whether or not the current process is finished

BEGIN

	PROCESS(clk) IS												-- this process is only for switching states
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
				ELSIF (funct = "01" THEN
					state <= "010";
				ELSIF (funct = "10" THEN
					state <= "011";
				ELSIF (funct = "11" THEN
					state <= "100";
				END IF;
			END IF;
		END IF;
	END PROCESS;

END Behaviour;