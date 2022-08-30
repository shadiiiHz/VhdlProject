SetActiveLib -work
comp -include "$dsn\src\Auto_Car.vhd" 
comp -include "$dsn\src\TestBench\auto_car_TB.vhd" 
asim +access +r TESTBENCH_FOR_auto_car 
wave 
wave -noreg Clock
wave -noreg Start
wave -noreg Reset
wave -noreg Speed
wave -noreg Path_Station_and_Time
wave -noreg Emergency
wave -noreg Stop
wave -noreg Chance
wave -noreg Total_Time
wave -noreg Station_Halt
wave -noreg NextStation_Left
wave -noreg Station_Number
wave -noreg Open_Close
# The following lines can be used for timing simulation
# acom <backannotated_vhdl_file_name>
# comp -include "$dsn\src\TestBench\auto_car_TB_tim_cfg.vhd" 
# asim +access +r TIMING_FOR_auto_car 
