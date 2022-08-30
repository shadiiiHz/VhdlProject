-------------------------------------------------------------------------------
--
-- Title       : Auto_Car
-- Design      : h4
-- Author      : 
-- Company     : 
--
-------------------------------------------------------------------------------
--
-- File        : Auto_Car.vhd
-- Generated   : Fri Jan 15 20:35:40 2021
-- From        : interface description file
-- By          : Itf2Vhdl ver. 1.22
--
-------------------------------------------------------------------------------
--
-- Description : 
--
-------------------------------------------------------------------------------

--{{ Section below this comment is automatically maintained
--   and may be overwritten
--{entity {Auto_Car} architecture {Auto_Car}}

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use ieee.numeric_std.all;
entity Auto_Car is
	port(
	    -----------------------------------------------------------
		Clock                 : in  std_logic;
		Start                 : in  std_logic;
		Reset                 : in  std_logic;
		Speed                 : in  std_logic_vector(2 downto 0);
		Path_Station_and_Time : in  std_logic_vector(47 downto 0);
		Emergency             : in  std_logic;
		Stop                  : in  std_logic;
		Chance                : in  std_logic;
		-----------------------------------------------------------
		Total_Time            : out integer := 0;
		Station_Halt          : out integer := 0;
		NextStation_Left      : out std_logic_vector(7 downto 0);
		Station_Number        : out integer :=0;
		Open_Close            : out std_logic
	  
		);

end Auto_Car;

--}} End of automatically maintained section

architecture Auto_Car of Auto_Car is
---------------------for process state----------------------


signal Counter : integer range 0 to 2000000:=0;


signal Counter_Stop : integer range 0 to 2000000:=0;
signal Finish1 : std_logic;
signal Finish2 : std_logic;
signal Finish3 : std_logic;
signal Finish4 : std_logic;
signal Finish5 : std_logic;
signal Finish6 : std_logic;
------------------------------------------------------------
signal chera :integer := 0;
type STATE_TYPE is ( s0,s1, s2,s3, s4, s5,s6);	
signal current_state :STATE_TYPE; 
signal next_state :STATE_TYPE;
-------------------------------------------------------------



signal Emerg_Delay_Enable_0 : std_logic := '0';
signal Emerg_Delay_Enable_1 : std_logic := '0';
signal Emerg_Delay_Enable_2 : std_logic:= '0';
signal Emerg_Delay_Enable_3 : std_logic:= '0';
signal Emerg_Delay_Enable_4 : std_logic:= '0';
signal Emerg_Delay_Enable_5 : std_logic:= '0';
signal Emerg_Delay_Enable_6 : std_logic:= '0';
------------------------------------------------------
signal Chance_Delay_Enable_1 : std_logic := '0';
signal Chance_Delay_Enable_2 : std_logic:= '0';
signal Chance_Delay_Enable_3 : std_logic:= '0';
signal Chance_Delay_Enable_4 : std_logic:= '0';
signal Chance_Delay_Enable_5 : std_logic:= '0';
signal Chance_Delay_Enable_6 : std_logic:= '0';
signal Finish_Chance_1 :std_logic := '0';
signal Finish_Chance_2 :std_logic :='0';
signal Finish_Chance_3 :std_logic :='0';
signal Finish_Chance_4 :std_logic :='0';
signal Finish_Chance_5 :std_logic :='0';
signal Finish_Chance_6 :std_logic :='0';
signal Finish_C1 : boolean := false;
signal Finish_C2 : boolean := false;
signal Finish_C3 : boolean := false;
signal Finish_C4 : boolean := false;
signal Finish_C5 : boolean := false;


signal Counter_Station_Halt : integer range 0 to 2000000:=0;
signal Station_Number_LFSR :integer :=0;
signal pseudo_rand :std_logic_vector(31 downto 0);
------------------emergency of other stations-------------------------------------- 


----------------------Path_Time_integer------------------------
signal Path_Time_integer_0_3  :integer  ;
signal Path_Time_integer_8_11  :integer  ;
signal Path_Time_integer_16_19  :integer ;
signal  Path_Time_integer_24_27  :integer ;
signal  Path_Time_integer_32_35  :integer ;
signal  Path_Time_integer_40_43  :integer; 
---------------------Path_station_integer----------------------
signal	Path_station_number_integer_4_7  :integer  ;
signal  Path_station_number_integer_12_15  :integer  ;
signal  Path_station_number_integer_20_23  :integer ;
signal  Path_station_number_integer_28_31  :integer ;
signal  Path_station_number_integer_36_39  :integer ;
signal  Path_station_number_integer_44_47  :integer ;
--------------------------------------------------------
signal second_between_stations  :integer; 
signal CM :std_logic_vector(6 downto 0) := "0000000";
signal speed_integer :integer ;	
signal ten :integer := 10; 	
signal five :integer := 5; 
signal okay :integer := 0;	
signal Clculate_Time :integer := 0;
signal Time_Distance_5KM :integer := 0;
signal b :integer := 0;
--------------------------------------------------------
begin
	
-------------------------------------------------------
  
------------------------Time-----------------------------
Path_Time_integer_0_3 <= to_integer(unsigned(Path_Station_and_Time(3 downto 0)));
Path_Time_integer_8_11 <= to_integer(unsigned(Path_Station_and_Time(11 downto 8))); 
Path_Time_integer_16_19 <= to_integer(unsigned(Path_Station_and_Time(19 downto 16))); 
Path_Time_integer_24_27	<= to_integer(unsigned(Path_Station_and_Time(27 downto 24))); 
Path_Time_integer_32_35	<= to_integer(unsigned(Path_Station_and_Time(35 downto 32))); 
Path_Time_integer_40_43	<= to_integer(unsigned(Path_Station_and_Time(43 downto 40))); 
----------------------station-------------------------------
Path_station_number_integer_4_7   <= to_integer(unsigned(Path_Station_and_Time(7 downto 4)));
Path_station_number_integer_12_15 <= to_integer(unsigned(Path_Station_and_Time(15 downto 12))); 
Path_station_number_integer_20_23 <= to_integer(unsigned(Path_Station_and_Time(23 downto 20))); 
Path_station_number_integer_28_31 <= to_integer(unsigned(Path_Station_and_Time(31 downto 28))); 
Path_station_number_integer_36_39 <= to_integer(unsigned(Path_Station_and_Time(39 downto 36))); 
Path_station_number_integer_44_47 <= to_integer(unsigned(Path_Station_and_Time(47 downto 44))); 
-----------------------calculate Time between stations----------------------------------  
--speed_integer <= to_integer(unsigned(Speed));




-- enter your statements here --
process(Clock, reset) 

	begin 
		if reset = '1' then
			current_state <= s0;
		elsif Clock'event and Clock = '1' then
			current_state <= next_state;
		end if;
	end process;
process(Clock, reset)
function lfsr32(x : std_logic_vector(31 downto 0)) return std_logic_vector is
begin
    return x(30 downto 0) & (x(0) xnor x(1) xnor x(21) xnor x(31));
end function;

