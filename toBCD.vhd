LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE Ieee.numeric_std.all;


ENTITY toBCD IS
PORT (binaryIn 	  : IN UNSIGNED(7 DOWNTO 0);
		decimal0		  : OUT UNSIGNED(3 DOWNTO 0);
		decimal1		  : OUT UNSIGNED(3 DOWNTO 0);
		decimal2		  : OUT UNSIGNED(3 DOWNTO 0));
END toBCD;

ARCHITECTURE Behaviour OF toBCD IS

COMPONENT add3 IS
PORT (A0,A1,A2,A3 : IN STD_LOGIC;
		S0,S1,S2,S3 : OUT STD_LOGIC);
END COMPONENT;

SIGNAL add3Out_0, add3Out_1, add3Out_2, add3Out_3, add3Out_4 : UNSIGNED(3 DOWNTO 0);

BEGIN

add3_0 : add3 PORT MAP(A0 => binaryIn(5), A1 => binaryIn(6), A2 => binaryIn(7), A3 => '0',
							  S0 => add3Out_0(0), S1 => add3Out_0(1), S2 => add3Out_0(2), S3 => add3Out_0(3));
							  
add3_1 : add3 PORT MAP(A0 => binaryIn(4), A1 => add3Out_0(0), A2 => add3Out_0(1), A3 => add3Out_0(2),
							  S0 => add3Out_1(0), S1 => add3Out_1(1), S2 => add3Out_1(2), S3 => add3Out_1(3));
							  
add3_2 : add3 PORT MAP(A0 => binaryIn(3), A1 => add3Out_1(1), A2 => add3Out_1(2), A3 => add3Out_1(3),
							  S0 => add3Out_2(0), S1 => add3Out_2(1), S2 => add3Out_2(2), S3 => add3Out_2(3));
							  
add3_3 : add3 PORT MAP(A0 => binaryIn(2), A1 => add3Out_2(0), A2 => add3Out_2(1), A3 => add3Out_2(3),
							  S0 => add3Out_3(0), S1 => add3Out_3(1), S2 => add3Out_3(2), S3 => add3Out_3(3));
							  
add3_4 : add3 PORT MAP(A0 => add3Out_2(3), A1 => add3Out_1(3), A2 => add3Out_0(3), A3 => '0',
							  S0 => add3Out_4(0), S1 => add3Out_4(1), S2 => add3Out_4(2), S3 => add3Out_4(3));
							  
add3_5 : add3 PORT MAP(A0 => add3Out_2(1), A1 => add3Out_3(0), A2 => add3Out_3(1), A3 => add3Out_3(2),
							  S0 => decimal0(1), S1 => decimal0(2), S2 => decimal0(3), S3 => decimal1(0));
							  
add3_6 : add3 PORT MAP(A0 => add3Out_3(3), A1 => add3Out_4(0), A2 => add3Out_4(1), A3 => add3Out_4(2),
							  S0 => decimal1(1), S1 => decimal1(2), S2 => decimal1(3), S3 => decimal2(0));

decimal0(0) <= binaryIn(0);

decimal2(1) <= add3Out_4(3);
decimal2(2) <= '0';
decimal2(3) <= '0';

END Behaviour;