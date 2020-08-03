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

BEGIN



END Behaviour;