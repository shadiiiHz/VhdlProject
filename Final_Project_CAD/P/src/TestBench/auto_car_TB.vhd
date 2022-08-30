library ieee;
use ieee.NUMERIC_STD.all;
use ieee.std_logic_1164.all;

	-- Add your library and packages declaration here ...

entity auto_car_tb is
end auto_car_tb;

architecture TB_ARCHITECTURE of auto_car_tb is
	-- Component declaration of the tested unit
	component auto_car
	port(
		Clock : in STD_LOGIC;
		Start : in STD_LOGIC;
		Reset : in STD_LOGIC;
		Speed : in STD_LOGIC_VECTOR(2 downto 0);
		Path_Station_and_Time : in STD_LOGIC_VECTOR(47 downto 0);
		Emergency : in STD_LOGIC;
		Stop : in STD_LOGIC;
		Chance : in STD_LOGIC;
		Total_Time : out INTEGER;
		Station_Halt : out INTEGER;
		NextStation_Left : out STD_LOGIC_VECTOR(7 downto 0);
		Station_Number : out INTEGER;
		Open_Close : out STD_LOGIC );
	end component;

	-- Stimulus signals - signals mapped to the input and inout ports of tested entity
	signal Clock : STD_LOGIC;
	signal Start : STD_LOGIC;
	signal Reset : STD_LOGIC;
	signal Speed : STD_LOGIC_VECTOR(2 downto 0);
	signal Path_Station_and_Time : STD_LOGIC_VECTOR(47 downto 0);
	signal Emergency : STD_LOGIC;
	signal Stop : STD_LOGIC;
	signal Chance : STD_LOGIC;
	-- Observed signals - signals mapped to the output ports of tested entity
	signal Total_Time : INTEGER;
	signal Station_Halt : INTEGER;
	signal NextStation_Left : STD_LOGIC_VECTOR(7 downto 0);
	signal Station_Number : INTEGER;
	signal Open_Close : STD_LOGIC;

	

begin

	-- Unit Under Test port map
	UUT : auto_car
		port map (
			Clock => Clock,
			Start => Start,
			Reset => Reset,
			Speed => Speed,
			Path_Station_and_Time => Path_Station_and_Time,
			Emergency => Emergency,
			Stop => Stop,
			Chance => Chance,
			Total_Time => Total_Time,
			Station_Halt => Station_Halt,
			NextStation_Left => NextStation_Left,
			Station_Number => Station_Number,
			Open_Close => Open_Close
		);

	Clock <= '0', '1' after 2ns, '0' after 3ns, '1' after 4ns, '0' after 5ns, '1' after 6ns, '0' after 7ns,
	'1' after 8ns,  '0' after 9ns,  '1' after 10ns,  '0' after 11ns,  '1' after 12ns,  '0' after 13ns,  '1' after 14ns,
	'0' after 15ns,  '1' after 16ns,  '0' after 17ns,  '1' after 18ns,  '0' after 19ns,  '1' after 20ns,  '0' after 21ns, '1' after 22ns,
	'0' after 23ns,  '1' after 24ns,  '0' after 25ns,  '1' after 26ns,  '0' after 27ns,  '1' after 28ns,  '0' after 29ns, '1' after 30ns,
	'0' after 31ns,  '1' after 32ns,  '0' after 33ns,  '1' after 34ns,  '0' after 35ns, '1' after 36ns, '0' after 37ns, '1' after 38ns, '0' after 39ns, '1' after 40ns, '0' after 41ns,
	'1' after 42ns,  '0' after 43ns,  '1' after 44ns,  '0' after 45ns,  '1' after 46ns,  '0' after 47ns,  '1' after 48ns,
	'0' after 49ns,  '1' after 50ns,  '0' after 51ns,  '1' after 52ns,  '0' after 53ns,  '1' after 54ns,  '0' after 55ns, '1' after 56ns,
	'0' after 57ns,  '1' after 58ns,  '0' after 59ns,  '1' after 60ns,  '0' after 61ns,  '1' after 62ns,  '0' after 63ns, '1' after 64ns,
	'0' after 65ns,  '1' after 66ns,  '0' after 67ns,  '1' after 68ns,  '0' after 69ns, '1' after 70ns, '0' after 71ns, '1' after 72ns, '0' after 73ns, '1' after 74ns, '0' after 75ns,
	'1' after 76ns,  '0' after 77ns,  '1' after 78ns,  '0' after 79ns,  '1' after 80ns,  '0' after 81ns,  '1' after 82ns,
	'0' after 83ns,  '1' after 84ns,  '0' after 85ns,  '1' after 86ns,  '0' after 87ns,  '1' after 88ns,  '0' after 89ns, '1' after 90ns,
	'0' after 91ns,  '1' after 92ns,  '0' after 93ns,  '1' after 94ns,  '0' after 95ns,  '1' after 96ns,  '0' after 97ns, '1' after 98ns,
	'0' after 99ns,  '1' after 100ns,  '0' after 101ns,  '1' after 102ns,  '0' after 103ns, '1' after 104ns, '0' after 105ns, '1' after 106ns, '0' after 107ns, '1' after 108ns, '0' after 109ns,
	'0' after 110ns,  '1' after 111ns,  '0' after 112ns,  '1' after 113ns,  '0' after 114ns,  '1' after 115ns,  '0' after 116ns, '1' after 117ns,
	'0' after 118ns,  '1' after 119ns,  '0' after 120ns,  '1' after 121ns,  '0' after 122ns,  '1' after 123ns,  '0' after 124ns, '1' after 125ns,
	'0' after 126ns,  '1' after 127ns,  '0' after 128ns,  '1' after 129ns,  '0' after 130ns,  '1' after 131ns,  '0' after 132ns, '1' after 133ns,
	'0' after 134ns,  '1' after 135ns,  '0' after 136ns,  '1' after 137ns,  '0' after 138ns;
    reset <= '1', '0' after 5ns;
	Start <= '1';
	Path_Station_and_Time <= "000100010010000100110001010000010101000101100001";
	--Emergency <= '1';
	--Emergency <= '1', '0' after 48ns;
	Chance <= '0', '1' after 16ns, '0' after 30ns;
	stop <= '0';
	Speed <= "101";

end TB_ARCHITECTURE;

configuration TESTBENCH_FOR_auto_car of auto_car_tb is
	for TB_ARCHITECTURE
		for UUT : auto_car
			use entity work.auto_car(auto_car);
		end for;
	end for;
end TESTBENCH_FOR_auto_car;

