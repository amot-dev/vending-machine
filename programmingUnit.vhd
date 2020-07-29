ENTITY programmingUnit IS
PORT (clock, reset, hardReset, set, enable, product : IN STD_LOGIC;
		QDN														 : IN STD_LOGic_VECTOR(2 DOWNTO 0);
		writeEnable												 : OUT STD_LOGIC;
		data, address											 : OUT UNSIGNED(5 DOWNTO 0));
END accumulator;

ARCHITECTURE Behaviour OF programmingUnit IS

BEGIN
END Behaviour;
