ENTITY accumulator IS
PORT (clock, reset, enable : IN STD_LOGIC;
		N, D, Q					: IN STD_LOGic;
		count						: OUT UNSIGNED(5 DOWNTO 0));
END accumulator;

ARCHITECTURE Behaviour OF accumulator IS

SIGNAL internalCount : UNSIGNED(5 DOWNTO 0);

BEGIN

	PROCESS(clk)
	BEGIN
		IF (rising_edge(clk) AND enable) THEN	-- if enable is set, on rising edge,
			internalCount <= internalCount + 1;	-- increment internal count by 1
		ELSIF (rising_edge(clk) THEN				-- if enable is not set, on rising edge,
			count <= internalCount;					-- output count
	END PROCESS;

	PROCESS(reset)						-- on reset (asserted after count is output for one clock cycle)
	BEGIN
		IF (reset = '1') THEN		-- if reset is true (ie, don't activate when reset changes to false)
			internalCount <= 0;		-- reset internal count
	END PROCESS;
	
END Behaviour;
		