LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE Ieee.numeric_std.all;


ENTITY vendingMachine IS
PORT (clock, reset, hard_reset, start, funct, prod, set : IN STD_LOGIC;
		Q, D, N														  : IN STD_LOGic;
		change0, change1, change2								  : OUT UNSIGNED(3 DOWNTO 0);
		runTotal0, runTotal1, runTotal2						  : OUT UNSIGNED(3 DOWNTO 0);
		total0, total1, total2									  : OUT UNSIGNED(3 DOWNTO 0));
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

BEGIN

END Behaviour;