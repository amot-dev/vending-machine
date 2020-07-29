ENTITY accumulator IS
PORT (clock, reset, enable : IN STD_LOGIC;
		Q, D, N					: IN STD_LOGic;
		count						: OUT UNSIGNED(5 DOWNTO 0));
END accumulator;

ARCHITECTURE Behaviour OF accumulator IS

SIGNAL internalCount : UNSIGNED(5 DOWNTO 0);

BEGIN

	PROCESS(clk)
	BEGIN
		IF (rising_edge(clk) AND enable) THEN	-- if enable is set, on rising edge,
			IF Q THEN
				internalCount <= internalCount + 5;	-- for a quarter, increment internal count by 5 (25 cents)
			ELSIF D THEN
				internalCount <= internalCount + 2;	-- for a dime, increment internal count by 2 (10 cents)
			ELSIF N THEN
				internalCount <= internalCount + 1;	-- for a nickel, increment internal count by 1 (5 cents)
		ELSIF (rising_edge(clk) THEN				-- if enable is not set, on rising edge,
			count <= internalCount;					-- output count
	END PROCESS;

	PROCESS(reset)						-- on reset (asserted after count is output for one clock cycle)
	BEGIN
		IF (reset = '1') THEN		-- if reset is true (ie, don't activate when reset changes to false)
			internalCount <= 0;		-- reset internal count
	END PROCESS;
	
END Behaviour;
		