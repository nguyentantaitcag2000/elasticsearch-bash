@echo off
cd /d %~dp0
setlocal enabledelayedexpansion

REM Function to copy file and print colored status
call :CopyWithColor "lib-window\bzip2.dll" "C:\Program Files\Git\usr\bin\bzip2.exe"
call :CopyWithColor "lib-window\zip.exe" "C:\Program Files\Git\usr\bin\zip.exe"
call :CopyWithColor "lib-window\jq64.exe" "C:\Program Files\Git\usr\bin\jq.exe"

pause
exit /b

:CopyWithColor
@REM echo Copying "%~1" to "%~2"...
copy /Y "%~1" "%~2" >nul
if %errorlevel%==0 (
    echo Successfully copied "%~1"!
) else (
    echo Failed to copy "%~1"!
)
color 07
exit /b
