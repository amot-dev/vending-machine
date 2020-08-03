LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;


ENTITY tb_add3 IS
END tb_add3;

ARCHITECTURE Simulation OF tb_add3 IS

COMPONENT add3 IS
PORT (A0,A1,A2,A3 : IN STD_LOGIC;
		S0,S1,S2,S3 : OUT STD_LOGIC);
END COMPONENT;

SIGNAL A0Sig,A1Sig,A2Sig,A3Sig : STD_LOGIC;
SIGNAL S0Sig,S1Sig,S2Sig,S3Sig : STD_LOGIC;

BEGIN
DUT : add3
PORT MAP(A0 => A0Sig, A1 => A1Sig, A2 => A2Sig, A3 => A3Sig,
			S0 => S0Sig, S1 => S1Sig, S2 => S2Sig, S3 => S3Sig);

-- apply stimulus with 20ns delays
PROCESS IS
BEGIN

A3Sig <= '0';A2Sig <= '0';A1Sig <= '0';A0Sig <= '0';wait for 20 ns;
A3Sig <= '0';A2Sig <= '0';A1Sig <= '0';A0Sig <= '1';wait for 20 ns;
A3Sig <= '0';A2Sig <= '0';A1Sig <= '1';A0Sig <= '0';wait for 20 ns;
A3Sig <= '0';A2Sig <= '0';A1Sig <= '1';A0Sig <= '1';wait for 20 ns;
A3Sig <= '0';A2Sig <= '1';A1Sig <= '0';A0Sig <= '0';wait for 20 ns;
A3Sig <= '0';A2Sig <= '1';A1Sig <= '0';A0Sig <= '1';wait for 20 ns;
A3Sig <= '0';A2Sig <= '1';A1Sig <= '1';A0Sig <= '0';wait for 20 ns;
A3Sig <= '0';A2Sig <= '1';A1Sig <= '1';A0Sig <= '1';wait for 20 ns;
A3Sig <= '1';A2Sig <= '0';A1Sig <= '0';A0Sig <= '0';wait for 20 ns;
A3Sig <= '1';A2Sig <= '0';A1Sig <= '0';A0Sig <= '1';wait for 20 ns;
A3Sig <= '1';A2Sig <= '0';A1Sig <= '1';A0Sig <= '0';wait for 20 ns;
A3Sig <= '1';A2Sig <= '0';A1Sig <= '1';A0Sig <= '1';wait for 20 ns;
A3Sig <= '1';A2Sig <= '1';A1Sig <= '0';A0Sig <= '0';wait for 20 ns;
A3Sig <= '1';A2Sig <= '1';A1Sig <= '0';A0Sig <= '1';wait for 20 ns;
A3Sig <= '1';A2Sig <= '1';A1Sig <= '1';A0Sig <= '0';wait for 20 ns;
A3Sig <= '1';A2Sig <= '1';A1Sig <= '1';A0Sig <= '1';wait for 20 ns;

WAIT;

END PROCESS;
END Simulation;