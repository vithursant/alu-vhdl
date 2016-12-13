----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Graham Thoms
-- 
-- Create Date:    14:36:12 01/31/2016 
-- Design Name: 
-- Module Name:    alu_VHDL - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

-------------------------------------------------------------------
--									4 bit ALU
-------------------------------------------------------------------

entity alu_VHDL_4bit is 									-- entity for 4 bit ALU
	Port ( a : in STD_LOGIC_VECTOR(3 downto 0); 		-- input a
		    b : in STD_LOGIC_VECTOR(3 downto 0); 		-- input b
			 SEL:in STD_LOGIC_VECTOR(2 downto 0);
			 ci : in STD_LOGIC; 								-- carry in
			 co : out STD_LOGIC;								-- carry out
			 S : out STD_LOGIC_VECTOR(3 downto 0);
			 SS : out STD_LOGIC_VECTOR(6 downto 0);	-- 7 segment display output
			 Aout: out STD_LOGIC_VECTOR(3 downto 0); 	-- A output for leds
			 Bout: out STD_LOGIC_VECTOR(3 downto 0);	-- B output for leds
			 POS : out STD_LOGIC_VECTOR(3 downto 0)); 
end alu_VHDL_4bit;

architecture Behavioral of alu_VHDL_4bit is
	
	component alu_VHDL_1bit is
    Port ( A : in  STD_LOGIC;
           B : in  STD_LOGIC;
           S : out  STD_LOGIC;
           Cin : in  STD_LOGIC;
           Cout : out  STD_LOGIC;
			  sel : in STD_LOGIC_VECTOR (2 downto 0));
	end component;
	
	component SevenSeg is
		Port (	BCD : in STD_LOGIC_VECTOR(3 downto 0); -- Binary coded decimal input
					SevenSegDisplay : out STD_LOGIC_VECTOR(6 downto 0));
	end component;
	
	
	signal S_one, S_two, S_three, S_four: std_logic; 
	signal C_one, C_two, C_three, C_four: std_logic; 
	signal gout : STD_LOGIC_VECTOR(3 downto 0);

	begin 

	-- 4 x 1 bit ALUs cascaded through the carry-outs to the carry-ins

	G0: alu_VHDL_1bit port map (a(0), b(0), S_one, SEL(0), C_one, SEL); 
	G1: alu_VHDL_1bit port map (a(1), b(1), S_two, C_one, C_two, SEL); 
	G2: alu_VHDL_1bit port map (a(2), b(2), S_three, C_two,C_three, SEL); 
	G3: alu_VHDL_1bit port map (a(3), b(3), S_four, C_three,C_four, SEL); 

	-- Operands to LEDs

	Aout(0) <= a(0);
	Aout(1) <= a(1);
	Aout(2) <= a(2);
	Aout(3) <= a(3);
	Bout(0) <= b(0);
	Bout(1) <= b(1);
	Bout(2) <= b(2);
	Bout(3) <= b(3);

	-- 4 bit sum
	
	gout(0) <= S_one; 
	gout(1) <= S_two; 
	gout(2) <= S_three; 
	gout(3) <= S_four;
	co <= C_four;
	
	S(0) <= S_one; 
	S(1) <= S_two; 
	S(2) <= S_three; 
	S(3) <= S_four;
	
	-- seven segment display outputting 4 bit sum
	
	POS <= "1110";
	
	U1: SevenSeg port map (gout,SS);
	
end Behavioral;

-------------------------------------------------------------------
--									END 4 bit ALU
-------------------------------------------------------------------

-------------------------------------------------------------------
--									1 bit ALU
-------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity alu_VHDL_1bit is
    Port ( A : in  STD_LOGIC;
           B : in  STD_LOGIC;
           S : out  STD_LOGIC;
           Cin : in  STD_LOGIC;
           Cout : out  STD_LOGIC;
			  SEL : in STD_LOGIC_VECTOR (2 downto 0));
end alu_VHDL_1bit;

architecture Behavioral of alu_VHDL_1bit is

	component FullAdder is
		 Port ( x : in  STD_LOGIC;
				  y : in  STD_LOGIC;
				  g : out  STD_LOGIC;
				  ci : in  STD_LOGIC;
				  co : out  STD_LOGIC);
	end component;

	component Mux8to1 is
		 Port ( b0 : in  STD_LOGIC;
				  b1 : in  STD_LOGIC;
				  b2 : in  STD_LOGIC;
				  b3 : in  STD_LOGIC;
				  b4 : in  STD_LOGIC;
				  b5 : in  STD_LOGIC;
				  b6 : in  STD_LOGIC;
				  b7 : in  STD_LOGIC;
				  sel: in STD_LOGIC_VECTOR(2 downto 0);
				  dout : out  STD_LOGIC);
	end component; 

	signal S_s, Co_s, dout_s_a, dout_s_b, b_not_s,a_not_s,a_xos_s0_s : STD_LOGIC; 

	begin 

	b_not_s <= not B;
	a_not_s <= not A;

	-- connecting MUXs for inputs a and b to fulladder
	
	A0: Mux8to1 port map (A, A,not A,not A,A, A, not A, not A, Sel, dout_s_a); 
	B0: Mux8to1 port map (B, not B,B,B,'1', '0', '0', '0', Sel, dout_s_b);
	F0: FullAdder port map (dout_s_a, dout_s_b, S_s, Cin, Co_s);
	
	-- outputs of 1 bit ALU

	S <= S_s; 
	Cout <= Co_s;
	
