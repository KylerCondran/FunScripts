@echo off
set ip1=192
set ip2=168
set ip3=1
set ip4=1
:start
ping -n 1 %ip1%.%ip2%.%ip3%.%ip4% | find /i "unreachable" >nul>nul
if not errorlevel 1 goto next
if errorlevel 1 goto found
:found
echo found %ip1%.%ip2%.%ip3%.%ip4% 
:next
if /i %ip4% NEQ 256 set /a ip4=%ip4%+1
if /i %ip4% EQU 256 set /a ip3=%ip3%+1
if /i %ip4% EQU 256 set /a ip4=1
if %ip4% NEQ 256 goto start