ENTITY vendingUnit IS
PORT (clock, reset, enable : IN STD_LOGIC;
		product					: IN STD_LOGIC_VECTOR(1 DOWNTO 0);
		QDN						: IN STD_LOGic_VECTOR(2 DOWNTO 0);
		totalInserted			: OUT UNSIGNED(5 DOWNTO 0);
		change					: OUT UNSIGNED(5 DOWNTO 0);
		done						: OUT STD_LOGIC);
END vendingUnit;

ARCHITECTURE Behaviour OF vendingUnit IS

BEGIN

	PROCESS(clock)
	BEGIN
		
	END PROCESS;

END Behaviour;