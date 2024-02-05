@echo off                           
prompt $$ 
rem chcp 65001
mode con: cols=120 lines=50
for /f %%a in ('whoami') do set "whoami=%%a"

REM Que version soy?
for %%F in ("%~f0") do set "fileSize=%%~zF"
cls

Title AGD Toolbox - %whoami% - Version %fileSize%
echo.
echo AGD Toolbox - v%fileSize%
echo --------------------
echo.

copy /Y "%~dp0AGD-update.cmd" "%~dp0AGD.cmd" >nul 2>&1


set AGDToolbox-URL=https://raw.githubusercontent.com/Nr2ar/AGDToolbox/main/
set curl=curl.exe -H "Cache-Control: no-cache, no-store"



REM ============================================================================
REM ============       PARAMETROS              =================================
REM ============================================================================


:parse
IF "%~1"=="" GOTO endparse

rem ------- help
IF "%~1"=="help" (
	echo  * AYUDA *
	echo.
	echo    ip : muestra información de red
	echo    total : instalar Total Commander
	echo.
	echo    noupdate: No intentar actualizarse
	echo    help: Esta ayuda
	echo.
	pause
	exit /b
	)
rem ---------------


rem ------- No actualizar
IF "%~1"=="noupdate" (
	echo  * NO actualizar
rem *	GOTO verificando_requisitos
	)
rem ---------------



rem ------- ip
IF "%~1"=="ip" (

whoami.exe
echo.

ipconfig /all | findstr /v /i /c:"Descrip" /c:"*" /c:"Teredo" | findstr /i /c:"adapt" /c:"Ethernet" /c:"IPv4" /c:"subred" /c:"subnet" /c:"Mask" /c:"Physical" /c:"sica." /c:"Puerta" /c:"Gateway" /c:"192." /c:".0"

echo.

    pause
	)
rem ---------------

rem ------- total
IF "%~1"=="total" (

echo.
echo * Instalación de Total Commander




)

rem ---------------

SHIFT
GOTO parse
:endparse
REM ready for action!





exit /b

= = = = = = = = = = = = FIN = = = = = = = = = = = = =
