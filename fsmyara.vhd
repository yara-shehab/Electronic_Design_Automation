
entity dac is
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
end dac;

architecture fsm of dac is
 
  type state_type is (start, s2, s6, sa, s0);  
  signal ns, cs : state_type;
--Synthesis directives
  --pragma current_state cs
  --pragma next_state ns
  --pragma clock clk
begin
  process (CS, daytime, code, reset)
  begin
    if (reset='1') then
      door<= '0';
      alarm<= '0';
      ns<=start;
    else
      case cs is
          when start =>
            if (code="0010") then 
                 door<= '0';
                 alarm <= '0';
	    ns <= s2; 
            elsif  (daytime = '1' and code="1101") then
                   door <= '1';
                   alarm <= '0';
	    ns <= start;
             else
                   door<= '0';
                   alarm<= '1';
	    ns <= start;
       end if;

        when s2 =>
                 if (code="0110") then 
                   door<= '0';
                   alarm<= '0';
	    ns <= s6;
                 elsif  ( daytime = '1' and code="1101") then
                        door<= '1';
                        alarm<= '0';
	    ns <= start;
                 else
                   door<= '0';
                   alarm<= '1';
	    ns <= start;
          end if;
        when s6 => 
                   if (code="1010") then
                     door<= '0';
                     alarm<= '0';
	    ns <= sa;
                   elsif  (code="1101" and daytime = '1')then
                          door<= '1';
                          alarm<= '0';
	    ns <= start;
                   else

                     door<= '0';
                     alarm<= '1';
	    ns <= start;
          end if;
          when sa => 
                   if (code="0000") then 
                     door<= '0';
                     alarm<= '0';
	    ns <= s0;
                   elsif  (code="1101" and daytime = '1') then
                          door<= '1';
                          alarm<= '0';
	    ns <= start;
                   else
                     door<= '0';
                     alarm<= '1';
	    ns <= start;
                 end if;

                   when s0 => 
                   if (code="0101") then 
                     door<= '1';
                     alarm<= '0';
	    ns <= start;
		    elsif  (code="1101" and daytime = '1') then
                          door<= '1';
                          alarm<= '0';
		ns <= start;
                   else 
                          door<= '0';
                          alarm<= '1';
						  ns <= start;
          end if;    
        end case;
    end if;
  end process;

  process(clk)
  begin
	if(clk = '1' and  clk'event)then
      cs <= ns;
    end if;
  end process;

end fsm;