begin 	
	if (reset = '1') then
		Counter <= 0; 
		pseudo_rand <= (others => '0');
	elsif(Clock'event and Clock = '1') then	
		pseudo_rand <= lfsr32(pseudo_rand);	
		speed_integer <= to_integer(unsigned(Speed));
		Time_Distance_5KM <= five / speed_integer;
		if(CM = "0000001") then
			
			if(Emergency = '1') then 
			   Emerg_Delay_Enable_1 <= '1';
			end if; 
			
		    if( Chance_Delay_Enable_1 = '0' and Chance_Delay_Enable_2 = '0' and Chance_Delay_Enable_3 = '0' and Chance_Delay_Enable_4 = '0' and Chance_Delay_Enable_5 = '0') then	
				if(Counter = Path_Time_integer_40_43 * ten - 1) then
					if(Chance ='1') then
						Finish_C1 <= true;
						Clculate_Time <= Clculate_Time + Counter + (Time_Distance_5KM * ten) + 1;
						--Counter_Station_Halt <= 0;
						--Station_Halt <= 0; 
						--okay <= 0;
						Counter <= 0;
					else
						Finish1 <= '1';
						Clculate_Time <= Clculate_Time + Counter + (Time_Distance_5KM * ten) + 1 ; 
						--Counter_Station_Halt <= 0;
						--Station_Halt <=  0;	
						--okay <= 0;
				        Counter <= 0;
					end if;
				   
			    elsif(Stop = '0') then
					Counter <= Counter + 1;
					--Counter_help_1 <= Counter;
					--if(okay = 0) then 
						--Counter_Station_Halt <= (Path_Time_integer_40_43 * ten - 2 );
						--Station_Halt <=(Path_Time_integer_40_43 * ten - 2 );
						--okay <=1;
					--else 
						--Counter_Station_Halt <= Counter_Station_Halt - 1; 
						--Station_Halt <=  Counter_Station_Halt;
					--end if;
				elsif(Stop = '1') then
					Counter_Stop <= Counter_Stop + 1;
					
					
					
		        end if;
			end if;
			

			if(Chance_Delay_Enable_2 = '1') then --Modify
				if(Counter = five * ten  )then	
				   Finish_Chance_2 <= '1'; 
				   Chance_Delay_Enable_2 <= '0';
				   Finish_C2 <= false;
				   Clculate_Time <= Clculate_Time + Counter + (Time_Distance_5KM * ten) + 1;
				   --Counter_Station_Halt <= 0;
				   --Station_Halt <= 0;
				   --okay <= 0;
				   Counter <= 0; 
			    elsif(Stop = '0') then
					Counter <= Counter + 1;
					--if(okay = 0) then 
						--Counter_Station_Halt <= ( five * ten - 2 );
						--Station_Halt <=( five * ten - 2 );
						--okay <=1;
					--else 
					--	Counter_Station_Halt <= Counter_Station_Halt - 1; 
						--Station_Halt <=  Counter_Station_Halt;
					--end if;
				elsif(Stop = '1') then
					Counter_Stop <= Counter_Stop + 1;
				end if;
		    end if;
			if(Chance_Delay_Enable_3 = '1') then 
				if(Counter = five * ten )then	
				   Finish_Chance_3 <= '1'; 
				   Chance_Delay_Enable_3 <= '0';
				   Finish_C3 <= false;
				   Clculate_Time <= Clculate_Time + Counter + (Time_Distance_5KM * ten) +  1; 
				  -- Counter_Station_Halt <= 0;
				  -- Station_Halt <= 0;
				  -- okay <= 0;
				   Counter <= 0; 
			    elsif(Stop = '0') then
					Counter <= Counter + 1;
					--if(okay = 0) then 
						--Counter_Station_Halt <= ( five * ten - 2 );
						--Station_Halt <=( five * ten - 2 );
						--okay <=1;
					--else 
						--Counter_Station_Halt <= Counter_Station_Halt - 1; 
						--Station_Halt <=  Counter_Station_Halt;
					--end if;
				elsif(Stop = '1') then
					Counter_Stop <= Counter_Stop + 1;
				end if;
		    end if;
			if(Chance_Delay_Enable_4 = '1') then 
				if(Counter = five * ten )then	
				   Finish_Chance_4 <= '1'; 
				   Chance_Delay_Enable_4 <= '0'; 
				   Finish_C4 <= false; 
				   Clculate_Time <= Clculate_Time + Counter + (Time_Distance_5KM * ten) + 1 ; 
				   --Counter_Station_Halt <= 0;
				   --Station_Halt <= 0;
				  -- okay <= 0;
				   Counter <= 0; 
			    elsif(Stop = '0') then
					Counter <= Counter + 1;
					--if(okay = 0) then 
						--Counter_Station_Halt <= ( five * ten - 2 );
						--Station_Halt <=( five * ten - 2 );
						--okay <=1;
					--else 
						--Counter_Station_Halt <= Counter_Station_Halt - 1; 
						--Station_Halt <=  Counter_Station_Halt;
					--end if;
				elsif(Stop = '1') then
					Counter_Stop <= Counter_Stop + 1;
				end if;
		    end if;
			if(Chance_Delay_Enable_5 = '1') then 
				if(Counter = five * ten )then	
				   Finish_Chance_5 <= '1'; 
				   Chance_Delay_Enable_5 <= '0';
				   Finish_C5 <= false; 
				   Clculate_Time <= Clculate_Time + Counter + (Time_Distance_5KM * ten) + 1; 
				   --Counter_Station_Halt <= 0;
				   --Station_Halt <= 0;
				   --okay <= 0;
				   Counter <= 0; 
			    elsif(Stop = '0') then
					Counter <= Counter + 1;
					--if(okay = 0) then 
						--Counter_Station_Halt <= ( five * ten - 2 );
						--Station_Halt <=( five * ten - 2 );
						--okay <=1;
					--else 
						--Counter_Station_Halt <= Counter_Station_Halt - 1; 
						--Station_Halt <=  Counter_Station_Halt;
					--end if;
				elsif(Stop = '1') then
					Counter_Stop <= Counter_Stop + 1;
				end if;
		    end if;
			if(Chance = '1') then
				if(Finish_C1 = true) then
					Chance_Delay_Enable_1 <= '1'; 
			        Station_Number_LFSR <= 3 ;
					
				end if;
				--if(Counter =  Counter_help + Counter_help_1 -1) then
					
				--end if;
			   --	Counter <= Counter + 1;
			
		    end if; 
			if(Chance = '0') then 
				Finish_Chance_1 <= '0';
		    end if;
			
			
		end if;--CM1
		if(CM = "0000010") then	
			Finish_Chance_1 <= '0';
			Finish_Chance_3	<= '0';
			Finish_Chance_4	<= '0';
			Finish_Chance_5	<= '0';
			
			if(Emerg_Delay_Enable_1 = '0' and Chance_Delay_Enable_1 = '0' and Chance_Delay_Enable_2 = '0' and Chance_Delay_Enable_3 = '0' and Chance_Delay_Enable_4 = '0' and Chance_Delay_Enable_5 = '0' ) then --normal without emergancy or chance
			  if(Counter = Path_Time_integer_32_35 * ten - 1) then
				 if(Chance ='1') then
					 Finish_C2 <= true; 
					 Clculate_Time <= Clculate_Time + Counter + (Time_Distance_5KM * ten) + 1 ;	
					 Counter_Station_Halt <= 0;
					 Station_Halt <= 0;	
					 okay <= 0;
					 Counter <= 0;
				 else  
					 
					 Finish2 <= '1';
					 Clculate_Time <= Clculate_Time + Counter + (Time_Distance_5KM * ten) + 1 ;	 
					 Counter_Station_Halt <= 0;
					 Station_Halt <= 0;
					 okay <= 0;
				     Counter <= 0;
				 end if; 
			  elsif(Stop = '0') then
				  Counter <= Counter + 1;
				  if(okay = 0) then 
						Counter_Station_Halt <= (Path_Time_integer_32_35 * ten - 2 );
						Station_Halt <=(Path_Time_integer_32_35 * ten - 2 );
						okay <=1;
				  else 
						Counter_Station_Halt <= Counter_Station_Halt - 1; 
						Station_Halt <=  Counter_Station_Halt;
				  end if;
			  elsif(Stop = '1') then
					Counter_Stop <= Counter_Stop + 1;
			  end if;
		    end if;	
			
			if(Emerg_Delay_Enable_1 = '1') then --answer to emergancy of state 1 
				if(Counter = (Path_Time_integer_32_35 + ten) * ten - 1) then	
				   Finish2 <= '1';
				   Emerg_Delay_Enable_1 <= '0';
				   Clculate_Time <= Clculate_Time + Counter + (Time_Distance_5KM * ten) + 1;
				   Counter <= 0;
			    
			    elsif(Stop = '0') then
					Counter <= Counter ; 
				elsif(Stop = '1') then
					Counter_Stop <= Counter_Stop + 1;
				end if;
		    end if;
			if(Emergency = '1') then  --emergancy state 2 is on
			  Emerg_Delay_Enable_2 <= '1';
			  
		    end if;
			if(Chance_Delay_Enable_1 = '1') then 
				if(Counter = five * ten )then	
				   Finish_Chance_1 <= '1'; 
				   Chance_Delay_Enable_1 <= '0'; 
				   Finish_C1 <= false;
				   Clculate_Time <= Clculate_Time + Counter + (Time_Distance_5KM * ten) + 1;   
				  -- Counter_Station_Halt <= 0;
				  -- Station_Halt <= 0;
				  -- okay <= 0;
				   Counter <= 0; 
			    elsif(Stop = '0') then
					Counter <= Counter + 1;
					--if(okay = 0) then 
						--Counter_Station_Halt <= ( five * ten - 2 );
						--Station_Halt <=( five * ten - 2 );
						--okay <=1;
					--else 
						--Counter_Station_Halt <= Counter_Station_Halt - 1; 
						--Station_Halt <=  Counter_Station_Halt;
					--end if;
				elsif(Stop = '1') then
					Counter_Stop <= Counter_Stop + 1;
				end if;
		    end if;
			
			if(Chance_Delay_Enable_3 = '1') then 
				if(Counter = five * ten )then	
				   Finish_Chance_3 <= '1'; 
				   Chance_Delay_Enable_3 <= '0';
				   Finish_C3 <= false;
				   Clculate_Time <= Clculate_Time + Counter + (Time_Distance_5KM * ten) + 1;   
				   --Counter_Station_Halt <= 0;
				   --Station_Halt <= 0;
				   --okay <= 0;
				   Counter <= 0; 
			    elsif(Stop = '0') then
					Counter <= Counter + 1;
					--if(okay = 0) then 
						--Counter_Station_Halt <= ( five * ten - 2 );
						--Station_Halt <=( five * ten - 2 );
						--okay <=1;
					--else 
						--Counter_Station_Halt <= Counter_Station_Halt - 1; 
						--Station_Halt <=  Counter_Station_Halt;
					--end if;
				elsif(Stop = '1') then
					Counter_Stop <= Counter_Stop + 1;
				end if;
		    end if;
			if(Chance_Delay_Enable_4 = '1') then 
				if(Counter = five * ten )then	
				   Finish_Chance_4 <= '1'; 
				   Chance_Delay_Enable_4 <= '0';
				   Finish_C4 <= false;
				   Clculate_Time <= Clculate_Time + Counter + (Time_Distance_5KM * ten) + 1;
				   --Counter_Station_Halt <= 0;
				   --Station_Halt <= 0;
				  -- okay <= 0;
				   Counter <= 0; 
			    elsif(Stop = '0') then
					Counter <= Counter + 1;
					--if(okay = 0) then 
						--Counter_Station_Halt <= ( five * ten - 2 );
						---Station_Halt <=( five * ten - 2 );
						--okay <=1;
					--else 
						--Counter_Station_Halt <= Counter_Station_Halt - 1; 
						--Station_Halt <=  Counter_Station_Halt;
					--end if;
				elsif(Stop = '1') then
					Counter_Stop <= Counter_Stop + 1;
				end if;
		    end if;
			if(Chance_Delay_Enable_5 = '1') then 
				if(Counter = five * ten )then	
				   Finish_Chance_5 <= '1'; 
				   Chance_Delay_Enable_5 <= '0';
				   Finish_C5 <= false;
				   Clculate_Time <= Clculate_Time + Counter + (Time_Distance_5KM * ten) + 1; 
				   --Counter_Station_Halt <= 0;
				  -- Station_Halt <= 0;
				  -- okay <= 0;
				   Counter <= 0; 
			    elsif(Stop = '0') then
					Counter <= Counter + 1;
					--if(okay = 0) then 
						---Counter_Station_Halt <= ( five * ten - 2 );
						--Station_Halt <=( five * ten - 2 );
						--okay <=1;
					--else 
						--Counter_Station_Halt <= Counter_Station_Halt - 1; 
						--Station_Halt <=  Counter_Station_Halt;
					--end if;
				elsif(Stop = '1') then
					Counter_Stop <= Counter_Stop + 1;
				end if;
		    end if;
			if(Chance = '1') then 
			   if(Finish_C2 = true) then
					Chance_Delay_Enable_2 <= '1'; 
			        --Station_Number_LFSR <= 3;
			   end if;
		    end if;	
			if(Chance = '0') then 
				Finish_Chance_2 <= '0';
		    end if;
		end if;--CM2
		if(CM = "0000100") then	
			Finish_Chance_1 <= '0';
			Finish_Chance_2	<= '0';
			Finish_Chance_4	<= '0';
			Finish_Chance_5	<= '0';
			--okay <= 0;
			if(Emerg_Delay_Enable_2 = '0' and Chance_Delay_Enable_1 = '0' and Chance_Delay_Enable_2 = '0' and Chance_Delay_Enable_3 = '0' and Chance_Delay_Enable_4 = '0' and Chance_Delay_Enable_5 = '0' ) then --normal without emergancy or chance
			  if(Counter = Path_Time_integer_24_27  * ten - 1) then	
				 
				 if(Chance ='1') then
					 Finish_C3 <= true; 
					 Clculate_Time <= Clculate_Time + Counter + (Time_Distance_5KM * ten) + 1;	
					 Counter_Station_Halt <= 0;
					 Station_Halt <= 0; 
					 okay <= 0;
					 Counter <= 0;
				 else
					 Finish3 <= '1'; 
					 Clculate_Time <= Clculate_Time + Counter + (Time_Distance_5KM * ten) + 1;
					 Counter_Station_Halt <= 0;
					 Station_Halt <= 0;
					 okay <= 0;
				     Counter <= 0;
				 end if;
			  elsif(Stop = '0') then
				  Counter <= Counter + 1;
				  if(okay = 0) then 
						Counter_Station_Halt <= (Path_Time_integer_24_27 * ten - 2 );
						Station_Halt <=(Path_Time_integer_24_27 * ten - 2 );
						okay <=1;
				  else 
						Counter_Station_Halt <= Counter_Station_Halt - 1; 
						Station_Halt <=  Counter_Station_Halt;
				  end if;
				  
			  elsif(Stop = '1') then
					Counter_Stop <= Counter_Stop + 1;
			  end if;
		    end if;
			if(Emerg_Delay_Enable_2 = '1') then ----answer to emergancy of state 2 
				if(Counter = (Path_Time_integer_24_27  + ten) * ten - 1) then	
				    Finish3 <= '1';
				    Emerg_Delay_Enable_2 <= '0';
				    Clculate_Time <= Clculate_Time + Counter + (Time_Distance_5KM * ten) + 1;
				    Counter <= 0;
			    
			    elsif(Stop = '0') then
					Counter <= Counter + 1;
				elsif(Stop = '1') then
					Counter_Stop <= Counter_Stop + 1;
				end if;
		    end if;
			if(Emergency = '1') then  --emergancy state 3 is on
			  Emerg_Delay_Enable_3 <= '1';
			  
		    end if;
			if(Chance_Delay_Enable_1 = '1') then 
				if(Counter = five * ten )then	
				    Finish_Chance_1 <= '1'; 
				    Chance_Delay_Enable_1 <= '0';
				    Finish_C1 <= false; 
				    Clculate_Time <= Clculate_Time + Counter + (Time_Distance_5KM * ten) + 1 ; 
					--Counter_Station_Halt <= 0;
					--Station_Halt <= 0;
					--okay <= 0;
				    Counter <= 0; 
			    elsif(Stop = '0') then
					Counter <= Counter + 1;
					--if(okay = 0) then 
						--b <= 1;
						--Counter_Station_Halt <= 48;
						--Station_Halt <= 48;
						--okay <=1;
					--else 
					--	Counter_Station_Halt <= Counter_Station_Halt - 1; 
					--	Station_Halt <=  Counter_Station_Halt;
					---end if;
				elsif(Stop = '1') then
					Counter_Stop <= Counter_Stop + 1;
				end if;
		    end if;
			if(Chance_Delay_Enable_2 = '1') then 
				if(Counter = five * ten )then	
				    Finish_Chance_2 <= '1'; 
				    Chance_Delay_Enable_2 <= '0';
				    Finish_C2 <= false;
				    Clculate_Time <= Clculate_Time + Counter + (Time_Distance_5KM * ten) + 1; 
					--Counter_Station_Halt <= 0;
					--Station_Halt <= 0;
					--okay <= 0;
				    Counter <= 0; 
			    elsif(Stop = '0') then
					Counter <= Counter + 1;	
					--if(okay = 0) then 
						--Counter_Station_Halt <= ( five * ten - 2 );
						--Station_Halt <=( five * ten - 2 );
						--okay <=1;
					--else 
						--Counter_Station_Halt <= Counter_Station_Halt - 1; 
						--Station_Halt <=  Counter_Station_Halt;
					--end if;
				elsif(Stop = '1') then
					Counter_Stop <= Counter_Stop + 1;
				end if;
		    end if;
			
			if(Chance_Delay_Enable_4 = '1') then 
				if(Counter = five * ten )then	
				    Finish_Chance_4 <= '1'; 
				    Chance_Delay_Enable_4 <= '0';
				    Finish_C4 <= false;
				    Clculate_Time <= Clculate_Time + Counter + (Time_Distance_5KM * ten) + 1;  
					--Counter_Station_Halt <= 0;
					--Station_Halt <= 0;
					--okay <= 0;
				    Counter <= 0; 
			    elsif(Stop = '0') then
					Counter <= Counter + 1;
					--if(okay = 0) then 
						--Counter_Station_Halt <= ( five * ten - 2 );
						--Station_Halt <=( five * ten - 2 );
						--okay <=1;
					--else 
						--Counter_Station_Halt <= Counter_Station_Halt - 1; 
						--Station_Halt <=  Counter_Station_Halt;
					--end if;
				elsif(Stop = '1') then
					Counter_Stop <= Counter_Stop + 1;
				end if;
		    end if;
			if(Chance_Delay_Enable_5 = '1') then 
				if(Counter = five * ten )then	
				    Finish_Chance_5 <= '1'; 
				    Chance_Delay_Enable_5 <= '0';
				    Finish_C5 <= false; 
				    Clculate_Time <= Clculate_Time + Counter + (Time_Distance_5KM * ten) + 1;
					--Counter_Station_Halt <= 0;
					--Station_Halt <= 0;
					--okay <= 0;	
				    Counter <= 0; 
			    elsif(Stop = '0') then
					Counter <= Counter + 1;	
					--if(okay = 0) then 
						--Counter_Station_Halt <= ( five * ten - 2 );
						--Station_Halt <=( five * ten - 2 );
						--okay <=1;
					--else 
						--Counter_Station_Halt <= Counter_Station_Halt - 1; 
						--Station_Halt <=  Counter_Station_Halt;
					--end if;
				elsif(Stop = '1') then
					Counter_Stop <= Counter_Stop + 1;
				end if;
		    end if;
			if(Chance = '1') then 
			   if(Finish_C3 = true) then
					Chance_Delay_Enable_3 <= '1'; 
			       -- Station_Number_LFSR <= 3;
			   end if;
			   --Station_Number_LFSR <= to_integer(unsigned(pseudo_rand(3 downto 0)));
		    end if;	
			if(Chance = '0') then 
				Finish_Chance_3 <= '0';
		    end if;
		end if;--CM3
		if(CM = "0001000") then	
			Finish_Chance_1 <= '0';
			Finish_Chance_2	<= '0';
			Finish_Chance_3	<= '0';
			Finish_Chance_5	<= '0';
			
			if(Emerg_Delay_Enable_3 = '0' and Chance_Delay_Enable_1 = '0' and Chance_Delay_Enable_2 = '0' and Chance_Delay_Enable_3 = '0' and Chance_Delay_Enable_4 = '0' and Chance_Delay_Enable_5 = '0' ) then --normal without emergancy or chance
			  if(Counter = Path_Time_integer_16_19  * ten - 1) then	
				 if(Chance ='1') then
					 Finish_C4 <= true; 
					 Clculate_Time <= Clculate_Time + Counter + (Time_Distance_5KM * ten) + 1; 
					 Counter_Station_Halt <= 0;
					 Station_Halt <= 0;
					 okay <= 0;
					 Counter <= 0;
				 else
					 Finish4 <= '1'; 
					 Clculate_Time <= Clculate_Time + Counter + (Time_Distance_5KM * ten) + 1; 
					 Station_Halt <= 0;
					 okay <= 0;
				     Counter <= 0;
				 end if;
			  
			  elsif(Stop = '0') then  
				  Counter <= Counter + 1; 
				  if(okay = 0) then 
						Counter_Station_Halt <= (Path_Time_integer_16_19 * ten - 2 );
						Station_Halt <=(Path_Time_integer_16_19 * ten - 2 );
						okay <=1;
				  else 
						Counter_Station_Halt <= Counter_Station_Halt - 1; 
						Station_Halt <=  Counter_Station_Halt;
				  end if;
			  elsif(Stop = '1') then
					Counter_Stop <= Counter_Stop + 1;
			  end if;
		    end if;
		    if(Emerg_Delay_Enable_3 = '1') then ----answer to emergancy of state 3 
				if(Counter = (Path_Time_integer_16_19  + ten) * ten - 1) then	
				   Finish4 <= '1';
				   Clculate_Time <= Clculate_Time + Counter + (Time_Distance_5KM * ten) + 1;
				   Counter <= 0;
				   Emerg_Delay_Enable_3 <= '0';
			    
			    elsif(Stop = '0') then
					Counter <= Counter + 1;  
				elsif(Stop = '1') then
					Counter_Stop <= Counter_Stop + 1;
				end if;
		    end if;
			if(Emergency = '1') then  --emergancy state 4 is on
			  Emerg_Delay_Enable_4 <= '1';
		    end if;	
			if(Chance_Delay_Enable_1 = '1') then 
				if(Counter = five * ten )then	
				   Finish_Chance_1 <= '1'; 
				   Chance_Delay_Enable_1 <= '0';
				   Finish_C1 <= false; 
				   Clculate_Time <= Clculate_Time + Counter + (Time_Distance_5KM * ten) + 1; 
				  -- Counter_Station_Halt <= 0;
				  -- Station_Halt <= 0;
				  -- okay <= 0;
				   Counter <= 0; 
			    elsif(Stop = '0') then
					Counter <= Counter + 1;
					--if(okay = 0) then 
						--Counter_Station_Halt <= ( five * ten - 2 );
						--Station_Halt <=( five * ten - 2 );
						--okay <=1;
					--else 
						--Counter_Station_Halt <= Counter_Station_Halt - 1; 
						--Station_Halt <=  Counter_Station_Halt;
					--end if;
				elsif(Stop = '1') then
					Counter_Stop <= Counter_Stop + 1;
				end if;
		    end if;
			if(Chance_Delay_Enable_2 = '1') then 
				if(Counter = five * ten )then	
				   Finish_Chance_2 <= '1'; 
				   Chance_Delay_Enable_2 <= '0';
				   Finish_C2 <= false;	
				   Clculate_Time <= Clculate_Time + Counter + (Time_Distance_5KM * ten) + 1; 
				   --Counter_Station_Halt <= 0;
				  -- Station_Halt <= 0;
				  -- okay <= 0;
				   Counter <= 0; 
			    elsif(Stop = '0') then
					Counter <= Counter + 1;	
					--if(okay = 0) then 
						--Counter_Station_Halt <= ( five * ten - 2 );
						--Station_Halt <=( five * ten - 2 );
						--okay <=1;
					--else 
						--Counter_Station_Halt <= Counter_Station_Halt - 1; 
						--Station_Halt <=  Counter_Station_Halt;
					--end if;
				elsif(Stop = '1') then
					Counter_Stop <= Counter_Stop + 1;
				end if;
		    end if;
			if(Chance_Delay_Enable_3 = '1') then 
				if(Counter = five * ten )then	
				   Finish_Chance_3 <= '1'; 
				   Chance_Delay_Enable_3 <= '0';
				   Finish_C3 <= false;	
				   Clculate_Time <= Clculate_Time + Counter + (Time_Distance_5KM * ten) + 1;  
				   --Counter_Station_Halt <= 0;
				   --Station_Halt <= 0;
				  -- okay <= 0;
				   Counter <= 0; 
			    elsif(Stop = '0') then
					Counter <= Counter + 1;
					--if(okay = 0) then 
						--Counter_Station_Halt <= ( five * ten - 2 );
						--Station_Halt <=( five * ten - 2 );
						--okay <=1;
					--else 
						--Counter_Station_Halt <= Counter_Station_Halt - 1; 
						--Station_Halt <=  Counter_Station_Halt;
					--end if;
				elsif(Stop = '1') then
					Counter_Stop <= Counter_Stop + 1;
				end if;
		    end if;
			
			if(Chance_Delay_Enable_5 = '1') then 
				if(Counter = five * ten )then	
				   Finish_Chance_5 <= '1'; 
				   Chance_Delay_Enable_5 <= '0';
				   Finish_C5 <= false;
				   Clculate_Time <= Clculate_Time + Counter + (Time_Distance_5KM * ten) + 1;
				   --Counter_Station_Halt <= 0;
--				   Station_Halt <= 0;
--				   okay <= 0;
				   Counter <= 0; 
			    elsif(Stop = '0') then
					Counter <= Counter + 1;	
					--if(okay = 0) then 
--						Counter_Station_Halt <= ( five * ten - 2 );
--						Station_Halt <=( five * ten - 2 );
--						okay <=1;
--					else 
--						Counter_Station_Halt <= Counter_Station_Halt - 1; 
--						Station_Halt <=  Counter_Station_Halt;
--					end if;
				elsif(Stop = '1') then
					Counter_Stop <= Counter_Stop + 1;
				end if;
		    end if;
			if(Chance = '1') then 
			   if(Finish_C4 = true) then
					Chance_Delay_Enable_4 <= '1'; 
			        --Station_Number_LFSR <= 3;
			   end if;
			   --Station_Number_LFSR <= to_integer(unsigned(pseudo_rand(3 downto 0)));
		    end if;
			if(Chance = '0') then 
				Finish_Chance_4 <= '0';
		    end if;
		end if;--CM4 
		if(CM = "0010000") then	
			Finish_Chance_1 <= '0';
			Finish_Chance_2	<= '0';
			Finish_Chance_3	<= '0';
			Finish_Chance_4	<= '0';
		
			if(Emerg_Delay_Enable_4 = '0' and Chance_Delay_Enable_1 = '0' and Chance_Delay_Enable_2 = '0' and Chance_Delay_Enable_3 = '0' and Chance_Delay_Enable_4 = '0' and Chance_Delay_Enable_5 = '0' ) then --normal without emergancy or chance
			  if(Counter = Path_Time_integer_8_11  * ten - 1) then	
				 if(Chance ='1') then
					 Finish_C5 <= true; 
					 Clculate_Time <= Clculate_Time + Counter + (Time_Distance_5KM * ten) + 1;	
					 Counter_Station_Halt <= 0;
					 Station_Halt <= 0;
					 okay <= 0;
					 Counter <= 0;
				 else
					 Finish5 <= '1'; 
					 Clculate_Time <= Clculate_Time + Counter + (Time_Distance_5KM * ten) + 1; 
					 Station_Halt <= 0;
					 okay <= 0;
				     Counter <= 0;
				 end if;
			  
			  elsif(Stop = '0') then
				  Counter <= Counter + 1;
				  if(okay = 0) then 
						Counter_Station_Halt <= (Path_Time_integer_8_11 * ten - 2 );
						Station_Halt <=(Path_Time_integer_8_11 * ten - 2 );
						okay <=1;
				  else 
						Counter_Station_Halt <= Counter_Station_Halt - 1; 
						Station_Halt <=  Counter_Station_Halt;
				  end if;
			  elsif(Stop = '1') then
					Counter_Stop <= Counter_Stop + 1;
			  end if;
		    end if;
			if(Emerg_Delay_Enable_4 = '1') then ----answer to emergancy of state 4 
				if(Counter = (Path_Time_integer_8_11  + ten) * ten - 1) then	
				   Finish5 <= '1'; 
				   Clculate_Time <= Clculate_Time + Counter + (Time_Distance_5KM * ten) + 1;
				   Counter <= 0;
				   Emerg_Delay_Enable_4 <= '0';
			    
			    elsif(Stop = '0') then
					Counter <= Counter + 1; 
				elsif(Stop = '1') then
					Counter_Stop <= Counter_Stop + 1;
				end if;
		    end if;
			if(Emergency = '1') then  --emergancy state 5 is on
			  Emerg_Delay_Enable_5 <= '1';
		    end if;	
			if(Chance_Delay_Enable_1 = '1') then 
				if(Counter = five * ten )then	
				   Finish_Chance_1 <= '1'; 
				   Chance_Delay_Enable_1 <= '0';
				   Finish_C1 <= false;
				   Clculate_Time <= Clculate_Time + Counter + (Time_Distance_5KM * ten) + 1;
--				   Counter_Station_Halt <= 0;
--				   Station_Halt <= 0;
--				   okay <= 0;
				   Counter <= 0; 
			    elsif(Stop = '0') then
					Counter <= Counter + 1;
					--if(okay = 0) then 
--						Counter_Station_Halt <= ( five * ten - 2 );
--						Station_Halt <=( five * ten - 2 );
--						okay <=1;
--					else 
--						Counter_Station_Halt <= Counter_Station_Halt - 1; 
--						Station_Halt <=  Counter_Station_Halt;
--					end if;
				elsif(Stop = '1') then
					Counter_Stop <= Counter_Stop + 1;
				end if;
		    end if;
			if(Chance_Delay_Enable_2 = '1') then 
				if(Counter = five * ten )then	
				   Finish_Chance_2 <= '1'; 
				   Chance_Delay_Enable_2 <= '0';
				   Finish_C2 <= false;
				   Clculate_Time <= Clculate_Time + Counter + (Time_Distance_5KM * ten) + 1; 
				   --Counter_Station_Halt <= 0;
--				   Station_Halt <= 0;
--				   okay <= 0;
				   Counter <= 0; 
			    elsif(Stop = '0') then
					Counter <= Counter + 1;	
					--if(okay = 0) then 
--						Counter_Station_Halt <= ( five * ten - 2 );
--						Station_Halt <=( five * ten - 2 );
--						okay <=1;
--					else 
--						Counter_Station_Halt <= Counter_Station_Halt - 1; 
--						Station_Halt <=  Counter_Station_Halt;
--					end if;
				elsif(Stop = '1') then
					Counter_Stop <= Counter_Stop + 1;
				end if;
		    end if;
			if(Chance_Delay_Enable_3 = '1') then 
				if(Counter = five * ten )then	
				   Finish_Chance_3 <= '1'; 
				   Chance_Delay_Enable_3 <= '0';
				   Finish_C3 <= false;	
				   Clculate_Time <= Clculate_Time + Counter + (Time_Distance_5KM * ten) + 1;
				   --Counter_Station_Halt <= 0;
--				   Station_Halt <= 0;
--				   okay <= 0;
				   Counter <= 0; 
			    elsif(Stop = '0') then
					Counter <= Counter + 1;	
					--if(okay = 0) then 
--						Counter_Station_Halt <= ( five * ten - 2 );
--						Station_Halt <=( five * ten - 2 );
--						okay <=1;
--					else 
--						Counter_Station_Halt <= Counter_Station_Halt - 1; 
--						Station_Halt <=  Counter_Station_Halt;
--					end if;
				elsif(Stop = '1') then
					Counter_Stop <= Counter_Stop + 1;
				end if;
		    end if;
			if(Chance_Delay_Enable_4 = '1') then 
				if(Counter = five * ten )then	
				   Finish_Chance_4 <= '1'; 
				   Chance_Delay_Enable_4 <= '0'; 
				   Finish_C4 <= false;
				   Clculate_Time <= Clculate_Time + Counter + (Time_Distance_5KM * ten) + 1;
				   --Counter_Station_Halt <= 0;
--				   Station_Halt <= 0;
--				   okay <= 0;
				   Counter <= 0; 
			    elsif(Stop = '0') then
					Counter <= Counter + 1;
					--if(okay = 0) then 
--						Counter_Station_Halt <= ( five * ten - 2 );
--						Station_Halt <=( five * ten - 2 );
--						okay <=1;
--					else 
--						Counter_Station_Halt <= Counter_Station_Halt - 1; 
--						Station_Halt <=  Counter_Station_Halt;
--					end if;
				elsif(Stop = '1') then
					Counter_Stop <= Counter_Stop + 1;
				end if;
		    end if;
			
			if(Chance = '1') then 
			   if(Finish_C5 = true) then
					Chance_Delay_Enable_5 <= '1'; 
			        --Station_Number_LFSR <= 3;
			   end if;
			   --Station_Number_LFSR <= to_integer(unsigned(pseudo_rand(3 downto 0)));
		    end if;	
			if(Chance = '0') then 
				Finish_Chance_5 <= '0';
		    end if;
		end if;--CM5
		if(CM = "0100000") then	
			Finish_Chance_1 <= '0';
			Finish_Chance_2	<= '0';
			Finish_Chance_3	<= '0';
			Finish_Chance_4	<= '0';
			Finish_Chance_5	<= '0';	
			
			if(Emerg_Delay_Enable_5 = '0' and Chance_Delay_Enable_1 = '0' and Chance_Delay_Enable_2 = '0' and Chance_Delay_Enable_3 = '0' and Chance_Delay_Enable_4 = '0' and Chance_Delay_Enable_5 = '0' ) then --normal without emergancy or chance
			  if(Counter = Path_Time_integer_0_3  * ten - 1) then	
				 Finish6 <= '1';
				 Clculate_Time <= Clculate_Time + Counter + (Time_Distance_5KM * ten) + 1;
				 Counter_Station_Halt <= 0;
				 Station_Halt <= 0;
				 okay <= 0;
				 Counter <= 0;
			  
			  elsif(Stop = '0') then
				  Counter <= Counter + 1;
				  if(okay = 0) then 
						Counter_Station_Halt <= (Path_Time_integer_0_3 * ten - 2 );
						Station_Halt <=(Path_Time_integer_0_3 * ten - 2 );
						okay <=1;
				  else 
						Counter_Station_Halt <= Counter_Station_Halt - 1; 
						Station_Halt <=  Counter_Station_Halt;
				  end if;
			  elsif(Stop = '1') then
					Counter_Stop <= Counter_Stop + 1;
			  end if;
		    end if;
			if(Emerg_Delay_Enable_5 = '1') then ----answer to emergancy of state 5
				if(Counter = (Path_Time_integer_0_3  + ten) * ten - 1) then	
				   Finish6 <= '1';
				   Clculate_Time <= Clculate_Time + Counter + (Time_Distance_5KM * ten) + 1;
				   Counter <= 0;
				   Emerg_Delay_Enable_5 <= '0';
			    
			    elsif(Stop = '0') then
					Counter <= Counter + 1;
				elsif(Stop = '1') then
					Counter_Stop <= Counter_Stop + 1;
				end if;
		    end if;
			if(Chance_Delay_Enable_1 = '1') then 
				if(Counter = five * ten )then	
				   Finish_Chance_1 <= '1'; 
				   Chance_Delay_Enable_1 <= '0';
				   Finish_C1 <= false;
				   Clculate_Time <= Clculate_Time + Counter + (Time_Distance_5KM * ten) + 1 ; 
				   --Counter_Station_Halt <= 0;
--				   Station_Halt <= 0;
--				   okay <= 0;
				   Counter <= 0; 
			    elsif(Stop = '0') then
					Counter <= Counter + 1;	
					--if(okay = 0) then 
--						Counter_Station_Halt <= ( five * ten - 2 );
--						Station_Halt <=( five * ten - 2 );
--						okay <=1;
--					else 
--						Counter_Station_Halt <= Counter_Station_Halt - 1; 
--						Station_Halt <=  Counter_Station_Halt;
--					end if;
				elsif(Stop = '1') then
					Counter_Stop <= Counter_Stop + 1;
				end if;
		    end if;
			if(Chance_Delay_Enable_2 = '1') then 
				if(Counter = five * ten )then	
				   Finish_Chance_2 <= '1'; 
				   Chance_Delay_Enable_2 <= '0'; 
				   Finish_C2 <= false;
				   Clculate_Time <= Clculate_Time + Counter + (Time_Distance_5KM * ten) + 1; 
				   --Counter_Station_Halt <= 0;
--				   Station_Halt <= 0;
--				   okay <= 0;
				   Counter <= 0; 
			    elsif(Stop = '0') then
					Counter <= Counter + 1;	
					--if(okay = 0) then 
--						Counter_Station_Halt <= ( five * ten - 2 );
--						Station_Halt <=( five * ten - 2 );
--						okay <=1;
--					else 
--						Counter_Station_Halt <= Counter_Station_Halt - 1; 
--						Station_Halt <=  Counter_Station_Halt;
--					end if;
				elsif(Stop = '1') then
					Counter_Stop <= Counter_Stop + 1;
				end if;
		    end if;
			if(Chance_Delay_Enable_3 = '1') then 
				if(Counter = five * ten )then	
				   Finish_Chance_3 <= '1'; 
				   Chance_Delay_Enable_3 <= '0';
				   Finish_C3 <= false;
				   Clculate_Time <= Clculate_Time + Counter + (Time_Distance_5KM * ten) + 1; 
				  -- Counter_Station_Halt <= 0;
--				   Station_Halt <= 0;
--				   okay <= 0;
				   Counter <= 0; 
			    elsif(Stop = '0') then
					Counter <= Counter + 1;
					--if(okay = 0) then 
--						Counter_Station_Halt <= ( five * ten - 2 );
--						Station_Halt <=( five * ten - 2 );
--						okay <=1;
--					else 
--						Counter_Station_Halt <= Counter_Station_Halt - 1; 
--						Station_Halt <=  Counter_Station_Halt;
--					end if;
				elsif(Stop = '1') then
					Counter_Stop <= Counter_Stop + 1;
				end if;
		    end if;
			if(Chance_Delay_Enable_4 = '1') then 
				if(Counter = five * ten )then	
				   Finish_Chance_4 <= '1'; 
				   Chance_Delay_Enable_4 <= '0';
				   Finish_C4 <= false;
				   Clculate_Time <= Clculate_Time + Counter + (Time_Distance_5KM * ten) + 1;
				   --Counter_Station_Halt <= 0;
--				   Station_Halt <= 0;
--				   okay <= 0;
				   Counter <= 0; 
			    elsif(Stop = '0') then
					Counter <= Counter + 1;	
					--if(okay = 0) then 
--						Counter_Station_Halt <= ( five * ten - 2 );
--						Station_Halt <=( five * ten - 2 );
--						okay <=1;
--					else 
--						Counter_Station_Halt <= Counter_Station_Halt - 1; 
--						Station_Halt <=  Counter_Station_Halt;
--					end if;
				elsif(Stop = '1') then
					Counter_Stop <= Counter_Stop + 1;
				end if;
		    end if;
			if(Chance_Delay_Enable_5 = '1') then 
				if(Counter = five * ten )then	
				   Finish_Chance_5 <= '1'; 
				   Chance_Delay_Enable_5 <= '0'; 
				   Finish_C5 <= false;	
				   Clculate_Time <= Clculate_Time + Counter + (Time_Distance_5KM * ten) + 1; 
				   --Counter_Station_Halt <= 0;
--				   Station_Halt <= 0;
--				   okay <= 0;
				   Counter <= 0; 
			    elsif(Stop = '0') then
					Counter <= Counter + 1;
					--if(okay = 0) then 
--						Counter_Station_Halt <= ( five * ten - 2 );
--						Station_Halt <=( five * ten - 2 );
--						okay <=1;
--					else 
--						Counter_Station_Halt <= Counter_Station_Halt - 1; 
--						Station_Halt <=  Counter_Station_Halt;
--					end if;
				elsif(Stop = '1') then
					Counter_Stop <= Counter_Stop + 1;
				end if;
		    end if;
		
		end if;--CM6 
		
	end if;--reset
	Total_Time <= (Clculate_Time + Counter_Stop ) / ten;	
end process;
process(Finish1,Finish2,Finish3,Finish4,Finish5,Finish6,current_state,CM,Finish_Chance_1,Finish_Chance_2,Finish_Chance_3,Finish_Chance_4,Finish_Chance_5,Station_Number_LFSR)
variable active_machine : std_logic:='0';
begin
	case current_state is
		
		when s0 =>
			 --if (Stop = '1') then
		        -- active_machine:='0';
				 --Open_Close <= '1';
	         --elsif (Start = '1') then
	           -- active_machine:='1'; 
				---Open_Close <= '0';
				next_state <= s1;
	         --end if; 
		when s1 => 
		
		Station_Number <= Path_station_number_integer_44_47;
		CM <= "0000001"; 
		Open_Close <= '1';
		if(Emergency = '1') then
			Open_Close <= '0';
			CM <= "0000010";
			next_state <= s2;
			
		end if;
		if(Finish1 = '1') then --answer to emergancy of state 1	 
			CM <= "0000010"; 
			Open_Close <= '0';
			next_state <= s2;
	    end if;
		--if(Finish_Chance_1 = '1') then
			--CM <= "0000010";
			--next_state <= s2;
			
	    --end if;
		if(Finish_Chance_2 = '1') then
			CM <= "0000100"; 
			Open_Close <= '0';
			next_state <= s3;
	    end if;
		if(Finish_Chance_3 = '1') then
			CM <= "0001000";
			Open_Close <= '0';
			next_state <= s4;
	    end if;
		if(Finish_Chance_4 = '1') then
			CM <= "0010000"; 
			Open_Close <= '0';
			next_state <= s5;
	    end if;
		if(Finish_Chance_5 = '1') then
			CM <= "0100000"; 
			Open_Close <= '0';
			next_state <= s6;
	    end if;
		if(Chance = '1') then
			--Station_Number_LFSR <= to_integer(unsigned(pseudo_rand(3 downto 0)));
			    --Station_Number_LFSR <= 2;
			    if(Station_Number_LFSR = Path_station_number_integer_44_47) then 
					CM <= "0000001";
					Open_Close <= '0';
				    next_state <= s1;
			    end if;	
			    if(Station_Number_LFSR = Path_station_number_integer_36_39) then
				   CM <= "0000010";
				   Open_Close <= '0';
				   next_state <= s2;
				   
			    end if;	
			
			    if(Station_Number_LFSR = Path_station_number_integer_28_31) then
					CM <= "0000100"; 
					Open_Close <= '0';
				    next_state <= s3;
				   
			    end if;	
			    if(Station_Number_LFSR = Path_station_number_integer_20_23) then
					CM <= "0001000"; 
					Open_Close <= '0';
				    next_state <= s4;
				   
			    end if;	
			   if(Station_Number_LFSR = Path_station_number_integer_12_15) then
				   CM <= "0010000";	
				   Open_Close <= '0';
				   next_state <= s5;
				  
				 
			       end if;	
			    if(Station_Number_LFSR = Path_station_number_integer_4_7) then 
					CM <= "0100000";
					Open_Close <= '0';
			     	next_state <= s6;
					 
			    	
			   end if;
		end if;
		
			
		when s2 => 
		Station_Number <= Path_station_number_integer_36_39;
		Open_Close <= '1';
		CM <= "0000010"; 
		if(Finish2 = '1') then --answer to emergancy of state 1	 
			CM <= "0000100";
			Open_Close <= '0';
			next_state <= s3;
	    end if;
		if(Emergency = '1') then
			CM <= "0000100"; 
			Open_Close <= '0';
			next_state <= s3;
		end if;
		if(Finish_Chance_1 = '1') then
			CM <= "0000010"; 
			Open_Close <= '0';
			next_state <= s2;
	    end if;
		--if(Finish_Chance_2 = '1') then
			--CM <= "0000100";
			--next_state <= s3;
	   -- end if;
		if(Finish_Chance_3 = '1') then
			CM <= "0001000";
			Open_Close <= '0';
			next_state <= s4;
	    end if;
		if(Finish_Chance_4 = '1') then
			CM <= "0010000"; 
			Open_Close <= '0';
			next_state <= s5;
	    end if;
		if(Finish_Chance_5 = '1') then
			CM <= "0100000"; 
			Open_Close <= '0';
			next_state <= s6;
	    end if;
		if(Chance = '1') then
			--Station_Number_LFSR <= 1;
			if(Station_Number_LFSR = Path_station_number_integer_44_47) then 
				CM <= "0000001"; 
				Open_Close <= '0';
				next_state <= s1;
			end if;	
			if(Station_Number_LFSR = Path_station_number_integer_36_39) then
				CM <= "0000010";
				Open_Close <= '0';
				next_state <= s2;
				   
				   
			end if;	
			
			if(Station_Number_LFSR = Path_station_number_integer_28_31) then
			   CM <= "0000100";	 
			   Open_Close <= '0';
			   next_state <= s3;
				   
			end if;	
			if(Station_Number_LFSR = Path_station_number_integer_20_23) then
			   CM <= "0001000";	 
			   Open_Close <= '0';
			   next_state <= s4;
				   
			end if;	
		    if(Station_Number_LFSR = Path_station_number_integer_12_15) then
				CM <= "0010000";
				Open_Close <= '0';
				next_state <= s5;
		    end if;	
			if(Station_Number_LFSR = Path_station_number_integer_4_7) then 
				CM <= "0100000"; 
				Open_Close <= '0';
			    next_state <= s6;
					
			    	
			end if;    
			
			--Station_Number_LFSR <= to_integer(unsigned(pseudo_rand(3 downto 0)));
			    
		end if;
			
		when s3 => 
		Station_Number <= Path_station_number_integer_28_31; 
		Open_Close <= '1';
		CM <= "0000100"; 
		if(Finish3 = '1') then --answer to emergancy of state 2	 
			CM <= "0001000";
			Open_Close <= '0';
			next_state <= s4;
	    end if;
		if(Emergency = '1') then
			CM <= "0001000";
			Open_Close <= '0';
			next_state <= s4;
		end if;
		if(Finish_Chance_1 = '1') then
			CM <= "0000010";
			Open_Close <= '0';
			next_state <= s2;
	    end if;
		if(Finish_Chance_2 = '1') then
			CM <= "0000100"; 
			Open_Close <= '0';
			next_state <= s3;
	    end if;
		--if(Finish_Chance_3 = '1') then
			--CM <= "0001000";
			--next_state <= s4;
	    --end if;
		if(Finish_Chance_4 = '1') then
			CM <= "0010000";
			Open_Close <= '0';
			next_state <= s5;
	    end if;
		if(Finish_Chance_5 = '1') then
			CM <= "0100000";
			Open_Close <= '0';
			next_state <= s6;
	    end if;
		if(Chance = '1') then
			--Station_Number_LFSR <= to_integer(unsigned(pseudo_rand(3 downto 0)));
			    --Station_Number_LFSR <= 2;
			    if(Station_Number_LFSR = Path_station_number_integer_44_47) then 
					CM <= "0000001";
					Open_Close <= '0';
				   next_state <= s1;
			    end if;	
			    if(Station_Number_LFSR = Path_station_number_integer_36_39) then
				   CM <= "0000010";
				   Open_Close <= '0';
				   next_state <= s2;
				   
			    end if;	
			
			    if(Station_Number_LFSR = Path_station_number_integer_28_31) then
					CM <= "0000100";
					Open_Close <= '0';
				   next_state <= s3;
				   
			    end if;	
			    if(Station_Number_LFSR = Path_station_number_integer_20_23) then
					CM <= "0001000";
					Open_Close <= '0';
				   next_state <= s4;
				   
			    end if;	
			   if(Station_Number_LFSR = Path_station_number_integer_12_15) then
				   CM <= "0010000";	
				   Open_Close <= '0';
				   next_state <= s5;
				 
			       end if;	
			    if(Station_Number_LFSR = Path_station_number_integer_4_7) then 
					CM <= "0100000"; 
					Open_Close <= '0';
			     	next_state <= s6;
			    	
			   end if;
		end if;
		when s4 => 
		Station_Number <= Path_station_number_integer_20_23;  
		Open_Close <= '1';
		CM <= "0001000"; 
		if(Finish4 = '1') then --answer to emergancy of state 3	
			CM <= "0010000";
			Open_Close <= '0';
			next_state <= s5;
	    end if;
		if(Emergency = '1') then
			CM <= "0010000"; 
			Open_Close <= '0';
			next_state <= s5;
		end if;
		if(Finish_Chance_1 = '1') then
			CM <= "0000010"; 
			Open_Close <= '0';
			next_state <= s2;
	    end if;
		if(Finish_Chance_2 = '1') then
			CM <= "0000100"; 
			Open_Close <= '0';
			next_state <= s3;
	    end if;
		if(Finish_Chance_3 = '1') then
			CM <= "0001000"; 
			Open_Close <= '0';
			next_state <= s4;
	    end if;
		--if(Finish_Chance_4 = '1') then
			---CM <= "0010000";
			--next_state <= s5;
	    --end if;
		if(Finish_Chance_5 = '1') then
			CM <= "0100000";
			Open_Close <= '0';
			next_state <= s6;
	    end if;
		if(Chance = '1') then
			--Station_Number_LFSR <= to_integer(unsigned(pseudo_rand(3 downto 0)));
			    --Station_Number_LFSR <= 2;
			    if(Station_Number_LFSR = Path_station_number_integer_44_47) then 
					CM <= "0000001";
					Open_Close <= '0';
				    next_state <= s1;
			    end if;	
			    if(Station_Number_LFSR = Path_station_number_integer_36_39) then
				   CM <= "0000010";	
				   Open_Close <= '0';
				   next_state <= s2;
				   
			    end if;	
			
			    if(Station_Number_LFSR = Path_station_number_integer_28_31) then
					CM <= "0000100";  
					Open_Close <= '0';
				    next_state <= s3;
				   
			    end if;	
			    if(Station_Number_LFSR = Path_station_number_integer_20_23) then
					CM <= "0001000";  
					Open_Close <= '0';
				    next_state <= s4;
				   
			    end if;	
			   if(Station_Number_LFSR = Path_station_number_integer_12_15) then
				   CM <= "0010000";	
				   Open_Close <= '0';
				   next_state <= s5;
				 
			       end if;	
			    if(Station_Number_LFSR = Path_station_number_integer_4_7) then 
					CM <= "0100000";
					Open_Close <= '0';
			     	next_state <= s6;
			    	
			   end if;
		end if;
		when s5 => 
		Station_Number <= Path_station_number_integer_12_15; 
		Open_Close <= '1';
		CM <= "0010000"; 
		if(Finish5 = '1') then --answer to emergancy of state 4	 
			CM <= "0100000";
			Open_Close <= '0';
			next_state <= s6;
	    end if;
		if(Emergency = '1') then
			CM <= "0100000"; 
			Open_Close <= '0';
			next_state <= s6;
		end if;
		if(Finish_Chance_1 = '1') then
			CM <= "0000010";   
			Open_Close <= '0';
			next_state <= s2;
	    end if;
		if(Finish_Chance_2 = '1') then
			CM <= "0000100"; 
			Open_Close <= '0';
			next_state <= s3;
	    end if;
		if(Finish_Chance_3 = '1') then
			CM <= "0001000";
			Open_Close <= '0';
			next_state <= s4;
	    end if;
		if(Finish_Chance_4 = '1') then
			CM <= "0010000"; 
			Open_Close <= '0';
			next_state <= s5;
	    end if;
		--if(Finish_Chance_5 = '1') then
			--CM <= "0100000";
			--next_state <= s6;
	    --end if;
		if(Chance = '1') then
			--Station_Number_LFSR <= to_integer(unsigned(pseudo_rand(3 downto 0)));
			    --Station_Number_LFSR <= 2;
			    if(Station_Number_LFSR = Path_station_number_integer_44_47) then 
					CM <= "0000001";
					Open_Close <= '0';
				   next_state <= s1;
			    end if;	
			    if(Station_Number_LFSR = Path_station_number_integer_36_39) then
				   CM <= "0000010";
				   Open_Close <= '0';
				   next_state <= s2;
				   
			    end if;	
			
			    if(Station_Number_LFSR = Path_station_number_integer_28_31) then
					CM <= "0000100";
					Open_Close <= '0';
				    next_state <= s3;
				   
			    end if;	
			    if(Station_Number_LFSR = Path_station_number_integer_20_23) then
					CM <= "0001000"; 
					Open_Close <= '0';
				    next_state <= s4;
				   
			    end if;	
			   if(Station_Number_LFSR = Path_station_number_integer_12_15) then
				   CM <= "0010000";	
				   Open_Close <= '0';
				   next_state <= s5;
				 
			       end if;	
			    if(Station_Number_LFSR = Path_station_number_integer_4_7) then 
					CM <= "0100000";
					Open_Close <= '0';
			     	next_state <= s6;
			    	
			   end if;
		end if;
		when s6 => 	 
		Station_Number <= Path_station_number_integer_4_7;		
		Open_Close <= '1';
		CM <= "0100000"; 
		if(Finish6 = '1') then --answer to emergancy of state 4	
			CM <= "0000000";  
			Open_Close <= '0';
			next_state <= s0;
	    end if;	
		if(Emergency = '1') then
			CM <= "0000000"; 
			Open_Close <= '0';
			next_state <= s0;
		end if;
		if(Finish_Chance_1 = '1') then
			CM <= "0000010";
			Open_Close <= '0';
			next_state <= s2;
	    end if;
		if(Finish_Chance_2 = '1') then
			CM <= "0000100";  
			Open_Close <= '0';
			next_state <= s3;
	    end if;
		if(Finish_Chance_3 = '1') then
			CM <= "0001000"; 
			Open_Close <= '0';
			next_state <= s4;
	    end if;
		if(Finish_Chance_4 = '1') then
			CM <= "0010000"; 
			Open_Close <= '0';
			next_state <= s5;
	    end if;
		if(Finish_Chance_5 = '1') then
			CM <= "0100000";  
			Open_Close <= '0';
			next_state <= s6;
	    end if;
		
		when others =>
		next_state <= s0;
			
	end case;	
end process;


end Auto_Car;
