@echo off
set xv_path=C:\\Xilinx\\Vivado\\2016.4\\bin
call %xv_path%/xsim averager_tb_behav -key {Behavioral:sim_1:Functional:averager_tb} -tclbatch averager_tb.tcl -view C:/Users/Mike/Documents/ECE_492_SeniorProject/ultrasonicRadar2D/triangleCalculate_ver2_tb_behav.wcfg -log simulate.log
if "%errorlevel%"=="0" goto SUCCESS
if "%errorlevel%"=="1" goto END
:END
exit 1
:SUCCESS
exit 0
