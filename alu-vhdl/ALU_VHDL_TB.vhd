--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   22:05:43 02/01/2016
-- Design Name:   
-- Module Name:   H:/ENGG3050/ALU_VHDL/ALU_VHDL_TB.vhd
-- Project Name:  ALU_VHDL
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: alu_VHDL_4bit
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY ALU_VHDL_TB IS
END ALU_VHDL_TB;
 
ARCHITECTURE behavior OF ALU_VHDL_TB IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT alu_VHDL_4bit
    PORT(
         a : IN  std_logic_vector(3 downto 0);
         b : IN  std_logic_vector(3 downto 0);
         SEL : IN  std_logic_vector(2 downto 0);
         ci : IN  std_logic;
         co : OUT  std_logic;
         S : OUT  std_logic_vector(3 downto 0);
         SS : OUT  std_logic_vector(6 downto 0);
         Aout : OUT  std_logic_vector(3 downto 0);
         Bout : OUT  std_logic_vector(3 downto 0);
         POS : OUT  std_logic_vector(3 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal a : std_logic_vector(3 downto 0) := (others => '0');
   signal b : std_logic_vector(3 downto 0) := (others => '0');
   signal SEL : std_logic_vector(2 downto 0) := (others => '0');
   signal ci : std_logic := '0';

 	--Outputs
   signal co : std_logic;
   signal S : std_logic_vector(3 downto 0);
   signal SS : std_logic_vector(6 downto 0);
   signal Aout : std_logic_vector(3 downto 0);
   signal Bout : std_logic_vector(3 downto 0);
   signal POS : std_logic_vector(3 downto 0);
   -- No clocks detected in port list. Replace <clock> below with 
   -- appropriate port name 
 
   constant period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: alu_VHDL_4bit PORT MAP (
          a => a,
          b => b,
          SEL => SEL,
          ci => ci,
          co => co,
          S => S,
          SS => SS,
          Aout => Aout,
          Bout => Bout,
          POS => POS
        );

  
   -- Stimulus process
   stim_proc: process
   begin		
      wait for period;	
		
		a(3) <= '0'; -- 6
		a(2) <= '1';
		a(1) <= '1';
		a(0) <= '0';
		
		b(3) <= '0'; -- 4
		b(2) <= '1';
		b(1) <= '0';
		b(0) <= '0';

		-- operations 0 - 4

		SEL(0) <= '0'; --OPERATION: a + b
		SEL(0) <= '0';
		SEL(0) <= '0';
		ci     <= '0';

      wait for period;


      wait;
   end process;

END;
