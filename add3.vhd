LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE Ieee.numeric_std.all;


ENTITY add3 IS
PORT (A0,A1,A2,A3 : IN STD_LOGIC;
		S0,S1,S2,S3 : OUT STD_LOGIC);
END add3;

ARCHITECTURE Behaviour OF add3 IS

SIGNAL uIn, uOut : UNSIGNED(3 DOWNTO 0);

BEGIN

uIn <= unsigned'(A3 & A2 & A1 & A0);
uOut <= UIn when UIn < 5 else
		  UIn + 3 when UIn < 16 else
		  "0000";

S0 <= uOut(0);
S1 <= uOut(1);
S2 <= uOut(2);
S3 <= uOut(3);

END Behaviour;