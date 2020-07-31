LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE Ieee.numeric_std.all;


ENTITY tb_programmingUnit IS
END tb_programmingUnit;

ARCHITECTURE Simulation of tb_programmingUnit IS

COMPONENT programmingUnit IS
PORT (clock, reset, set, enable : IN STD_LOGIC;
		product						  : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
		QDN							  : IN STD_LOGic_VECTOR(2 DOWNTO 0);
		writeEnable					  : OUT STD_LOGIC;
		address						  : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
		data				           : OUT UNSIGNED(5 DOWNTO 0);
		done							  : OUT STD_LOGIC);
END COMPONENT;

SIGNAL clkSig, resetSig, setSig, enableSig : STD_LOGIC;
SIGNAL productSig, addressSig			  		 : STD_LOGIC_VECTOR(1 DOWNTO 0);
SIGNAL QDNSig							  			 : STD_LOGic_VECTOR(2 DOWNTO 0);
SIGNAL writeEnableSig							 : STD_LOGIC;
SIGNAL dataSig									    : UNSIGNED(5 DOWNTO 0);
SIGNAL doneSig										 : STD_LOGIC;

BEGIN

	DUT : programmingUnit
	PORT MAP(clock => clkSig, reset => resetSig, set => setSig, enable => enableSig,
				product => productSig, address => addressSig, QDN => QDNSig,
				writeEnable => writeEnableSig, data => dataSig, done => doneSig);

	PROCESS IS
	BEGIN
		clkSig <= '0';wait for 5 ns;
		wait for 5 ns;
		
		clkSig <= '1';wait for 10 ns;clkSig <= '0';wait for 5 ns;
		enableSig <= '1';productSig <= "10";wait for 5 ns;
		
		clkSig <= '1';wait for 10 ns;clkSig <= '0';wait for 5 ns;
		QDNSig <= "101";wait for 5 ns;
		
		clkSig <= '1';wait for 10 ns;clkSig <= '0';wait for 5 ns;
		QDNSig <= "001";wait for 5 ns;
		
		clkSig <= '1';wait for 10 ns;clkSig <= '0';wait for 5 ns;
		resetSig <= '0';QDNSig <= "011";wait for 5 ns;					-- to test reset, set to '1', else, set to '0'
		
		clkSig <= '1';wait for 10 ns;clkSig <= '0';wait for 5 ns;
		resetSig <= '0';QDNSig <= "100";wait for 5 ns;
		
		clkSig <= '1';wait for 10 ns;clkSig <= '0';wait	for 5 ns;
		QDNSig <= "010";wait for 5 ns;
		
		clkSig <= '1';wait for 10 ns;clkSig <= '0';wait for 5 ns;
		setSig <= '1';QDNSig <= "000";wait for 5 ns;
		
		clkSig <= '1';wait for 10 ns;clkSig <= '0';wait for 5 ns;
		setSig <= '0';wait for 5 ns;
		
		clkSig <= '1';wait for 10 ns;clkSig <= '0';wait for 5 ns;
		wait for 5 ns;
		
		clkSig <= '1';wait for 10 ns;clkSig <= '0';wait for 5 ns;
		enableSig <= '0';wait for 5 ns;
		
		WAIT;
		
	END PROCESS;
END Simulation;

