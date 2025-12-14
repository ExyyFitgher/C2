@echo off
chcp 65001 >nul
echo ========================================
echo   C2 Panel - Windows Build Script
echo ========================================
echo.

REM Check if Node.js is installed
where node >nul 2>nul
if %ERRORLEVEL% neq 0 (
    echo ERROR: Node.js is not installed!
    echo Please download and install Node.js from: https://nodejs.org/
    pause
    exit /b 1
)

REM Check if icon.ico exists
if not exist "build\icon.ico" (
    echo WARNING: build\icon.ico not found!
    echo.
    echo Please create a Windows icon file:
    echo 1. Go to: https://convertio.co/png-ico/
    echo 2. Upload: client\public\favicon.png
    echo 3. Download and save as: build\icon.ico
    echo.
    echo Press any key to continue anyway (icon will use default)...
    pause >nul
    mkdir build 2>nul
    copy client\public\favicon.png build\icon.png >nul 2>nul
)

echo [1/6] Checking dependencies...
if not exist "node_modules" (
    echo Installing dependencies...
    call npm install
    if %ERRORLEVEL% neq 0 (
        echo ERROR: Failed to install dependencies
        pause
        exit /b 1
    )
)

echo.
echo [2/6] Installing Electron...
call npm install --save-dev electron electron-builder
if %ERRORLEVEL% neq 0 (
    echo ERROR: Failed to install Electron
    pause
    exit /b 1
)

echo.
echo [3/6] Rebuilding native modules for Electron...
call npx electron-rebuild -f -w better-sqlite3
if %ERRORLEVEL% neq 0 (
    echo WARNING: Could not rebuild better-sqlite3, trying alternative...
    call npm rebuild better-sqlite3
)

echo.
echo [4/6] Building web application...
call npm run build
if %ERRORLEVEL% neq 0 (
    echo ERROR: Failed to build application
    pause
    exit /b 1
)

echo.
echo [5/6] Skipping database setup (SQLite creates automatically)...
echo The app uses local SQLite database - no setup needed!

echo.
echo [6/6] Creating EXE file...
call npx electron-builder --win
if %ERRORLEVEL% neq 0 (
    echo ERROR: Failed to create EXE
    echo.
    echo Common fixes:
    echo 1. Make sure build\icon.ico exists
    echo 2. Run as Administrator
    echo 3. Disable antivirus temporarily
    echo 4. Install Visual Studio Build Tools
    pause
    exit /b 1
)

echo.
echo ========================================
echo   Build Complete!
echo ========================================
echo.
echo Your files are in the 'release' folder:
echo.
dir /b release\*.exe 2>nul
echo.
echo NOTE: This app uses SQLite - works offline!
echo No database setup required.
echo.
echo You can now:
echo 1. Run the installer (Setup.exe)
echo 2. Or use the portable version directly
echo.
pause
