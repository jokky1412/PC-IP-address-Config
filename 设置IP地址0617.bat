title ����IP��ַ
@echo off
setlocal enabledelayedexpansion
color 71
rem CMD������ʾ��������
chcp 65001 > nul

rem WIN10ϵͳCMD��ȡ����ԱȨ��
%1 start "" mshta vbscript:CreateObject("Shell.Application").ShellExecute("cmd.exe","/c pushd ""%~dp0"" && ""%~s0"" ::","","runas",1)(window.close)&&exit


set NAME="�������� 2"	
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
echo.******************************* �˵� *******************************
echo.*��������Ӧ���������й��ܣ�������1-%index4%��*
echo.
for /L %%j in (1,1,%IPs%) do ( echo  %%j��IP��ַ����Ϊ��!IP%%j!  ����: !GATE%%j!  ��������: !MASK%%j! )
echo.
echo. %index1%: �����������IP��ַ��������%NAME%
echo.
echo. %index2%������IP��ַ�������ã�ʹ�õ�����IP��ַ��
echo.
echo. %index3%: �Զ���ȡIP��ַ
echo.
echo. %index4%: ��ʾ������IP��Ϣ
echo.******************************* �˵� *******************************
goto select

:select
choice /c %_loop% /n /m "*��������Ӧ���֣�"
if errorlevel %index4% goto cfgIP
if errorlevel %index3% goto autoIP
if errorlevel %index2% goto inputIP
if errorlevel %index1% goto addIP
for /L %%i in (%IPs%,-1,1) do (if errorlevel %%i goto setIP%%i )


:setIP1
cls
echo. ��������IP��%IP1%�����أ�%GATE1%
netsh interface ip set address %NAME% static %IP1% %MASK1% %GATE1%
choice /t 4 /d y /n >nul
Call :displayIPinfo disp
goto start

:setIP2
cls
echo. ��������IP��%IP2%�����أ�%GATE2%
netsh interface ip set address %NAME% static %IP2% %MASK2% %GATE2%
choice /t 4 /d y /n >nul
Call :displayIPinfo disp
goto start

:setIP3
cls
echo. ��������IP��%IP3%�����أ�%GATE3%
netsh interface ip set address %NAME% static %IP3% %MASK3% %GATE3%
choice /t 4 /d y /n >nul
Call :displayIPinfo disp
goto start

:setIP4
cls
echo. ��������IP��%IP4%�����أ�%GATE4%
netsh interface ip set address %NAME% static %IP4% %MASK4% %GATE4%
choice /t 4 /d y /n >nul
Call :displayIPinfo disp
goto start

:setIP5
cls
echo. ��������IP��%IP5%�����أ�%GATE5%
netsh interface ip set address %NAME% static %IP5% %MASK5% %GATE5%
choice /t 4 /d y /n >nul
Call :displayIPinfo disp
goto start

:addIP
cls
echo ���  IP1: %IP1%
echo �������1: %GATE1%
netsh interface ip set address %NAME% static %IP1% %MASK1% %GATE1%
for /L %%i in (2,1,%IPs%) do (
echo ���  IP%%i: !IP%%i!
echo �������%%i: !GATE%%i!
netsh interface ip add address %NAME% !IP%%i! %MASK% !GATE%%i! 
							)
echo.�������IP��ַ�����Ե�...
choice /t 3 /d y /n >nul
echo.������...
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
echo �ֶ�����IP��ַ��Ĭ����������: 255.255.255.0��: 
echo.
set /p IPin= IP��ַ: 
set /p "MASK= ��������:�����»س�Ϊ%MASK%��"
set /p GATEin= ��  ��: 
echo..........
netsh interface ip set address %NAME% static %IPin% %MASK% %GATEin% 
echo.���Ե�...
choice /t 4 /d y /n >nul
echo..........
cls
Call :displayIPinfo disp
echo.
goto start

:autoIP
cls
echo ���õ�IP��ַ�������...
echo *  IP����Ϊ�Զ���ȡ��DHCP�� *
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
for /f "tokens=2 delims=:" %%i in ('ipconfig^|findstr "��������"') do set MASKnow=%%i
for /f "tokens=2 delims=:" %%i in ('ipconfig^|findstr "Ĭ������"') do set GATEnow=%%i
echo ------------------------------------------
echo ��ǰIP��ַ  ��%IPnow%
echo ��ǰ�������룺%MASKnow%
echo ��ǰĬ�����أ�%GATEnow%