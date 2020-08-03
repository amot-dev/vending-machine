LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE Ieee.numeric_std.all;


ENTITY tb_toBCD IS
END tb_toBCD;

ARCHITECTURE Simulation OF tb_toBCD IS

COMPONENT toBCD IS
PORT (binaryIn 	  : IN UNSIGNED(7 DOWNTO 0);
		decimal0		  : OUT UNSIGNED(3 DOWNTO 0);
		decimal1		  : OUT UNSIGNED(3 DOWNTO 0);
		decimal2		  : OUT UNSIGNED(3 DOWNTO 0));
END COMPONENT;

SIGNAL binaryInSig : UNSIGNED(7 DOWNTO 0);
SIGNAL decimal0Sig, decimal1Sig, decimal2Sig : UNSIGNED(3 DOWNTO 0);

BEGIN
DUT : toBCD
PORT MAP(binaryIn => binaryInSig, decimal0 => decimal0Sig, decimal1 => decimal1Sig, decimal2 => decimal2Sig);

PROCESS IS
BEGIN

binaryInSig <= "00000000";wait for 10 ns;
binaryInSig <= "00000001";wait for 10 ns;
binaryInSig <= "00000010";wait for 10 ns;
binaryInSig <= "00000011";wait for 10 ns;
binaryInSig <= "00000100";wait for 10 ns;
binaryInSig <= "00000101";wait for 10 ns;
binaryInSig <= "00000110";wait for 10 ns;
binaryInSig <= "00000111";wait for 10 ns;
binaryInSig <= "00001000";wait for 10 ns;
binaryInSig <= "00001001";wait for 10 ns;
binaryInSig <= "00001010";wait for 10 ns;
binaryInSig <= "00001011";wait for 10 ns;
binaryInSig <= "00001100";wait for 10 ns;
binaryInSig <= "00001101";wait for 10 ns;
binaryInSig <= "00001110";wait for 10 ns;
binaryInSig <= "00001111";wait for 10 ns;
binaryInSig <= "00010000";wait for 10 ns;
binaryInSig <= "00010001";wait for 10 ns;
binaryInSig <= "00010010";wait for 10 ns;
binaryInSig <= "00010011";wait for 10 ns;
binaryInSig <= "00010100";wait for 10 ns;
binaryInSig <= "00010101";wait for 10 ns;
binaryInSig <= "00010110";wait for 10 ns;
binaryInSig <= "00010111";wait for 10 ns;
binaryInSig <= "00011000";wait for 10 ns;
binaryInSig <= "00011001";wait for 10 ns;
binaryInSig <= "00011010";wait for 10 ns;
binaryInSig <= "00011011";wait for 10 ns;
binaryInSig <= "00011100";wait for 10 ns;
binaryInSig <= "00011101";wait for 10 ns;
binaryInSig <= "00011110";wait for 10 ns;
binaryInSig <= "00011111";wait for 10 ns;
binaryInSig <= "00100000";wait for 10 ns;
binaryInSig <= "00100001";wait for 10 ns;
binaryInSig <= "00100010";wait for 10 ns;
binaryInSig <= "00100011";wait for 10 ns;
binaryInSig <= "00100100";wait for 10 ns;
binaryInSig <= "00100101";wait for 10 ns;
binaryInSig <= "00100110";wait for 10 ns;
binaryInSig <= "00100111";wait for 10 ns;
binaryInSig <= "00101000";wait for 10 ns;
binaryInSig <= "00101001";wait for 10 ns;
binaryInSig <= "00101010";wait for 10 ns;
binaryInSig <= "00101011";wait for 10 ns;
binaryInSig <= "00101100";wait for 10 ns;
binaryInSig <= "00101101";wait for 10 ns;
binaryInSig <= "00101110";wait for 10 ns;
binaryInSig <= "00101111";wait for 10 ns;
binaryInSig <= "00110000";wait for 10 ns;
binaryInSig <= "00110001";wait for 10 ns;
binaryInSig <= "00110010";wait for 10 ns;
binaryInSig <= "00110011";wait for 10 ns;
binaryInSig <= "00110100";wait for 10 ns;
binaryInSig <= "00110101";wait for 10 ns;
binaryInSig <= "00110110";wait for 10 ns;
binaryInSig <= "00110111";wait for 10 ns;
binaryInSig <= "00111000";wait for 10 ns;
binaryInSig <= "00111001";wait for 10 ns;
binaryInSig <= "00111010";wait for 10 ns;
binaryInSig <= "00111011";wait for 10 ns;
binaryInSig <= "00111100";wait for 10 ns;
binaryInSig <= "00111101";wait for 10 ns;
binaryInSig <= "00111110";wait for 10 ns;
binaryInSig <= "00111111";wait for 10 ns;

WAIT;

END PROCESS;
END Simulation;