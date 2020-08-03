LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE Ieee.numeric_std.all;


ENTITY add3 IS
PORT (A0,A1,A2,A3   : IN STD_LOGIC;
		S0,S1,S2,S3   : OUT STD_LOGIC);
END add3;

ARCHITECTURE Behaviour OF add3 IS

SIGNAL uIn, uOut : UNSIGNED(3 DOWNTO 0);

BEGIN

--S3 <= A3 when unsigned'(A3 & A2 & A1 & A0) < 5 else
--		'1';
--
--S2 <= A2 when unsigned'(A3 & A2 & A1 & A0) < 5 else
--		(A3 AND A0);
--
--S1 <= A1 when unsigned'(A3 & A2 & A1 & A0) < 5 else
--		((A3 AND NOT A0) OR ())
--
--S0 <= A0 when unsigned'(A3 & A2 & A1 & A0) < 5 else
--		(NOT A0);

uIn <= unsigned'(A3 & A2 & A1 & A0);
uOut <= UIn when UIn < 5 else
		  UIn + 3 when UIn < 10 else
		  UIn;

S0 <= uOut(0);
S1 <= uOut(1);
S2 <= uOut(2);
S3 <= uOut(3);

END Behaviour;