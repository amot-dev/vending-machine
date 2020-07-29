LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE Ieee.numeric_std.all;


ENTITY tb_accumulator IS
END tb_accumulator;

ARCHITECTURE Simulation of tb_accumulator IS

COMPONENT accumulator IS
PORT (clock, reset, enable : IN STD_LOGIC;
		Q, D, N					: IN STD_LOGic;
		count						: OUT UNSIGNED(5 DOWNTO 0));
END COMPONENT;

SIGNAL clockSig, resetSig, enableSig : STD_LOGIC;
SIGNAL QSig, DSig, NSig					 : STD_LOGIC;
SIGNAL countSig							 : UNSIGNED(5 DOWNTO 0);

BEGIN

	DUT : accumulator
	PORT MAP(clock => clockSig, reset => resetSig, enable => enableSig,
				Q => QSig, D => DSig, N => NSig, count => countSig);

	PROCESS IS
	BEGIN
		clkSig <= '0';wait for 10 ns;
		QSig <= '1';
		
		clkSig <= '1';wait for 10 ns;clkSig <= '0';wait for 10 ns;
		QSig <= '0';
		enableSig <= '1';
		
		clkSig <= '1';wait for 10 ns;clkSig <= '0';wait for 10 ns;
		QSig <= '1';DSig <= '1';NSig <= '1';
		
		clkSig <= '1';wait for 10 ns;clkSig <= '0';wait for 10 ns;
		QSig <= '0';DSig <= '1';NSig <= '1';
		
		clkSig <= '1';wait for 10 ns;clkSig <= '0';wait for 10 ns;
		QSig <= '0';DSig <= '0';NSig <= '1';
		
		clkSig <= '1';wait for 10 ns;clkSig <= '0';wait for 10 ns;
		QSig <= '1';DSig <= '0';NSig <= '1';
		
		clkSig <= '1';wait for 10 ns;clkSig <= '0';wait for 10 ns;
		enableSig <= '0';
		WAIT;
		
	END PROCESS;
END Simulation;

