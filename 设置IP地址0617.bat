title 设置IP地址
@echo off
setlocal enabledelayedexpansion
color 71

set NAME="本地连接 2"	
set "MASK=255.255.255.0"

set IPs=4
set /a index1=%IPs%+1
set /a index2=%IPs%+2
set /a index3=%IPs%+3
set /a index4=%IPs%+4

set IP1=10.176.3.253
set MASK1=%MASK%
set GATE1=10.176.3.254

set IP2=192.168.2.222
set MASK2=%MASK%
set GATE2=192.168.2.1

set IP3=192.168.1.111
set MASK3=%MASK%
set GATE3=192.168.1.1

set IP4=172.31.220.1
set MASK4=%MASK%
set GATE4=172.31.220.254

SET _startchar=0
SET _length=%IPs%
SET _num=123456789
CALL SET _loop=%%_num:~%_startchar%,%_length%%%
set /a "_loop=%_loop%%index1%%index2%%index3%%index4%"

cls
Call :displayIPinfo disp
:start
echo.******************************* 菜单 *******************************
echo.*请输入相应数字来运行功能：（输入1-%index4%）*
echo.
for /L %%j in (1,1,%IPs%) do ( echo  %%j：IP地址设置为：!IP%%j!  网关: !GATE%%j!  子网掩码: !MASK%%j! )
echo.
echo. %index1%: 添加以上所有IP地址到网卡：%NAME%
echo.
echo. %index2%：输入IP地址进行设置（使用单独的IP地址）
echo.
echo. %index3%: 自动获取IP地址
echo.
echo. %index4%: 显示网卡的IP信息
echo.******************************* 菜单 *******************************
goto select

:select
choice /c %_loop% /n /m "*请输入相应数字："
if errorlevel %index4% goto cfgIP
if errorlevel %index3% goto autoIP
if errorlevel %index2% goto inputIP
if errorlevel %index1% goto addIP
for /L %%i in (%IPs%,-1,1) do (if errorlevel %%i goto setIP%%i )


:setIP1
cls
echo. 正在设置IP：%IP1%，网关：%GATE1%
netsh interface ip set address %NAME% static %IP1% %MASK1% %GATE1%
choice /t 4 /d y /n >nul
Call :displayIPinfo disp
goto start

:setIP2
cls
echo. 正在设置IP：%IP2%，网关：%GATE2%
netsh interface ip set address %NAME% static %IP2% %MASK2% %GATE2%
choice /t 4 /d y /n >nul
Call :displayIPinfo disp
goto start

:setIP3
cls
echo. 正在设置IP：%IP3%，网关：%GATE3%
netsh interface ip set address %NAME% static %IP3% %MASK3% %GATE3%
choice /t 4 /d y /n >nul
Call :displayIPinfo disp
goto start

:setIP4
cls
echo. 正在设置IP：%IP4%，网关：%GATE4%
netsh interface ip set address %NAME% static %IP4% %MASK4% %GATE4%
choice /t 4 /d y /n >nul
Call :displayIPinfo disp
goto start

:setIP5
cls
echo. 正在设置IP：%IP5%，网关：%GATE5%
netsh interface ip set address %NAME% static %IP5% %MASK5% %GATE5%
choice /t 4 /d y /n >nul
Call :displayIPinfo disp
goto start

:addIP
cls
echo 添加  IP1: %IP1%
echo 添加网关1: %GATE1%
netsh interface ip set address %NAME% static %IP1% %MASK1% %GATE1%
for /L %%i in (2,1,%IPs%) do (
echo 添加  IP%%i: !IP%%i!
echo 添加网关%%i: !GATE%%i!
netsh interface ip add address %NAME% !IP%%i! %MASK% !GATE%%i! 
							)
echo.正在添加IP地址，请稍等...
choice /t 3 /d y /n >nul
echo.添加完毕...
choice /t 1 /d y /n >nul
echo ///////////////// ipconfig ////////////////
ipconfig
echo ///////////////// ipconfig ////////////////
choice /t 5 /d y /n >nul
echo.
goto start

:inputIP
cls
Call :displayIPinfo disp
echo.
echo 手动设置IP地址（默认子网掩码: 255.255.255.0）: 
echo.
set /p IPin= IP地址: 
set /p "MASK= 子网掩码:【按下回车为%MASK%】"
set /p GATEin= 网  关: 
echo..........
netsh interface ip set address %NAME% static %IPin% %MASK% %GATEin% 
echo.请稍等...
choice /t 4 /d y /n >nul
echo..........
cls
Call :displayIPinfo disp
echo.
goto start

:autoIP
cls
echo 设置的IP地址将被清除...
echo *  IP设置为自动获取（DHCP） *
netsh interface ip set address %NAME% source=dhcp
choice /t 2 /d y /n >nul
Call :displayIPinfo disp
echo.-----------------------------------------------------------
goto start

:cfgIP
cls
echo. 
echo ///////////////// ipconfig ////////////////
ipconfig
echo ///////////////// ipconfig ////////////////
echo. 
choice /t 5 /d y /n >nul
goto start

:displayIPinfo
for /f "tokens=2 delims=:" %%i in ('ipconfig^|findstr "IPv4"')     do set IPnow=%%i
for /f "tokens=2 delims=:" %%i in ('ipconfig^|findstr "子网掩码"') do set MASKnow=%%i
for /f "tokens=2 delims=:" %%i in ('ipconfig^|findstr "默认网关"') do set GATEnow=%%i
echo ------------------------------------------
echo 当前IP地址  ：%IPnow%
echo 当前子网掩码：%MASKnow%
echo 当前默认网关：%GATEnow%