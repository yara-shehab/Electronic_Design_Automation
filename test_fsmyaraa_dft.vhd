entity test_fsmyaraa_dft is
end test_fsmyaraa_dft;

architecture test of test_fsmyaraa_dft is
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
end component dac;
for dut: dac use entity work.dac (fsm);
component fsmyaraa_dft is
   port (
      clk      : in      bit;
      vdd      : in      bit;
      vss      : in      bit;
      code     : in      bit_vector(3 downto 0);
      daytime  : in      bit;
      reset    : in      bit;
      door     : out     bit;
      alarm    : out     bit;
      scan_in  : in      bit;
      test     : in      bit;
      scan_out : out     bit
 );
end component fsmyaraa_dft;
for dut1: fsmyaraa_dft use entity work.fsmyaraa_dft (structural);

	signal	code 	: bit_vector(3 downto 0) := "0000";
	signal	daytime  	: bit 	:= '0';
	signal	reset	: bit	:= '0';
	signal	clk		: bit	:= '0';
	signal	vss 	: bit	:= '0';
	signal	vdd  	: bit	:= '0';
	signal	door    	: bit 	:= '0';
	signal	alarm	 	: bit 	:= '0';
	signal	doorx   	: bit 	:= '0';
	signal	alarmx	 	: bit 	:= '0';
	signal	scan_in : bit 	:= '0';
	signal	test	: bit 	:= '0';
	signal	scan_out: bit 	:= '0';
	signal	sequence: bit_vector(9 downto 0) := "1001110010";
	constant clk_period : time := 100 ns;
begin
	dut: dac port map (clk,vdd,vss,code,daytime,reset,door,alarm);
	dut1: fsmyaraa_dft port map (clk,vdd,vss,code,daytime,reset,doorx,alarmx,scan_in,test,scan_out);
	clk_process :process
	begin
        clk <= '0';
        wait for clk_period/2;  
        clk <= '1';
        wait for clk_period/2;  
	end process clk_process;
	
	stim_process :process
	begin
	
	--test0
	reset<='1';
	WAIT FOR 100 ns;
	ASSERT door = doorx and alarm = alarmx
	REPORT "Error not 2"
	SEVERITY error;
	
	--test1
	reset <= '0'; code <= "0010" ; daytime <= '1'; 
	WAIT FOR 100 ns;
	ASSERT door = doorx and alarm = alarmx
	REPORT "Error not 2"
	SEVERITY error;

        code <= "0110" ; 
	WAIT FOR 100 ns;
	ASSERT door = doorx and alarm = alarmx
	REPORT "Error not 6"
	SEVERITY error;

        code <= "1010" ; 
	WAIT FOR 100 ns;
	ASSERT door = doorx and alarm = alarmx
	REPORT "Error not A"
	SEVERITY error;

        code <= "1101" ; 
	WAIT FOR 100 ns;
	ASSERT door = doorx and alarm = alarmx
	REPORT "Error , can't open!"
	SEVERITY error;


        --test2

	reset <= '0'; code <= "0010" ; daytime <= '0'; 
	WAIT FOR 100 ns;
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
	WAIT FOR 100 ns;
	ASSERT door = doorx and alarm = alarmx
	REPORT "Error not zero"
	SEVERITY error;

        code <= "0101" ; 
	WAIT FOR 100 ns;
	ASSERT door = doorx and alarm = alarmx
	REPORT "Error not 5"
	SEVERITY error;

	--test3


	reset <= '0'; code <= "0010" ; daytime <= '0'; 
	WAIT FOR 100 ns;
	ASSERT door = doorx and alarm = alarmx
	REPORT "Error not 2"
	SEVERITY error;
	

        code <= "0110" ; 
	WAIT FOR 100 ns;
	ASSERT door = doorx and alarm = alarmx
	REPORT "Error not 6"
	SEVERITY error;

        
        code <= "1010" ; 
	WAIT FOR 100 ns;
	ASSERT door = doorx and alarm = alarmx
	REPORT "Error not A"
	SEVERITY error;


        code <= "0000" ; 
	WAIT FOR 50 ns;
	ASSERT door = doorx and alarm = alarmx
	REPORT "Error not Zero"
	SEVERITY error;


        code <= "0111" ; 
	WAIT FOR 100 ns;
	ASSERT door = doorx and alarm = alarmx
	REPORT "Error can't read not 5"
	SEVERITY error;

        --test4
	reset <= '0'; code <= "0010" ; daytime <= '1'; 
	WAIT FOR 100 ns;
	ASSERT door = doorx and alarm = alarmx
	REPORT "Error not 2"
	SEVERITY error;


        code <= "0111" ; 
	WAIT FOR 100 ns;
	ASSERT door = doorx and alarm = alarmx
	REPORT "Error can't read not 6"
	SEVERITY error;

        --test5
	reset <= '0'; code <= "1101" ; daytime <= '1'; 
	WAIT FOR 100 ns;
	ASSERT door = doorx and alarm = alarmx
	REPORT "Error can't open"
	SEVERITY error;

		
		test <= '1';
		for  i In 0 to  sequence'length -1 loop 
			scan_in <= sequence(i);  -- Assign values to circuit inputs
			 -- Wait to "propagate" values
			-- Check output against expected result. 
			if  i >= 3 then -- 3 registers in the scan chain 
				Assert  scan_out = sequence(i-3)
				Report " scanout does not follow scan in"
				Severity error;
			end if;
			wait for  clk_period  ;
		end loop; 
		
		wait;
	end process stim_process;
end test;
