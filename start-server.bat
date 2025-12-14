@echo off
setlocal EnableDelayedExpansion

:: ===================================
:: C2 Panel - Server Starter
:: ===================================

title C2 Panel Server

cd /d "%~dp0"

echo.
echo ===============================================
echo        C2 PANEL - STARTING SERVER
echo ===============================================
echo.

:: Check environment variables
if not defined DATABASE_URL (
    echo [!] DATABASE_URL not set.
    echo [*] Please enter your PostgreSQL connection string:
    set /p DATABASE_URL="DATABASE_URL: "
)

if not defined SESSION_SECRET (
    echo [!] SESSION_SECRET not set.
    echo [*] Generating random session secret...
    for /f "tokens=*" %%i in ('powershell -Command "[System.Guid]::NewGuid().ToString()"') do set SESSION_SECRET=%%i
)

:: Export environment variables
set DATABASE_URL=%DATABASE_URL%
set SESSION_SECRET=%SESSION_SECRET%

echo.
echo [*] Starting development server...
echo [*] Press Ctrl+C to stop the server
echo.

call npm run dev

pause
