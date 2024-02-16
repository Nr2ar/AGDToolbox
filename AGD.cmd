rem @echo off                           
prompt $$ 
chcp 65001
mode con: cols=120 lines=50
setlocal enableextensions enabledelayedexpansion

rem auto-install command line
rem curl -H "Cache-Control: no-cache, no-store" -Lo AGD-Toolbox.cmd http://tool.agdseguridad.com.ar && AGD-Toolbox.cmd install

rem Definir variables
set AGDToolbox-URL=https://raw.githubusercontent.com/Nr2ar/AGDToolbox/main
set curl=curl.exe -H "Cache-Control: no-cache, no-store" --remote-name
set ftp1=ftp://live
set ftp2=SoyLive
set ftp3=ftp.nr2.com
set ftp=%ftp1%:%ftp2%666@%ftp3%.ar:43321


rem Borrar rastros de getadmin
del /s /q "%TEMP%\%~n0.vbs" > NUL 2>&1

REM Que version soy?
for %%F in ("%~f0") do set "fileSize=%%~zF"

REM Quien soy?
for /f %%a in ('whoami') do set "whoami=%%a"

REM Guardar Parametros
set AGD-Params=%*
cls

Title AGD Toolbox - %whoami% - Version %fileSize%

echo AGD Toolbox - v%fileSize%
echo --------------------
echo.


if %~n0 == AGD-Toolbox goto install

:updated
if %~n0 == AGD-update (
  FOR /F "usebackq" %%A IN ('%windir%\AGD-*.cmd') DO set old-size=%%~zA
	move /Y "%~dp0AGD-update.cmd" "%~dp0AGD.cmd"  > NUL
	echo Toolbox v%fileSize% actualizado de versión v!old-size!
	echo.
  timeout 15
	exit
	exit
)


REM ============================================================================
REM ============       PARAMETROS              =================================
REM ============================================================================

echo Opciones: "%*"

:parse
IF "%~1"=="" GOTO eof
IF "%~1"=="admin" set AGD-admin=yes
IF "%~1"=="sched" goto %~1

IF "%~1"=="help" goto %~1
IF "%~1"=="update" goto %~1
IF "%~1"=="install" goto %~1
IF "%~1"=="ip" goto %~1
IF "%~1"=="total" goto %~1
IF "%~1"=="reteam" goto %~1

:next
SHIFT
goto parse
:endparse
REM ready for action!


REM //ANCHOR - Help
:help
echo  * AYUDA *
echo.
echo    ip : muestra información de red y Windows
echo    total : instalar Total Commander
echo    reteam : fuerza reinstalacion de Teamviewer 13
echo.
echo    install: instala AGD Toolbox
echo    update: Fuerza una actualización
echo    help: Esta ayuda
echo.

goto next
rem ------------------------------------------------------------------------------------------


REM //ANCHOR - Update
:update
echo * Forzar actualización

call :getadmin

goto install-update

exit
rem ------------------------------------------------------------------------------------------


REM //ANCHOR - Install
:install
echo * Instalar AGD Toolbox

call :getadmin

for /f "tokens=*" %%a in ('time.exe /t') do set current_time=%%a

schtasks /create /ru SYSTEM /sc DAILY /mo 1 /st %current_time% /tn "AGD\AGDToolbox" /tr "'%windir%\AGD.cmd' sched" /it /F

:install-update
echo on
curl.exe -o "%windir%\AGD-update.cmd" %AGDToolbox-URL%/AGD.cmd

pause


rem //REVIEW - no se que hace esto
if not defined AGD-Scheduled (
  if exist "%windir%\AGD-update.cmd" (start "AGD Update" "%windir%\AGD-update.cmd")
  exit
  ) ELSE (
  cmd /c move "%windir%\AGD-update.cmd" "%windir%\AGD.cmd" & timeout 5 & exit
  )

exit
exit
rem ------------------------------------------------------------------------------------------


REM //ANCHOR - Scheduled Task
:sched

set AGD-Scheduled=yes

echo Soy tarea programada. Me voy a actualizar

goto install-update

rem ------------------------------------------------------------------------------------------



REM //ANCHOR - IP
:ip
rem for /f %%a in ('wmic computersystem get domain ^| findstr /r /v "^$"') do (set ip_workgroup_domain=%%a)

for /f "skip=1 delims=" %%a in ('wmic computersystem get domain') do (
    set "line=%%a"
    if not defined secondLine (
        set ip_workgroup_domain=!line!
        set "secondLine=true"
    )
)

(
for /f "tokens=3 delims= " %%A IN ('reg query HKEY_LOCAL_MACHINE\SOFTWARE\TeamViewer /v ClientID ^| Find "0x"') DO set /A TeamID=%%A
for /f "tokens=3 delims= " %%A IN ('reg query HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\TeamViewer /v ClientID ^| Find "0x"') DO set /A TeamID=%%A
) >nul 2>&1

echo  Host: %ip_workgroup_domain%- %whoami%
if defined TeamID (echo  Teamviewer: %TeamID%)
echo.

ipconfig /all | findstr /v /i /c:"Descrip" /c:"*" /c:"Teredo" | findstr /i /c:"adapt" /c:"Ethernet" /c:"IPv4" /c:"subred" /c:"subnet" /c:"Mask" /c:"Physical" /c:"sica." /c:"Puerta" /c:"Gateway" /c:"192." /c:".0"

echo.
for /f "delims=" %%i in ('curl.exe ifconfig.me 2^>nul') do set "ip_public=%%i"
for /f "tokens=2 delims=: " %%a in ('nslookup %ip_public% 2^>nul ^| findstr /C:"Name:" /C:"Nombre:"') do set "ip_hostname=%%a"

echo IP Publica: %ip_public% - %ip_hostname%

echo.

goto next
rem ------------------------------------------------------------------------------------------


REM //ANCHOR - Total Commander
:total
echo.
echo * Instalación de Total Commander

call :getadmin

%temp:~0,2%
cd "%temp%"
echo on
%curl% --ignore-content-length %ftp%/Install/TotalCommanderInstall11.exe

@echo off

"%temp%\TotalCommanderInstall11.exe"

goto next
rem ------------------------------------------------------------------------------------------


REM //ANCHOR - ReTeam
:reteam

echo.
echo * Instalación de Teamviewer 13

call :getadmin

%temp:~0,2%
cd "%temp%"

%curl% --ignore-content-length %ftp%/PORTABLES/ReTeam13.exe

"%temp%\ReTeam13.exe"

goto next
rem ------------------------------------------------------------------------------------------


:eof

echo FIN
pause
exit /b
exit

REM //ANCHOR - GetAdmin
:getadmin

if defined AGD-admin exit /b

REM Check admin mode, auto-elevate if required.
  openfiles > NUL 2>&1 || (
    REM Not elevated. Do it.
    echo createObject^("Shell.Application"^).shellExecute "%~dpnx0", "admin %AGD-Params%", "", "runas">"%TEMP%\%~n0.vbs"
    cscript /nologo "%TEMP%\%~n0.vbs"
    exit
  )

del /s /q "%TEMP%\%~n0.vbs" > NUL 2>&1

REM If here, then process is elevated. Otherwise, batch is already terminated and/or stuck in code above.



exit /b


= = = = = = = = = = = = FIN = = = = = = = = = = = = =
