ENTITY freeUnit IS
PORT (clock, reset, enable : IN STD_LOGIC;
		product					: IN UNSIGNED(1 DOWNTO 0);
		QDN						: IN STD_LOGic_VECTOR(2 DOWNTO 0);
		totalInserted			: OUT UNSIGNED(5 DOWNTO 0);
		change					: OUT UNSIGNED(5 DOWNTO 0);
		done						: OUT STD_LOGIC);
END freeUnit;

ARCHITECTURE Behaviour OF freeUnit IS

BEGIN

	PROCESS(clk)
	BEGIN
		IF rising_edge(clk) THEN
			totalInsterted <= "ZZZZZZ";	-- as this unit dispenses products for free, set money-related outputs to floating
			change <= "ZZZZZZ";
			done <= '1';						-- dispense product
	END PROCESS;

END Behaviour;