LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE Ieee.numeric_std.all;


ENTITY tb_vendingUnit IS
END tb_vendingUnit;

ARCHITECTURE Simulation of tb_vendingUnit IS

COMPONENT vendingUnit IS
PORT (clock, reset, enable : IN STD_LOGIC;
		price						: IN UNSIGNED(5 DOWNTO 0);
		QDN						: IN STD_LOGic_VECTOR(2 DOWNTO 0);
		totalInserted, change: OUT UNSIGNED(5 DOWNTO 0);
		done						: OUT STD_LOGIC);
END COMPONENT;

SIGNAL clkSig, resetSig, enableSig : STD_LOGIC;
SIGNAL priceSig			  		 	  : UNSIGNED(5 DOWNTO 0);
SIGNAL QDNSig							  : STD_LOGic_VECTOR(2 DOWNTO 0);
SIGNAL totalInsertedSig, changeSig : UNSIGNED(5 DOWNTO 0);
SIGNAL doneSig							  : STD_LOGIC;

BEGIN

	DUT : vendingUnit
	PORT MAP(clock => clkSig, reset => resetSig, enable => enableSig,
				price => priceSig, QDN => QDNSig, done => doneSig,
				totalInserted => totalInsertedSig, change => changeSig);

	PROCESS IS
	BEGIN
		clkSig <= '0';wait for 5 ns;
		priceSig <= "001001";QDNSig <= "100";wait for 5 ns;
		
		clkSig <= '1';wait for 10 ns;clkSig <= '0';wait for 5 ns;
		enableSig <= '1';wait for 5 ns;
		
		clkSig <= '1';wait for 10 ns;clkSig <= '0';wait for 5 ns;
		QDNSig <= "010";wait for 5 ns;
		
		clkSig <= '1';wait for 10 ns;clkSig <= '0';wait for 5 ns;
		QDNSig <= "111";wait for 5 ns;
		
		clkSig <= '1';wait for 10 ns;clkSig <= '0';wait for 5 ns;
		wait for 5 ns;
		
		clkSig <= '1';wait for 10 ns;clkSig <= '0';wait for 5 ns;
		wait for 5 ns;
		
		clkSig <= '1';wait for 10 ns;clkSig <= '0';wait	for 5 ns;
		QDNSig <= "000";wait for 5 ns;
		
		clkSig <= '1';wait for 10 ns;clkSig <= '0';wait for 5 ns;
		wait for 5 ns;
		
		clkSig <= '1';wait for 10 ns;clkSig <= '0';wait for 5 ns;
		enableSig <= '0';wait for 5 ns;
		
		clkSig <= '1';wait for 10 ns;clkSig <= '0';wait for 5 ns;
		wait for 5 ns;
		
		clkSig <= '1';wait for 10 ns;clkSig <= '0';wait for 5 ns;
		wait for 5 ns;
		
		WAIT;
		
	END PROCESS;
END Simulation;

