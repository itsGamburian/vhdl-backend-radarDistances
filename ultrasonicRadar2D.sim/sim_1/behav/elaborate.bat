@echo off
set xv_path=C:\\Xilinx\\Vivado\\2016.4\\bin
call %xv_path%/xelab  -wto 3d29406c5dc64099866e5cf69dcb3008 -m64 --debug typical --relax --mt 2 -L xil_defaultlib -L secureip -L xpm --snapshot averager_tb_behav xil_defaultlib.averager_tb -log elaborate.log
if "%errorlevel%"=="0" goto SUCCESS
if "%errorlevel%"=="1" goto END
:END
exit 1
:SUCCESS
exit 0
