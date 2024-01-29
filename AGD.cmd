@echo off                           
prompt $$ 
chcp 65001
cls

REM Que version soy?
for %%F in ("%~f0") do set "fileSize=%%~zF"

Title AGD Toolbox - Version %fileSize%
echo.
echo AGD Toolbox v%fileSize%
echo ----------------
echo.

copy /Y "%~dp0AGD-update.cmd" "%~dp0AGD.cmd" >nul 2>&1


set limpia10-URL=https://raw.githubusercontent.com/Nr2ar/AGDToolbox/main/
set curl="%~dp0curl.exe" -H "Cache-Control: no-cache, no-store"
set winlive=no
set soywinlive=no
set forzar_winlive=no
set myname=%~nx0
if %COMPUTERNAME% equ MINWINPC (
	set winlive=yes
)





REM ============================================================================
REM ============       PARAMETROS              =================================
REM ============================================================================


:parse
IF "%~1"=="" GOTO endparse


rem ------- No actualizar
IF "%~1"=="ip" (
    for /f "tokens=*" %%a IN ('ipconfig ^| Find "IPv4"') DO echo %%a
    pause
	)
rem ---------------




rem ------- No actualizar
IF "%~1"=="noupdate" (
	echo  * NO actualizar
rem *	GOTO verificando_requisitos
	)
rem ---------------

rem ------- Ayuda?
IF "%~1"=="help" (
	echo  * AYUDA *
	echo.
	echo Parametros disponíbles:
	echo.
	echo    noupdate: No intentar actualizarse
	echo    a-z: Unidad exclusiva a limpiar
	echo    live: Forzar modo Windows Live
	echo    help: Esta ayuda
	echo.
	pause
	exit /b
	)
rem ---------------


rem ------- Forzar modo live?
IF "%~1"=="live" (
	set forzar_winlive=yes
	echo  * Modo Windows LIVE
)
rem ---------------


rem ------- Unidad?

setlocal enableextensions

set "drive=%~1"
set "valid=N"

if not "%drive%" == "" (
  set "drive=%drive:~0,2%"
  if not "%drive%" == "" (
    for /f "tokens=1 delims=:" %%d in ("%drive%") do set "drive=%%d"
    for %%d in (A B C D E F G H I J K L M N O P Q R S T U V W X Y Z) do (
      if /i "%%d" == "%drive%" set "valid=Y"
    )
  )
)

if "%valid%" == "Y" (
  echo  * Sólo se limpiara unidad %drive%:
  echo.
  set param_drive=-path !drive!:
)

endlocal

rem ---------------

SHIFT
GOTO parse
:endparse
REM ready for action!





exit /b

= = = = = = = = = = = = FIN = = = = = = = = = = = = =



exit /b
No me funcionó :[

echo %limpia-free%> "%~dp0limpia-free.txt"
FOR %%? IN ("%~dp0limpia-free.txt") DO (SET /A "limpia_free_length=%%~z? - 2")
del /q "%~dp0limpia-free.txt" >nul 2>&1

echo on
rem Check if limpia_free_length is equal to or less than 8.
if %limpia_free_length% LEQ 8 (
  set limpia_free_8=%limpia-free%
) else (
  rem Use only the first 8 characters of limpia-free
  set limpia_free_8=%limpia-free:~0,9%
)

set /a "gibibytes=limpia_free_8 / 1024 / 1024"
set /a "remainder=(limpia_free_8 %% (gibibytes * 1024 * 1024)) * 100 / (gibibytes * 1024 * 1024)"
set limpia_free_GB=%gibibytes%.%remainder%

echo limpia-free %limpia-free%
echo limpia_free_8 %limpia_free_8%
echo limpia_free_GB+remainder %limpia_free_GB%

