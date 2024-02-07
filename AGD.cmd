@echo off                           
prompt $$ 
rem chcp 65001
mode con: cols=120 lines=50
for /f %%a in ('whoami') do set "whoami=%%a"

setlocal enabledelayedexpansion


REM Que version soy?
for %%F in ("%~f0") do set "fileSize=%%~zF"
cls

Title AGD Toolbox - %whoami% - Version %fileSize%

echo AGD Toolbox - v%fileSize%
echo --------------------
echo.

copy /Y "%~dp0AGD-update.cmd" "%~dp0AGD.cmd" >nul 2>&1


set AGDToolbox-URL=https://raw.githubusercontent.com/Nr2ar/AGDToolbox/main
set curl=curl.exe -H "Cache-Control: no-cache, no-store"
set ftp1=ftp://live
set ftp2=SoyLive666
set ftp3=ftp.nr2.com.ar
set ftp=%ftp1%:%ftp2%@%ftp3%:43321

REM ============================================================================
REM ============       PARAMETROS              =================================
REM ============================================================================


:parse
IF "%~1"=="" GOTO endparse


IF "%~1"=="help" goto %~1



:help
echo  * AYUDA *
echo.
echo    ip : muestra información de red y Windows
echo    total : instalar Total Commander
echo    reteam : fuerza reinstalacion de Teamviewer 13
echo.
echo    noupdate: No intentar actualizarse
echo    help: Esta ayuda
echo.
pause
exit /b


rem ------- No actualizar
IF "%~1"=="noupdate" (
	echo  * NO actualizar
rem *	GOTO verificando_requisitos
	)
rem ---------------



rem ------- ip
IF "%~1"=="ip" (

for /f %%a in ('wmic computersystem get domain ^| findstr /r /v "^$"') do (set ip_workgroup_domain=%%a)

echo. Host: !ip_workgroup_domain! - %whoami%

ipconfig /all | findstr /v /i /c:"Descrip" /c:"*" /c:"Teredo" | findstr /i /c:"adapt" /c:"Ethernet" /c:"IPv4" /c:"subred" /c:"subnet" /c:"Mask" /c:"Physical" /c:"sica." /c:"Puerta" /c:"Gateway" /c:"192." /c:".0"

echo.
for /f "delims=" %%i in ('curl.exe ifconfig.me 2^>nul') do set "ip_public=%%i"
for /f "tokens=2 delims=: " %%a in ('nslookup %ip_public% 2^>nul ^| findstr /C:"Name:" /C:"Nombre:"') do set "ip_hostname=%%a"

echo IP Publica: %ip_public% - %ip_hostname%

echo.

    pause
	)
rem ---------------

rem ------- total
IF "%~1"=="total" (

echo.
echo * Instalación de Total Commander

cd "%temp%"

%curl% --remote-name %ftp%/Install/TotalCommanderInstall11.exe

"%temp%\TotalCommanderInstall11.exe"

)
rem ---------------


rem ------- reteam
IF "%~1"=="reteam" (

echo.
echo * Instalación de Teamviewer 13

cd "%temp%"

%curl% --remote-name %ftp%/PORTABLES/ReTeam13.exe

"%temp%\ReTeam13.exe"

)
rem ---------------



SHIFT
GOTO parse
:endparse
REM ready for action!





exit /b

= = = = = = = = = = = = FIN = = = = = = = = = = = = =
