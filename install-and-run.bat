@echo off
setlocal EnableDelayedExpansion

:: ===================================
:: EXY ATTACK - Auto Installer & Builder
:: ===================================

title EXY ATTACK - Installer
color 0A

:: Request Admin Privileges
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo.
    echo ===============================================
    echo   REQUESTING ADMINISTRATOR PRIVILEGES...
    echo ===============================================
    echo.
    powershell -Command "Start-Process cmd -ArgumentList '/c cd /d \"%~dp0\" && \"%~f0\"' -Verb RunAs"
    exit /b
)

cls
echo.
echo  ███████╗██╗  ██╗██╗   ██╗     █████╗ ████████╗████████╗ █████╗  ██████╗██╗  ██╗
echo  ██╔════╝╚██╗██╔╝╚██╗ ██╔╝    ██╔══██╗╚══██╔══╝╚══██╔══╝██╔══██╗██╔════╝██║ ██╔╝
echo  █████╗   ╚███╔╝  ╚████╔╝     ███████║   ██║      ██║   ███████║██║     █████╔╝ 
echo  ██╔══╝   ██╔██╗   ╚██╔╝      ██╔══██║   ██║      ██║   ██╔══██║██║     ██╔═██╗ 
echo  ███████╗██╔╝ ██╗   ██║       ██║  ██║   ██║      ██║   ██║  ██║╚██████╗██║  ██╗
echo  ╚══════╝╚═╝  ╚═╝   ╚═╝       ╚═╝  ╚═╝   ╚═╝      ╚═╝   ╚═╝  ╚═╝ ╚═════╝╚═╝  ╚═╝
echo.
echo ===============================================
echo        COMMAND ^& CONTROL PANEL INSTALLER
echo ===============================================
echo.

cd /d "%~dp0"

:: Set build directory
set "BUILD_DIR=%~dp0build-output"

echo [*] Checking system requirements...
echo.

:: Check for Node.js
echo [*] Checking Node.js installation...
where node >nul 2>&1
if %errorlevel% neq 0 (
    echo [!] Node.js not found. Installing...
    
    :: Download Node.js installer
    echo [*] Downloading Node.js v20.10.0...
    powershell -Command "Invoke-WebRequest -Uri 'https://nodejs.org/dist/v20.10.0/node-v20.10.0-x64.msi' -OutFile 'node_installer.msi'"
    
    if exist node_installer.msi (
        echo [*] Installing Node.js...
        msiexec /i node_installer.msi /qn /norestart
        del node_installer.msi
        
        :: Refresh environment
        set "PATH=%PATH%;C:\Program Files\nodejs"
        echo [+] Node.js installed successfully!
    ) else (
        echo [X] Failed to download Node.js.
        echo [!] Please install manually from https://nodejs.org
        pause
        exit /b 1
    )
) else (
    for /f "tokens=*" %%i in ('node -v') do set NODE_VER=%%i
    echo [+] Node.js found: !NODE_VER!
)

:: Check for npm
echo [*] Checking npm installation...
where npm >nul 2>&1
if %errorlevel% neq 0 (
    echo [X] npm not found. Please reinstall Node.js
    pause
    exit /b 1
) else (
    for /f "tokens=*" %%i in ('npm -v') do set NPM_VER=%%i
    echo [+] npm found: !NPM_VER!
)

echo.
echo ===============================================
echo         INSTALLING DEPENDENCIES
echo ===============================================
echo.

:: Install dependencies
echo [*] Installing npm packages...
echo [*] This may take a few minutes...
call npm install --silent
if %errorlevel% neq 0 (
    echo [!] Some packages failed. Trying with --force...
    call npm install --force --silent
)

echo [+] Dependencies installed!

echo.
echo ===============================================
echo            BUILDING APPLICATION
echo ===============================================
echo.

:: Create build directory
echo [*] Creating build directory...
if not exist "%BUILD_DIR%" mkdir "%BUILD_DIR%"

:: Build the project
echo [*] Building project...
call npm run build
if %errorlevel% neq 0 (
    echo [!] Build failed. Attempting to fix...
    
    :: Clear npm cache
    echo [*] Clearing npm cache...
    call npm cache clean --force
    
    :: Try building again
    echo [*] Retrying build...
    call npm run build
    
    if %errorlevel% neq 0 (
        echo [X] Build failed. Check errors above.
        pause
        exit /b 1
    )
)

echo [+] Build completed!

echo.
echo ===============================================
echo         BUILDING DESKTOP APPLICATION
echo ===============================================
echo.

:: Check if electron-builder is available
echo [*] Checking Electron Builder...
call npm list electron-builder >nul 2>&1
if %errorlevel% neq 0 (
    echo [*] Installing Electron Builder...
    call npm install electron-builder --save-dev --silent
)

:: Build Windows EXE
echo [*] Building Windows executable...
echo [*] This may take several minutes...

call npx electron-builder --win --x64
if %errorlevel% neq 0 (
    echo [!] Electron build failed. Trying portable build...
    call npx electron-builder --win portable
    
    if %errorlevel% neq 0 (
        echo [!] EXE build failed. Running in development mode instead...
        goto :run_dev
    )
)

:: Copy EXE to build directory
echo [*] Copying EXE to output directory...
if exist "dist\*.exe" (
    copy /Y "dist\*.exe" "%BUILD_DIR%\" >nul
    echo [+] EXE created successfully!
    echo [+] Location: %BUILD_DIR%
    
    :: List created files
    echo.
    echo Created files:
    dir /b "%BUILD_DIR%\*.exe" 2>nul
)

echo.
echo ===============================================
echo            INSTALLATION COMPLETE
echo ===============================================
echo.
echo [+] All tasks completed successfully!
echo.
echo Output directory: %BUILD_DIR%
echo.
echo To run the application:
echo   1. Navigate to: %BUILD_DIR%
echo   2. Double-click the EXE file
echo.
echo ===============================================
echo.

:: Ask if user wants to run now
set /p RUN_NOW="Do you want to run the application now? (Y/N): "
if /i "%RUN_NOW%"=="Y" goto :run_app
if /i "%RUN_NOW%"=="y" goto :run_app
goto :end

:run_app
echo.
echo [*] Starting EXY ATTACK...
if exist "%BUILD_DIR%\*.exe" (
    for %%f in ("%BUILD_DIR%\*.exe") do (
        start "" "%%f"
        goto :end
    )
) else (
    goto :run_dev
)
goto :end

:run_dev
echo.
echo [*] Running in development mode...
echo [*] Opening browser at http://localhost:5000
start http://localhost:5000
call npm run dev
goto :end

:end
echo.
pause