end Behavioral;

-------------------------------------------------------------------
--									END 1 bit ALU
-------------------------------------------------------------------

-------------------------------------------------------------------
--									FULL ADDER
-------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity FullAdder is
    Port ( x : in  STD_LOGIC;						-- input x
           y : in  STD_LOGIC;						-- input y
           g : out  STD_LOGIC;					-- output g = x + y + ci
           ci : in  STD_LOGIC;					-- input ci (carry in)
           co : out  STD_LOGIC);					-- output co (carry out)
end FullAdder;

architecture dataflow of FullAdder is
	begin
	
	-- fulladder logic
	
	g <= ((x xor y) xor ci);						-- sum
	co <= ((x and y) or ((x xor y) and ci));		-- carry out
	
end dataflow;

-------------------------------------------------------------------
--									END FULL ADDER
-------------------------------------------------------------------

-------------------------------------------------------------------
--									8 to 1 MUX
-------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Mux8to1 is
    Port ( b0 : in  STD_LOGIC;				-- MUX inputs
	        b1 : in  STD_LOGIC;
			  b2 : in  STD_LOGIC;
			  b3 : in  STD_LOGIC;
			  b4 : in  STD_LOGIC;
			  b5 : in  STD_LOGIC;
			  b6 : in  STD_LOGIC;
			  b7 : in  STD_LOGIC;
           sel: in STD_LOGIC_VECTOR(2 downto 0); -- select lines
           dout : out  STD_LOGIC);			-- output
end Mux8to1;

architecture Behavioral of Mux8to1 is
	begin
	
	-- behaviour of 8 to 1 MUX
	
	dout <= 		b0 when (sel="000") 
				else
					b1 when (sel="001")
				else 
					b2 when (sel="010")
				else 
					b3 when (sel="011")
				else 
					b4 when (sel="100")
				else 
					b5 when (sel="101")
				else 
					b6 when (sel="110")
				else 
					b7;
end Behavioral;

-------------------------------------------------------------------
--									END 8 to 1 MUX
-------------------------------------------------------------------

-------------------------------------------------------------------
--									7 SEG DISPLAY
-------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity SevenSeg is
	Port (
		BCD : in STD_LOGIC_VECTOR(3 downto 0); 				-- Binary coded decimal input
		SevenSegDisplay : out STD_LOGIC_VECTOR(6 downto 0) -- 7 seg display output
	);
end SevenSeg;

architecture Behavioral of SevenSeg is

	begin

	process(BCD)
	BEGIN

	case BCD is -- input for the LCD Display, allows user to visually see the number on a screen
		when "0000"=> SevenSegDisplay <="0000001"; -- '0'
		when "0001"=> SevenSegDisplay <="1001111"; -- '1'
		when "0010"=> SevenSegDisplay <="0010010"; -- '2'
		when "0011"=> SevenSegDisplay <="0000110"; -- '3'
		when "0100"=> SevenSegDisplay <="1001100"; -- '4'
		when "0101"=> SevenSegDisplay <="0100100"; -- '5'
		when "0110"=> SevenSegDisplay <="0100000"; -- '6'
		when "0111"=> SevenSegDisplay <="0001111"; -- '7'
		when "1000"=> SevenSegDisplay <="0000000"; -- '8'
		when "1001"=> SevenSegDisplay <="0000100"; -- '9'
		when "1010"=> SevenSegDisplay <="0001000"; -- 'A'
		when "1011"=> SevenSegDisplay <="1100000"; -- 'b'
		when "1100"=> SevenSegDisplay <="0110001"; -- 'C'
		when "1101"=> SevenSegDisplay <="1000010"; -- 'd'
		when "1110"=> SevenSegDisplay <="0110000"; -- 'E'
		when "1111"=> SevenSegDisplay <="0111000"; -- 'F'
		when others => SevenSegDisplay <="1111111";-- ERROR
	end case;

end process;

end Behavioral;

-------------------------------------------------------------------
--									END 7 SEG DISPLAY
-------------------------------------------------------------------


