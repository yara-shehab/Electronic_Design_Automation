-- Entity declaration for your testbench. Don't declare any ports here
ENTITY tb IS
END ENTITY tb;

ARCHITECTURE tba OF tb IS

-- Component Declaration for the Device Under Test (DUT)
component dac is
port  (
	clk    : in	bit;
	vdd   : in	bit;
	vss   : in	bit;
	code       : in bit_vector (3 downto 0);
	daytime     : in	bit;
        reset : in bit;
	door     : out	bit;
	alarm     : out	bit
      );
END component dac;
component fsmyaraa_b_l is
   port (
      clk     : in      bit;
      vdd     : in      bit;
      vss     : in      bit;
      code    : in      bit_vector(3 downto 0);
      daytime : in      bit;
      reset   : in      bit;
      door    : out     bit;
      alarm   : out     bit
 );
end fsmyaraa_b_l;

FOR dut: dac USE ENTITY WORK.dac (fsm);
FOR dut: fsmyaraa_b_l USE ENTITY WORK.fsmyaraa_b_l (structural);


-- Declare input signals and initialize them
SIGNAL clk    : bit := '0';
SIGNAL vdd   : bit := '1';
SIGNAL vss   : bit := '0';
SIGNAL code     : bit_vector (3 downto 0);
SIGNAL daytime    : bit := '0';
SIGNAL reset    : bit := '0';
SIGNAL door : bit := '0';
SIGNAL alarm   : bit := '0';
SIGNAL doorx : bit := '0';
SIGNAL alarmx   : bit := '0';


-- Constants and Clock period definitions
constant clk_period : time := 50 ns;
BEGIN

-- Instantiate the Device Under Test (DUT)
  dut: dac PORT MAP (clk, vdd, vss, code, daytime, reset, door, alarm);
  dut: fsmyaraa_b_l PORT MAP (clk, vdd, vss, code, daytime, reset, doorx, alarmx);

-- Clock process definitions
   clk_process :process
   begin
        clk <= '1';
        wait for clk_period/2;  
        clk <= '0';
        wait for clk_period/2;  
   end process;

-- Stimulus process, refer to clock signal
proc: PROCESS IS
BEGIN
	--test0
	reset<='1';
	WAIT FOR 50 ns;
	ASSERT door = doorx and alarm = alarmx
	REPORT "Error not 2"
	SEVERITY error;
	
	--test1
	reset <= '0'; code <= "0010" ; daytime <= '1'; 
	WAIT FOR 50 ns;
	ASSERT door = doorx and alarm = alarmx
	REPORT "Error not 2"
	SEVERITY error;

        code <= "0110" ; 
	WAIT FOR 50 ns;
	ASSERT door = doorx and alarm = alarmx
	REPORT "Error not 6"
	SEVERITY error;

        code <= "1010" ; 
	WAIT FOR 50 ns;
	ASSERT door = doorx and alarm = alarmx
	REPORT "Error not A"
	SEVERITY error;

        code <= "1101" ; 
	WAIT FOR 50 ns;
	ASSERT door = doorx and alarm = alarmx
	REPORT "Error , can't open!"
	SEVERITY error;


        --test2

	reset <= '0'; code <= "0010" ; daytime <= '0'; 
	WAIT FOR 50 ns;
	ASSERT door = doorx and alarm = alarmx
	REPORT "Error not 2"
	SEVERITY error;


        code <= "0110" ; 
	WAIT FOR 50 ns;
	ASSERT door = doorx and alarm = alarmx
	REPORT "Error not 6"
	SEVERITY error;

        
        code <= "1010" ; 
	WAIT FOR 50 ns;
	ASSERT door = doorx and alarm = alarmx
	REPORT "Error not A"
	SEVERITY error;


        code <= "0000" ; 
	WAIT FOR 50 ns;
	ASSERT door = doorx and alarm = alarmx
	REPORT "Error not zero"
	SEVERITY error;

        code <= "0101" ; 
	WAIT FOR 50 ns;
	ASSERT door = doorx and alarm = alarmx
	REPORT "Error not 5"
	SEVERITY error;

	--test3


	reset <= '0'; code <= "0010" ; daytime <= '0'; 
	WAIT FOR 50 ns;
	ASSERT door = doorx and alarm = alarmx
	REPORT "Error not 2"
	SEVERITY error;
	

        code <= "0110" ; 
	WAIT FOR 50 ns;
	ASSERT door = doorx and alarm = alarmx
	REPORT "Error not 6"
	SEVERITY error;

        
        code <= "1010" ; 
	WAIT FOR 50 ns;
	ASSERT door = doorx and alarm = alarmx
	REPORT "Error not A"
	SEVERITY error;


        code <= "0000" ; 
	WAIT FOR 50 ns;
	ASSERT door = doorx and alarm = alarmx
	REPORT "Error not Zero"
	SEVERITY error;


        code <= "0111" ; 
	WAIT FOR 50 ns;
	ASSERT door = doorx and alarm = alarmx
	REPORT "Error can't read not 5"
	SEVERITY error;

        --test4
	reset <= '0'; code <= "0010" ; daytime <= '1'; 
	WAIT FOR 50 ns;
	ASSERT door = doorx and alarm = alarmx
	REPORT "Error not 2"
	SEVERITY error;


        code <= "0111" ; 
	WAIT FOR 50 ns;
	ASSERT door = doorx and alarm = alarmx
	REPORT "Error can't read not 6"
	SEVERITY error;

        --test5
	reset <= '0'; code <= "1101" ; daytime <= '1'; 
	WAIT FOR 50 ns;
	ASSERT door = doorx and alarm = alarmx
	REPORT "Error can't open"
	SEVERITY error;


WAIT; -- stop process simulation run

END PROCESS proc;
END ARCHITECTURE tb;


